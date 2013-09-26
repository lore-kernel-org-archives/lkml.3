Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab3IZDlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 23:41:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55614 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab3IZDlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 23:41:52 -0400
Message-ID: <1380166898.5431.40.camel@marge.simpson.net>
Subject: Re: [RFC][PATCH] sched: Avoid select_idle_sibling() for
 wake_affine(.sync=true)
From: Mike Galbraith <bitbucket@online.de>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 26 Sep 2013 05:41:38 +0200
In-Reply-To: <5243A0E9.4060802@linux.vnet.ibm.com>
References: <20130925075341.GB3081@twins.programming.kicks-ass.net>
	 <1380099377.8523.9.camel@marge.simpson.net>
	 <5243A0E9.4060802@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:nRkNtsrz6boaeMVAVXxMEwxSQrv12EWOWiAlEZ3UZpv
 etLB2kmCE32Nq7Uc2SYY+I3HyEO/Ik5CneRmitNMjjCPnnrcry
 TGmFhYKLDPkvokxogYgkbnXpPfVSZeFRBtzsbNMx8Yj4WIUUqk
 w7dqnq/fSKwZjbPXtEhAJI+uKgdL07Ygi3RY/6Ujw76QW45Tcu
 46kmLKBvOjZYrJMCQSQb0omyM++oTyc2btsjfIkBy4uLn0ZJJH
 SAK5wjyFgclu+N2VYgzaO8spXoCqfFyU0ElpIB2Os4mQEg0ssH
 wnJIShu8EKwJKWjMnTNdStpPOOxp94jP1KA8CAuBcnlNbj4L6W
 dEXFwsVfIFXGJekJxMcIV3U2/vLU5D5Xq8Zv5Nwxe7O1YQGQR9
 5Lwy68Wbzno8Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-26 at 10:50 +0800, Michael wang wrote: 
> On 09/25/2013 04:56 PM, Mike Galbraith wrote:
> > On Wed, 2013-09-25 at 09:53 +0200, Peter Zijlstra wrote: 
> >> Subject: sched: Avoid select_idle_sibling() for wake_affine(.sync=true)
> >> From: Peter Zijlstra <peterz@infradead.org>
> >> Date: Wed Sep 25 08:28:39 CEST 2013
> >>
> >> When a task is the only running task and does a sync wakeup; avoid
> >> going through select_idle_sibling() as it doesn't know the current CPU
> >> is going to be idle shortly.
> >>
> >> Without this two sync wakers will ping-pong between CPUs for no
> >> reason.
> > 
> > That will make pipe-test go fugly -> pretty, and help very fast/light
> > localhost network, but eat heavier localhost overlap recovery.  We need
> > a working (and cheap) overlap detector scheme, so we can know when there
> > is enough to be worth going after.
> > 
> > (I sent you some lmbench numbers offline a while back showing the
> > two-faced little <b-word> in action, doing both good and evil)
> 
> It seems like the choice between the overhead and a little possibility
> to balance the load :)
> 
> Like the case when we have:
> 
> 	core0 sg		core1 sg
> 	cpu0	cpu1		cpu2	cpu3
> 	waker	busy		idle	idle
> 
> If the sync wakeup was on cpu0, we can:
> 
> 1. choose cpu in core1 sg like we did usually
>    some overhead but tend to make the load a little balance
> 	core0 sg		core1 sg
> 	cpu0	cpu1		cpu2	cpu3
> 	idle	busy		wakee	idle

Reducing latency and increasing throughput when the waker isn't really
really going to immediately schedule off as the hint implies.  Nice for
bursty loads and ramp.

The breakeven point is going up though.  If you don't have nohz
throttled, you eat tick start/stop overhead, and the menu governor
recently added yet more overhead, so maybe we should say hell with it.

> 2. choose cpu0 like the patch proposed
>    no overhead but tend to make the load a little more unbalance
> 	core0 sg		core1 sg
> 	cpu0	cpu1		cpu2	cpu3
> 	wakee	busy		idle	idle
> 
> May be we should add a higher scope load balance check in wake_affine(),
> but that means higher overhead which is just what the patch want to
> reduce...

Yeah, more overhead is the last thing we need.

> What about some discount for sync case inside select_idle_sibling()?
> For example we consider sync cpu as idle and prefer it more than the others?

That's what the sync hint does.  Problem is, it's a hint.  If it were
truth, there would be no point in calling select_idle_sibling().

-Mike

