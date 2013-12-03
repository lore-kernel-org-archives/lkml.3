Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab3LCV2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 16:28:52 -0500
Received: from smtp.outflux.net ([198.145.64.163]:38731 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150Ab3LCV2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 16:28:36 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, keescook@chromium.org
Subject: [PATCH 2/2] test: check copy_to/from_user boundary validation
Date: Tue,  3 Dec 2013 13:27:34 -0800
Message-Id: <1386106054-27636-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386106054-27636-1-git-send-email-keescook@chromium.org>
References: <1386106054-27636-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To help avoid an architecture failing to correctly check kernel/user
boundaries when handling copy_to_user, copy_from_user, put_user, or
get_user, perform some simple tests and fail to load if any of them
behave unexpectedly.

Specifically, this is to make sure there is a way to notice if things
like what was fixed in 8404663f81d212918ff85f493649a7991209fa04 ("ARM:
7527/1: uaccess: explicitly check __user pointer when !CPU_USE_DOMAINS")
ever regresses again, for any architecture.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/Makefile         |    1 +
 kernel/test_user_copy.c |  103 +++++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug       |   13 ++++++
 3 files changed, 117 insertions(+)
 create mode 100644 kernel/test_user_copy.c

diff --git a/kernel/Makefile b/kernel/Makefile
index 9de0f0e89937..f8185152cbb8 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -60,6 +60,7 @@ obj-$(CONFIG_RESOURCE_COUNTERS) += res_counter.o
 obj-$(CONFIG_SMP) += stop_machine.o
 obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
 obj-$(CONFIG_TEST_MODULE) += test_module.o
+obj-$(CONFIG_TEST_USER_COPY) += test_user_copy.o
 obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
 obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
 obj-$(CONFIG_AUDIT_WATCH) += audit_watch.o
diff --git a/kernel/test_user_copy.c b/kernel/test_user_copy.c
new file mode 100644
index 000000000000..dbf62ec80e48
--- /dev/null
+++ b/kernel/test_user_copy.c
@@ -0,0 +1,103 @@
+/*
+ * Kernel module for testing copy_to/from_user infrastructure.
+ *
+ * Copyright 2013 Google Inc. All Rights Reserved
+ *
+ * Authors:
+ *      Kees Cook       <keescook@chromium.org>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt) "test_user_copy: " fmt
+
+#include <linux/mman.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/vmalloc.h>
+
+#define failed(msg) {	\
+	pr_warn(msg);	\
+	ret = -EINVAL;	\
+}
+
+static int __init test_user_copy_init(void)
+{
+	int ret = 0;
+	char *kmem;
+	char __user *usermem;
+	unsigned long user_addr;
+	unsigned long value = 0x5A;
+
+	kmem = kmalloc(PAGE_SIZE * 2, GFP_KERNEL);
+	if (!kmem) {
+		pr_warn("Failed to allocate kernel memory\n");
+		return -ENOMEM;
+	}
+
+	user_addr = vm_mmap(NULL, 0, PAGE_SIZE * 2,
+			    PROT_READ | PROT_WRITE | PROT_EXEC,
+			    MAP_ANONYMOUS | MAP_PRIVATE, 0);
+	if (user_addr >= TASK_SIZE) {
+		pr_warn("Failed to allocate user memory\n");
+		kfree(kmem);
+		return -ENOMEM;
+	}
+
+	usermem = (char __user *)user_addr;
+
+	/* Legitimate usage: none of these should fail. */
+	if (copy_from_user(kmem, usermem, PAGE_SIZE))
+		failed("legitimate copy_from_user failed");
+	if (copy_to_user(usermem, kmem, PAGE_SIZE))
+		failed("legitimate copy_to_user failed");
+	if (get_user(value, (unsigned long __user *)usermem))
+		failed("legitimate get_user failed");
+	if (put_user(value, (unsigned long __user *)usermem))
+		failed("legitimate put_user failed");
+
+	/* Invalid usage: none of these should succeed. */
+	if (!copy_from_user(kmem, (char __user *)(kmem + PAGE_SIZE),
+			    PAGE_SIZE))
+		failed("illegal all-kernel copy_from_user passed");
+	if (!copy_from_user((char *)usermem, (char __user *)kmem, PAGE_SIZE))
+		failed("illegal reversed copy_from_user passed");
+
+	if (!copy_to_user((char __user *)kmem, kmem + PAGE_SIZE, PAGE_SIZE))
+		failed("illegal all-kernel copy_to_user passed");
+	if (!copy_to_user((char __user *)kmem, (char *)usermem, PAGE_SIZE))
+		failed("illegal reversed copy_to_user passed");
+
+	if (!get_user(value, (unsigned long __user *)kmem))
+		failed("illegal get_user passed");
+	if (!put_user(value, (unsigned long __user *)kmem))
+		failed("illegal put_user passed");
+
+	vm_munmap(user_addr, PAGE_SIZE * 2);
+	kfree(kmem);
+
+	if (ret == 0)
+		pr_info("tests passed.\n");
+
+	return ret;
+}
+
+module_init(test_user_copy_init);
+
+static void __exit test_user_copy_exit(void)
+{
+	pr_info("unloaded.\n");
+}
+
+module_exit(test_user_copy_exit);
+
+MODULE_AUTHOR("Kees Cook <keescook@chromium.org>");
+MODULE_LICENSE("GPL");
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 20abc92032e0..92d1a39f885e 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1592,6 +1592,19 @@ config TEST_MODULE
 
 	  If unsure, say N.
 
+config TEST_USER_COPY
+	tristate "Test user/kernel boundary protections"
+	default n
+	depends on m
+	help
+	  This builds the "test_user_copy" module that runs sanity checks
+	  on the copy_to/from_user infrastructure, making sure basic
+	  user/kernel boundary testing is working. If it fails to load,
+	  a regression has been detected in the user/kernel memory boundary
+	  protections.
+
+	  If unsure, say N.
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
-- 
1.7.9.5

