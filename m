Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbaBQOeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 09:34:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43181 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaBQOd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 09:33:58 -0500
Date: Mon, 17 Feb 2014 15:33:40 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 03/11] perf: Allow for multiple ring buffers per event
Message-ID: <20140217143340.GR27965@twins.programming.kicks-ass.net>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1391683834-29868-4-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391683834-29868-4-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 12:50:26PM +0200, Alexander Shishkin wrote:
> Currently, a perf event can have one ring buffer associated with it, that
> is used for perf record stream. However, some pmus, such as instruction
> tracing units, will generate binary streams of their own, for which it is
> convenient to reuse the ring buffer code to export such streams to the
> userspace. So, this patch extends the perf code to support more than one
> ring buffer per event.



No-no-no-no... like I said last time around, 'splice' whatever results
you get into a perf buffer and make it look like perf events.

I'm not convinced it needs to be a PERF_RECORD_SAMPLE; but some
PERF_RECORD_* type for sure. Also it must allow interleaving with other
events.

I understand your use-case wants sideband events in another buffer due
to generation speed and not particularly caring about itrace data that's
lost but wanting a coherent side-band stream.

And that's fine, use two events for this; but that doesn't mean it
shouldn't be possible to mix them.

So for example:

/*
 * struct {
 *	struct perf_event_header	header;
 *	u64				extended_size;
 *	u64				data_offset;
 *	u64				data_size;
 *	struct sample_id		sample_id;
 * }
PERF_RECORD_DATA


Now; suppose your itrace data is 1mb, allocate an event of
1mb+sizeof(PERF_RECORD_DATA)+PAGE_SIZE-1.

Then write the PERF_RECORD_DATA structure into the normal ring-buffer
location; set data_offset to point to the first page boundary, data_size
to 1mb.

Then frob things such that perf_mmap_to_page() for the next 1mb of pages
points to your buffer pages and wipe the page-table entries.

Then we need to somehow shoot down TLBs, and that's tricky, because up
to this point we're in interrupt context (ideally the whole itrace
nonsense gets dropped out of the PMI through an irq_work ASAP, no point
in doing it in NMI context anyhow).

So for TLB shootdown we can do a number of vile-ish things; but I think
the prettiest is relying (and thus mandating) that the consumer wait in
poll()/select()/etc. And either adding something like poll_work() which
gets ran on poll-wakeup on the right task, or doing something ugly with
task-work.

The point being that the consumer only needs to flush the TLBs before
trying to access the buffer and that its clearly not doing so when its
poll()-ing.

Another vile option is shooting down page-table entries and TLBs for the
entire buffer when writing into the control page to update the tail --
that has some other 'fun' issues, but should be possible as well.
