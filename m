Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab3LCV2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 16:28:41 -0500
Received: from smtp.outflux.net ([198.145.64.163]:53412 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894Ab3LCV2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 16:28:35 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, keescook@chromium.org
Subject: [PATCH 1/2] test: add minimal module for verification testing
Date: Tue,  3 Dec 2013 13:27:33 -0800
Message-Id: <1386106054-27636-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386106054-27636-1-git-send-email-keescook@chromium.org>
References: <1386106054-27636-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing module loading verification tests (for example, with module
singing, or LSM hooks), it is very handy to have a module that can be
built on all systems under test, isn't auto-loaded at boot, and has
no device or similar dependencies. This creates the "test_module.ko"
module for that purpose, which only reports its load and unload to printk.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/Makefile      |    1 +
 kernel/test_module.c |   26 ++++++++++++++++++++++++++
 lib/Kconfig.debug    |   14 ++++++++++++++
 3 files changed, 41 insertions(+)
 create mode 100644 kernel/test_module.c

diff --git a/kernel/Makefile b/kernel/Makefile
index bbaf7d59c1bb..9de0f0e89937 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -59,6 +59,7 @@ obj-$(CONFIG_IKCONFIG) += configs.o
 obj-$(CONFIG_RESOURCE_COUNTERS) += res_counter.o
 obj-$(CONFIG_SMP) += stop_machine.o
 obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
+obj-$(CONFIG_TEST_MODULE) += test_module.o
 obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
 obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
 obj-$(CONFIG_AUDIT_WATCH) += audit_watch.o
diff --git a/kernel/test_module.c b/kernel/test_module.c
new file mode 100644
index 000000000000..f825589315d7
--- /dev/null
+++ b/kernel/test_module.c
@@ -0,0 +1,26 @@
+/*
+ * "hello world" kernel module
+ */
+
+#define pr_fmt(fmt) "test_module: " fmt
+
+#include <linux/module.h>
+
+static int __init test_module_init(void)
+{
+	pr_info("Hello, world\n");
+
+	return 0;
+}
+
+module_init(test_module_init);
+
+static void __exit test_module_exit(void)
+{
+	pr_info("Goodbye\n");
+}
+
+module_exit(test_module_exit);
+
+MODULE_AUTHOR("Kees Cook <keescook@chromium.org>");
+MODULE_LICENSE("GPL");
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index db25707aa41b..20abc92032e0 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1578,6 +1578,20 @@ config DMA_API_DEBUG
 	  This option causes a performance degredation.  Use only if you want
 	  to debug device drivers. If unsure, say N.
 
+config TEST_MODULE
+	tristate "Test module loading with 'hello world' module"
+	default n
+	depends on m
+	help
+	  This builds the "test_module" module that emits "Hello, world"
+	  on printk when loaded. It is designed to be used for basic
+	  evaluation of the module loading subsystem (for example when
+	  validating module verification). It lacks any extra dependencies,
+	  and will not normally be loaded by the system unless explicitly
+	  request by name.
+
+	  If unsure, say N.
+
 source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
-- 
1.7.9.5

