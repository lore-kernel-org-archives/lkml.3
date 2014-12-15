Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbaLONO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 08:14:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:39040 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbaLONOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 08:14:23 -0500
Date: Mon, 15 Dec 2014 14:14:10 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Sasha Levin <levinsasha928@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sched: odd values for effective load calculations
Message-ID: <20141215131410.GM10476@twins.programming.kicks-ass.net>
References: <547E42F7.5070105@gmail.com>
 <20141213083012.GH32572@gmail.com>
 <20141215121227.GZ29390@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215121227.GZ29390@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 01:12:27PM +0100, Peter Zijlstra wrote:
> 
> Sorry for the long delay, I was out for a few weeks due to having become
> a dad for the second time.
> 
> On Sat, Dec 13, 2014 at 09:30:12AM +0100, Ingo Molnar wrote:
> > * Sasha Levin <levinsasha928@gmail.com> wrote:
> > 
> > > Hi all,
> > > 
> > > I was fuzzing with trinity inside a KVM tools guest, running the latest -next
> > > kernel along with the undefined behaviour sanitizer patch, and hit the following:
> > > 
> > > [  787.894288] ================================================================================
> > > [  787.897074] UBSan: Undefined behaviour in kernel/sched/fair.c:4541:17
> > > [  787.898981] signed integer overflow:
> > > [  787.900066] 361516561629678 * 101500 cannot be represented in type 'long long int'
> 
> So that's:
> 
> 	this_eff_load *= this_load +
> 		effective_load(tg, this_cpu, weight, weight);
> 
> Going by the numbers the 101500 must be 'this_eff_load', 100 * ~1024
> makes that. Which makes the rhs 'large'. Do you have
> CONFIG_FAIR_GROUP_SCHED enabled? If so, what kind of cgroup hierarchy
> are you using?
> 
> In any case, bit sad this doesn't have a register dump included :/

Hmm, I was hoping to be able to see if it was this_load or the
effective_load() result being silly large, but going by the ASM output
of my compiler this isn't going to be available in registers, its all
stack spills.

Pinning my hopes on that reproducability thing :/
