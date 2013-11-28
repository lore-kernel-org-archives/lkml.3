Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902Ab3K1Qdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 11:33:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53481 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab3K1Qde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 11:33:34 -0500
Date: Thu, 28 Nov 2013 17:33:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
 userspace child
Message-ID: <20131128163323.GF10022@twins.programming.kicks-ass.net>
References: <20131128133947.GR10022@twins.programming.kicks-ass.net>
 <20131128141329.GB3925@htj.dyndns.org>
 <20131128143145.GT10022@twins.programming.kicks-ass.net>
 <20131128143848.GD3925@htj.dyndns.org>
 <20131128145505.GX10022@twins.programming.kicks-ass.net>
 <20131128145723.GH3925@htj.dyndns.org>
 <20131128145948.GZ10022@twins.programming.kicks-ass.net>
 <20131128150722.GJ3925@htj.dyndns.org>
 <20131128151704.GC10022@twins.programming.kicks-ass.net>
 <20131128153906.GL3925@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128153906.GL3925@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 10:39:06AM -0500, Tejun Heo wrote:
> Hey,
> 
> On Thu, Nov 28, 2013 at 04:17:04PM +0100, Peter Zijlstra wrote:
> > So there's three useful parts to having a single parent task:
> > 
> >  - its a task so you can change the entire task attribute set; current
> >    and future.
> 
> Using task as interface could be okay but I'd still go for explicitly
> specifying what gets inherited and expand them gradually; otherwise,
> we end up exposing broken stuff unintentionally.  cpuset did this with
> bound workers and the capability was removed retro-actively, which is
> not a happy situation.

I can work with that. We'd need way to inhibit setting certain
attributes, but that can be worked out -- its all in-kernel anyway.

> >  - new children will automatically get the desired attributes.
> > 
> >  - all children are easily identified by virtual of being children of
> >    said parent process.
> 
> That'd mean that we'd have to have a dummy target task for attributes
> for each workqueue and hooks for workqueue to get notified of
> attribute changes.  Unless we're gonna go back to per-workqueue
> workers, we can't have a single parent per workqueue and all its
> workers as children of it.  Different workqueue configure different
> set of attributes.  Not all !percpu workers are equal and each
> workqueue serves as an attribute domain.
> 
> We *could* do all that and it proably won't require walking the
> children from userland as each attribute change would surmount to
> finding or creating a matching worker pool, but it doesn't look
> attractive to me.

I'm not sure we need a single parent per workqueue; certainly the case I
get asked most frequently about doesn't care, they only want to contain
_all_ unbound workers.

I don't see a problem with later splitting out other workqueues if
there's a good use-case for those.

I'm not even sure we need to split out the userspace helpers per-se;
again, they fall in the all-unbound category and I don't think I've seen
people ask for specific control of those over other unbound workers --
although conceptually it does make some sense to split them out.

> > Well, mixed attributes is you own responsibility. I'm all for letting
> > people shoot themselves in the foot as long we don't crash.
> 
> Again, I'm worried about exposing unintended characteristics of
> implementation and being locked into it.  Regardless of interface, I
> think it's important to control what can be depended upon from
> userland if we're gonna keep up "no userland visible behavior will
> break" thing.

I appreciate your caution, but we shouldn't overdo the thing and
dis-allow everything.

> > The huge disadvantage to creating special interfaces is that you can
> > only capture a small part of the task attributes; and worse, you create
> > a special limited interface for a special few tasks.
> 
> Yeah, that's the disadvantage but I don't think the single parent per
> workqueue model is gonna work. 

I never proposed a parent per workqueue. The most I proposed was a
single parent for all unbound workers and a parent for all usermode
helpers.

> automatic
> NUMA binding, which means we need workqueue-specific interface anyway.

I'm curious; why is there workqueue numa stuff? NUMA doesn't have the
correctness issues per-cpu has -- per-cpu is fundamentally special in
that there's no concurrency.


