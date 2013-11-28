Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330Ab3K1ONf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:13:35 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:40227 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab3K1ONd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:13:33 -0500
Date: Thu, 28 Nov 2013 09:13:29 -0500
From: Tejun Heo <htejun@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
 userspace child
Message-ID: <20131128141329.GB3925@htj.dyndns.org>
References: <20131125121416.GB23829@redhat.com>
 <OF4CF076F6.04AFF122-ON48257C2F.0009B6E4-48257C2F.000BF905@zte.com.cn>
 <20131126180420.GA18172@redhat.com>
 <OF99742718.77495161-ON48257C30.000A8334-48257C30.000BA983@zte.com.cn>
 <20131127183117.GB13098@mtj.dyndns.org>
 <20131128091358.GH10022@twins.programming.kicks-ass.net>
 <20131128114542.GA3826@redhat.com>
 <20131128121748.GN10022@twins.programming.kicks-ass.net>
 <20131128133152.GA821@redhat.com>
 <20131128133947.GR10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128133947.GR10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > > Urgh, but that's still completely wrong. khelper is a singlethread
> > > workqueue, those should be unbound and therefore should not have this
> > > flag set at all.
> > 
> > Well. This is debatable, but I leave this to you and Tejun ;)
> 
> How can that be debatable? I don't see a single argument in favour of
> doing that; its plain ridiculous.

As the flag name suggests, it prevents userland from changing affinity
of the worker threads which we need whether the worker is confined to
a cpu, NUMA node, random subset of CPUs or not at all.  Please note
that there's no one-to-one mapping between a worker and any given
workqueue.  workqueue can't allow userland to set affinity on random
workers.  They're shared resources.

> > > In fact, I know people want to set affinity on khelper
> > 
> > This is not that simple. Note that khelper itself is the rescuer thread,
> > it doesn't not process the works. There are other kworker/u* threads which
> > run the work queued on khelper_wq. There is a pool of threads.
> 
> That's just fucked. WTF does singlethreaded mean then?

As explained in the other reply, it's a carried-over name and will be
replaced by alloc_ordered_workqueue().  Note that if khelper_wq is
converted to use alloc_ordered_workqueue(), the task named "khelper"
wouldn't even exist as there's no reason for the wq to have a rescuer.

> A single parent process for all usermode helpers makes so much sense;
> not doing it is just weird.

If we're gonna allow userland to play with the parent attributes,
yeah, that'd make sense.  I'm not sure whether that's an interface
that we'd want to commit to tho?  Do we really want to tell userland
"there will always be a kernel task khelper and if you change that
one's attributes all processes forked from it will inherit those
attributes no matter what they are."  I think we'd want something more
specific cause that's a lot of commitment to things that we haven't
carefully thought about.

Thanks.

-- 
tejun
