Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbaATLBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:01:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43424 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbaATLBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:01:14 -0500
Message-ID: <52DD01CD.9030809@zytor.com>
Date: Mon, 20 Jan 2014 03:00:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Len Brown <lenb@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-next@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the tip tree
References: <20140116145829.5e4fcab103b1c5c77501ee77@canb.auug.org.au> <20140116121955.GQ31570@twins.programming.kicks-ass.net> <20140117074628.88698f59939c9002b7c12968@canb.auug.org.au> <CAJvTdKnoNh2YAvtXraYxTct+8e6e_8Om9cAZGSTpy8UO=t=W4w@mail.gmail.com> <20140120082620.GB30183@twins.programming.kicks-ass.net> <52DCE4CF.2060605@zytor.com> <20140120091600.GW31570@twins.programming.kicks-ass.net> <52DCEAF4.3040902@zytor.com> <20140120095532.GX31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140120095532.GX31570@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2014 01:55 AM, Peter Zijlstra wrote:
> 
> Ok, so I still don't get the problem of enabling interrupts early.
> 
> If we enable them early we can get interrupts; which afaict fall into
> two groups, those that do and do not set NEED_RESCHED.
> 
> For those that do not set NEED_RESCHED, we'd have woken from MWAIT/HLT
> and looped right back into it, so receiving those early -- before
> actually calling MWAIT/HLT seems like a NO-OP.

The description for commit d331e739f5ad seems to indicate otherwise:

    Idle callbacks has some races when enter_idle() sets isidle and
subsequent
    interrupts that can happen on that CPU, before CPU goes to idle. Due
to this,
    an IDLE_END can get called before IDLE_START. To avoid these races,
disable
    interrupts before enter_idle and make sure that all idle routines do not
    enable interrupts before entering idle.

This implies to me that once we have set isidle, if we take an interrupt
we *have* to drop out of the idle routine.

> For those setting NEED_RESCHED, we test NEED_RESCHED in all the right
> places.
> 
>  - current_set_polling_and_test(), we test need_resched after telling
>    remote CPUs they don't need to send interrupts because we're polling
>    for it -- the remote cpus set NEED_RESCHED before testing if we're
>    polling for it.
> 
>  - we test NEED_RESCHED after setting up the monitor and before calling
>    MWAIT. Therefore, if an interrupt would happen right before we call
>    MWAIT, the monitor is already set and the MWAIT does an immediate
>    exit.
> 
> AFAICT we simply cannot get stuck and miss a NEED_RESCHED this way.
> 

Well, it is obviously needed for the HLT case.  For MWAIT it seems like
the MONITOR should have gotten disarmed and therefore MWAIT shouldn't
sleep... I don't know off the top of my head if there are any errata in
that department and/or if there are any other issues.

	-hpa

