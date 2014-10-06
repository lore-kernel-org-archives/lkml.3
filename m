Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaJFFK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 01:10:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbaJFFJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 01:09:30 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        aviro@redhat.com, pmoore@redhat.com, arozansk@redhat.com,
        ebiederm@xmission.com, serge@hallyn.com
Subject: [PATCH V5 12/13] namespaces: expose ns instance serial numbers in proc
Date: Mon,  6 Oct 2014 01:08:37 -0400
Message-Id: <53b81e89f7179ef8569409293f990b3ac7deac61.1412543112.git.rgb@redhat.com>
In-Reply-To: <cover.1412543112.git.rgb@redhat.com>
References: <cover.1412543112.git.rgb@redhat.com>
In-Reply-To: <cover.1412543112.git.rgb@redhat.com>
References: <cover.1412543112.git.rgb@redhat.com>
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
index 310da74..29c3909 100644
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
 	res = readlink_copy(buffer, buflen, name);
 	ns_ops->put(ns);
 out_put_task:
@@ -210,16 +216,23 @@ static int proc_ns_dir_readdir(struct file *file, struct dir_context *ctx)
 
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
@@ -247,9 +260,13 @@ static struct dentry *proc_ns_dir_lookup(struct inode *dir,
 
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

