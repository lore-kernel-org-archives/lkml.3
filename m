Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaLCRUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:20:23 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:41131 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaLCRUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:20:19 -0500
Date: Wed, 3 Dec 2014 12:20:10 -0500
From: Tejun Heo <tj@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Jan Kara <jack@suse.cz>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dongsu Park <dongsu.park@profitbricks.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH - v3?] workqueue: allow rescuer thread to do more work.
Message-ID: <20141203172010.GC5013@htj.dyndns.org>
References: <20141030101932.2241daa7@notabene.brown>
 <20141104142240.GD14459@htj.dyndns.org>
 <20141106165811.GA2338@gmail.com>
 <545C368C.5040704@cn.fujitsu.com>
 <20141110162848.6f2246bb@notabene.brown>
 <20141110085250.GB15948@quack.suse.cz>
 <20141111090402.35fa0700@notabene.brown>
 <20141118152754.60b0c75e@notabene.brown>
 <20141202204304.GR10918@htj.dyndns.org>
 <20141203114011.5d02dc43@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141203114011.5d02dc43@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 03, 2014 at 11:40:11AM +1100, NeilBrown wrote:
> To execute the work item, we need to drop the locks.
> To perform the "list_move_tail" and the "get_pwq" we need to hold both locks.
> 
> It seems easier to do the test while holding the required locks.

Hmmm... is it difficult to regrab the locks tho?  If the problem is
wq_mayday_lock nesting outside pool locks, I don't think switching the
order would be too difficult.  The only place the two are nested is
pool_mayday_timeout() anyway, right?

> >    Isn't that -
> > whether the wq still needs rescuing after rescuer went through it once
> > - what we wanna know anyway?  e.g. something like the following.
> > 
> > 	for_each_pwq_on_mayday_list {
> > 		try to fetch work items from pwq->pool;
> > 		if (none was fetched)
> > 			goto remove_pwq;
> > 
> > 		execute the fetched work items;
> > 
> > 		if (need_to_create_worker()) {
> > 			move the pwq to the tail;
> > 			continue;
> > 		}
> > 
> > 	remove_pwq:
> > 		remove the pwq;
> > 	}
> 
> That looks nice.  I have a little difficulty matching the code to that
> outline.
> In particular I need to hold the pool->lock to call put_pwq() and after
> calling put_pwq() it isn't clear that I have a safe reference to pool so that
> it is safe to de-reference it... unless I always
> attach_to_pool/detach_from_pool.
> But to do that I have to drop the locks at awkward times.

Would inverting pool locks and wq_mayday_lock make it less awkward?

> Please correct me if I'm wrong, but it looks like I have to call
> worker_attach_to_pool() or I cannot safely call put_pwq().
> I then have to call worker_detach_from_pool() as the last step.

If I'm not mistaken, the two aren't related.  detach is necessary iff
attach has been called.  put_pwq() can be called independently.

Thanks.

-- 
tejun
