Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbaJXL0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:26:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52407 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111AbaJXL0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:26:20 -0400
Date: Fri, 24 Oct 2014 13:26:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 12/20] x86: perf: intel_pt: Intel PT PMU driver
Message-ID: <20141024112610.GX21513@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1413207948-28202-13-git-send-email-alexander.shishkin@linux.intel.com>
 <20141022142003.GQ12706@worktop.programming.kicks-ass.net>
 <878uk53o1e.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878uk53o1e.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 10:49:33AM +0300, Alexander Shishkin wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > On Mon, Oct 13, 2014 at 04:45:40PM +0300, Alexander Shishkin wrote:
> >> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> >> @@ -1528,6 +1528,14 @@ again:
> >>  	}
> >>  
> >>  	/*
> >> +	 * Intel PT
> >> +	 */
> >> +	if (__test_and_clear_bit(55, (unsigned long *)&status)) {
> >> +		handled++;
> >> +		intel_pt_interrupt();
> >> +	}
> >> +
> >
> > How does the PT interrupt interact with the regular PMI? In particular
> > does it respect stuff like FREEZE_ON_PMI etc?
> 
> It ignores the FREEZE_ON_PMI bit. I stop it by hand inside the PMI
> handler, so you can see parts of the handler in the trace if you're
> tracing the kernel.

Urgh, horrid that. Routing something to the same interrupt, sharing
status registers but not observing the same semantics for the interrupt
is a massive fail.

IIRC Andi was planning to start using FREEZE_ON_PMI to avoid the MSR
writes in intel_pmu_{disable,enable}_all(), this interrupt not actually
respecting that makes that non-trivial.

We already use FREEZE_ON_PMI for LBR, but for now PT and LBR are
mutually exclusive so that's not a problem, if we ever get those working
together this needs to get fixed.
