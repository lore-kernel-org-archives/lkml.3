Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaETJvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:51:12 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58752 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaETJvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:51:09 -0400
Date: Tue, 20 May 2014 11:51:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC 2/2] perf: add AUX area to ring buffer for raw data streams
Message-ID: <20140520095102.GV2485@laptop.programming.kicks-ass.net>
References: <1400166510-9234-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1400166510-9234-3-git-send-email-alexander.shishkin@linux.intel.com>
 <20140519085854.GW30445@twins.programming.kicks-ass.net>
 <87bnuuylha.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <87bnuuylha.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 03:57:37PM +0300, Alexander Shishkin wrote:
> Peter Zijlstra <peterz@infradead.org> writes:

> > I'm not entirely thrilled to expose it to the PMU like this.. I realize
> > you want this in order to get physically contiguous pages.
> 
> Hmm, I guess we can have code in perf core to carry out the allocation
> according to, say, contstraint flags and pass the page array down to the
> PMU if that sounds like a cleaner thing to do?
> 
> > Are you aware of allocation constraints for other architectures?
> 
> Somewhat. ARM's trace memory controller supports both scatter-gather and
> a plain contiguous buffer, I haven't found evidence of one being
> available while the other one isn't, so I'm inclined to assume that if
> it can write to system memory, it supports SG.

I've just added a patch from Vince Weaver:

  http://lkml.kernel.org/r/alpine.DEB.2.10.1405161708060.11099@vincent-weaver-1.umelst.maine.edu

That adds pmu::capabilities, I suppose we could start with something
like:

  PERF_PMU_CAP_AUX_BROKEN_SG

which would make the allocator attempt to fill the AUX buffer with as
big a chunks of contiguous memory as is available.

> > That appears to be missing a is_power_of_2(aux_size) check.
> >
> > The problem with not having that is that since
> > perf_event_mmap_page::aux_{head,tail} are of Z mod 2^64 but your actual
> > {head,tail} are of Z mod aux_size, you need aux_size to be a full
> > divider of 2^64 or otherwise you get wrapping issues at the overflow.
> >
> > Having it them all 2^n makes the divider trivial.
> 
> I left it out so that the PMU callback could decide if it wants to do
> the math or not. Maybe it can also be a constraint flag or is it not
> worth it at all?

I'd start with the most constrained model -- that is add the power of
two test -- and worry about relaxing it if it turns out its really
needed.
