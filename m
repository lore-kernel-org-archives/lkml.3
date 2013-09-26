Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab3IZHKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:10:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55700 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab3IZHKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:10:02 -0400
Message-ID: <1380179397.7525.45.camel@marge.simpson.net>
Subject: Re: [RFC][PATCH] sched: Avoid select_idle_sibling() for
 wake_affine(.sync=true)
From: Mike Galbraith <bitbucket@online.de>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 26 Sep 2013 09:09:57 +0200
In-Reply-To: <5243D4E8.4000707@linux.vnet.ibm.com>
References: <20130925075341.GB3081@twins.programming.kicks-ass.net>
	 <1380099377.8523.9.camel@marge.simpson.net>
	 <5243A0E9.4060802@linux.vnet.ibm.com>
	 <1380166898.5431.40.camel@marge.simpson.net>
	 <5243C24F.6070704@linux.vnet.ibm.com>
	 <1380173688.7525.12.camel@marge.simpson.net>
	 <5243D4E8.4000707@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:ZfbwOopFBzmkYjKFEjGKWSHCR3RvtwXrfnVjr+1Pn3X
 gLJq+x3YYQ5aPNkkwPEMWRPXjgVSnjFco3fI3TWXJ+tDKZ7nRP
 yjj4IUnHePJua/2D07nLwrfwFEre9+dplOhhSjdeohbfdd0MB6
 YkdgtFyfkbADkZI90rdd7NYlcB6UTtKsBqOQ+mnj/Ijxq2IY4k
 sDLKMAfZ+O4BGYRMZE4ZFfG8vy5pRDZVEU67GJ03DePbQvFyjz
 A3q1saJm/jQ5kATPwGtw+dhjtFWqGFfEXrKPaay64sLpIQ20qw
 03l452MHveYYs4MY+G+HQyf1/uFTNOspqWwf7y4Misbm5H6801
 EtXmRbbouWXHUgU7+TwcOJFmCUWVsI1j8nBkiwnpY3yAAZxUIk
 oNsPO3xqKJ8FQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-26 at 14:32 +0800, Michael wang wrote: 
> On 09/26/2013 01:34 PM, Mike Galbraith wrote:
> > On Thu, 2013-09-26 at 13:12 +0800, Michael wang wrote: 
> >> On 09/26/2013 11:41 AM, Mike Galbraith wrote:
> >> [snip]
> >>>> Like the case when we have:
> >>>>
> >>>> 	core0 sg		core1 sg
> >>>> 	cpu0	cpu1		cpu2	cpu3
> >>>> 	waker	busy		idle	idle
> >>>>
> >>>> If the sync wakeup was on cpu0, we can:
> >>>>
> >>>> 1. choose cpu in core1 sg like we did usually
> >>>>    some overhead but tend to make the load a little balance
> >>>> 	core0 sg		core1 sg
> >>>> 	cpu0	cpu1		cpu2	cpu3
> >>>> 	idle	busy		wakee	idle
> >>>
> >>> Reducing latency and increasing throughput when the waker isn't really
> >>> really going to immediately schedule off as the hint implies.  Nice for
> >>> bursty loads and ramp.
> >>>
> >>> The breakeven point is going up though.  If you don't have nohz
> >>> throttled, you eat tick start/stop overhead, and the menu governor
> >>> recently added yet more overhead, so maybe we should say hell with it.
> >>
> >> Exactly, more and more factors to be considered, we say things get
> >> balanced but actually it's not the best choice...
> >>
> >>>
> >>>> 2. choose cpu0 like the patch proposed
> >>>>    no overhead but tend to make the load a little more unbalance
> >>>> 	core0 sg		core1 sg
> >>>> 	cpu0	cpu1		cpu2	cpu3
> >>>> 	wakee	busy		idle	idle
> >>>>
> >>>> May be we should add a higher scope load balance check in wake_affine(),
> >>>> but that means higher overhead which is just what the patch want to
> >>>> reduce...
> >>>
> >>> Yeah, more overhead is the last thing we need.
> >>>
> >>>> What about some discount for sync case inside select_idle_sibling()?
> >>>> For example we consider sync cpu as idle and prefer it more than the others?
> >>>
> >>> That's what the sync hint does.  Problem is, it's a hint.  If it were
> >>> truth, there would be no point in calling select_idle_sibling().
> >>
> >> Just wondering if the hint was wrong in most of the time, then why don't
> >> we remove it...
> > 
> > For very fast/light network ping-pong micro-benchmarks, it is right.
> > For pipe-test, it's absolutely right, jabbering parties are 100%
> > synchronous, there is nada/nil/zip/diddly squat overlap reclaimable..
> > but in the real world, it ain't necessarily so.
> > 
> >> Otherwise I think we can still utilize it to make some decision tends to
> >> be correct, don't we?
> > 
> > Sometimes :)
> 
> Ok, a double-edged sword I see :)
> 
> May be we can wave it carefully here, give the discount to a bigger
> scope not the sync cpu, for example:
> 
> 	sg1				sg2
> 	cpu0	cpu1	cpu2	cpu3	cpu4	cpu5	cpu6	cpu7
> 	waker	idle	idle	idle	idle	idle	idle	idle
> 
> If it's sync wakeup on cpu0 (only waker), and the sg is wide enough,
> which means one cpu is not so influencial, then suppose cpu0 to be idle
> could be more safe, also prefer sg1 than sg2 is more likely to be right.
> 
> And we can still choose idle-cpu at final step, like cpu1 in this case,
> to avoid the risk that waker don't get off as it said.
> 
> The key point is to reduce the influence of sync, trust a little but not
> totally ;-)

What we need is a dirt cheap way to fairly accurately predict overlap
potential (todo: write omniscience().. patent, buy planet).

-Mike

