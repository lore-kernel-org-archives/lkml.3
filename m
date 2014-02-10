Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbaBJSrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:47:40 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:51621 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbaBJSri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:47:38 -0500
Date: Mon, 10 Feb 2014 10:47:29 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Zoran Markovic <zoran.markovic@linaro.org>, linux-kernel@vger.kernel.org,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, fweisbec@gmail.com,
        tj@kernel.org
Subject: Re: [RFC PATCH] rcu: move SRCU grace period work to power efficient
 workqueue
Message-ID: <20140210184729.GL4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1391197986-12774-1-git-send-email-zoran.markovic@linaro.org>
 <52F8A51F.4090909@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F8A51F.4090909@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021018-0928-0000-0000-000006741AED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 06:08:31PM +0800, Lai Jiangshan wrote:
> Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Thank you all, queued for 3.15.

We should also have some facility for moving the SRCU workqueues to
housekeeping/timekeeping kthreads in the NO_HZ_FULL case.  Or does
this patch already have that effect?

							Thanx, Paul

> On 02/01/2014 03:53 AM, Zoran Markovic wrote:
> > From: Shaibal Dutta <shaibal.dutta@broadcom.com>
> > 
> > For better use of CPU idle time, allow the scheduler to select the CPU
> > on which the SRCU grace period work would be scheduled. This improves
> > idle residency time and conserves power.
> > 
> > This functionality is enabled when CONFIG_WQ_POWER_EFFICIENT is selected.
> > 
> > Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > Cc: Dipankar Sarma <dipankar@in.ibm.com>
> > Signed-off-by: Shaibal Dutta <shaibal.dutta@broadcom.com>
> > [zoran.markovic@linaro.org: Rebased to latest kernel version. Added commit
> > message. Fixed code alignment.]
> > ---
> >  kernel/rcu/srcu.c |    5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/rcu/srcu.c b/kernel/rcu/srcu.c
> > index 3318d82..a1ebe6d 100644
> > --- a/kernel/rcu/srcu.c
> > +++ b/kernel/rcu/srcu.c
> > @@ -398,7 +398,7 @@ void call_srcu(struct srcu_struct *sp, struct rcu_head *head,
> >  	rcu_batch_queue(&sp->batch_queue, head);
> >  	if (!sp->running) {
> >  		sp->running = true;
> > -		schedule_delayed_work(&sp->work, 0);
> > +		queue_delayed_work(system_power_efficient_wq, &sp->work, 0);
> >  	}
> >  	spin_unlock_irqrestore(&sp->queue_lock, flags);
> >  }
> > @@ -674,7 +674,8 @@ static void srcu_reschedule(struct srcu_struct *sp)
> >  	}
> >  
> >  	if (pending)
> > -		schedule_delayed_work(&sp->work, SRCU_INTERVAL);
> > +		queue_delayed_work(system_power_efficient_wq,
> > +				   &sp->work, SRCU_INTERVAL);
> >  }
> >  
> >  /*
> 

