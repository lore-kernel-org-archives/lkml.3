Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbaANOwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:52:09 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:54258 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaANOwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:52:06 -0500
Date: Tue, 14 Jan 2014 09:52:01 -0500
From: Tejun Heo <tj@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH driver-core-next] kernfs: fix get_active failure handling in
 kernfs_seq_*()
Message-ID: <20140114145201.GD12131@htj.dyndns.org>
References: <13896533783@kroah.com>
 <20140113225053.GA10124@mtj.dyndns.org>
 <20140113230017.GB26622@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113230017.GB26622@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

tj: This was originally committed as d92d2e6bd72b but got reverted by
    683bb2761fbf along with other kernfs self removal patches.
    However, this one is an independent fix and shouldn't have been
    reverted together.  Reinstate the change.  Sorry about the mess.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
---
 fs/kernfs/file.c |   51 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 44 insertions(+), 7 deletions(-)

--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -54,6 +54,38 @@ static const struct kernfs_ops *kernfs_o
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
@@ -69,7 +101,11 @@ static void *kernfs_seq_start(struct seq
 
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
@@ -85,7 +121,11 @@ static void *kernfs_seq_next(struct seq_
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
@@ -99,12 +139,9 @@ static void *kernfs_seq_next(struct seq_
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
 
