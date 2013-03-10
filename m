Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab3CJMev (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 08:34:51 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:48686 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab3CJMeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 08:34:50 -0400
Date: Sun, 10 Mar 2013 05:34:46 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com,
        zab@redhat.com
Subject: Re: [PATCH 07/31] workqueue: restructure pool / pool_workqueue
 iterations in freeze/thaw functions
Message-ID: <20130310123446.GD24522@htj.dyndns.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
 <1362194662-2344-8-git-send-email-tj@kernel.org>
 <513C5BCD.4030108@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513C5BCD.4030108@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Sun, Mar 10, 2013 at 06:09:17PM +0800, Lai Jiangshan wrote:
> > +	/* clear FREEZING */
> > +	for_each_pool(pool, id) {
> > +		spin_lock(&pool->lock);
> > +		WARN_ON_ONCE(!(pool->flags & POOL_FREEZING));
> > +		pool->flags &= ~POOL_FREEZING;
> > +		spin_unlock(&pool->lock);
> > +	}
> 
> 
> I think it would be better if we move this code to ...
> 
> >  
> > -			wake_up_worker(pool);
> > +	/* restore max_active and repopulate worklist */
> > +	list_for_each_entry(wq, &workqueues, list) {
> > +		if (!(wq->flags & WQ_FREEZABLE))
> > +			continue;
> >  
> > -			spin_unlock(&pool->lock);
> > +		for_each_pwq(pwq, wq) {
> > +			spin_lock(&pwq->pool->lock);
> > +			pwq_set_max_active(pwq, wq->saved_max_active);
> > +			spin_unlock(&pwq->pool->lock);
> >  		}
> >  	}
> >  
> > +	/* kick workers */
> > +	for_each_pool(pool, id) {
> > +		spin_lock(&pool->lock);
> > +		wake_up_worker(pool);
> > +		spin_unlock(&pool->lock);
> > +	}
> 
> 
> ... to here.
> 
> clear FREEZING and then kick.

Yeah, that would be prettier but also change the order of operations
which I'd like to keep the same across the conversion.  We can create
a separate patch to merge the two loops later.  Care to send a
separate patch?

Thanks.

-- 
tejun
