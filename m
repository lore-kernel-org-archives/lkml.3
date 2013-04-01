Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341Ab3DAS2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 14:28:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45447 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab3DAS2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 14:28:07 -0400
Date: Mon, 1 Apr 2013 11:27:57 -0700
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jack@suse.cz, fengguang.wu@intel.com, jmoyer@redhat.com,
        zab@redhat.com, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org
Subject: [PATCH 0.5/14] workqueue: fix memory leak in apply_workqueue_attrs()
Message-ID: <20130401182757.GB3142@htj.dyndns.org>
References: <1364453020-2829-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364453020-2829-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4862125b0256a946d2749a1d5003b0604bc3cb4d Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Mon, 1 Apr 2013 11:23:31 -0700

apply_workqueue_attrs() wasn't freeing temp attrs variable @new_attrs
in its success path.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
This causes some minor conflicts down the series but nothing
noteworthy.  I'm not posting the whole refreshed series.  If you want
it, holler.

Thanks.

 kernel/workqueue.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index abe1f0d..89480fc 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3636,6 +3636,7 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 	struct workqueue_attrs *new_attrs;
 	struct pool_workqueue *pwq = NULL, *last_pwq;
 	struct worker_pool *pool;
+	int ret;
 
 	/* only unbound workqueues can change attributes */
 	if (WARN_ON(!(wq->flags & WQ_UNBOUND)))
@@ -3668,12 +3669,16 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 		spin_unlock_irq(&last_pwq->pool->lock);
 	}
 
-	return 0;
+	ret = 0;
+	/* fall through */
+out_free:
+	free_workqueue_attrs(new_attrs);
+	return ret;
 
 enomem:
 	kmem_cache_free(pwq_cache, pwq);
-	free_workqueue_attrs(new_attrs);
-	return -ENOMEM;
+	ret = -ENOMEM;
+	goto out_free;
 }
 
 static int alloc_and_link_pwqs(struct workqueue_struct *wq)
-- 
1.8.1.4

