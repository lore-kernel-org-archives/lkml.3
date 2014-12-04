Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaLDPyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:54:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667AbaLDPyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:54:17 -0500
From: Seth Jennings <sjenning@redhat.com>
To: Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Petr Mladek <pmladek@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCHv5 3/3] samples: add sample live patching module
Date: Thu,  4 Dec 2014 09:53:31 -0600
Message-Id: <1417708411-23655-4-git-send-email-sjenning@redhat.com>
In-Reply-To: <1417708411-23655-1-git-send-email-sjenning@redhat.com>
References: <1417708411-23655-1-git-send-email-sjenning@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a sample live patching module.

Signed-off-by: Seth Jennings <sjenning@redhat.com>
---
 MAINTAINERS                          |  1 +
 samples/Kconfig                      |  7 +++
 samples/Makefile                     |  2 +-
 samples/livepatch/Makefile           |  1 +
 samples/livepatch/livepatch-sample.c | 87 ++++++++++++++++++++++++++++++++++++
 5 files changed, 97 insertions(+), 1 deletion(-)
 create mode 100644 samples/livepatch/Makefile
 create mode 100644 samples/livepatch/livepatch-sample.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 7985293..9d3f9d9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5726,6 +5726,7 @@ F:	include/linux/livepatch.h
 F:	arch/x86/include/asm/livepatch.h
 F:	arch/x86/kernel/livepatch.c
 F:	Documentation/ABI/testing/sysfs-kernel-livepatch
+F:	samples/livepatch/
 L:	live-patching@vger.kernel.org
 
 LLC (802.2)
diff --git a/samples/Kconfig b/samples/Kconfig
index 6181c2c..0aed20d 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -63,4 +63,11 @@ config SAMPLE_RPMSG_CLIENT
 	  to communicate with an AMP-configured remote processor over
 	  the rpmsg bus.
 
+config SAMPLE_LIVE_PATCHING
+	tristate "Build live patching sample -- loadable modules only"
+	depends on LIVE_PATCHING && m
+	help
+	  Builds a sample live patch that replaces the procfs handler
+	  for /proc/cmdline to print "this has been live patched".
+
 endif # SAMPLES
diff --git a/samples/Makefile b/samples/Makefile
index 1a60c62..f00257b 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -1,4 +1,4 @@
 # Makefile for Linux samples code
 
-obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ trace_events/ \
+obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ trace_events/ livepatch/ \
 			   hw_breakpoint/ kfifo/ kdb/ hidraw/ rpmsg/ seccomp/
diff --git a/samples/livepatch/Makefile b/samples/livepatch/Makefile
new file mode 100644
index 0000000..7f1cdc1
--- /dev/null
+++ b/samples/livepatch/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SAMPLE_LIVE_PATCHING) += livepatch-sample.o
diff --git a/samples/livepatch/livepatch-sample.c b/samples/livepatch/livepatch-sample.c
new file mode 100644
index 0000000..21f159d
--- /dev/null
+++ b/samples/livepatch/livepatch-sample.c
@@ -0,0 +1,87 @@
+/*
+ * livepatch-sample.c - Kernel Live Patching Sample Module
+ *
+ * Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/livepatch.h>
+
+/*
+ * This (dumb) live patch overrides the function that prints the
+ * kernel boot cmdline when /proc/cmdline is read.
+ *
+ * Example:
+ * $ cat /proc/cmdline
+ * <your cmdline>
+ * $ insmod livepatch-sample.ko
+ * $ cat /proc/cmdline
+ * this has been live patched
+ * $ echo 0 > /sys/kernel/livepatch/klp_sample/enabled
+ * <your cmdline>
+ */
+
+#include <linux/seq_file.h>
+static int livepatch_cmdline_proc_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%s\n", "this has been live patched");
+	return 0;
+}
+
+static struct klp_func funcs[] = {
+	{
+		.old_name = "cmdline_proc_show",
+		.new_func = livepatch_cmdline_proc_show,
+	}, { }
+};
+
+static struct klp_object objs[] = {
+	{
+		/* name being NULL means vmlinux */
+		.funcs = funcs,
+	}, { }
+};
+
+static struct klp_patch patch = {
+	.mod = THIS_MODULE,
+	.objs = objs,
+};
+
+static int livepatch_init(void)
+{
+	int ret;
+
+	ret = klp_register_patch(&patch);
+	if (ret)
+		return ret;
+	ret = klp_enable_patch(&patch);
+	if (ret) {
+		WARN_ON(klp_unregister_patch(&patch));
+		return ret;
+	}
+	return 0;
+}
+
+static void livepatch_exit(void)
+{
+	WARN_ON(klp_disable_patch(&patch));
+	WARN_ON(klp_unregister_patch(&patch));
+}
+
+module_init(livepatch_init);
+module_exit(livepatch_exit);
+MODULE_LICENSE("GPL");
-- 
1.9.3

