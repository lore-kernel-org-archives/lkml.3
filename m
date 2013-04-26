Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab3DZTZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 15:25:46 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:39862 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210Ab3DZTZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 15:25:44 -0400
Date: Fri, 26 Apr 2013 12:25:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 3.8.10
Message-ID: <20130426192542.GB23742@kroah.com>
References: <20130426192521.GA23742@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130426192521.GA23742@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 3ae4796..e2b10b9 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 3
 PATCHLEVEL = 8
-SUBLEVEL = 9
+SUBLEVEL = 10
 EXTRAVERSION =
 NAME = Displaced Humerus Anterior
 
diff --git a/include/linux/capability.h b/include/linux/capability.h
index 98503b7..d9a4f7f4 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -35,6 +35,7 @@ struct cpu_vfs_cap_data {
 #define _KERNEL_CAP_T_SIZE     (sizeof(kernel_cap_t))
 
 
+struct file;
 struct inode;
 struct dentry;
 struct user_namespace;
@@ -211,6 +212,7 @@ extern bool capable(int cap);
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
