Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab3F1JKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 05:10:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45980 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab3F1JKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 05:10:07 -0400
Date: Fri, 28 Jun 2013 11:09:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: deadlock in scheduler enabling HRTICK feature
Message-ID: <20130628090939.GD29209@dyad.programming.kicks-ass.net>
References: <51CA0622.8010105@gmail.com>
 <20130625211713.GA18796@laptop.programming.kicks-ass.net>
 <51CA0980.8010409@gmail.com>
 <20130626070533.GA3601@dyad.programming.kicks-ass.net>
 <51CB1AE9.5090709@gmail.com>
 <20130627104309.GQ28407@twins.programming.kicks-ass.net>
 <51CCBCA9.1000200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CCBCA9.1000200@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 04:28:57PM -0600, David Ahern wrote:
> On 6/27/13 4:43 AM, Peter Zijlstra wrote:
> >On Wed, Jun 26, 2013 at 10:46:33AM -0600, David Ahern wrote:
> >>On 6/26/13 1:05 AM, Peter Zijlstra wrote:
> >>>>What is the expectation that the feature provides? not a whole lot of
> >>>>documentation on it. I walked down the path wondering if it solved an odd
> >>>>problem we are seeing with the CFS in 2.6.27 kernel.
> >>>
> >>>Its supposed to use hrtimers for slice expiry instead of the regular tick.
> >>
> >>So theoretically CPU bound tasks would get preempted sooner? That was my
> >>guess/hope anyways.
> >
> >Doth the below worketh?
> 
> It doth.
> 
> Usually make -j 8 for a kernel build in a VM would lock it up pretty
> quickly. With the patch I was able to run full builds multiple times.

Good!

> As for the solution you are avoiding the nesting by not waking up the
> softirq daemon.

Yah! :-) Obviously doing a wakeup while holding scheduler locks isn't going to
work out well. And the only reason we really need that pesky softirq nonsense
is when we accidentally schedule a timer that's already expired; in that case
we'll run it from sirq context.

We don't care about missing events like that; there's always the actual tick
for backup.

I suppose I'd better go write a Changelog and properly submit the patch :-)
