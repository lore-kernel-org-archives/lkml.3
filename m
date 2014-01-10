Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaAJN5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 08:57:46 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:53751 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaAJN5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:57:38 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 01/14] kernfs: fix get_active failure handling in kernfs_seq_*()
Date: Fri, 10 Jan 2014 08:57:18 -0500
Message-Id: <1389362251-8128-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389362251-8128-1-git-send-email-tj@kernel.org>
References: <1389362251-8128-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When kernfs_seq_start() fails to obtain an active reference, it
returns ERR_PTR(-ENODEV).  kernfs_seq_stop() is then invoked with the
error pointer value; however, it still proceeds to invoke
kernfs_put_active() on the node leading to unbalanced put.

If kernfs_seq_stop() is called even after active ref failure, it
should skip invocation of @ops->seq_stop() and put_active.
Unfortunately, this is a bit complicated because active ref failure
isn't the only thing which may fail with ERR_PTR(-ENODEV).
@ops->seq_start/next() may also fail with the error value and
kernfs_seq_stop() doesn't have a way to tell apart those failures.

Work it around by factoring out the active part of kernfs_seq_stop()
into kernfs_seq_stop_active() and invoking it directly if
@ops->seq_start/next() fail with ERR_PTR(-ENODEV) and updating
kernfs_seq_stop() to skip kernfs_seq_stop_active() on
ERR_PTR(-ENODEV).  This is a bit nasty but ensures that the active put
is skipped iff get_active failed in kernfs_seq_start().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
---
 fs/kernfs/file.c | 51 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 44 insertions(+), 7 deletions(-)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 316604c..bdd3885 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -54,6 +54,38 @@ static const struct kernfs_ops *kernfs_ops(struct kernfs_node *kn)
 	return kn->attr.ops;
 }
 
+/*
+ * As kernfs_seq_stop() is also called after kernfs_seq_start() or
+ * kernfs_seq_next() failure, it needs to distinguish whether it's stopping
+ * a seq_file iteration which is fully initialized with an active reference
+ * or an aborted kernfs_seq_start() due to get_active failure.  The
+ * position pointer is the only context for each seq_file iteration and
+ * thus the stop condition should be encoded in it.  As the return value is
+ * directly visible to userland, ERR_PTR(-ENODEV) is the only acceptable
+ * choice to indicate get_active failure.
+ *
+ * Unfortunately, this is complicated due to the optional custom seq_file
+ * operations which may return ERR_PTR(-ENODEV) too.  kernfs_seq_stop()
+ * can't distinguish whether ERR_PTR(-ENODEV) is from get_active failure or
+ * custom seq_file operations and thus can't decide whether put_active
+ * should be performed or not only on ERR_PTR(-ENODEV).
+ *
+ * This is worked around by factoring out the custom seq_stop() and
+ * put_active part into kernfs_seq_stop_active(), skipping it from
+ * kernfs_seq_stop() if ERR_PTR(-ENODEV) while invoking it directly after
+ * custom seq_file operations fail with ERR_PTR(-ENODEV) - this ensures
+ * that kernfs_seq_stop_active() is skipped only after get_active failure.
+ */
+static void kernfs_seq_stop_active(struct seq_file *sf, void *v)
+{
+	struct kernfs_open_file *of = sf->private;
+	const struct kernfs_ops *ops = kernfs_ops(of->kn);
+
+	if (ops->seq_stop)
+		ops->seq_stop(sf, v);
+	kernfs_put_active(of->kn);
+}
+
 static void *kernfs_seq_start(struct seq_file *sf, loff_t *ppos)
 {
 	struct kernfs_open_file *of = sf->private;
@@ -69,7 +101,11 @@ static void *kernfs_seq_start(struct seq_file *sf, loff_t *ppos)
 
 	ops = kernfs_ops(of->kn);
 	if (ops->seq_start) {
-		return ops->seq_start(sf, ppos);
+		void *next = ops->seq_start(sf, ppos);
+		/* see the comment above kernfs_seq_stop_active() */
+		if (next == ERR_PTR(-ENODEV))
+			kernfs_seq_stop_active(sf, next);
+		return next;
 	} else {
 		/*
 		 * The same behavior and code as single_open().  Returns
@@ -85,7 +121,11 @@ static void *kernfs_seq_next(struct seq_file *sf, void *v, loff_t *ppos)
 	const struct kernfs_ops *ops = kernfs_ops(of->kn);
 
 	if (ops->seq_next) {
-		return ops->seq_next(sf, v, ppos);
+		void *next = ops->seq_next(sf, v, ppos);
+		/* see the comment above kernfs_seq_stop_active() */
+		if (next == ERR_PTR(-ENODEV))
+			kernfs_seq_stop_active(sf, next);
+		return next;
 	} else {
 		/*
 		 * The same behavior and code as single_open(), always
@@ -99,12 +139,9 @@ static void *kernfs_seq_next(struct seq_file *sf, void *v, loff_t *ppos)
 static void kernfs_seq_stop(struct seq_file *sf, void *v)
 {
 	struct kernfs_open_file *of = sf->private;
-	const struct kernfs_ops *ops = kernfs_ops(of->kn);
 
-	if (ops->seq_stop)
-		ops->seq_stop(sf, v);
-
-	kernfs_put_active(of->kn);
+	if (v != ERR_PTR(-ENODEV))
+		kernfs_seq_stop_active(sf, v);
 	mutex_unlock(&of->mutex);
 }
 
-- 
1.8.4.2

