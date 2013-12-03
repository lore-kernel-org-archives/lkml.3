Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab3LCXHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:07:45 -0500
Received: from smtp.outflux.net ([198.145.64.163]:60922 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455Ab3LCXHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:07:15 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, keescook@chromium.org
Subject: [PATCH v2 2/2] test: check copy_to/from_user boundary validation
Date: Tue,  3 Dec 2013 15:06:27 -0800
Message-Id: <1386111987-13073-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386111987-13073-1-git-send-email-keescook@chromium.org>
References: <1386111987-13073-1-git-send-email-keescook@chromium.org>
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

Additionally, adds new "user" selftest target, which loads this module.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2:
 - add sched.h for archs that define TASK_SIZE with more complexity
 - add to selftests, move to lib/; akpm.
 - clean up test macro, drop needless pr_warn; Joe Perches.
---
 lib/Kconfig.debug                     |   13 ++++
 lib/Makefile                          |    1 +
 lib/test_user_copy.c                  |  108 +++++++++++++++++++++++++++++++++
 tools/testing/selftests/Makefile      |    1 +
 tools/testing/selftests/user/Makefile |   13 ++++
 5 files changed, 136 insertions(+)
 create mode 100644 lib/test_user_copy.c
 create mode 100644 tools/testing/selftests/user/Makefile

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 81882335c625..6e905cc04aa7 100644
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
diff --git a/lib/Makefile b/lib/Makefile
index b494b9af631c..98ec3b861062 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
 obj-y += kstrtox.o
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
 obj-$(CONFIG_TEST_MODULE) += test_module.o
+obj-$(CONFIG_TEST_USER_COPY) += test_user_copy.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
diff --git a/lib/test_user_copy.c b/lib/test_user_copy.c
new file mode 100644
index 000000000000..681921ca2da8
--- /dev/null
+++ b/lib/test_user_copy.c
@@ -0,0 +1,108 @@
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
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/vmalloc.h>
+
+#define test(condition, msg)		\
+({					\
+	int cond = (condition);		\
+	if (cond)			\
+		pr_warn("%s\n", msg);	\
+	cond;				\
+})
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
+	if (!kmem)
+		return -ENOMEM;
+
+	user_addr = vm_mmap(NULL, 0, PAGE_SIZE * 2,
+			    PROT_READ | PROT_WRITE | PROT_EXEC,
+			    MAP_ANONYMOUS | MAP_PRIVATE, 0);
+	if (user_addr >= (unsigned long)(TASK_SIZE)) {
+		pr_warn("Failed to allocate user memory\n");
+		kfree(kmem);
+		return -ENOMEM;
+	}
+
+	usermem = (char __user *)user_addr;
+
+	/* Legitimate usage: none of these should fail. */
+	ret |= test(copy_from_user(kmem, usermem, PAGE_SIZE),
+		    "legitimate copy_from_user failed");
+	ret |= test(copy_to_user(usermem, kmem, PAGE_SIZE),
+		    "legitimate copy_to_user failed");
+	ret |= test(get_user(value, (unsigned long __user *)usermem),
+		    "legitimate get_user failed");
+	ret |= test(put_user(value, (unsigned long __user *)usermem),
+		    "legitimate put_user failed");
+
+	/* Invalid usage: none of these should succeed. */
+	ret |= test(!copy_from_user(kmem, (char __user *)(kmem + PAGE_SIZE),
+				    PAGE_SIZE),
+		    "illegal all-kernel copy_from_user passed");
+	ret |= test(!copy_from_user((char *)usermem, (char __user *)kmem,
+				    PAGE_SIZE),
+		    "illegal reversed copy_from_user passed");
+	ret |= test(!copy_to_user((char __user *)kmem, kmem + PAGE_SIZE,
+				  PAGE_SIZE),
+		    "illegal all-kernel copy_to_user passed");
+	ret |= test(!copy_to_user((char __user *)kmem, (char *)usermem,
+				  PAGE_SIZE),
+		    "illegal reversed copy_to_user passed");
+	ret |= test(!get_user(value, (unsigned long __user *)kmem),
+		    "illegal get_user passed");
+	ret |= test(!put_user(value, (unsigned long __user *)kmem),
+		    "illegal put_user passed");
+
+	vm_munmap(user_addr, PAGE_SIZE * 2);
+	kfree(kmem);
+
+	if (ret == 0) {
+		pr_info("tests passed.\n");
+		return 0;
+	}
+
+	return -EINVAL;
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
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 9f3eae290900..32487ed18354 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -9,6 +9,7 @@ TARGETS += ptrace
 TARGETS += timers
 TARGETS += vm
 TARGETS += powerpc
+TARGETS += user
 
 all:
 	for TARGET in $(TARGETS); do \
diff --git a/tools/testing/selftests/user/Makefile b/tools/testing/selftests/user/Makefile
new file mode 100644
index 000000000000..396255bd720e
--- /dev/null
+++ b/tools/testing/selftests/user/Makefile
@@ -0,0 +1,13 @@
+# Makefile for user memory selftests
+
+# No binaries, but make sure arg-less "make" doesn't trigger "run_tests"
+all:
+
+run_tests: all
+	@if /sbin/modprobe test_user_copy ; then \
+		rmmod test_user_copy; \
+		echo "user_copy: ok"; \
+	else \
+		echo "user_copy: [FAIL]"; \
+		exit 1; \
+	fi
-- 
1.7.9.5

