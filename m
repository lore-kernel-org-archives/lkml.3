Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab3K2OeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 09:34:00 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:51215 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab3K2Od7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 09:33:59 -0500
Date: Fri, 29 Nov 2013 09:33:54 -0500
From: Tejun Heo <htejun@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
 userspace child
Message-ID: <20131129143354.GB3717@htj.dyndns.org>
References: <20131128141329.GB3925@htj.dyndns.org>
 <20131128143145.GT10022@twins.programming.kicks-ass.net>
 <20131128143848.GD3925@htj.dyndns.org>
 <20131128145505.GX10022@twins.programming.kicks-ass.net>
 <20131128145723.GH3925@htj.dyndns.org>
 <20131128145948.GZ10022@twins.programming.kicks-ass.net>
 <20131128150722.GJ3925@htj.dyndns.org>
 <20131128151704.GC10022@twins.programming.kicks-ass.net>
 <20131128153906.GL3925@htj.dyndns.org>
 <20131128163323.GF10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128163323.GF10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Thu, Nov 28, 2013 at 05:33:23PM +0100, Peter Zijlstra wrote:
> I'm not sure we need a single parent per workqueue; certainly the case I
> get asked most frequently about doesn't care, they only want to contain
> _all_ unbound workers.
> 
> I don't see a problem with later splitting out other workqueues if
> there's a good use-case for those.
>
> I'm not even sure we need to split out the userspace helpers per-se;
> again, they fall in the all-unbound category and I don't think I've seen
> people ask for specific control of those over other unbound workers --
> although conceptually it does make some sense to split them out.

There are workqueues with custom attributes, so, if we want to have
default settings for all workers, we'll have to implement nested
configuration where global knobs control the default settings with
individual settings overriding them.

> > Again, I'm worried about exposing unintended characteristics of
> > implementation and being locked into it.  Regardless of interface, I
> > think it's important to control what can be depended upon from
> > userland if we're gonna keep up "no userland visible behavior will
> > break" thing.
> 
> I appreciate your caution, but we shouldn't overdo the thing and
> dis-allow everything.

Yeah, going extreme on either extreme would suck but I'm not
suggesting disallowing everything, just that we need to vet what gets
exposed.

> I never proposed a parent per workqueue. The most I proposed was a
> single parent for all unbound workers and a parent for all usermode
> helpers.

It'd be weird to have one mechanism to control default attributes and
a different one to control per-workqueue attributes (again, we need a
custom mechanism to control attributes outside task scope anyway).  If
we're actually gonna do this, I'd much prefer reusing the existing
workqueue mechanism than introducing something new which wouldn't be
able to replace the existing one.

> > automatic
> > NUMA binding, which means we need workqueue-specific interface anyway.
> 
> I'm curious; why is there workqueue numa stuff? NUMA doesn't have the
> correctness issues per-cpu has -- per-cpu is fundamentally special in
> that there's no concurrency.

NUMA doesn't have correctness issues but it does have significant
performance impacts.  There are work itmes which may consume
considerable amount of cpu cycles, e.g. crypt, writeback, io
completion.  Binding them to cpu limits how much they can scale and
using plain unbound deteriorates NUMA affinity.  Even for unbound work
items which aren't necessary cpu cycle / memory access heavy, sticking
to NUMA affinity leads to generally better behavior.

Thanks.

-- 
tejun
