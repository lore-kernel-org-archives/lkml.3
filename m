Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbaIRQsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 12:48:47 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:36886 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218AbaIRQsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 12:48:45 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: davem@davemloft.net
Cc: netfilter@vger.kernel.org, coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kernel@codethink.co.uk,
        rob.jones@codethink.co.uk
Subject: [PATCH] net/netfilter/x_tables.c: use __seq_open_private()
Date: Thu, 18 Sep 2014 17:48:31 +0100
Message-Id: <1411058911-17655-1-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce boilerplate code by using __seq_open_private() instead of seq_open()
in xt_match_open() and xt_target_open().

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
---

This patch uses an existing variant of seq_open() to reduce the kernel code
size.

The only significant variation from the pre-existing code is the fact that
__seq_open_private() calls kzalloc() rather than kmalloc(), which could
conceivably have an impact on timing.

 net/netfilter/x_tables.c |   30 ++++--------------------------
 1 file changed, 4 insertions(+), 26 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 227aa11..89aa680 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1137,22 +1137,11 @@ static const struct seq_operations xt_match_seq_ops = {
 
 static int xt_match_open(struct inode *inode, struct file *file)
 {
-	struct seq_file *seq;
 	struct nf_mttg_trav *trav;
-	int ret;
-
-	trav = kmalloc(sizeof(*trav), GFP_KERNEL);
-	if (trav == NULL)
+	trav = __seq_open_private(file, &xt_match_seq_ops, sizeof(*trav));
+	if (!trav)
 		return -ENOMEM;
 
-	ret = seq_open(file, &xt_match_seq_ops);
-	if (ret < 0) {
-		kfree(trav);
-		return ret;
-	}
-
-	seq = file->private_data;
-	seq->private = trav;
 	trav->nfproto = (unsigned long)PDE_DATA(inode);
 	return 0;
 }
@@ -1201,22 +1190,11 @@ static const struct seq_operations xt_target_seq_ops = {
 
 static int xt_target_open(struct inode *inode, struct file *file)
 {
-	struct seq_file *seq;
 	struct nf_mttg_trav *trav;
-	int ret;
-
-	trav = kmalloc(sizeof(*trav), GFP_KERNEL);
-	if (trav == NULL)
+	trav = __seq_open_private(file, &xt_target_seq_ops, sizeof(*trav));
+	if (!trav)
 		return -ENOMEM;
 
-	ret = seq_open(file, &xt_target_seq_ops);
-	if (ret < 0) {
-		kfree(trav);
-		return ret;
-	}
-
-	seq = file->private_data;
-	seq->private = trav;
 	trav->nfproto = (unsigned long)PDE_DATA(inode);
 	return 0;
 }
-- 
1.7.10.4

