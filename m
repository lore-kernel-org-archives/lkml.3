Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbaIILyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:54:19 -0400
Received: from mga14.intel.com ([192.55.52.115]:41522 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbaIILyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:54:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,491,1406617200"; 
   d="scan'208";a="588513023"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 09/22] perf: Support overwrite mode for AUX area
In-Reply-To: <20140909105537.GJ6758@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com> <1408538179-792-10-git-send-email-alexander.shishkin@linux.intel.com> <20140909084436.GY19379@twins.programming.kicks-ass.net> <87y4ttt9m0.fsf@ashishki-desk.ger.corp.intel.com> <20140909105537.GJ6758@twins.programming.kicks-ass.net>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 09 Sep 2014 14:53:42 +0300
Message-ID: <87sik1t3g9.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Tue, Sep 09, 2014 at 12:40:39PM +0300, Alexander Shishkin wrote:
>> Peter Zijlstra <peterz@infradead.org> writes:
>> 
>> > On Wed, Aug 20, 2014 at 03:36:06PM +0300, Alexander Shishkin wrote:
>> >
>> >> diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
>> >> index 925f369947..5006caba63 100644
>> >> --- a/kernel/events/ring_buffer.c
>> >> +++ b/kernel/events/ring_buffer.c
>> >
>> >> @@ -294,9 +295,22 @@ void perf_aux_output_end(struct perf_output_handle *handle, unsigned long size,
>> >>  			 bool truncated)
>> >>  {
>> >>  	struct ring_buffer *rb = handle->rb;
>> >> +	unsigned long aux_head;
>> >>  
>> >> +	aux_head = local_read(&rb->aux_head);
>> >> +
>> >> +	if (rb->aux_overwrite) {
>> >> +		local_set(&rb->aux_head, size);
>> >> +
>> >> +		/*
>> >> +		 * Send a RECORD_AUX with size==0 to communicate aux_head
>> >> +		 * of this snapshot to userspace
>> >> +		 */
>> >> +		perf_event_aux_event(handle->event, size, 0, truncated);
>> >
>> > Humm.. why not write a 'normal' AUX record?
>> 
>> In this mode, the hardware is running in a circular buffer mode,
>> overwriting old data, so we don't actually know the size of the
>> snapshot, we have userspace figure it out later on (based on timestamps,
>> for example). I didn't want to configure PMI for this mode to avoid
>> overhead, but with PMI we can try to keep track of the overwrites and
>> try to infer the actual snapshot size in the kernel. For Intel PT. As
>> far as I can tell, ARM's scatter-gather trace-to-memory storing block
>> does not generate interrupts at all.
>
> Well, wouldn't the 'size' be basically the entire buffer. All you have
> to then provide is the head pointer.

Yes, that's what the code above is doing. We can replace size==0 with
size==$buffer_size to mean the same thing.

> Ideally you would also provide a
> tail pointer so you know when to stop, but I suppose you can infer that
> from the data stream itself?

The tail pointer is the problem I mentioned above, because it's either

  - where we stopped the previous time
  - head+1, if old data is overwritten

and in order to tell the difference, we need an interrupt.
We can infer where the new data starts from the timestamps in the trace
stream, so the decoder can take care of it (and that's how it's done at
the moment).

> If you can provide the tail you can indeed
> compute the size etc.. at which point you don't have to rely on parsing
> the stream etc.

Ideally, there wouldn't be too many adjacent snapshots so it won't even
be a problem. But yes, if we want to reliably know the tail/size, we
need an interrupt.

Regards,
--
Alex
