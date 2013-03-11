Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab3CKLU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 07:20:58 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50223 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab3CKLU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 07:20:57 -0400
X-AuditID: 9c93016f-b7b46ae000000e4b-35-513dbe175c2c
From: Namhyung Kim <namhyung@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Vince Weaver <vince@deater.net>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/2] perf: Fix mixed hw/sw event group initialization
References: <1362629990-10053-1-git-send-email-namhyung@kernel.org>
	<1362629990-10053-2-git-send-email-namhyung@kernel.org>
	<1362996074.14933.1.camel@laptop>
Date: Mon, 11 Mar 2013 20:20:55 +0900
In-Reply-To: <1362996074.14933.1.camel@laptop> (Peter Zijlstra's message of
	"Mon, 11 Mar 2013 11:01:14 +0100")
Message-ID: <87ehfmqj1k.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Mon, 11 Mar 2013 11:01:14 +0100, Peter Zijlstra wrote:
> On Thu, 2013-03-07 at 13:19 +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> There's a problem with mixed hw/sw group when the leader is a software
>> event.  For instance:
>
>> Jiri's patch 0231bb533675 ("perf: Fix event group context move") fixed
>> a part of problem but there's a devil still..
>> 
>> The problem arose when a sw event is added to already moved (to hw
>> context) group whose leader also is a sw event.  In the above example
>> 
>>  1. task-clock (sw event) is a group leader (has PERF_GROUP_SOFTWARE)
>>  2. cycles (hw event) is added, so the leader moved to the hw context
>>  3. faults (sw event) is added but the leader also is a sw event
>>  4. after find_get_context(), ctx is not same as leader->ctx since the
>>     leader had moved to the hw context (-EINVAL)
>> 
>> Fix it by adding new PERF_GROUP_MIXED flag and use leader's ctx->pmu
>> if it's set.
>
>> Reported-by: Andreas Hollmann <hollmann@in.tum.de>
>> Cc: Jiri Olsa <jolsa@redhat.com>
>> Cc: Vince Weaver <vince@deater.net>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  include/linux/perf_event.h |  1 +
>>  kernel/events/core.c       | 37 ++++++++++++++++++++++---------------
>>  2 files changed, 23 insertions(+), 15 deletions(-)
>> 
>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>> index e47ee462c2f2..001a3b64fe61 100644
>> --- a/include/linux/perf_event.h
>> +++ b/include/linux/perf_event.h
>> @@ -285,6 +285,7 @@ typedef void (*perf_overflow_handler_t)(struct perf_event *,
>>  
>>  enum perf_group_flag {
>>  	PERF_GROUP_SOFTWARE		= 0x1,
>> +	PERF_GROUP_MIXED		= 0x2,
>>  };
>>  
>>  #define SWEVENT_HLIST_BITS		8
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index 007dfe846d4d..06266d5ed500 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -6441,6 +6441,8 @@ out:
>>   * @pid:		target pid
>>   * @cpu:		target cpu
>>   * @group_fd:		group leader event fd
>> + * @flags:		flags which controls the meaning of arguments.
>> + * 			see PERF_FLAG_*
>>   */
>>  SYSCALL_DEFINE5(perf_event_open,
>>  		struct perf_event_attr __user *, attr_uptr,
>> @@ -6536,26 +6538,30 @@ SYSCALL_DEFINE5(perf_event_open,
>>  	 */
>>  	pmu = event->pmu;
>>  
>> -	if (group_leader &&
>> -	    (is_software_event(event) != is_software_event(group_leader))) {
>> -		if (is_software_event(event)) {
>> -			/*
>> -			 * If event and group_leader are not both a software
>> -			 * event, and event is, then group leader is not.
>> -			 *
>> -			 * Allow the addition of software events to !software
>> -			 * groups, this is safe because software events never
>> -			 * fail to schedule.
>> -			 */
>> -			pmu = group_leader->pmu;
>> -		} else if (is_software_event(group_leader) &&
>> -			   (group_leader->group_flags & PERF_GROUP_SOFTWARE)) {
>> +	if (group_leader) {
>> +		if (group_leader->group_flags & PERF_GROUP_SOFTWARE) {
>>  			/*
>>  			 * In case the group is a pure software group, and we
>>  			 * try to add a hardware event, move the whole group to
>>  			 * the hardware context.
>>  			 */
>> -			move_group = 1;
>> +			if (!is_software_event(event))
>> +				move_group = 1;
>> +		} else if (group_leader->group_flags & PERF_GROUP_MIXED) {
>> +			/*
>> +			 * The group leader was moved on to a hardware context,
>> +			 * so move this event also.
>> +			 */
>> +			if (is_software_event(event))
>> +				pmu = group_leader->ctx->pmu;
>> +		} else if (!is_software_event(group_leader)) {
>> +			/*
>> +			 * Allow the addition of software events to !software
>> +			 * groups, this is safe because software events never
>> +			 * fail to schedule.
>> +			 */
>> +			if (is_software_event(event))
>> +				pmu = group_leader->pmu;
>>  		}
>>  	}
>>  
>> @@ -6650,6 +6656,7 @@ SYSCALL_DEFINE5(perf_event_open,
>>  			perf_install_in_context(ctx, sibling, event->cpu);
>>  			get_ctx(ctx);
>>  		}
>> +		group_leader->group_flags = PERF_GROUP_MIXED;
>>  	}
>>  
>>  	perf_install_in_context(ctx, event, event->cpu);
>
>
> This seems reasonable, but I think the perf_group_detach thing needs to
> migrate events between pmu's as well to complete the whole mess.

Hmm.. it seems that it needs whole perf_{remove_from,install_in}_context
step to migrate them, right?  Looks like not a simple job for me. :(

Any advice?

Thanks,
Namhyung
