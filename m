Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab3FENz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:55:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926Ab3FENzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:55:24 -0400
Date: Wed, 5 Jun 2013 09:55:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Robin Dong <sanbai@taobao.com>, linux-kernel@vger.kernel.org,
        Zhu Yanhai <gaoyang.zyh@taobao.com>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <taoma.tm@gmail.com>, kent.overstreet@gmail.com
Subject: Re: [RFC v1] add new io-scheduler to use cgroup on high-speed device
Message-ID: <20130605135512.GB16339@redhat.com>
References: <1370398171-25173-1-git-send-email-sanbai@taobao.com>
 <20130605030337.GO14916@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130605030337.GO14916@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 08:03:37PM -0700, Tejun Heo wrote:
> (cc'ing Kent.  Original posting at
>  http://thread.gmane.org/gmane.linux.kernel/1502484 )
> 
> Hello,
> 
> On Wed, Jun 05, 2013 at 10:09:31AM +0800, Robin Dong wrote:
> > We want to use blkio.cgroup on high-speed device (like fusionio) for our mysql clusters.
> > After testing different io-scheduler, we found that  cfq is too slow and deadline can't run on cgroup.
> > So we developed a new io-scheduler: tpps (Tiny Parallel Proportion Scheduler).It dispatch requests
> > only by using their individual weight and total weight (proportion) therefore it's simply and efficient.
> > 
> > Test case: fusionio card, 4 cgroups, iodepth-512
> 
> So, while I understand the intention behind it, I'm not sure a
> separate io-sched for this is what we want.  Kent and Jens have been
> thinking about this lately so they'll probably chime in.  From my POV,
> I see a few largish issues.
> 
> * It has to be scalable with relatively large scale SMP / NUMA
>   configurations.  It better integrate with blk-mq support currently
>   being brewed.

Agreed that any new algorithm to do proportional IO should integrate
well will blk-mq support. I have yet to look at that implementation but
my understanding was that current algorithm is per queue and one
queue would not know about other queue.

As you suggested in the past, may be some kind of token based scheme
will work better instead of trying to service differentation based
on time slice.

> 
> * It definitely has to support hierarchy.  Nothing which doesn't
>   support full hierarchy can be added to cgroup at this point.
> 
> * We already have separate implementations in blk-throtl and
>   cfq-iosched.  Maybe it's too late and too different for cfq-iosched
>   given that it's primarily targeted at disks, but I wonder whether we
>   can make blk-throtl generic and scalable enough to cover all other
>   use cases.

I think it will be hard to cover all the use cases. There is a reason
why CFQ got so complicated and bulky because it tried to cover all the
use cases and provide service differentiation among workloads. blk-cgroup
will try to do the same thing at group level. All these question will
arise when to idle, how much to idle, how much device queue depth we
should drive to keep service differention better, how much outstanding
IO from each group we should allow in the queue.

And all of this affects what kind of service differentation you see
on different devices for different workloads.

I think generic implementation can be written with the goal of trying to
make it work with faster flash devices (which will typically use blk-mq).
And for slower disks, one can continue to use CFQ's cgroup implementation.

On a side note, it would be nice if we handle problem of managing buffered
writes using cgroup first. Otherwise there are very few practical
scenarios where proportional IO thing can be used.

Robin, what's the workload/setup which will benefit from this even without 
buffered write support.

Thanks
Vivek
