Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbaJSSKw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 14:10:52 -0400
Received: from karr.yath.de ([144.76.4.50]:44567 "EHLO karr.yath.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbaJSSKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 14:10:50 -0400
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Oct 2014 14:10:49 EDT
Date: Sun, 19 Oct 2014 20:05:15 +0200
From: Sebastian Schmidt <yath@yath.de>
To: Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] pstore: honor dmesg_restrict sysctl on dmesg dumps
Message-ID: <20141019180515.GA14661@moniac.lan.yath.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the kernel.dmesg_restrict restriction is in place, only users with
CAP_SYSLOG should be able to access crash dumps (like: attacker is
trying to exploit a bug, watchdog reboots, attacker can happily read
crash dumps and logs).

This puts the restriction on console-* types as well as sensitive
information could have been leaked there.

Other log types are unaffected.

Signed-off-by: Sebastian Schmidt <yath@yath.de>
---
 fs/pstore/inode.c      | 22 ++++++++++++++++++++++
 include/linux/syslog.h |  1 +
 kernel/printk/printk.c |  2 +-
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index fafb7a0..5041660 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -36,6 +36,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/uaccess.h>
+#include <linux/syslog.h>
 
 #include "internal.h"
 
@@ -120,6 +121,18 @@ static const struct seq_operations pstore_ftrace_seq_ops = {
 	.show	= pstore_ftrace_seq_show,
 };
 
+static int pstore_check_syslog_permissions(struct pstore_private *ps)
+{
+	switch (ps->type) {
+	case PSTORE_TYPE_DMESG:
+	case PSTORE_TYPE_CONSOLE:
+		return check_syslog_permissions(SYSLOG_ACTION_READ_ALL,
+			SYSLOG_FROM_READER);
+	default:
+		return 0;
+	}
+}
+
 static ssize_t pstore_file_read(struct file *file, char __user *userbuf,
 						size_t count, loff_t *ppos)
 {
@@ -138,6 +151,10 @@ static int pstore_file_open(struct inode *inode, struct file *file)
 	int err;
 	const struct seq_operations *sops = NULL;
 
+	err = pstore_check_syslog_permissions(ps);
+	if (err)
+		return err;
+
 	if (ps->type == PSTORE_TYPE_FTRACE)
 		sops = &pstore_ftrace_seq_ops;
 
@@ -174,6 +191,11 @@ static const struct file_operations pstore_file_operations = {
 static int pstore_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct pstore_private *p = dentry->d_inode->i_private;
+	int err;
+
+	err = pstore_check_syslog_permissions(p);
+	if (err)
+		return err;
 
 	if (p->psi->erase)
 		p->psi->erase(p->type, p->id, p->count,
diff --git a/include/linux/syslog.h b/include/linux/syslog.h
index 98a3153..9def529 100644
--- a/include/linux/syslog.h
+++ b/include/linux/syslog.h
@@ -48,5 +48,6 @@
 #define SYSLOG_FROM_PROC             1
 
 int do_syslog(int type, char __user *buf, int count, bool from_file);
+int check_syslog_permissions(int type, bool from_file);
 
 #endif /* _LINUX_SYSLOG_H */
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index ced2b84..c8755e7 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -480,7 +480,7 @@ static int syslog_action_restricted(int type)
 	       type != SYSLOG_ACTION_SIZE_BUFFER;
 }
 
-static int check_syslog_permissions(int type, bool from_file)
+int check_syslog_permissions(int type, bool from_file)
 {
 	/*
 	 * If this is from /proc/kmsg and we've already opened it, then we've
-- 
2.1.1

