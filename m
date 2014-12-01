Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaLAIvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 03:51:52 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:6807 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbaLAIvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 03:51:51 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <tixy@linaro.org>, <masami.hiramatsu.pt@hitachi.com>,
        <linux@arm.linux.org.uk>
CC: <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v11 1/7] ARM: probes: move all probe code to dedicate directory
Date: Mon, 1 Dec 2014 16:48:15 +0800
Message-ID: <1417423695-47521-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1417423513-47161-1-git-send-email-wangnan0@huawei.com>
References: <1417423513-47161-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In discussion on LKML (https://lkml.org/lkml/2014/11/28/158), Russell
King suggest to move all probe related code to arch/arm/probes. This
patch do the work. Due to dependency on 'arch/arm/kernel/patch.h', this
patch also move patch.h to 'arch/arm/include/asm/patch.h', and related
'#include' directive are also midified to '#include <asm/patch.h>'.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 arch/arm/Makefile                                |  1 +
 arch/arm/{kernel => include/asm}/patch.h         |  0
 arch/arm/kernel/Makefile                         | 16 ++--------------
 arch/arm/kernel/jump_label.c                     |  2 +-
 arch/arm/kernel/patch.c                          |  3 +--
 arch/arm/probes/Makefile                         | 15 +++++++++++++++
 arch/arm/{kernel => probes}/kprobes-arm.c        |  0
 arch/arm/{kernel => probes}/kprobes-common.c     |  0
 arch/arm/{kernel => probes}/kprobes-test-arm.c   |  0
 arch/arm/{kernel => probes}/kprobes-test-thumb.c |  0
 arch/arm/{kernel => probes}/kprobes-test.c       |  0
 arch/arm/{kernel => probes}/kprobes-test.h       |  0
 arch/arm/{kernel => probes}/kprobes-thumb.c      |  0
 arch/arm/{kernel => probes}/kprobes.c            |  2 +-
 arch/arm/{kernel => probes}/kprobes.h            |  0
 arch/arm/{kernel => probes}/probes-arm.c         |  0
 arch/arm/{kernel => probes}/probes-arm.h         |  0
 arch/arm/{kernel => probes}/probes-thumb.c       |  0
 arch/arm/{kernel => probes}/probes-thumb.h       |  0
 arch/arm/{kernel => probes}/probes.c             |  0
 arch/arm/{kernel => probes}/probes.h             |  0
 arch/arm/{kernel => probes}/uprobes-arm.c        |  0
 arch/arm/{kernel => probes}/uprobes.c            |  0
 arch/arm/{kernel => probes}/uprobes.h            |  0
 24 files changed, 21 insertions(+), 18 deletions(-)
 rename arch/arm/{kernel => include/asm}/patch.h (100%)
 create mode 100644 arch/arm/probes/Makefile
 rename arch/arm/{kernel => probes}/kprobes-arm.c (100%)
 rename arch/arm/{kernel => probes}/kprobes-common.c (100%)
 rename arch/arm/{kernel => probes}/kprobes-test-arm.c (100%)
 rename arch/arm/{kernel => probes}/kprobes-test-thumb.c (100%)
 rename arch/arm/{kernel => probes}/kprobes-test.c (100%)
 rename arch/arm/{kernel => probes}/kprobes-test.h (100%)
 rename arch/arm/{kernel => probes}/kprobes-thumb.c (100%)
 rename arch/arm/{kernel => probes}/kprobes.c (99%)
 rename arch/arm/{kernel => probes}/kprobes.h (100%)
 rename arch/arm/{kernel => probes}/probes-arm.c (100%)
 rename arch/arm/{kernel => probes}/probes-arm.h (100%)
 rename arch/arm/{kernel => probes}/probes-thumb.c (100%)
 rename arch/arm/{kernel => probes}/probes-thumb.h (100%)
 rename arch/arm/{kernel => probes}/probes.c (100%)
 rename arch/arm/{kernel => probes}/probes.h (100%)
 rename arch/arm/{kernel => probes}/uprobes-arm.c (100%)
 rename arch/arm/{kernel => probes}/uprobes.c (100%)
 rename arch/arm/{kernel => probes}/uprobes.h (100%)

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 034a949..a57d9bb 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -266,6 +266,7 @@ core-$(CONFIG_KVM_ARM_HOST) 	+= arch/arm/kvm/
 
 # If we have a machine-specific directory, then include it in the build.
 core-y				+= arch/arm/kernel/ arch/arm/mm/ arch/arm/common/
+core-y				+= arch/arm/probes/
 core-y				+= arch/arm/net/
 core-y				+= arch/arm/crypto/
 core-y				+= arch/arm/firmware/
diff --git a/arch/arm/kernel/patch.h b/arch/arm/include/asm/patch.h
similarity index 100%
rename from arch/arm/kernel/patch.h
rename to arch/arm/include/asm/patch.h
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 38ddd9f..40d3e00 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -51,20 +51,8 @@ obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o insn.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o insn.o
 obj-$(CONFIG_JUMP_LABEL)	+= jump_label.o insn.o patch.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
-obj-$(CONFIG_UPROBES)		+= probes.o probes-arm.o uprobes.o uprobes-arm.o
-obj-$(CONFIG_KPROBES)		+= probes.o kprobes.o kprobes-common.o patch.o
-ifdef CONFIG_THUMB2_KERNEL
-obj-$(CONFIG_KPROBES)		+= kprobes-thumb.o probes-thumb.o
-else
-obj-$(CONFIG_KPROBES)		+= kprobes-arm.o probes-arm.o
-endif
-obj-$(CONFIG_ARM_KPROBES_TEST)	+= test-kprobes.o
-test-kprobes-objs		:= kprobes-test.o
-ifdef CONFIG_THUMB2_KERNEL
-test-kprobes-objs		+= kprobes-test-thumb.o
-else
-test-kprobes-objs		+= kprobes-test-arm.o
-endif
+# Main staffs in KPROBES are in arch/arm/probes/ .
+obj-$(CONFIG_KPROBES)		+= patch.o
 obj-$(CONFIG_OABI_COMPAT)	+= sys_oabi-compat.o
 obj-$(CONFIG_ARM_THUMBEE)	+= thumbee.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
diff --git a/arch/arm/kernel/jump_label.c b/arch/arm/kernel/jump_label.c
index 4ce4f78..c6c73ed 100644
--- a/arch/arm/kernel/jump_label.c
+++ b/arch/arm/kernel/jump_label.c
@@ -1,8 +1,8 @@
 #include <linux/kernel.h>
 #include <linux/jump_label.h>
+#include <asm/patch.h>
 
 #include "insn.h"
-#include "patch.h"
 
 #ifdef HAVE_JUMP_LABEL
 
diff --git a/arch/arm/kernel/patch.c b/arch/arm/kernel/patch.c
index 07314af..08bcfa1 100644
--- a/arch/arm/kernel/patch.c
+++ b/arch/arm/kernel/patch.c
@@ -5,8 +5,7 @@
 #include <asm/cacheflush.h>
 #include <asm/smp_plat.h>
 #include <asm/opcodes.h>
-
-#include "patch.h"
+#include <asm/patch.h>
 
 struct patch {
 	void *addr;
diff --git a/arch/arm/probes/Makefile b/arch/arm/probes/Makefile
new file mode 100644
index 0000000..34b53b0
--- /dev/null
+++ b/arch/arm/probes/Makefile
@@ -0,0 +1,15 @@
+obj-$(CONFIG_UPROBES)		+= probes.o probes-arm.o uprobes.o uprobes-arm.o
+obj-$(CONFIG_KPROBES)		+= probes.o kprobes.o kprobes-common.o
+ifdef CONFIG_THUMB2_KERNEL
+obj-$(CONFIG_KPROBES)		+= kprobes-thumb.o probes-thumb.o
+else
+obj-$(CONFIG_KPROBES)		+= kprobes-arm.o probes-arm.o
+endif
+obj-$(CONFIG_ARM_KPROBES_TEST)	+= test-kprobes.o
+test-kprobes-objs		:= kprobes-test.o
+ifdef CONFIG_THUMB2_KERNEL
+test-kprobes-objs		+= kprobes-test-thumb.o
+else
+test-kprobes-objs		+= kprobes-test-arm.o
+endif
+
diff --git a/arch/arm/kernel/kprobes-arm.c b/arch/arm/probes/kprobes-arm.c
similarity index 100%
rename from arch/arm/kernel/kprobes-arm.c
rename to arch/arm/probes/kprobes-arm.c
diff --git a/arch/arm/kernel/kprobes-common.c b/arch/arm/probes/kprobes-common.c
similarity index 100%
rename from arch/arm/kernel/kprobes-common.c
rename to arch/arm/probes/kprobes-common.c
diff --git a/arch/arm/kernel/kprobes-test-arm.c b/arch/arm/probes/kprobes-test-arm.c
similarity index 100%
rename from arch/arm/kernel/kprobes-test-arm.c
rename to arch/arm/probes/kprobes-test-arm.c
diff --git a/arch/arm/kernel/kprobes-test-thumb.c b/arch/arm/probes/kprobes-test-thumb.c
similarity index 100%
rename from arch/arm/kernel/kprobes-test-thumb.c
rename to arch/arm/probes/kprobes-test-thumb.c
diff --git a/arch/arm/kernel/kprobes-test.c b/arch/arm/probes/kprobes-test.c
similarity index 100%
rename from arch/arm/kernel/kprobes-test.c
rename to arch/arm/probes/kprobes-test.c
diff --git a/arch/arm/kernel/kprobes-test.h b/arch/arm/probes/kprobes-test.h
similarity index 100%
rename from arch/arm/kernel/kprobes-test.h
rename to arch/arm/probes/kprobes-test.h
diff --git a/arch/arm/kernel/kprobes-thumb.c b/arch/arm/probes/kprobes-thumb.c
similarity index 100%
rename from arch/arm/kernel/kprobes-thumb.c
rename to arch/arm/probes/kprobes-thumb.c
diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/probes/kprobes.c
similarity index 99%
rename from arch/arm/kernel/kprobes.c
rename to arch/arm/probes/kprobes.c
index 6d64420..43b2488 100644
--- a/arch/arm/kernel/kprobes.c
+++ b/arch/arm/probes/kprobes.c
@@ -30,11 +30,11 @@
 #include <asm/cacheflush.h>
 #include <linux/percpu.h>
 #include <linux/bug.h>
+#include <asm/patch.h>
 
 #include "kprobes.h"
 #include "probes-arm.h"
 #include "probes-thumb.h"
-#include "patch.h"
 
 #define MIN_STACK_SIZE(addr) 				\
 	min((unsigned long)MAX_STACK_SIZE,		\
diff --git a/arch/arm/kernel/kprobes.h b/arch/arm/probes/kprobes.h
similarity index 100%
rename from arch/arm/kernel/kprobes.h
rename to arch/arm/probes/kprobes.h
diff --git a/arch/arm/kernel/probes-arm.c b/arch/arm/probes/probes-arm.c
similarity index 100%
rename from arch/arm/kernel/probes-arm.c
rename to arch/arm/probes/probes-arm.c
diff --git a/arch/arm/kernel/probes-arm.h b/arch/arm/probes/probes-arm.h
similarity index 100%
rename from arch/arm/kernel/probes-arm.h
rename to arch/arm/probes/probes-arm.h
diff --git a/arch/arm/kernel/probes-thumb.c b/arch/arm/probes/probes-thumb.c
similarity index 100%
rename from arch/arm/kernel/probes-thumb.c
rename to arch/arm/probes/probes-thumb.c
diff --git a/arch/arm/kernel/probes-thumb.h b/arch/arm/probes/probes-thumb.h
similarity index 100%
rename from arch/arm/kernel/probes-thumb.h
rename to arch/arm/probes/probes-thumb.h
diff --git a/arch/arm/kernel/probes.c b/arch/arm/probes/probes.c
similarity index 100%
rename from arch/arm/kernel/probes.c
rename to arch/arm/probes/probes.c
diff --git a/arch/arm/kernel/probes.h b/arch/arm/probes/probes.h
similarity index 100%
rename from arch/arm/kernel/probes.h
rename to arch/arm/probes/probes.h
diff --git a/arch/arm/kernel/uprobes-arm.c b/arch/arm/probes/uprobes-arm.c
similarity index 100%
rename from arch/arm/kernel/uprobes-arm.c
rename to arch/arm/probes/uprobes-arm.c
diff --git a/arch/arm/kernel/uprobes.c b/arch/arm/probes/uprobes.c
similarity index 100%
rename from arch/arm/kernel/uprobes.c
rename to arch/arm/probes/uprobes.c
diff --git a/arch/arm/kernel/uprobes.h b/arch/arm/probes/uprobes.h
similarity index 100%
rename from arch/arm/kernel/uprobes.h
rename to arch/arm/probes/uprobes.h
-- 
1.8.4

