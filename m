Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbaESNHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:07:24 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:40663 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbaESNHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:07:23 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Mon, 19 May 2014 09:11:15 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: perfevents: irq loop stuck!
In-Reply-To: <20140516074445.GJ11096@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1405190906190.14771@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405132256470.27229@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405142246170.30015@vincent-weaver-1.umelst.maine.edu> <20140515182136.GI11096@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1405160017120.1351@vincent-weaver-1.umelst.maine.edu>
 <20140516074445.GJ11096@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014, Peter Zijlstra wrote:

> On Fri, May 16, 2014 at 12:25:28AM -0400, Vince Weaver wrote:
> > anyway I'm not sure if it's worth tracking this more if it's possible to 
> > mostly fix the case by fixing the sample_period bounds.
> 
> Right, so lets start with that, if it triggers again, we'll have another
> look.

I applied the patch and can verify it avoids the too-big-period-wrapping 
problem.

I left things fuzzing over the weekend, and eventually the bug triggered 
again.  The problem issue still seems to be caused by 
	"sample_period=2,fixed counter 0"
so maybe there's an erratum out there I should be looking up.

The fuzzing also turned up a few other issues, and in the end after 2 days 
it locked up the machine so hard that it also took out the ethernet switch 
due to some sort of packet trasmit storm, which is a failure mode I 
have to admit I haven't encountered before.

Vince

[69213.252805] ------------[ cut here ]------------
[69213.260637] WARNING: CPU: 4 PID: 11343 at 
arch/x86/kernel/cpu/perf_event_intel.c:1373 intel_pmu_handle_irq+0x2a4/0x3c0()
[69213.276788] perfevents: irq loop stuck!
...
[69213.686561] CPU#4: ctrl:       0000000000000000
[69213.694352] CPU#4: status:     0000000000000000
[69213.701979] CPU#4: overflow:   0000000000000000
[69213.709599] CPU#4: fixed:      00000000000000b8
[69213.717172] CPU#4: pebs:       0000000000000000
[69213.724596] CPU#4: active:     0000000300000000
[69213.731939] CPU#4:   gen-PMC0 ctrl:  000000000013412e
[69213.739877] CPU#4:   gen-PMC0 count: 000000000000002c
[69213.747820] CPU#4:   gen-PMC0 left:  0000ffffffffffd7
[69213.755657] CPU#4:   gen-PMC1 ctrl:  0000000000138b40
[69213.763461] CPU#4:   gen-PMC1 count: 00000000000086b3
[69213.771152] CPU#4:   gen-PMC1 left:  0000ffffffff81c9
[69213.778742] CPU#4:   gen-PMC2 ctrl:  000000000013024e
[69213.786271] CPU#4:   gen-PMC2 count: 0000000000000001
[69213.793784] CPU#4:   gen-PMC2 left:  0000ffffffffffff
[69213.801227] CPU#4:   gen-PMC3 ctrl:  0000000000134f2e
[69213.808720] CPU#4:   gen-PMC3 count: 00000000000009f9
[69213.816192] CPU#4:   gen-PMC3 left:  0000fffffffff6de
[69213.823620] CPU#4: fixed-PMC0 count: 0000fffffffffffe
[69213.831035] CPU#4: fixed-PMC1 count: 0000ffffea2a90b2
[69213.838477] CPU#4: fixed-PMC2 count: 00000000051c5865
[69213.845792] perf_event_intel: clearing PMU state on CPU#4

