Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaEAMfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 08:35:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:33073 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaEAMfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 08:35:00 -0400
Date: Thu, 1 May 2014 14:35:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
In-Reply-To: <20140501115042.GC13658@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1405011433180.6261@ionos.tec.linutronix.de>
References: <alpine.DEB.2.10.1404281017590.18996@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1404281447570.18996@vincent-weaver-1.umelst.maine.edu> <20140429094632.GP27561@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404291411220.22490@vincent-weaver-1.umelst.maine.edu>
 <20140429190108.GB30445@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1404291534520.22490@vincent-weaver-1.umelst.maine.edu> <20140430184437.GH17778@laptop.programming.kicks-ass.net> <alpine.DEB.2.10.1404301701260.15279@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.02.1404302310530.6261@ionos.tec.linutronix.de> <20140501102602.GP11096@twins.programming.kicks-ass.net> <20140501115042.GC13658@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2014, Peter Zijlstra wrote:
> On Thu, May 01, 2014 at 12:26:02PM +0200, Peter Zijlstra wrote:
> > On Thu, May 01, 2014 at 12:51:33AM +0200, Thomas Gleixner wrote:
> > > And that's the issue which puzzles us. Let's look at what we expect:
> > > 
> > > Now the trace shows a different story:
> > > 
> > >      perf_fuzzer-4387  [001]  1802.628659: sys_enter:            NR 298 (69bb58, 0, ffffffff, 12, 0, 0)
> > 
> > That's a per-cpu event (.pid = -1, .cpu = 12), they don't get inherited,
> > so the only thing keeping it alive is the fd the child got. So
> > exit_files() killing this thing makes perfect sense.

Duh, right. Should have noticed :(

> 
> grep ptr=0xffff880118fda000 bug.out | less
> 
> We find lovely bits such as:
> 
>      perf_fuzzer-4387  [001]  1773.427175: kmalloc:              (perf_event_alloc+0x5a) call_site=ffffffff8113a8fa ptr=0xffff880118fda000 bytes_req=1272 bytes_alloc=2048 gfp_flags=GFP_KERNEL|GFP_ZERO
>      ksoftirqd/6-38    [006]  1773.457770: kfree:                (free_event_rcu+0x2f) call_site=ffffffff8113177f ptr=0xffff880118fda000
>           <idle>-0     [007]  1774.020378: kfree:                (free_event_rcu+0x2f) call_site=ffffffff8113177f ptr=0xffff880118fda000
>      perf_fuzzer-4387  [000]  1774.096354: kmalloc:              (perf_event_alloc+0x5a) call_site=ffffffff8113a8fa ptr=0xffff880118fda000 bytes_req=1272 bytes_alloc=2048 gfp_flags=GFP_KERNEL|GFP_ZERO
> 
> 
> That's almost half a second between the double free, Vince, is your TSC
> solid?

grep DROPPED bug.out

Now align that with the double malloc/free sites and you have an explanation ...



