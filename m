Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbaEIOaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 10:30:06 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51730 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753305AbaEIOaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 10:30:04 -0400
Date: Fri, 9 May 2014 15:29:56 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Sonny Rao <sonnyrao@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Douglas Anderson <dianders@chromium.org>,
        Bhaskar Janakiraman <bjanakiraman@chromium.org>,
        Olof <olofj@chromium.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: CPU performance counters not working on big.LITTLE switcher
Message-ID: <20140509142956.GE3921@e103592.cambridge.arm.com>
References: <CAPz6YkXsig6XornqoMyn5DtRd9NECyc+qgQo39RQK0sDeat34Q@mail.gmail.com>
 <alpine.LFD.2.11.1405052238230.980@knanqh.ubzr>
 <CAPz6YkXFeoj5HyrpD3tETj+9mhesmvADNcxeQtMRhouWf3sXGg@mail.gmail.com>
 <alpine.LFD.2.11.1405061613590.980@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1405061613590.980@knanqh.ubzr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 04:28:49PM -0400, Nicolas Pitre wrote:
> On Mon, 5 May 2014, Sonny Rao wrote:
> 
> > On Mon, May 5, 2014 at 7:52 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> > > On Mon, 5 May 2014, Sonny Rao wrote:
> > >
> > >> Hi, we have the problem today that cpu based performance counters don't
> > >> work when we're using the big.LITTLE switcher on Exynos 5420, and it
> > >> doesn't look like code exists to deal with this in the switcher.
> > >>
> > >> As it stands right now, if you put an A-15 or A-7 PMU node into your
> > >> device-tree on an bl_switcher system it's very broken.  At the minimum, I
> > >> think it should disable performance counters until there's some kind of
> > >> proper implementation.
> > >>
> > >> I looked into trying to make this work, but it turned out to not be as
> > >> simple as just context switching counters from A-15 to A-7.  The biggest
> > >> problem is that the PMUs are not architecturally compatible.  There are
> > >> different events and differing numbers of counters on these two cores.
> > >>  There's also the tangential issue of representing this in the device tree,
> > >> but that's far less important.
> > >>
> > >> My guess as to how to fix this is to create an "architectural" PMU which
> > >> contains the intersection of the two performance monitor units with the
> > >> minimum number of counters supported by either core (which in this case
> > >> looks to be 4 on the A7).  However, I don't really have the bandwidth to
> > >> work on this at  the moment.  I was mostly wondering, have other people run
> > >> into this limitation and is there any sort of plan to work on it?
> > >
> > > The Linaro kernel release from a year ago or so contained a hack to make
> > > PMUs available and cope with the switcher.
> > 
> > Ok, any pointers?  Like I mentioned, if one enables the A15 Counters
> > with an upstream kernel that's using the switcher, I think things are
> > very broken, and since the switcher code is upstream, it seems like at
> > a minimum it would be good to deal with that somehow.  The big hammer
> > would be just to make hardware PMU support incompatible with the
> > switcher support, but maybe there are better solutions.
> 
> The problem is not specific to the switcher though.  Suppose you have 
> all cores enabled and visible to the system.  In that case nothing 
> prevents a task from being migrated around and therefore be subject to 
> different PMUs already.
> 
> > > However, the ultimate solution is to add multi-PMU support in a generic
> > > way to the kernel and let user space see both A15 and A7 counters.  It
> > > is then up to the analysis tools to consolidate (some of) them if
> > > wanted.
> > 
> > How is that meant to work?  I think you'd need the generic perf-event
> > subsystem to properly support multiple CPU-type PMUs, which it
> > currently does not.
> 
> Exact.  That's where a proper solution should start.

Mark Rutland is actively working on this again AFAIK.

I believe there is nothing so special about the "CPU-style" PMU in perf,
except for a load of supposedly generic event names that are not very
portable between CPUs and need careful interpretation.   So, the current
approach is to expose the CPU PMUs as additional PMU types.  The perf
tool integration is not seamless yet, but should be usable when the
patches land.

There's some additional work I wanted to do when things are ready so
that the handling of PMUs across suspend/resume is compatible with IKS,
though it would be down to Linaro folks to do the IKS side of the
integration.

> 
> > In the case of a system using the switcher, would
> > the events on a particular logical "cpu" just get inter-mingled from
> > the different cores?  I think it would be difficult to make sense of
> > data like that without extra information about when the logical cpu
> > switched from one type to the other.
> 
> Sure, but that is not much different from a task migrating across 
> different clusters even without the switcher.  The idea in that case 
> would be for both PMU types to be tracked.  That way you'd get A7-cycles 
> and A15-cycles, A7-cache_miss and A15_cache_miss, etc.  If you don't 
> care about the split then the reporting tool would just have to sum 
> them, but having split results might be very helpful.

The only sane approach is not to count "instructions", but, say,
to "A15 instructions" and "A7 instructions" as separate events.

Aggregating the counts can be misleading because the two CPUs may not
have precisely the same definition of an "instruction" for accounting
purposes.

Treating the CPU PMUs as two distinct types of PMU should make it
relatively easy to get separate counts for each kind of CPU.

Cheers
---Dave

> 
> > > Someone at ARM indicated they'd be working on the multi-PMU support if I
> > > remember correctly.  For that reason, Linaro stopped maintaining the
> > > initial hack since it was a lot of work to keep it working on top of
> > > later kernels and a better solution was coming anyway.  I don't know
> > > what the status of that work is though.
> > >
> > >
> > > Nicolas
> > 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
