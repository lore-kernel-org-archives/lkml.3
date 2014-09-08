Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbaIHLHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 07:07:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:13423 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbaIHLH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 07:07:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,486,1406617200"; 
   d="scan'208";a="569916772"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 04/22] perf: Add a capability for AUX_NO_SG pmus to do software double buffering
In-Reply-To: <20140908071712.GT19379@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com> <1408538179-792-5-git-send-email-alexander.shishkin@linux.intel.com> <20140908071712.GT19379@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 08 Sep 2014 14:07:22 +0300
Message-ID: <87oauqv09h.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, Aug 20, 2014 at 03:36:01PM +0300, Alexander Shishkin wrote:
>> For pmus that don't support scatter-gather for AUX data in hardware, it
>> might still make sense to implement software double buffering to avoid
>> losing data while the user is reading data out. For this purpose, add
>> a pmu capability that guarantees multiple high-order chunks for AUX buffer,
>> so that the pmu driver can do switchover tricks.
>
> Please expand this with more detail on how to use this.

Sure.

>> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
>> ---
>>  include/linux/perf_event.h  |  1 +
>>  kernel/events/ring_buffer.c | 15 ++++++++++++++-
>>  2 files changed, 15 insertions(+), 1 deletion(-)
>> 
>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>> index fe10bf6f94..1e7b659b49 100644
>> --- a/include/linux/perf_event.h
>> +++ b/include/linux/perf_event.h
>> @@ -172,6 +172,7 @@ struct perf_event;
>>   */
>>  #define PERF_PMU_CAP_NO_INTERRUPT		0x01
>>  #define PERF_PMU_CAP_AUX_NO_SG			0x02
>> +#define PERF_PMU_CAP_AUX_SW_DOUBLEBUF		0x04
>>  
>>  /**
>>   * struct pmu - generic performance monitoring unit
>> diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
>> index d10919ca42..f5ee3669f8 100644
>> --- a/kernel/events/ring_buffer.c
>> +++ b/kernel/events/ring_buffer.c
>> @@ -286,9 +286,22 @@ int rb_alloc_aux(struct ring_buffer *rb, struct perf_event *event,
>>  	if (!has_aux(event))
>>  		return -ENOTSUPP;
>>  
>> -	if (event->pmu->capabilities & PERF_PMU_CAP_AUX_NO_SG)
>> +	if (event->pmu->capabilities & PERF_PMU_CAP_AUX_NO_SG) {
>>  		order = get_order(nr_pages * PAGE_SIZE);
>>  
>> +		/*
>> +		 * PMU requests more than one contiguous chunks of memory
>> +		 * for SW double buffering
>> +		 */
>> +		if ((event->pmu->capabilities & PERF_PMU_CAP_AUX_SW_DOUBLEBUF) &&
>> +		    !overwrite) {
>> +			if (!order)
>> +				return -EINVAL;
>> +
>> +			order--;
>> +		}
>> +	}
>
> In particular this looks like it will allocate double the total amount
> of pages and 'loose' half of them. There is no corresponding code in the
> free path to collect them.

This code makes the biggest high order allocation no bigger than half of
the total requested size. Then, when I allocate the high-order chunks, I
do a split_page() on them and everywhere else in the code they are
treated as individual pages, including the free path. So this patch has
no implication on freeing. Is this your concern?

Regards,
--
Alex
