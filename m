Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab3FYOuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:50:20 -0400
Received: from mail09.linbit.com ([212.69.161.110]:50483 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab3FYOuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:50:13 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 3/6] drbd: Fix rcu_read_lock balance on error path
Date: Tue, 25 Jun 2013 16:50:05 +0200
Message-Id: <1372171808-30515-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372171808-30515-1-git-send-email-philipp.reisner@linbit.com>
References: <1372171808-30515-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 9e3f441..0936d6a 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2658,7 +2658,6 @@ int nla_put_status_info(struct sk_buff *skb, struct drbd_conf *mdev,
 		const struct sib_info *sib)
 {
 	struct state_info *si = NULL; /* for sizeof(si->member); */
-	struct net_conf *nc;
 	struct nlattr *nla;
 	int got_ldev;
 	int err = 0;
@@ -2688,13 +2687,19 @@ int nla_put_status_info(struct sk_buff *skb, struct drbd_conf *mdev,
 		goto nla_put_failure;
 
 	rcu_read_lock();
-	if (got_ldev)
-		if (disk_conf_to_skb(skb, rcu_dereference(mdev->ldev->disk_conf), exclude_sensitive))
-			goto nla_put_failure;
+	if (got_ldev) {
+		struct disk_conf *disk_conf;
 
-	nc = rcu_dereference(mdev->tconn->net_conf);
-	if (nc)
-		err = net_conf_to_skb(skb, nc, exclude_sensitive);
+		disk_conf = rcu_dereference(mdev->ldev->disk_conf);
+		err = disk_conf_to_skb(skb, disk_conf, exclude_sensitive);
+	}
+	if (!err) {
+		struct net_conf *nc;
+
+		nc = rcu_dereference(mdev->tconn->net_conf);
+		if (nc)
+			err = net_conf_to_skb(skb, nc, exclude_sensitive);
+	}
 	rcu_read_unlock();
 	if (err)
 		goto nla_put_failure;
-- 
1.7.9.5

