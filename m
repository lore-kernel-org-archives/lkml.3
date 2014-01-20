Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbaATLGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:06:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53354 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaATLGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:06:09 -0500
Date: Mon, 20 Jan 2014 12:05:42 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Len Brown <lenb@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-next@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the tip tree
Message-ID: <20140120110542.GY31570@twins.programming.kicks-ass.net>
References: <20140116145829.5e4fcab103b1c5c77501ee77@canb.auug.org.au>
 <20140116121955.GQ31570@twins.programming.kicks-ass.net>
 <20140117074628.88698f59939c9002b7c12968@canb.auug.org.au>
 <CAJvTdKnoNh2YAvtXraYxTct+8e6e_8Om9cAZGSTpy8UO=t=W4w@mail.gmail.com>
 <20140120082620.GB30183@twins.programming.kicks-ass.net>
 <52DCE4CF.2060605@zytor.com>
 <20140120091600.GW31570@twins.programming.kicks-ass.net>
 <52DCEAF4.3040902@zytor.com>
 <20140120095532.GX31570@twins.programming.kicks-ass.net>
 <52DD01CD.9030809@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DD01CD.9030809@zytor.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 03:00:29AM -0800, H. Peter Anvin wrote:
> On 01/20/2014 01:55 AM, Peter Zijlstra wrote:
> > 
> > Ok, so I still don't get the problem of enabling interrupts early.
> > 
> > If we enable them early we can get interrupts; which afaict fall into
> > two groups, those that do and do not set NEED_RESCHED.
> > 
> > For those that do not set NEED_RESCHED, we'd have woken from MWAIT/HLT
> > and looped right back into it, so receiving those early -- before
> > actually calling MWAIT/HLT seems like a NO-OP.
> 
> The description for commit d331e739f5ad seems to indicate otherwise:
> 
>     Idle callbacks has some races when enter_idle() sets isidle and
> subsequent
>     interrupts that can happen on that CPU, before CPU goes to idle. Due
> to this,
>     an IDLE_END can get called before IDLE_START. To avoid these races,
> disable
>     interrupts before enter_idle and make sure that all idle routines do not
>     enable interrupts before entering idle.
> 
> This implies to me that once we have set isidle, if we take an interrupt
> we *have* to drop out of the idle routine.

I don't think that applies anymore; the generic idle loop calls
arch_cpu_idle_enter() before calling arch_cpu_idle() where we would do
the enable.

So in that sense its impossible to get arch_cpu_idle_exit() -- or rather
exit_idle() as called from the interrupts -- to happen before
arch_cpu_idle_enter().
