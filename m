Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751128AbaFIS1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 14:27:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbaFIS1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 14:27:33 -0400
Date: Mon, 9 Jun 2014 14:27:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: docker crashes rcuos in __blkg_release_rcu
Message-ID: <20140609182728.GB31499@redhat.com>
References: <alpine.DEB.2.02.1406081816540.17948@jlaw-desktop.mno.stratus.com>
 <20140609174708.GA31499@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609174708.GA31499@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 01:47:08PM -0400, Vivek Goyal wrote:
> On Sun, Jun 08, 2014 at 06:22:00PM -0400, Joe Lawrence wrote:
> 
> [..]
> > Summary thus far:
> > 
> > R12: ffff88103c17a130 = struct rcu_head *rcu_head 
> > R13: ffff88103c17a080 = struct blkcg_gq *blkg
> >      ffff88103fc7df90 = struct request_queue *blkg->q (contains 0x6b
> >                                                        poison-pattern)
> > 
> > commit 2a4fd070 "blkcg: move bulk of blkcg_gq release operations to the
> > RCU callback" shuffled around some code in this space, introducing the
> > the calls to spin_[un]lock_irq(blkg->q->queue_lock).
> > 
> 
> Hi Joe,
> 
> Thanks for reporting and debugging this issue. So in summary it looks
> like that we have freed request queue associated with the blkg and
> when blkg is freed later and tries to access spin lock embedded in
> request queue, it crashes.
> 
> So the question is why request queue is being freed early. Are there any
> reference counting issues.

I am wondering if we need to take a reference on the queue
(blk_get_queue()) in blkg_alloc(), to make sure request queue is
still around when blkg is being freed.

I will try to reproduce the issue locally.

Thanks
Vivek
