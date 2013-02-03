Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3BCBXL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:23:11 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:43822 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab3BCBXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:23:01 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Subject: [PATCH 53/62] ocfs2: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:54 -0800
Message-Id: <1359854463-2538-54-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 fs/ocfs2/cluster/tcp.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 1bfe880..7c10d75 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -304,28 +304,22 @@ static u8 o2net_num_from_nn(struct o2net_node *nn)
 
 static int o2net_prep_nsw(struct o2net_node *nn, struct o2net_status_wait *nsw)
 {
-	int ret = 0;
-
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
+	int ret;
 
-	if (ret == 0)  {
-		init_waitqueue_head(&nsw->ns_wq);
-		nsw->ns_sys_status = O2NET_ERR_NONE;
-		nsw->ns_status = 0;
+	spin_lock(&nn->nn_lock);
+	ret = idr_alloc(&nn->nn_status_idr, nsw, 0, 0, GFP_ATOMIC);
+	if (ret >= 0) {
+		nsw->ns_id = ret;
+		list_add_tail(&nsw->ns_node_item, &nn->nn_status_list);
 	}
+	spin_unlock(&nn->nn_lock);
+	if (ret < 0)
+		return ret;
 
-	return ret;
+	init_waitqueue_head(&nsw->ns_wq);
+	nsw->ns_sys_status = O2NET_ERR_NONE;
+	nsw->ns_status = 0;
+	return 0;
 }
 
 static void o2net_complete_nsw_locked(struct o2net_node *nn,
-- 
1.8.1

