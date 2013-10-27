Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab3J0HpC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 03:45:02 -0400
Received: from mail-pb0-f73.google.com ([209.85.160.73]:39573 "EHLO
	mail-pb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab3J0HpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 03:45:00 -0400
From: Greg Thelen <gthelen@google.com>
To: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        handai.szj@taobao.com, Andrew Morton <akpm@linux-foundation.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org, Greg Thelen <gthelen@google.com>
Subject: [PATCH 1/3] percpu counter: test module
Date: Sun, 27 Oct 2013 00:44:34 -0700
Message-Id: <1382859876-28196-2-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382859876-28196-1-git-send-email-gthelen@google.com>
References: <1382859876-28196-1-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tests various percpu operations.

Enable with CONFIG_PERCPU_TEST=m.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 lib/Kconfig.debug |   9 ++++
 lib/Makefile      |   2 +
 lib/percpu_test.c | 138 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 149 insertions(+)
 create mode 100644 lib/percpu_test.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 06344d9..cee589d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1472,6 +1472,15 @@ config INTERVAL_TREE_TEST
 	help
 	  A benchmark measuring the performance of the interval tree library
 
+config PERCPU_TEST
+	tristate "Per cpu counter test"
+	depends on m && DEBUG_KERNEL
+	help
+	  Enable this option to build test modules with validates per-cpu
+	  counter operations.
+
+	  If unsure, say N.
+
 config ATOMIC64_SELFTEST
 	bool "Perform an atomic64_t self-test at boot"
 	help
diff --git a/lib/Makefile b/lib/Makefile
index f3bb2cb..bb016e1 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -157,6 +157,8 @@ obj-$(CONFIG_INTERVAL_TREE_TEST) += interval_tree_test.o
 
 interval_tree_test-objs := interval_tree_test_main.o interval_tree.o
 
+obj-$(CONFIG_PERCPU_TEST) += percpu_test.o
+
 obj-$(CONFIG_ASN1) += asn1_decoder.o
 
 obj-$(CONFIG_FONT_SUPPORT) += fonts/
diff --git a/lib/percpu_test.c b/lib/percpu_test.c
new file mode 100644
index 0000000..1ebeb44
--- /dev/null
+++ b/lib/percpu_test.c
@@ -0,0 +1,138 @@
+#include <linux/module.h>
+
+/* validate @native and @pcp counter values match @expected */
+#define CHECK(native, pcp, expected)                                    \
+	do {                                                            \
+		WARN((native) != (expected),                            \
+		     "raw %ld (0x%lx) != expected %ld (0x%lx)",         \
+		     (long)(native), (long)(native),                    \
+		     (long)(expected), (long)(expected));               \
+		WARN(__this_cpu_read(pcp) != (expected),                \
+		     "pcp %ld (0x%lx) != expected %ld (0x%lx)",         \
+		     (long)__this_cpu_read(pcp), (long)__this_cpu_read(pcp), \
+		     (long)(expected), (long)(expected));               \
+	} while (0)
+
+static DEFINE_PER_CPU(long, long_counter);
+static DEFINE_PER_CPU(unsigned long, ulong_counter);
+
+static int __init percpu_test_init(void)
+{
+	/*
+	 * volatile prevents compiler from optimizing it uses, otherwise the
+	 * +ul_one and -ul_one below would replace with inc/dec instructions.
+	 */
+	volatile unsigned int ui_one = 1;
+	long l = 0;
+	unsigned long ul = 0;
+
+	pr_info("percpu test start\n");
+
+	preempt_disable();
+
+	l += -1;
+	__this_cpu_add(long_counter, -1);
+	CHECK(l, long_counter, -1);
+
+	l += 1;
+	__this_cpu_add(long_counter, 1);
+	CHECK(l, long_counter, 0);
+
+	ul = 0;
+	__this_cpu_write(ulong_counter, 0);
+
+	ul += 1UL;
+	__this_cpu_add(ulong_counter, 1UL);
+	CHECK(ul, ulong_counter, 1);
+
+	ul += -1UL;
+	__this_cpu_add(ulong_counter, -1UL);
+	CHECK(ul, ulong_counter, 0);
+
+	ul += -(unsigned long)1;
+	__this_cpu_add(ulong_counter, -(unsigned long)1);
+	CHECK(ul, ulong_counter, -1);
+
+	ul = 0;
+	__this_cpu_write(ulong_counter, 0);
+
+	ul -= 1;
+	__this_cpu_dec(ulong_counter);
+	CHECK(ul, ulong_counter, 0xffffffffffffffff);
+	CHECK(ul, ulong_counter, -1);
+
+	l += -ui_one;
+	__this_cpu_add(long_counter, -ui_one);
+	CHECK(l, long_counter, 0xffffffff);
+
+	l += ui_one;
+	__this_cpu_add(long_counter, ui_one);
+	CHECK(l, long_counter, 0x100000000);
+
+
+	l = 0;
+	__this_cpu_write(long_counter, 0);
+
+	l -= ui_one;
+	__this_cpu_sub(long_counter, ui_one);
+	CHECK(l, long_counter, -1);
+
+	l = 0;
+	__this_cpu_write(long_counter, 0);
+
+	l += ui_one;
+	__this_cpu_add(long_counter, ui_one);
+	CHECK(l, long_counter, 1);
+
+	l += -ui_one;
+	__this_cpu_add(long_counter, -ui_one);
+	CHECK(l, long_counter, 0x100000000);
+
+	l = 0;
+	__this_cpu_write(long_counter, 0);
+
+	l -= ui_one;
+	this_cpu_sub(long_counter, ui_one);
+	CHECK(l, long_counter, -1);
+	CHECK(l, long_counter, 0xffffffffffffffff);
+
+	ul = 0;
+	__this_cpu_write(ulong_counter, 0);
+
+	ul += ui_one;
+	__this_cpu_add(ulong_counter, ui_one);
+	CHECK(ul, ulong_counter, 1);
+
+	ul = 0;
+	__this_cpu_write(ulong_counter, 0);
+
+	ul -= ui_one;
+	__this_cpu_sub(ulong_counter, ui_one);
+	CHECK(ul, ulong_counter, -1);
+	CHECK(ul, ulong_counter, 0xffffffffffffffff);
+
+	ul = 3;
+	__this_cpu_write(ulong_counter, 3);
+
+	ul = this_cpu_sub_return(ulong_counter, ui_one);
+	CHECK(ul, ulong_counter, 2);
+
+	ul = __this_cpu_sub_return(ulong_counter, ui_one);
+	CHECK(ul, ulong_counter, 0);
+
+	preempt_enable();
+
+	pr_info("percpu test done\n");
+	return -EAGAIN;  /* Fail will directly unload the module */
+}
+
+static void __exit percpu_test_exit(void)
+{
+}
+
+module_init(percpu_test_init)
+module_exit(percpu_test_exit)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Greg Thelen");
+MODULE_DESCRIPTION("percpu variables test");
-- 
1.8.4.1

