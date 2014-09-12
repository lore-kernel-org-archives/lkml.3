Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbaILIMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 04:12:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:45936 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbaILIMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 04:12:18 -0400
Date: Fri, 12 Sep 2014 10:12:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Davidlohr Bueso <dave@stgolabs.net>
cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Darren Hart <darren@dvhart.com>
Subject: Re: futex_wait_setup sleeping while atomic bug.
In-Reply-To: <1410479618.14217.4.camel@linux-t7sj.site>
Message-ID: <alpine.DEB.2.10.1409121011320.4178@nanos>
References: <20140911151040.GB3008@redhat.com>  <alpine.DEB.2.10.1409112318500.4178@nanos> <1410479618.14217.4.camel@linux-t7sj.site>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014, Davidlohr Bueso wrote:

> On Thu, 2014-09-11 at 23:52 +0200, Thomas Gleixner wrote:
> > From: Thomas Gleixner <tglx@linutronix.de>
> > Date: Thu, 11 Sep 2014 23:44:35 +0200
> > Subject: futex: Unlock hb->lock in futex_wait_requeue_pi() error path
> 
> That's the second time we are bitten by bugs in when requeing, now pi.
> We need to reconsider some of our testing tools to stress these paths
> better, imo.

Testing tools are nice. What we really need is more competent eyes
looking at that code ...
 
> > futex_wait_requeue_pi() calls futex_wait_setup(). If
> > futex_wait_setup() succeeds it returns with hb->lock held and
> > preemption disabled. Now the sanity check after this does:
> > 
> >         if (match_futex(&q.key, &key2)) {
> > 	   	ret = -EINVAL;
> > 		goto out_put_keys;
> > 	}
> > 
> > which releases the keys but does not release hb->lock. So we happily
> > return to user space with hb->lock held and therefor preemption
> > disabled.
> > 
> > Unlock hb->lock before taking the exit route.
> > 
> > Reported-by: Dave "Trinity" Jones <davej@redhat.com>
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
> 
> 
> 
