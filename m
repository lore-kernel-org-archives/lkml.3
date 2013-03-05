Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab3CEUDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:03:14 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:40053 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509Ab3CEUDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:03:09 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, bfields@fieldses.org,
        jackm@dev.mellanox.co.il, ogerlitz@mellanox.com,
        roland@purestorage.com, dan.magenheimer@oracle.com,
        gregkh@linuxfoundation.org, vjaquez@igalia.com, rene.sapiens@ti.com,
        x0095078@ti.com, omar.ramirez@ti.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/7] workqueue: convert to idr_alloc()
Date: Tue,  5 Mar 2013 12:02:48 -0800
Message-Id: <1362513772-15174-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362513772-15174-1-git-send-email-tj@kernel.org>
References: <1362513772-15174-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr_get_new*() and friends are about to be deprecated.  Convert to the
new idr_alloc() interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 81f2457..55fac5b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -457,11 +457,12 @@ static int worker_pool_assign_id(struct worker_pool *pool)
 	int ret;
 
 	mutex_lock(&worker_pool_idr_mutex);
-	idr_pre_get(&worker_pool_idr, GFP_KERNEL);
-	ret = idr_get_new(&worker_pool_idr, pool, &pool->id);
+	ret = idr_alloc(&worker_pool_idr, pool, 0, 0, GFP_KERNEL);
+	if (ret >= 0)
+		pool->id = ret;
 	mutex_unlock(&worker_pool_idr_mutex);
 
-	return ret;
+	return ret < 0 ? ret : 0;
 }
 
 /*
-- 
1.8.1.4

