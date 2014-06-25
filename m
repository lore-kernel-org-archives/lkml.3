Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461AbaFYMM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:12:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57661 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330AbaFYMM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:12:58 -0400
Date: Wed, 25 Jun 2014 14:12:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC v2 6/7] perf: add api for pmus to write to AUX space
Message-ID: <20140625121249.GB3935@laptop>
References: <1402501310-31940-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1402501310-31940-7-git-send-email-alexander.shishkin@linux.intel.com>
 <20140624172723.GS3213@twins.programming.kicks-ass.net>
 <87fvitxmd8.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fvitxmd8.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 02:24:51PM +0300, Alexander Shishkin wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > On Wed, Jun 11, 2014 at 06:41:49PM +0300, Alexander Shishkin wrote:
> >> +void perf_aux_output_end(struct perf_output_handle *handle, unsigned long size,
> >> +			 bool truncated)
> >> +{
> >> +	struct ring_buffer *rb = handle->rb;
> >> +	unsigned long aux_head;
> >> +
> >> +	aux_head = local_read(&rb->aux_head);
> >> +	local_add(size, &rb->aux_head);
> >> +
> >> +	rb->user_page->aux_head = local_read(&rb->aux_head);
> >> +	smp_wmb();
> >> +
> >> +	perf_output_wakeup(handle);
> >> +	handle->event = NULL;
> >> +
> >> +	ring_buffer_put(rb);
> >> +}
> >
> > This thing is distinctly less complex than perf_output_put_handle().. ?
> 
> This one doesn't support nested writers, but there shouldn't be any
> either. But I notice now that the barrier is misplaced. Wakeup watermark
> is not yet taken care of, but will be. Anything else I'm missing?

Maybe put a comment in about explicitly not supporting nesting etc.
Maybe also a debug check to make sure we catch anybody doing it anyway.
