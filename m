Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbaLCSCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 13:02:45 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:48414 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaLCSCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 13:02:44 -0500
Date: Wed, 3 Dec 2014 13:02:41 -0500
From: Tejun Heo <tj@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Jan Kara <jack@suse.cz>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dongsu Park <dongsu.park@profitbricks.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH - v3?] workqueue: allow rescuer thread to do more work.
Message-ID: <20141203180241.GD5013@htj.dyndns.org>
References: <20141104142240.GD14459@htj.dyndns.org>
 <20141106165811.GA2338@gmail.com>
 <545C368C.5040704@cn.fujitsu.com>
 <20141110162848.6f2246bb@notabene.brown>
 <20141110085250.GB15948@quack.suse.cz>
 <20141111090402.35fa0700@notabene.brown>
 <20141118152754.60b0c75e@notabene.brown>
 <20141202204304.GR10918@htj.dyndns.org>
 <20141203114011.5d02dc43@notabene.brown>
 <20141203172010.GC5013@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141203172010.GC5013@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, something like the following.  Only compile tested.  I'll test it
and post proper patches w/ due credits.

Thanks.

Index: work/kernel/workqueue.c
===================================================================
--- work.orig/kernel/workqueue.c
+++ work/kernel/workqueue.c
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
@@ -2248,12 +2248,29 @@ repeat:
 		 * Slurp in all works issued via this workqueue and
 		 * process'em.
 		 */
-		WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
+		WARN_ON_ONCE(!list_empty(scheduled));
 		list_for_each_entry_safe(work, n, &pool->worklist, entry)
 			if (get_work_pwq(work) == pwq)
 				move_linked_works(work, scheduled, &n);
 
-		process_scheduled_works(rescuer);
+		if (!list_empty(scheduled)) {
+			process_scheduled_works(rescuer);
+
+			/*
+			 * The above execution of rescued work items could
+			 * have created more to rescue through
+			 * pwq_activate_first_delayed() or chained
+			 * queueing.  Let's put @pwq back on mayday list so
+			 * that such back-to-back work items, which may be
+			 * being used to relieve memory pressure, don't
+			 * incur MAYDAY_INTERVAL delay inbetween.
+			 */
+			if (need_to_create_worker(pool)) {
+				spin_lock(&wq_mayday_lock);
+				list_move_tail(&pwq->mayday_node, &wq->maydays);
+				spin_unlock(&wq_mayday_lock);
+			}
+		}
 
 		/*
 		 * Put the reference grabbed by send_mayday().  @pool won't

-- 
tejun
