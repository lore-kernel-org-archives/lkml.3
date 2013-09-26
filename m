Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab3IZGQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:16:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59417 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab3IZGQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:16:04 -0400
Message-ID: <1380176119.7525.27.camel@marge.simpson.net>
Subject: Re: [RFC][PATCH] sched: Avoid select_idle_sibling() for
 wake_affine(.sync=true)
From: Mike Galbraith <bitbucket@online.de>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 26 Sep 2013 08:15:19 +0200
In-Reply-To: <1380173688.7525.12.camel@marge.simpson.net>
References: <20130925075341.GB3081@twins.programming.kicks-ass.net>
	 <1380099377.8523.9.camel@marge.simpson.net>
	 <5243A0E9.4060802@linux.vnet.ibm.com>
	 <1380166898.5431.40.camel@marge.simpson.net>
	 <5243C24F.6070704@linux.vnet.ibm.com>
	 <1380173688.7525.12.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:Su6VRGZrDpQKARCxNO9Je3AKZRHQJt7LMWg/zDPLzEj
 15+2EZ952x4GsGWxqfUxjIRNEX5te/0WykIGefWAYuRLstkjCT
 aqM1bmvBSIfxnlKRVzakwriEuh0wO9Z/uD6psAo//62hpn/F5V
 JpdcrwQMhSv/4yBlkaInj3+4c4QRNAtJz2xhH60ISsRz5Ly/FB
 uWuGYkfwb3Rk4fqmrgGeNzsSsfRz2bx75d/ydtZX46EhZvEbC/
 1ZrIOBjzFcjuKC/6CCDJODYw5KNp35RwdqO4fFqcLfAEyzCXrJ
 117QDE7PeOqC2Jbxab8pCo+7V8nPKnXj5zGlgJdkybVPumw+7f
 WWP3w3IoQna9MzgEW7ed1/XywvfO720N8AejXdkOHFJWJHxeOV
 PmwkOjxHJUcug==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-26 at 07:34 +0200, Mike Galbraith wrote: 
> On Thu, 2013-09-26 at 13:12 +0800, Michael wang wrote: 
> > On 09/26/2013 11:41 AM, Mike Galbraith wrote:
> > [snip]
> > >> Like the case when we have:
> > >>
> > >> 	core0 sg		core1 sg
> > >> 	cpu0	cpu1		cpu2	cpu3
> > >> 	waker	busy		idle	idle
> > >>
> > >> If the sync wakeup was on cpu0, we can:
> > >>
> > >> 1. choose cpu in core1 sg like we did usually
> > >>    some overhead but tend to make the load a little balance
> > >> 	core0 sg		core1 sg
> > >> 	cpu0	cpu1		cpu2	cpu3
> > >> 	idle	busy		wakee	idle
> > > 
> > > Reducing latency and increasing throughput when the waker isn't really
> > > really going to immediately schedule off as the hint implies.  Nice for
> > > bursty loads and ramp.
> > > 
> > > The breakeven point is going up though.  If you don't have nohz
> > > throttled, you eat tick start/stop overhead, and the menu governor
> > > recently added yet more overhead, so maybe we should say hell with it.
> > 
> > Exactly, more and more factors to be considered, we say things get
> > balanced but actually it's not the best choice...
> > 
> > > 
> > >> 2. choose cpu0 like the patch proposed
> > >>    no overhead but tend to make the load a little more unbalance
> > >> 	core0 sg		core1 sg
> > >> 	cpu0	cpu1		cpu2	cpu3
> > >> 	wakee	busy		idle	idle
> > >>
> > >> May be we should add a higher scope load balance check in wake_affine(),
> > >> but that means higher overhead which is just what the patch want to
> > >> reduce...
> > > 
> > > Yeah, more overhead is the last thing we need.
> > > 
> > >> What about some discount for sync case inside select_idle_sibling()?
> > >> For example we consider sync cpu as idle and prefer it more than the others?
> > > 
> > > That's what the sync hint does.  Problem is, it's a hint.  If it were
> > > truth, there would be no point in calling select_idle_sibling().
> > 
> > Just wondering if the hint was wrong in most of the time, then why don't
> > we remove it...
> 
> For very fast/light network ping-pong micro-benchmarks, it is right.
> For pipe-test, it's absolutely right, jabbering parties are 100%
> synchronous, there is nada/nil/zip/diddly squat overlap reclaimable..
> but in the real world, it ain't necessarily so.
> 
> > Otherwise I think we can still utilize it to make some decision tends to
> > be correct, don't we?
> 
> Sometimes :)

P.S.  while we're slapping select_idle_sibling()'s _evil_ face, let's
give it a pat on the head too.  It showed regressions in bright red.
Put pipe-test on one core, you only see scheduler weight.. but entering
and exiting idle is part of the fast path, whether you're exercising it
by doing something silly or not.

-Mike

