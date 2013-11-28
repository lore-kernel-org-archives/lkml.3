Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab3K1Ob5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:31:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51075 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3K1Oby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:31:54 -0500
Date: Thu, 28 Nov 2013 15:31:45 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
 userspace child
Message-ID: <20131128143145.GT10022@twins.programming.kicks-ass.net>
References: <OF4CF076F6.04AFF122-ON48257C2F.0009B6E4-48257C2F.000BF905@zte.com.cn>
 <20131126180420.GA18172@redhat.com>
 <OF99742718.77495161-ON48257C30.000A8334-48257C30.000BA983@zte.com.cn>
 <20131127183117.GB13098@mtj.dyndns.org>
 <20131128091358.GH10022@twins.programming.kicks-ass.net>
 <20131128114542.GA3826@redhat.com>
 <20131128121748.GN10022@twins.programming.kicks-ass.net>
 <20131128133152.GA821@redhat.com>
 <20131128133947.GR10022@twins.programming.kicks-ass.net>
 <20131128141329.GB3925@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128141329.GB3925@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 09:13:29AM -0500, Tejun Heo wrote:
> Hello,
> 
> > > > Urgh, but that's still completely wrong. khelper is a singlethread
> > > > workqueue, those should be unbound and therefore should not have this
> > > > flag set at all.
> > > 
> > > Well. This is debatable, but I leave this to you and Tejun ;)
> > 
> > How can that be debatable? I don't see a single argument in favour of
> > doing that; its plain ridiculous.
> 
> As the flag name suggests, it prevents userland from changing affinity
> of the worker threads which we need whether the worker is confined to
> a cpu, NUMA node, random subset of CPUs or not at all.  Please note
> that there's no one-to-one mapping between a worker and any given
> workqueue.  workqueue can't allow userland to set affinity on random
> workers.  They're shared resources.

But the WQ_UNBOUND thingies should be just that and should thus not have
the NO_SETAFFINITY flag set because there is no valid reason to have it
set.

Regardless of whether the threads are shared between unbound workqueues
or not.

Sure, we absolutely must set it for per-cpu workqueues (and their
workers) otherwise we cannot guarantee correctness. Same for per-node if
we have that.

But absolutely not for unbound.
