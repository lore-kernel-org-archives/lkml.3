Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723Ab3CEUEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:04:20 -0500
Received: from mail-qe0-f47.google.com ([209.85.128.47]:35403 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757343Ab3CEUDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:03:22 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, bfields@fieldses.org,
        jackm@dev.mellanox.co.il, ogerlitz@mellanox.com,
        roland@purestorage.com, dan.magenheimer@oracle.com,
        gregkh@linuxfoundation.org, vjaquez@igalia.com, rene.sapiens@ti.com,
        x0095078@ti.com, omar.ramirez@ti.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/7] zcache: convert to idr_alloc()
Date: Tue,  5 Mar 2013 12:02:50 -0800
Message-Id: <1362513772-15174-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362513772-15174-1-git-send-email-tj@kernel.org>
References: <1362513772-15174-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr_get_new*() and friends are about to be deprecated.  Convert to the
new idr_alloc() interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
---
 drivers/staging/zcache/ramster/tcp.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/zcache/ramster/tcp.c b/drivers/staging/zcache/ramster/tcp.c
index aa2a1a7..f6e1e52 100644
--- a/drivers/staging/zcache/ramster/tcp.c
+++ b/drivers/staging/zcache/ramster/tcp.c
@@ -300,27 +300,22 @@ static u8 r2net_num_from_nn(struct r2net_node *nn)
 
 static int r2net_prep_nsw(struct r2net_node *nn, struct r2net_status_wait *nsw)
 {
-	int ret = 0;
+	int ret;
 
-	do {
-		if (!idr_pre_get(&nn->nn_status_idr, GFP_ATOMIC)) {
-			ret = -EAGAIN;
-			break;
-		}
-		spin_lock(&nn->nn_lock);
-		ret = idr_get_new(&nn->nn_status_idr, nsw, &nsw->ns_id);
-		if (ret == 0)
-			list_add_tail(&nsw->ns_node_item,
-				      &nn->nn_status_list);
-		spin_unlock(&nn->nn_lock);
-	} while (ret == -EAGAIN);
+	spin_lock(&nn->nn_lock);
+	ret = idr_alloc(&nn->nn_status_idr, nsw, 0, 0, GFP_ATOMIC);
+	if (ret >= 0) {
+		nsw->ns_id = ret;
+		list_add_tail(&nsw->ns_node_item, &nn->nn_status_list);
+	}
+	spin_unlock(&nn->nn_lock);
 
-	if (ret == 0)  {
+	if (ret >= 0) {
 		init_waitqueue_head(&nsw->ns_wq);
 		nsw->ns_sys_status = R2NET_ERR_NONE;
 		nsw->ns_status = 0;
+		return 0;
 	}
-
 	return ret;
 }
 
-- 
1.8.1.4

