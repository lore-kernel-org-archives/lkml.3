Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbaESM5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:57:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:1330 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593AbaESM5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:57:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,867,1392192000"; 
   d="scan'208";a="534169038"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC 2/2] perf: add AUX area to ring buffer for raw data streams
In-Reply-To: <20140519085854.GW30445@twins.programming.kicks-ass.net>
References: <1400166510-9234-1-git-send-email-alexander.shishkin@linux.intel.com> <1400166510-9234-3-git-send-email-alexander.shishkin@linux.intel.com> <20140519085854.GW30445@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 19 May 2014 15:57:37 +0300
Message-ID: <87bnuuylha.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Thu, May 15, 2014 at 06:08:30PM +0300, Alexander Shishkin wrote:
>> --- a/include/linux/perf_event.h
>> +++ b/include/linux/perf_event.h
>> @@ -252,6 +252,19 @@ struct pmu {
>>  	 * flush branch stack on context-switches (needed in cpu-wide mode)
>>  	 */
>>  	void (*flush_branch_stack)	(void);
>> +
>> +	/*
>> +	 * Allocate AUX space buffer: return an array of @nr_pages pages to be
>> +	 * mapped to userspace that will also be passed to ->free_aux.
>> +	 */
>> +	void *(*alloc_aux)		(int cpu, int nr_pages, bool overwrite,
>> +					 struct perf_event_mmap_page *user_page);
>> +					/* optional */
>> +
>> +	/*
>> +	 * Free AUX buffer
>> +	 */
>> +	void (*free_aux)		(void *aux); /* optional */
>>  };
>
> I'm not entirely thrilled to expose it to the PMU like this.. I realize
> you want this in order to get physically contiguous pages.

Hmm, I guess we can have code in perf core to carry out the allocation
according to, say, contstraint flags and pass the page array down to the
PMU if that sounds like a cleaner thing to do?

> Are you aware of allocation constraints for other architectures?

Somewhat. ARM's trace memory controller supports both scatter-gather and
a plain contiguous buffer, I haven't found evidence of one being
available while the other one isn't, so I'm inclined to assume that if
it can write to system memory, it supports SG.

>>  #define PERF_RECORD_MISC_CPUMODE_MASK		(7 << 0)
>> @@ -710,6 +726,18 @@ enum perf_event_type {
>>  	 */
>>  	PERF_RECORD_MMAP2			= 10,
>>  
>> +	/*
>> +	 * Records that new data landed in the AUX buffer part.
>> +	 *
>> +	 * struct {
>> +	 * 	struct perf_event_header	header;
>> +	 *
>> +	 * 	u64				aux_offset;
>> +	 * 	u64				aux_size;
>> +	 * };
>> +	 */
>> +	PERF_RECORD_AUX				= 11,
>> +
>>  	PERF_RECORD_MAX,			/* non-ABI */
>>  };
>
> Ideally the patch introducing this would also introduce code to generate
> these records.

Fair enough.

>> @@ -4076,7 +4090,63 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
>>  		return -EINVAL;
>>  
>>  	vma_size = vma->vm_end - vma->vm_start;
>> -	nr_pages = (vma_size / PAGE_SIZE) - 1;
>> +
>> +	if (vma->vm_pgoff == 0) {
>> +		nr_pages = (vma_size / PAGE_SIZE) - 1;
>> +	} else {
>> +		/*
>> +		 * AUX area mapping: if rb->aux_nr_pages != 0, it's already
>> +		 * mapped, all subsequent mappings should have the same size
>> +		 * and offset. Must be above the normal perf buffer.
>> +		 */
>> +		u64 aux_offset, aux_size;
>> +
>> +		if (!event->rb)
>> +			return -EINVAL;
>> +
>> +		nr_pages = vma_size / PAGE_SIZE;
>> +
>> +		mutex_lock(&event->mmap_mutex);
>> +		ret = -EINVAL;
>> +
>> +		rb = event->rb;
>> +		if (!rb)
>> +			goto aux_unlock;
>> +
>> +		aux_offset = ACCESS_ONCE(rb->user_page->aux_offset);
>> +		aux_size = ACCESS_ONCE(rb->user_page->aux_size);
>> +
>> +		if (aux_offset < perf_data_size(rb) + PAGE_SIZE)
>> +			goto aux_unlock;
>> +
>> +		if (aux_offset != vma->vm_pgoff << PAGE_SHIFT)
>> +			goto aux_unlock;
>> +
>> +		/* already mapped with a different offset */
>> +		if (rb_has_aux(rb) && rb->aux_pgoff != vma->vm_pgoff)
>> +			goto aux_unlock;
>> +
>> +		if (aux_size != vma_size || aux_size != nr_pages * PAGE_SIZE)
>> +			goto aux_unlock;
>> +
>> +		/* already mapped with a different size */
>> +		if (rb_has_aux(rb) && rb->aux_nr_pages != nr_pages)
>> +			goto aux_unlock;
>> +
>> +		if (!atomic_inc_not_zero(&rb->mmap_count))
>> +			goto aux_unlock;
>> +
>> +		if (rb_has_aux(rb)) {
>> +			atomic_inc(&rb->aux_mmap_count);
>> +			ret = 0;
>> +			goto unlock;
>> +		}
>> +
>> +		atomic_set(&rb->aux_mmap_count, 1);
>> +		user_extra = nr_pages;
>> +
>> +		goto accounting;
>> +	}
>
> That appears to be missing a is_power_of_2(aux_size) check.
>
> The problem with not having that is that since
> perf_event_mmap_page::aux_{head,tail} are of Z mod 2^64 but your actual
> {head,tail} are of Z mod aux_size, you need aux_size to be a full
> divider of 2^64 or otherwise you get wrapping issues at the overflow.
>
> Having it them all 2^n makes the divider trivial.

I left it out so that the PMU callback could decide if it wants to do
the math or not. Maybe it can also be a constraint flag or is it not
worth it at all?

Regards,
--
Alex
