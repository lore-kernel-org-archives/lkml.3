Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbaIHLRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 07:17:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:63855 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238AbaIHLRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 07:17:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,486,1406617200"; 
   d="scan'208";a="596195168"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 02/22] perf: Add AUX area to ring buffer for raw data streams
In-Reply-To: <20140908070242.GS19379@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com> <1408538179-792-3-git-send-email-alexander.shishkin@linux.intel.com> <20140908070242.GS19379@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 08 Sep 2014 14:16:56 +0300
Message-ID: <87lhpuuztj.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, Aug 20, 2014 at 03:35:59PM +0300, Alexander Shishkin wrote:
>> From: Peter Zijlstra <peterz@infradead.org>
>> 
>> This patch introduces "AUX space" in the perf mmap buffer, intended for
>> exporting high bandwidth data streams to userspace, such as instruction
>> flow traces.
>> 
>> AUX space is a ring buffer, defined by aux_{offset,size} fields in the
>> user_page structure, and read/write pointers aux_{head,tail}, which abide
>> by the same rules as data_* counterparts of the main perf buffer.
>> 
>> In order to allocate/mmap AUX, userspace needs to set up aux_offset to
>> such an offset that will be greater than data_offset+data_size and
>> aux_size to be the desired buffer size. Both need to be page aligned.
>> Then, same aux_offset and aux_size should be passed to mmap() call and
>> if everything adds up, you should have an AUX buffer as a result.
>> 
>> Pages that are mapped into this buffer also come out of user's mlock
>> rlimit plus perf_event_mlock_kb allowance.
>> 
>> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
>> ---
>
>> +void rb_free_aux(struct ring_buffer *rb, struct perf_event *event)
>> +{
>> +	struct perf_event *iter;
>> +	int pg;
>> +
>> +	if (rb->aux_priv) {
>> +		/* disable all potential writers before freeing */
>> +		rcu_read_lock();
>> +		list_for_each_entry_rcu(iter, &rb->event_list, rb_entry)
>> +			perf_event_disable(iter);
>> +		rcu_read_unlock();
>
> Hmm, I cannot remember this from the last time; and its not explained
> why this was added.
>
> This would change semantics between munmap of a buffer with and without
> AUX bits in. 

Indeed, but this seems fair: if an event is generating AUX data while we
unmap the AUX buffer, there is no reason to keep it on, because chances
are, AUX data is the only thing this event is generating. The
alternative would be to have a separate callback for this, but then
again, that would race with other pmu callbacks, since it would be
called from munmap() path. I should add an elaborate comment about this.

Does this sound reasonable?

Regards,
--
Alex
