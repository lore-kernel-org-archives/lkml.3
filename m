Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142Ab3IZFey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 01:34:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62559 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab3IZFex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 01:34:53 -0400
Message-ID: <1380173688.7525.12.camel@marge.simpson.net>
Subject: Re: [RFC][PATCH] sched: Avoid select_idle_sibling() for
 wake_affine(.sync=true)
From: Mike Galbraith <bitbucket@online.de>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 26 Sep 2013 07:34:48 +0200
In-Reply-To: <5243C24F.6070704@linux.vnet.ibm.com>
References: <20130925075341.GB3081@twins.programming.kicks-ass.net>
	 <1380099377.8523.9.camel@marge.simpson.net>
	 <5243A0E9.4060802@linux.vnet.ibm.com>
	 <1380166898.5431.40.camel@marge.simpson.net>
	 <5243C24F.6070704@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:xAIJK8VN1A0wCi74xaGxU+NtYz8rTfFAV55qRVClcxR
 Lt1jKKe+DLh5qJD8h0317b7Tohsvl1dxN8IEQkYFwAo+puSPLX
 LvCLukSIKNWCufiG3vjdbKyplmkph6hegPP2hBj9cwc6kImUvA
 4HZtEaloXZ1diZ+IRZSezeoQVj7dahk7koAjMYnrNgW+YVFwAL
 4nN1Lr7DUFC5mim3cgHm1rbM1zYGnqusXpqh75985tGwBk3qEb
 7Iy31KtAeYkWhHm/5IkwiMZ7f4c7B6jR/WXmIEewMse3N9FCD6
 f5qGaApMZTWKtw9RdUdo5/kNyIj8xApDZWYBaU13BhnbGTv0lE
 sJyePXYvPWcLJEhIjvp0eE2Mcln8j7zaliUQJrD5QcZz6jO5sv
 o/uQibeTpYbeA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-26 at 13:12 +0800, Michael wang wrote: 
> On 09/26/2013 11:41 AM, Mike Galbraith wrote:
> [snip]
> >> Like the case when we have:
> >>
> >> 	core0 sg		core1 sg
> >> 	cpu0	cpu1		cpu2	cpu3
> >> 	waker	busy		idle	idle
> >>
> >> If the sync wakeup was on cpu0, we can:
> >>
> >> 1. choose cpu in core1 sg like we did usually
> >>    some overhead but tend to make the load a little balance
> >> 	core0 sg		core1 sg
> >> 	cpu0	cpu1		cpu2	cpu3
> >> 	idle	busy		wakee	idle
> > 
> > Reducing latency and increasing throughput when the waker isn't really
> > really going to immediately schedule off as the hint implies.  Nice for
> > bursty loads and ramp.
> > 
> > The breakeven point is going up though.  If you don't have nohz
> > throttled, you eat tick start/stop overhead, and the menu governor
> > recently added yet more overhead, so maybe we should say hell with it.
> 
> Exactly, more and more factors to be considered, we say things get
> balanced but actually it's not the best choice...
> 
> > 
> >> 2. choose cpu0 like the patch proposed
> >>    no overhead but tend to make the load a little more unbalance
> >> 	core0 sg		core1 sg
> >> 	cpu0	cpu1		cpu2	cpu3
> >> 	wakee	busy		idle	idle
> >>
> >> May be we should add a higher scope load balance check in wake_affine(),
> >> but that means higher overhead which is just what the patch want to
> >> reduce...
> > 
> > Yeah, more overhead is the last thing we need.
> > 
> >> What about some discount for sync case inside select_idle_sibling()?
> >> For example we consider sync cpu as idle and prefer it more than the others?
> > 
> > That's what the sync hint does.  Problem is, it's a hint.  If it were
> > truth, there would be no point in calling select_idle_sibling().
> 
> Just wondering if the hint was wrong in most of the time, then why don't
> we remove it...

For very fast/light network ping-pong micro-benchmarks, it is right.
For pipe-test, it's absolutely right, jabbering parties are 100%
synchronous, there is nada/nil/zip/diddly squat overlap reclaimable..
but in the real world, it ain't necessarily so.

> Otherwise I think we can still utilize it to make some decision tends to
> be correct, don't we?

Sometimes :)

-Mike

