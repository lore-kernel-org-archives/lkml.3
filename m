Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbaLDPLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:11:10 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:42418 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbaLDPLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:11:09 -0500
Date: Thu, 4 Dec 2014 10:11:04 -0500
From: Tejun Heo <tj@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Jan Kara <jack@suse.cz>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dongsu Park <dongsu.park@profitbricks.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH workqueue/for-3.18-fixes 1/2] workqueue: invert the order
 between pool->lock and wq_mayday_lock
Message-ID: <20141204151104.GD15219@htj.dyndns.org>
References: <20141106165811.GA2338@gmail.com>
 <545C368C.5040704@cn.fujitsu.com>
 <20141110162848.6f2246bb@notabene.brown>
 <20141110085250.GB15948@quack.suse.cz>
 <20141111090402.35fa0700@notabene.brown>
 <20141118152754.60b0c75e@notabene.brown>
 <20141202204304.GR10918@htj.dyndns.org>
 <20141203114011.5d02dc43@notabene.brown>
 <20141203172010.GC5013@htj.dyndns.org>
 <20141203180241.GD5013@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141203180241.GD5013@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, pool->lock nests inside pool->lock.  There's no inherent
reason for this order.  The only place where the two locks are held
together is pool_mayday_timeout() and it just got decided that way.

This nesting order turns out to complicate things with the planned
rescuer_thread() update.  Let's invert them.  This doesn't cause any
behavior differences.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1804,8 +1804,8 @@ static void pool_mayday_timeout(unsigned
 	struct worker_pool *pool = (void *)__pool;
 	struct work_struct *work;
 
-	spin_lock_irq(&wq_mayday_lock);		/* for wq->maydays */
-	spin_lock(&pool->lock);
+	spin_lock_irq(&pool->lock);
+	spin_lock(&wq_mayday_lock);		/* for wq->maydays */
 
 	if (need_to_create_worker(pool)) {
 		/*
@@ -1818,8 +1818,8 @@ static void pool_mayday_timeout(unsigned
 			send_mayday(work);
 	}
 
-	spin_unlock(&pool->lock);
-	spin_unlock_irq(&wq_mayday_lock);
+	spin_unlock(&wq_mayday_lock);
+	spin_unlock_irq(&pool->lock);
 
 	mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INTERVAL);
 }
