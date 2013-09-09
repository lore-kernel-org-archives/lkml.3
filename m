Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab3IIPwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:52:25 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44957 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab3IIPwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:52:10 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        linux-efi@vger.kernel.org, jmorris@namei.org,
        linux-security-module@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 01/12] Add BSD-style securelevel support
Date: Mon,  9 Sep 2013 11:49:35 -0400
Message-Id: <1378741786-18430-2-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:5d52:9ee3:3e84:6668
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a coarse-grained runtime configuration option for restricting
userspace's ability to modify the running kernel.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 Documentation/security/securelevel.txt |  23 +++++++
 include/linux/security.h               |   8 +++
 security/Kconfig                       |   8 +++
 security/Makefile                      |   1 +
 security/securelevel.c                 | 116 +++++++++++++++++++++++++++++++++
 5 files changed, 156 insertions(+)
 create mode 100644 Documentation/security/securelevel.txt
 create mode 100644 security/securelevel.c

diff --git a/Documentation/security/securelevel.txt b/Documentation/security/securelevel.txt
new file mode 100644
index 0000000..a1355a0
--- /dev/null
+++ b/Documentation/security/securelevel.txt
@@ -0,0 +1,23 @@
+Linux securelevel interface
+---------------------------
+
+The Linux securelevel interface (inspired by the BSD securelevel interface)
+is a runtime mechanism for configuring coarse-grained kernel-level security
+restrictions. It provides a runtime configuration variable at
+/sys/kernel/security/securelevel which can be written to by root. The
+following values are supported:
+
+-1: Permanently insecure mode. This level is equivalent to level 0, but once
+    set cannot be changed.
+
+0:  Insecure mode (default). This level imposes no additional kernel
+    restrictions.
+
+1:  Secure mode. If set, userspace will be unable to perform direct access
+    to PCI devices, port IO access, access system memory directly via
+    /dev/mem and /dev/kmem, perform kexec_load(), use the userspace
+    software suspend mechanism, insert new ACPI code at runtime via the
+    custom_method interface or modify CPU MSRs (on x86). Certain drivers
+    may also limit additional interfaces.
+
+Once the securelevel value is increased, it may not be decreased.
diff --git a/include/linux/security.h b/include/linux/security.h
index 9d37e2b..e8b69e0 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -3081,6 +3081,14 @@ static inline void security_audit_rule_free(void *lsmrule)
 #endif /* CONFIG_SECURITY */
 #endif /* CONFIG_AUDIT */
 
+#ifdef CONFIG_SECURITY_SECURELEVEL
+extern int get_securelevel(void);
+extern int set_securelevel(int new_securelevel);
+#else
+static inline int get_securelevel(void) { return 0; }
+static inline int set_securelevel(int new_securelevel) { return 0; }
+#endif /* CONFIG_SECURELEVEL */
+
 #ifdef CONFIG_SECURITYFS
 
 extern struct dentry *securityfs_create_file(const char *name, umode_t mode,
diff --git a/security/Kconfig b/security/Kconfig
index e9c6ac7..3605d24 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -70,6 +70,14 @@ config SECURITY_PATH
 	  implement pathname based access controls.
 	  If you are unsure how to answer this question, answer N.
 
+config SECURITY_SECURELEVEL
+        bool "Securelevel kernel restriction interface"
+	depends on SECURITY
+	help
+	  This enables support for adding a set of additional kernel security
+	  restrictions at runtime. See Documentation/security/securelevel.txt
+	  for further information.
+
 config INTEL_TXT
 	bool "Enable Intel(R) Trusted Execution Technology (Intel(R) TXT)"
 	depends on HAVE_INTEL_TXT
diff --git a/security/Makefile b/security/Makefile
index c26c81e..d6c98ab 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_MMU)			+= min_addr.o
 # Object file lists
 obj-$(CONFIG_SECURITY)			+= security.o capability.o
 obj-$(CONFIG_SECURITYFS)		+= inode.o
+obj-$(CONFIG_SECURITY_SECURELEVEL)	+= securelevel.o
 # Must precede capability.o in order to stack properly.
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
 obj-$(CONFIG_SECURITY_SMACK)		+= smack/built-in.o
diff --git a/security/securelevel.c b/security/securelevel.c
new file mode 100644
index 0000000..7128430
--- /dev/null
+++ b/security/securelevel.c
@@ -0,0 +1,116 @@
+/*
+ *  securelevel.c - support for generic kernel lockdown
+ *
+ *  Copyright Nebula, Inc <matthew.garrett@nebula.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/security.h>
+#include <linux/uaccess.h>
+
+static int securelevel;
+
+static DEFINE_SPINLOCK(securelevel_lock);
+
+#define MAX_SECURELEVEL 1
+
+int get_securelevel(void)
+{
+	return securelevel;
+}
+EXPORT_SYMBOL(get_securelevel);
+
+int set_securelevel(int new_securelevel)
+{
+	int ret = 0;
+
+	spin_lock(&securelevel_lock);
+
+	if ((securelevel == -1) || (new_securelevel < securelevel) ||
+	    (new_securelevel > MAX_SECURELEVEL)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	securelevel = new_securelevel;
+out:
+	spin_unlock(&securelevel_lock);
+	return ret;
+}
+EXPORT_SYMBOL(set_securelevel);
+
+static ssize_t securelevel_read(struct file *filp, char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	char tmpbuf[12];
+	ssize_t length;
+
+	length = scnprintf(tmpbuf, sizeof(tmpbuf), "%d", securelevel);
+	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
+}
+
+static ssize_t securelevel_write(struct file *file, const char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	char *page = NULL;
+	ssize_t length;
+	int new_securelevel;
+
+	length = -ENOMEM;
+	if (count >= PAGE_SIZE)
+		goto out;
+
+	length = -EINVAL;
+	if (*ppos != 0)
+		goto out;
+
+	length = -ENOMEM;
+	page = (char *)get_zeroed_page(GFP_KERNEL);
+	if (!page)
+		goto out;
+
+	length = -EFAULT;
+	if (copy_from_user(page, buf, count))
+		goto out;
+
+	length = -EINVAL;
+	if (sscanf(page, "%d", &new_securelevel) != 1)
+		goto out;
+
+	length = set_securelevel(new_securelevel);
+	if (length)
+		goto out;
+
+	length = count;
+out:
+	free_page((unsigned long) page);
+	return length;
+}
+
+static const struct file_operations securelevel_fops = {
+	.read 	= securelevel_read,
+	.write 	= securelevel_write,
+	.llseek	= generic_file_llseek,
+};
+
+static __init int setup_securelevel(void)
+{
+	struct dentry *securelevel_file;
+
+	securelevel_file = securityfs_create_file("securelevel",
+						  S_IWUSR | S_IRUGO,
+						  NULL, NULL,
+						  &securelevel_fops);
+
+	if (IS_ERR(securelevel_file))
+		return PTR_ERR(securelevel_file);
+
+	return 0;
+}
+late_initcall(setup_securelevel);
-- 
1.8.3.1

