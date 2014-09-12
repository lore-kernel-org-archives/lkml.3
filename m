Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbaILOKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:10:30 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:57351 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbaILOJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:09:49 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@codethink.co.uk,
        rob.jones@codethink.co.uk
Subject: [PATCH 1/2] fs: proc: use __seq_open_private()
Date: Fri, 12 Sep 2014 15:09:37 +0100
Message-Id: <1410530978-29627-2-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410530978-29627-1-git-send-email-rob.jones@codethink.co.uk>
References: <1410530978-29627-1-git-send-email-rob.jones@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce boilerplate code by using __seq_open_private() instead of seq_open().

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
---
 fs/proc/task_nommu.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 678455d..b141050 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -269,20 +269,14 @@ static int maps_open(struct inode *inode, struct file *file,
 		     const struct seq_operations *ops)
 {
 	struct proc_maps_private *priv;
-	int ret = -ENOMEM;
-
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
 
 static int pid_maps_open(struct inode *inode, struct file *file)
-- 
1.7.10.4

