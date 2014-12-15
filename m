Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750774AbaLOMMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 07:12:45 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:34547 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaLOMMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 07:12:43 -0500
Date: Mon, 15 Dec 2014 13:12:27 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Sasha Levin <levinsasha928@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sched: odd values for effective load calculations
Message-ID: <20141215121227.GZ29390@twins.programming.kicks-ass.net>
References: <547E42F7.5070105@gmail.com>
 <20141213083012.GH32572@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141213083012.GH32572@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry for the long delay, I was out for a few weeks due to having become
a dad for the second time.

On Sat, Dec 13, 2014 at 09:30:12AM +0100, Ingo Molnar wrote:
> * Sasha Levin <levinsasha928@gmail.com> wrote:
> 
> > Hi all,
> > 
> > I was fuzzing with trinity inside a KVM tools guest, running the latest -next
> > kernel along with the undefined behaviour sanitizer patch, and hit the following:
> > 
> > [  787.894288] ================================================================================
> > [  787.897074] UBSan: Undefined behaviour in kernel/sched/fair.c:4541:17
> > [  787.898981] signed integer overflow:
> > [  787.900066] 361516561629678 * 101500 cannot be represented in type 'long long int'

So that's:

	this_eff_load *= this_load +
		effective_load(tg, this_cpu, weight, weight);

Going by the numbers the 101500 must be 'this_eff_load', 100 * ~1024
makes that. Which makes the rhs 'large'. Do you have
CONFIG_FAIR_GROUP_SCHED enabled? If so, what kind of cgroup hierarchy
are you using?

In any case, bit sad this doesn't have a register dump included :/

Is this easy to reproduce or something that happened once?

> > The values for effective load seem a bit off (and are overflowing!).
> 
> It definitely looks like a bug in SMP load balancing!

Yeah, although theoretically (and somewhat practical) this can be
triggered in more places if you manage to run up the 'weight' with
enough tasks.

That said, it should at worst result in 'funny' balancing behaviour, not
anything else.
