Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbaJBQkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:40:42 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:50758 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaJBQkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:40:39 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@codethink.co.uk,
        rob.jones@codethink.co.uk
Subject: [PATCH RESUBMIT] fs/proc/task_mmu: use __seq_open_private()
Date: Thu,  2 Oct 2014 17:40:26 +0100
Message-Id: <1412268026-633-1-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce boilerplate code by using __seq_open_private() instead of seq_open().

This function has been around, undocumented, for years. It can simplify
the set up code for seq file operations.

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
---

This patch was originally submitted on 12th September as part 2/2.

Part 1 was pipped at the post by someone else doing the same thing.

This part resubmitted as a stand-alone patch.

 fs/proc/task_mmu.c |   42 ++++++++++++++++--------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 442177b..c8e9045 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -235,19 +235,14 @@ static int do_maps_open(struct inode *inode, struct file *file,
 			const struct seq_operations *ops)
 {
 	struct proc_maps_private *priv;
-	int ret = -ENOMEM;
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (priv) {
-		priv->pid = proc_pid(inode);
-		ret = seq_open(file, ops);
-		if (!ret) {
-			struct seq_file *m = file->private_data;
-			m->private = priv;
-		} else {
-			kfree(priv);
-		}
-	}
-	return ret;
+
+	priv = __seq_open_private(file, ops, sizeof(*priv));
+	if (!priv)
+		return -ENOMEM;
+
+	priv->pid = proc_pid(inode);
+
+	return 0;
 }
 
 static void
@@ -1495,19 +1490,14 @@ static int numa_maps_open(struct inode *inode, struct file *file,
 			  const struct seq_operations *ops)
 {
 	struct numa_maps_private *priv;
-	int ret = -ENOMEM;
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (priv) {
-		priv->proc_maps.pid = proc_pid(inode);
-		ret = seq_open(file, ops);
-		if (!ret) {
-			struct seq_file *m = file->private_data;
-			m->private = priv;
-		} else {
-			kfree(priv);
-		}
-	}
-	return ret;
+
+	priv = __seq_open_private(file, ops, sizeof(*priv));
+	if (!priv)
+		return -ENOMEM;
+
+	priv->proc_maps.pid = proc_pid(inode);
+
+	return 0;
 }
 
 static int pid_numa_maps_open(struct inode *inode, struct file *file)
-- 
1.7.10.4

