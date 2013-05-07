Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760113Ab3EGEg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:36:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab3EGEZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:49 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=4K6t3UVbgFAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=p2YRqJIdbJIA:10 a=Z4Rwk6OoAAAA:8 a=UOpjjlpZozkG-P3uORQA:9 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035856.181510825@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [091/126] Add file_ns_capable() helper function for open-time capability
 checking
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0091-Add-file_ns_capable-helper-function-for-open-time-ca.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 935d8aabd4331f47a89c3e1daa5779d23cf244ee ]

Nothing is using it yet, but this will allow us to delay the open-time
checks to use time, without breaking the normal UNIX permission
semantics where permissions are determined by the opener (and the file
descriptor can then be passed to a different process, or the process can
drop capabilities).

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/capability.h |    2 ++
 kernel/capability.c        |   24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index d10b7ed..19e11d4 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -377,6 +377,7 @@ struct cpu_vfs_cap_data {
 
 #ifdef __KERNEL__
 
+struct file;
 struct inode;
 struct dentry;
 struct user_namespace;
@@ -553,6 +554,7 @@ extern bool capable(int cap);
 extern bool ns_capable(struct user_namespace *ns, int cap);
 extern bool nsown_capable(int cap);
 extern bool inode_capable(const struct inode *inode, int cap);
+extern bool file_ns_capable(const struct file *file, struct user_namespace *ns, int cap);
 
 /* audit system wants to get cap info from files as well */
 extern int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data *cpu_caps);
diff --git a/kernel/capability.c b/kernel/capability.c
index 493d972..f6c2ce5 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -393,6 +393,30 @@ bool ns_capable(struct user_namespace *ns, int cap)
 EXPORT_SYMBOL(ns_capable);
 
 /**
+ * file_ns_capable - Determine if the file's opener had a capability in effect
+ * @file:  The file we want to check
+ * @ns:  The usernamespace we want the capability in
+ * @cap: The capability to be tested for
+ *
+ * Return true if task that opened the file had a capability in effect
+ * when the file was opened.
+ *
+ * This does not set PF_SUPERPRIV because the caller may not
+ * actually be privileged.
+ */
+bool file_ns_capable(const struct file *file, struct user_namespace *ns, int cap)
+{
+	if (WARN_ON_ONCE(!cap_valid(cap)))
+		return false;
+
+	if (security_capable(file->f_cred, ns, cap) == 0)
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL(file_ns_capable);
+
+/**
  * capable - Determine if the current task has a superior capability in effect
  * @cap: The capability to be tested for
  *
-- 
1.7.10.4


