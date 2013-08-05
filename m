Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab3HEPAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 11:00:47 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:63158 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab3HEPAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 11:00:46 -0400
Message-ID: <51FFBE17.60409@gmail.com>
Date: Mon, 05 Aug 2013 11:00:39 -0400
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: Re: [PATCH 8/9] perf kvm: debug for missing vmexit/vmentry event
References: <1375473947-64285-1-git-send-email-dsahern@gmail.com> <1375473947-64285-9-git-send-email-dsahern@gmail.com> <51FF4BEA.7070308@linux.vnet.ibm.com>
In-Reply-To: <51FF4BEA.7070308@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/5/13 2:53 AM, Xiao Guangrong wrote:
> On 08/03/2013 04:05 AM, David Ahern wrote:
>> Expected to have missing events for each vcpu when perf is
>> started. After that should not have missing events.
>
> Sorry, i can not understand what's this info used for.

For debugging. Things that should not happen do seem to happen -- 
rarely, but it does

>
>>
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Jiri Olsa <jolsa@redhat.com>
>> Cc: Namhyung Kim <namhyung@kernel.org>
>> Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
>> ---
>>   tools/perf/builtin-kvm.c |   15 +++++++++++++--
>>   1 file changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
>> index 28afc05d..41dd25a 100644
>> --- a/tools/perf/builtin-kvm.c
>> +++ b/tools/perf/builtin-kvm.c
>> @@ -568,11 +568,22 @@ static bool handle_kvm_event(struct perf_kvm_stat *kvm,
>>   	    (kvm->trace_vcpu != vcpu_record->vcpu_id))
>>   		return true;
>>
>> -	if (kvm->events_ops->is_begin_event(evsel, sample, &key))
>> +	if (kvm->events_ops->is_begin_event(evsel, sample, &key)) {
>> +		if (vcpu_record->start_time) {
>> +			pr_debug("consecutive begin events (%s) for pid %d, vcpu %d\n",
>> +				 evsel->name, sample->pid, vcpu_record->vcpu_id);
>> +		}
>
> This is not true, the ->start_time is set in handle_begin_event() for the new alloced
> vcpu_record.
>
> If you just want to know the point where is the first event lost, you can track
> it in:
>
> static bool handle_end_event(struct perf_kvm_stat *kvm,
> 			     struct vcpu_event_record *vcpu_record,
> 			     struct event_key *key,
> 			     u64 timestamp)
> {
> 	......
>
> 	/* The begin event is not caught. */
> 	if (!time_begin)                       <======
> 		return true;
>

Ok. I'll drop the patch. I added it for a reason, but can't remember why 
at the moment.

David
