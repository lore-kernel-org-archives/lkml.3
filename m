Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbaETNMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:12:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbaETNMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:12:51 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Cc: Richard Guy Briggs <rgb@redhat.com>, arozansk@redhat.com, serge@hallyn.com,
        ebiederm@xmission.com, eparis@redhat.com, sgrubb@redhat.com
Subject: [PATCH V3 3/6] namespaces: expose ns instance serial numbers in proc
Date: Tue, 20 May 2014 09:12:04 -0400
Message-Id: <9975244b2ea7a260d616d2a0a6b118b0410f350b.1400271129.git.rgb@redhat.com>
In-Reply-To: <cover.1400271129.git.rgb@redhat.com>
References: <cover.1400271129.git.rgb@redhat.com>
In-Reply-To: <cover.1400271129.git.rgb@redhat.com>
References: <cover.1400271129.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose the namespace instace serial numbers in the proc filesystem at
/proc/<pid>/ns/<ns>_snum.  The link text gives the serial number in hex.

"snum" was chosen instead of "seq" for consistency with inum and there are a
number of other uses of "seq" in the namespace code.

Suggested-by: Serge E. Hallyn <serge@hallyn.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 fs/proc/namespaces.c |   33 +++++++++++++++++++++++++--------
 1 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index 9ae46b8..57fce90 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -47,12 +47,15 @@ static char *ns_dname(struct dentry *dentry, char *buffer, int buflen)
 	struct inode *inode = dentry->d_inode;
 	const struct proc_ns_operations *ns_ops = PROC_I(inode)->ns.ns_ops;
 
-	return dynamic_dname(dentry, buffer, buflen, "%s:[%lu]",
-		ns_ops->name, inode->i_ino);
+	if (strstr(dentry->d_iname, "_snum"))
+		return dynamic_dname(dentry, buffer, buflen, "%s_snum:[%llx]",
+			ns_ops->name, ns_ops->snum(PROC_I(inode)->ns.ns));
+	else
+		return dynamic_dname(dentry, buffer, buflen, "%s:[%lu]",
+			ns_ops->name, inode->i_ino);
 }
 
-const struct dentry_operations ns_dentry_operations =
-{
+const struct dentry_operations ns_dentry_operations = {
 	.d_delete	= always_delete_dentry,
 	.d_dname	= ns_dname,
 };
@@ -160,7 +163,10 @@ static int proc_ns_readlink(struct dentry *dentry, char __user *buffer, int bufl
 	if (!ns)
 		goto out_put_task;
 
-	snprintf(name, sizeof(name), "%s:[%u]", ns_ops->name, ns_ops->inum(ns));
+	if (strstr(dentry->d_iname, "_snum"))
+		snprintf(name, sizeof(name), "%s_snum:[%llx]", ns_ops->name, ns_ops->snum(ns));
+	else
+		snprintf(name, sizeof(name), "%s:[%u]", ns_ops->name, ns_ops->inum(ns));
 	len = strlen(name);
 
 	if (len > buflen)
@@ -216,16 +222,23 @@ static int proc_ns_dir_readdir(struct file *file, struct dir_context *ctx)
 
 	if (!dir_emit_dots(file, ctx))
 		goto out;
-	if (ctx->pos >= 2 + ARRAY_SIZE(ns_entries))
+	if (ctx->pos >= 2 + 2 * ARRAY_SIZE(ns_entries))
 		goto out;
 	entry = ns_entries + (ctx->pos - 2);
 	last = &ns_entries[ARRAY_SIZE(ns_entries) - 1];
 	while (entry <= last) {
 		const struct proc_ns_operations *ops = *entry;
+		char name[50];
+
 		if (!proc_fill_cache(file, ctx, ops->name, strlen(ops->name),
 				     proc_ns_instantiate, task, ops))
 			break;
 		ctx->pos++;
+		snprintf(name, sizeof(name), "%s_snum", ops->name);
+		if (!proc_fill_cache(file, ctx, name, strlen(name),
+				     proc_ns_instantiate, task, ops))
+			break;
+		ctx->pos++;
 		entry++;
 	}
 out:
@@ -253,9 +266,13 @@ static struct dentry *proc_ns_dir_lookup(struct inode *dir,
 
 	last = &ns_entries[ARRAY_SIZE(ns_entries)];
 	for (entry = ns_entries; entry < last; entry++) {
-		if (strlen((*entry)->name) != len)
+		char name[50];
+
+		snprintf(name, sizeof(name), "%s_snum", (*entry)->name);
+		if (strlen((*entry)->name) != len && strlen(name) != len)
 			continue;
-		if (!memcmp(dentry->d_name.name, (*entry)->name, len))
+		if (!memcmp(dentry->d_name.name, (*entry)->name, len)
+		    || !memcmp(dentry->d_name.name, name, len))
 			break;
 	}
 	if (entry == last)
-- 
1.7.1

