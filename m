Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047Ab3EAAzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 20:55:35 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:34020 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760460Ab3EAAz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 20:55:29 -0400
Date: Tue, 30 Apr 2013 17:55:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 08/34] arm: Use generic idle loop
Message-ID: <20130501005523.GN3780@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <87zjxv9lga.fsf@linaro.org>
 <alpine.LFD.2.02.1303251230440.22263@ionos>
 <20130325114808.GQ4977@n2100.arm.linux.org.uk>
 <alpine.LFD.2.02.1303251501520.22263@ionos>
 <20130408214719.GN17995@n2100.arm.linux.org.uk>
 <alpine.LFD.2.02.1304091106360.21884@ionos>
 <20130409093836.GA14496@n2100.arm.linux.org.uk>
 <51798C1D.9090405@codeaurora.org>
 <alpine.LFD.2.02.1304252300030.21884@ionos>
 <51806682.4040003@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51806682.4040003@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050100-3620-0000-0000-000002458D6D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 05:49:06PM -0700, Stephen Boyd wrote:
> On 04/25/13 14:01, Thomas Gleixner wrote:
> > On Thu, 25 Apr 2013, Stephen Boyd wrote:
> >> On 04/09/13 02:38, Russell King - ARM Linux wrote:
> >>> On Tue, Apr 09, 2013 at 11:20:31AM +0200, Thomas Gleixner wrote:
> >>>> On Mon, 8 Apr 2013, Russell King - ARM Linux wrote:
> >>>>> On Mon, Mar 25, 2013 at 03:02:39PM +0100, Thomas Gleixner wrote:
> >>>>> So, how can I review these changes when all there is is a git URL, and
> >>>>> I *do* not want to pull them into my tree without first looking at the
> >>>>> patches, possibly reviewing them and *replying* with the patch inline?
> >>>> the patches were CC'ed to LKML and linux-arch and I expected that you
> >>>> are at least having the latter. Find the relevant patch inlined below.
> >>> I've not been on linux-arch for a few years now, after it evolved into
> >>> yet another lkml-like list with high traffic rates, where mainly specific
> >>> x86 issues seemed to be discussed, rather than it being a way to contact
> >>> all arch maintainers.
> >>>
> >>>> It is a counter. I looked carefully at all the various slightly
> >>>> differently fcked up implementations and picked the counter based one
> >>>> as it fits all requirements.
> >>> Great, thanks.  The attached patch looks fine to me.
> >> I'm pretty sure that we need to apply this patch now that
> >> rcu_idle_enter()/exit() is called lower down in the idle loop. Kevin,
> >> did you test hotplug?
> > If the patch is agreed on, I guess I should take it via my idle
> > consolidation branch, right ?
> 
> Yes I think so. Hopefully Russell King or Paul McKenney can ack this patch.
> 
> >  
> >> ----8<-----
> >>
> >> From: Stephen Boyd <sboyd@codeaurora.org>
> >> Subject: [PATCH] ARM: smp: Drop RCU_NONIDLE usage in cpu_die()
> >>
> >> Before f7b861b (arm: Use generic idle loop, 2013-03-21) ARM would
> >> kill the CPU within the rcu idle section. Now that the
> >> rcu_idle_enter()/exit() pair have been pushed lower down in the
> >> idle loop this is no longer true and so using RCU_NONIDLE here is
> >> no longer necessary and also harmful because RCU is not actually
> >> idle at this point.
> >>
> >> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

>From an RCU perspective:

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> >> ---
> >>  arch/arm/kernel/smp.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> >> index 4619177..78f1eb5 100644
> >> --- a/arch/arm/kernel/smp.c
> >> +++ b/arch/arm/kernel/smp.c
> >> @@ -233,7 +233,7 @@ void __ref cpu_die(void)
> >>         mb();
> >>  
> >>         /* Tell __cpu_die() that this CPU is now safe to dispose of */
> >> -       RCU_NONIDLE(complete(&cpu_died));
> >> +       complete(&cpu_died);
> >>  
> >>         /*
> >>          * actual CPU shutdown procedure is at least platform (if not
> >>
> >> -- 
> >> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> >> hosted by The Linux Foundation
> >>
> >>
> 
> 
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
> 

