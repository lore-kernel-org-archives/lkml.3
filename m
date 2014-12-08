Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbaLHOFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 09:05:25 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:54653 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbaLHOEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 09:04:34 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <masami.hiramatsu.pt@hitachi.com>, <tixy@linaro.org>,
        <linux@arm.linux.org.uk>
CC: <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v15 1/7] ARM: probes: move all probe code to dedicate directory
Date: Mon, 8 Dec 2014 22:00:32 +0800
Message-ID: <1418047238-52624-2-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1418047238-52624-1-git-send-email-wangnan0@huawei.com>
References: <1418047238-52624-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In discussion on LKML (https://lkml.org/lkml/2014/11/28/158), Russell
King suggests to move all probe related code to arch/arm/probes. This
patch does the work. Due to dependency on 'arch/arm/kernel/patch.h', this
patch also moves patch.h to 'arch/arm/include/asm/patch.h', and related
'#include' directives are also midified to '#include <asm/patch.h>'.

Following is an overview of this patch:

 ./arch/arm/kernel/               ./arch/arm/probes/
 |-- Makefile                     |-- Makefile
 |-- probes-arm.c          ==>    |-- decode-arm.c
 |-- probes-arm.h          ==>    |-- decode-arm.h
 |-- probes-thumb.c        ==>    |-- decode-thumb.c
 |-- probes-thumb.h        ==>    |-- decode-thumb.h
 |-- probes.c              ==>    |-- decode.c
 |-- probes.h              ==>    |-- decode.h
 |                                |-- kprobes
 |                                |   |-- Makefile
 |-- kprobes-arm.c         ==>    |   |-- actions-arm.c
 |-- kprobes-common.c      ==>    |   |-- actions-common.c
 |-- kprobes-thumb.c       ==>    |   |-- actions-thumb.c
 |-- kprobes.c             ==>    |   |-- core.c
 |-- kprobes.h             ==>    |   |-- core.h
 |-- kprobes-test-arm.c    ==>    |   |-- test-arm.c
 |-- kprobes-test.c        ==>    |   |-- test-core.c
 |-- kprobes-test.h        ==>    |   |-- test-core.h
 |-- kprobes-test-thumb.c  ==>    |   `-- test-thumb.c
 |                                `-- uprobes
 |                                    |-- Makefile
 |-- uprobes-arm.c         ==>        |-- actions-arm.c
 |-- uprobes.c             ==>        |-- core.c
 |-- uprobes.h             ==>        `-- core.h
 |
 `-- patch.h               ==>    arch/arm/include/asm/patch.h

Signed-off-by: Wang Nan <wangnan0@huawei.com>

v1 -> v2:
 - Rename source files to describe their functions.
 - Add Makefiles in kprobes and uprobes directories.
---
 arch/arm/Makefile                                        |  1 +
 arch/arm/{kernel => include/asm}/patch.h                 |  0
 arch/arm/kernel/Makefile                                 | 16 ++--------------
 arch/arm/kernel/jump_label.c                             |  2 +-
 arch/arm/kernel/patch.c                                  |  3 +--
 arch/arm/probes/Makefile                                 |  7 +++++++
 arch/arm/{kernel/probes-arm.c => probes/decode-arm.c}    |  7 ++++---
 arch/arm/{kernel/probes-arm.h => probes/decode-arm.h}    |  4 +++-
 .../arm/{kernel/probes-thumb.c => probes/decode-thumb.c} |  6 +++---
 .../arm/{kernel/probes-thumb.h => probes/decode-thumb.h} |  4 +++-
 arch/arm/{kernel/probes.c => probes/decode.c}            |  4 ++--
 arch/arm/{kernel/probes.h => probes/decode.h}            |  2 +-
 arch/arm/probes/kprobes/Makefile                         | 11 +++++++++++
 .../kprobes-arm.c => probes/kprobes/actions-arm.c}       |  6 +++---
 .../kprobes-common.c => probes/kprobes/actions-common.c} |  4 ++--
 .../kprobes-thumb.c => probes/kprobes/actions-thumb.c}   |  6 +++---
 arch/arm/{kernel/kprobes.c => probes/kprobes/core.c}     |  8 ++++----
 arch/arm/{kernel/kprobes.h => probes/kprobes/core.h}     |  3 ++-
 .../kprobes-test-arm.c => probes/kprobes/test-arm.c}     |  2 +-
 .../kprobes-test.c => probes/kprobes/test-core.c}        |  8 ++++----
 .../kprobes-test.h => probes/kprobes/test-core.h}        |  2 +-
 .../kprobes-test-thumb.c => probes/kprobes/test-thumb.c} |  4 ++--
 arch/arm/probes/uprobes/Makefile                         |  2 ++
 .../uprobes-arm.c => probes/uprobes/actions-arm.c}       |  6 +++---
 arch/arm/{kernel/uprobes.c => probes/uprobes/core.c}     |  6 +++---
 arch/arm/{kernel/uprobes.h => probes/uprobes/core.h}     |  0
 26 files changed, 69 insertions(+), 55 deletions(-)
 rename arch/arm/{kernel => include/asm}/patch.h (100%)
 create mode 100644 arch/arm/probes/Makefile
 rename arch/arm/{kernel/probes-arm.c => probes/decode-arm.c} (99%)
 rename arch/arm/{kernel/probes-arm.h => probes/decode-arm.h} (97%)
 rename arch/arm/{kernel/probes-thumb.c => probes/decode-thumb.c} (99%)
 rename arch/arm/{kernel/probes-thumb.h => probes/decode-thumb.h} (97%)
 rename arch/arm/{kernel/probes.c => probes/decode.c} (99%)
 rename arch/arm/{kernel/probes.h => probes/decode.h} (99%)
 create mode 100644 arch/arm/probes/kprobes/Makefile
 rename arch/arm/{kernel/kprobes-arm.c => probes/kprobes/actions-arm.c} (99%)
 rename arch/arm/{kernel/kprobes-common.c => probes/kprobes/actions-common.c} (98%)
 rename arch/arm/{kernel/kprobes-thumb.c => probes/kprobes/actions-thumb.c} (99%)
 rename arch/arm/{kernel/kprobes.c => probes/kprobes/core.c} (99%)
 rename arch/arm/{kernel/kprobes.h => probes/kprobes/core.h} (96%)
 rename arch/arm/{kernel/kprobes-test-arm.c => probes/kprobes/test-arm.c} (99%)
 rename arch/arm/{kernel/kprobes-test.c => probes/kprobes/test-core.c} (99%)
 rename arch/arm/{kernel/kprobes-test.h => probes/kprobes/test-core.h} (99%)
 rename arch/arm/{kernel/kprobes-test-thumb.c => probes/kprobes/test-thumb.c} (99%)
 create mode 100644 arch/arm/probes/uprobes/Makefile
 rename arch/arm/{kernel/uprobes-arm.c => probes/uprobes/actions-arm.c} (98%)
 rename arch/arm/{kernel/uprobes.c => probes/uprobes/core.c} (98%)
 rename arch/arm/{kernel/uprobes.h => probes/uprobes/core.h} (100%)

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
index 0000000..aa1f859
--- /dev/null
+++ b/arch/arm/probes/Makefile
@@ -0,0 +1,7 @@
+obj-$(CONFIG_UPROBES)		+= decode.o decode-arm.o uprobes/
+obj-$(CONFIG_KPROBES)		+= decode.o kprobes/
+ifdef CONFIG_THUMB2_KERNEL
+obj-$(CONFIG_KPROBES)		+= decode-thumb.o
+else
+obj-$(CONFIG_KPROBES)		+= decode-arm.o
+endif
diff --git a/arch/arm/kernel/probes-arm.c b/arch/arm/probes/decode-arm.c
similarity index 99%
rename from arch/arm/kernel/probes-arm.c
rename to arch/arm/probes/decode-arm.c
index 8eaef81..e39cc75 100644
--- a/arch/arm/kernel/probes-arm.c
+++ b/arch/arm/probes/decode-arm.c
@@ -1,5 +1,6 @@
 /*
- * arch/arm/kernel/probes-arm.c
+ *
+ * arch/arm/probes/decode-arm.c
  *
  * Some code moved here from arch/arm/kernel/kprobes-arm.c
  *
@@ -20,8 +21,8 @@
 #include <linux/stddef.h>
 #include <linux/ptrace.h>
 
-#include "probes.h"
-#include "probes-arm.h"
+#include "decode.h"
+#include "decode-arm.h"
 
 #define sign_extend(x, signbit) ((x) | (0 - ((x) & (1 << (signbit)))))
 
diff --git a/arch/arm/kernel/probes-arm.h b/arch/arm/probes/decode-arm.h
similarity index 97%
rename from arch/arm/kernel/probes-arm.h
rename to arch/arm/probes/decode-arm.h
index ace6572..9c56b40 100644
--- a/arch/arm/kernel/probes-arm.h
+++ b/arch/arm/probes/decode-arm.h
@@ -1,5 +1,5 @@
 /*
- * arch/arm/kernel/probes-arm.h
+ * arch/arm/probes/decode-arm.h
  *
  * Copyright 2013 Linaro Ltd.
  * Written by: David A. Long
@@ -15,6 +15,8 @@
 #ifndef _ARM_KERNEL_PROBES_ARM_H
 #define  _ARM_KERNEL_PROBES_ARM_H
 
+#include "decode.h"
+
 enum probes_arm_action {
 	PROBES_EMULATE_NONE,
 	PROBES_SIMULATE_NOP,
diff --git a/arch/arm/kernel/probes-thumb.c b/arch/arm/probes/decode-thumb.c
similarity index 99%
rename from arch/arm/kernel/probes-thumb.c
rename to arch/arm/probes/decode-thumb.c
index 4131351..2f0453a 100644
--- a/arch/arm/kernel/probes-thumb.c
+++ b/arch/arm/probes/decode-thumb.c
@@ -1,5 +1,5 @@
 /*
- * arch/arm/kernel/probes-thumb.c
+ * arch/arm/probes/decode-thumb.c
  *
  * Copyright (C) 2011 Jon Medhurst <tixy@yxit.co.uk>.
  *
@@ -12,8 +12,8 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-#include "probes.h"
-#include "probes-thumb.h"
+#include "decode.h"
+#include "decode-thumb.h"
 
 
 static const union decode_item t32_table_1110_100x_x0xx[] = {
diff --git a/arch/arm/kernel/probes-thumb.h b/arch/arm/probes/decode-thumb.h
similarity index 97%
rename from arch/arm/kernel/probes-thumb.h
rename to arch/arm/probes/decode-thumb.h
index 7c6f6eb..039013c 100644
--- a/arch/arm/kernel/probes-thumb.h
+++ b/arch/arm/probes/decode-thumb.h
@@ -1,5 +1,5 @@
 /*
- * arch/arm/kernel/probes-thumb.h
+ * arch/arm/probes/decode-thumb.h
  *
  * Copyright 2013 Linaro Ltd.
  * Written by: David A. Long
@@ -15,6 +15,8 @@
 #ifndef _ARM_KERNEL_PROBES_THUMB_H
 #define  _ARM_KERNEL_PROBES_THUMB_H
 
+#include "decode.h"
+
 /*
  * True if current instruction is in an IT block.
  */
diff --git a/arch/arm/kernel/probes.c b/arch/arm/probes/decode.c
similarity index 99%
rename from arch/arm/kernel/probes.c
rename to arch/arm/probes/decode.c
index a8ab540..3b05d57 100644
--- a/arch/arm/kernel/probes.c
+++ b/arch/arm/probes/decode.c
@@ -1,5 +1,5 @@
 /*
- * arch/arm/kernel/probes.c
+ * arch/arm/probes/decode.c
  *
  * Copyright (C) 2011 Jon Medhurst <tixy@yxit.co.uk>.
  *
@@ -17,7 +17,7 @@
 #include <asm/ptrace.h>
 #include <linux/bug.h>
 
-#include "probes.h"
+#include "decode.h"
 
 
 #ifndef find_str_pc_offset
diff --git a/arch/arm/kernel/probes.h b/arch/arm/probes/decode.h
similarity index 99%
rename from arch/arm/kernel/probes.h
rename to arch/arm/probes/decode.h
index dba9f24..1d0b531 100644
--- a/arch/arm/kernel/probes.h
+++ b/arch/arm/probes/decode.h
@@ -1,5 +1,5 @@
 /*
- * arch/arm/kernel/probes.h
+ * arch/arm/probes/decode.h
  *
  * Copyright (C) 2011 Jon Medhurst <tixy@yxit.co.uk>.
  *
diff --git a/arch/arm/probes/kprobes/Makefile b/arch/arm/probes/kprobes/Makefile
new file mode 100644
index 0000000..eb38a42
--- /dev/null
+++ b/arch/arm/probes/kprobes/Makefile
@@ -0,0 +1,11 @@
+obj-$(CONFIG_KPROBES)		+= core.o actions-common.o
+obj-$(CONFIG_ARM_KPROBES_TEST)	+= test-kprobes.o
+test-kprobes-objs		:= test-core.o
+
+ifdef CONFIG_THUMB2_KERNEL
+obj-$(CONFIG_KPROBES)		+= actions-thumb.o
+test-kprobes-objs		+= test-thumb.o
+else
+obj-$(CONFIG_KPROBES)		+= actions-arm.o
+test-kprobes-objs		+= test-arm.o
+endif
diff --git a/arch/arm/kernel/kprobes-arm.c b/arch/arm/probes/kprobes/actions-arm.c
similarity index 99%
rename from arch/arm/kernel/kprobes-arm.c
rename to arch/arm/probes/kprobes/actions-arm.c
index ac300c6..8797879 100644
--- a/arch/arm/kernel/kprobes-arm.c
+++ b/arch/arm/probes/kprobes/actions-arm.c
@@ -1,5 +1,5 @@
 /*
- * arch/arm/kernel/kprobes-decode.c
+ * arch/arm/probes/kprobes/actions-arm.c
  *
  * Copyright (C) 2006, 2007 Motorola Inc.
  *
@@ -62,8 +62,8 @@
 #include <linux/kprobes.h>
 #include <linux/ptrace.h>
 
-#include "kprobes.h"
-#include "probes-arm.h"
+#include "../decode-arm.h"
+#include "core.h"
 
 #if  __LINUX_ARM_ARCH__ >= 6
 #define BLX(reg)	"blx	"reg"		\n\t"
diff --git a/arch/arm/kernel/kprobes-common.c b/arch/arm/probes/kprobes/actions-common.c
similarity index 98%
rename from arch/arm/kernel/kprobes-common.c
rename to arch/arm/probes/kprobes/actions-common.c
index 0bf5d64..bd20a71 100644
--- a/arch/arm/kernel/kprobes-common.c
+++ b/arch/arm/probes/kprobes/actions-common.c
@@ -1,5 +1,5 @@
 /*
- * arch/arm/kernel/kprobes-common.c
+ * arch/arm/probes/kprobes/actions-common.c
  *
  * Copyright (C) 2011 Jon Medhurst <tixy@yxit.co.uk>.
  *
@@ -15,7 +15,7 @@
 #include <linux/kprobes.h>
 #include <asm/opcodes.h>
 
-#include "kprobes.h"
+#include "core.h"
 
 
 static void __kprobes simulate_ldm1stm1(probes_opcode_t insn,
diff --git a/arch/arm/kernel/kprobes-thumb.c b/arch/arm/probes/kprobes/actions-thumb.c
similarity index 99%
rename from arch/arm/kernel/kprobes-thumb.c
rename to arch/arm/probes/kprobes/actions-thumb.c
index 9495d7f..6c4e60b 100644
--- a/arch/arm/kernel/kprobes-thumb.c
+++ b/arch/arm/probes/kprobes/actions-thumb.c
@@ -1,5 +1,5 @@
 /*
- * arch/arm/kernel/kprobes-thumb.c
+ * arch/arm/probes/kprobes/actions-thumb.c
  *
  * Copyright (C) 2011 Jon Medhurst <tixy@yxit.co.uk>.
  *
@@ -13,8 +13,8 @@
 #include <linux/ptrace.h>
 #include <linux/kprobes.h>
 
-#include "kprobes.h"
-#include "probes-thumb.h"
+#include "../decode-thumb.h"
+#include "core.h"
 
 /* These emulation encodings are functionally equivalent... */
 #define t32_emulate_rd8rn16rm0ra12_noflags \
diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/probes/kprobes/core.c
similarity index 99%
rename from arch/arm/kernel/kprobes.c
rename to arch/arm/probes/kprobes/core.c
index 6d64420..701f49d 100644
--- a/arch/arm/kernel/kprobes.c
+++ b/arch/arm/probes/kprobes/core.c
@@ -30,11 +30,11 @@
 #include <asm/cacheflush.h>
 #include <linux/percpu.h>
 #include <linux/bug.h>
+#include <asm/patch.h>
 
-#include "kprobes.h"
-#include "probes-arm.h"
-#include "probes-thumb.h"
-#include "patch.h"
+#include "../decode-arm.h"
+#include "../decode-thumb.h"
+#include "core.h"
 
 #define MIN_STACK_SIZE(addr) 				\
 	min((unsigned long)MAX_STACK_SIZE,		\
diff --git a/arch/arm/kernel/kprobes.h b/arch/arm/probes/kprobes/core.h
similarity index 96%
rename from arch/arm/kernel/kprobes.h
rename to arch/arm/probes/kprobes/core.h
index 9a2712e..2e1e5a3 100644
--- a/arch/arm/kernel/kprobes.h
+++ b/arch/arm/probes/kprobes/core.h
@@ -19,7 +19,8 @@
 #ifndef _ARM_KERNEL_KPROBES_H
 #define _ARM_KERNEL_KPROBES_H
 
-#include "probes.h"
+#include <asm/kprobes.h>
+#include "../decode.h"
 
 /*
  * These undefined instructions must be unique and
diff --git a/arch/arm/kernel/kprobes-test-arm.c b/arch/arm/probes/kprobes/test-arm.c
similarity index 99%
rename from arch/arm/kernel/kprobes-test-arm.c
rename to arch/arm/probes/kprobes/test-arm.c
index cb14242..d9a1255 100644
--- a/arch/arm/kernel/kprobes-test-arm.c
+++ b/arch/arm/probes/kprobes/test-arm.c
@@ -13,7 +13,7 @@
 #include <asm/system_info.h>
 #include <asm/opcodes.h>
 
-#include "kprobes-test.h"
+#include "test-core.h"
 
 
 #define TEST_ISA "32"
diff --git a/arch/arm/kernel/kprobes-test.c b/arch/arm/probes/kprobes/test-core.c
similarity index 99%
rename from arch/arm/kernel/kprobes-test.c
rename to arch/arm/probes/kprobes/test-core.c
index b206d77..7ab633d 100644
--- a/arch/arm/kernel/kprobes-test.c
+++ b/arch/arm/probes/kprobes/test-core.c
@@ -209,10 +209,10 @@
 #include <linux/bug.h>
 #include <asm/opcodes.h>
 
-#include "kprobes.h"
-#include "probes-arm.h"
-#include "probes-thumb.h"
-#include "kprobes-test.h"
+#include "core.h"
+#include "test-core.h"
+#include "../decode-arm.h"
+#include "../decode-thumb.h"
 
 
 #define BENCHMARKING	1
diff --git a/arch/arm/kernel/kprobes-test.h b/arch/arm/probes/kprobes/test-core.h
similarity index 99%
rename from arch/arm/kernel/kprobes-test.h
rename to arch/arm/probes/kprobes/test-core.h
index 4430990..9991754 100644
--- a/arch/arm/kernel/kprobes-test.h
+++ b/arch/arm/probes/kprobes/test-core.h
@@ -1,5 +1,5 @@
 /*
- * arch/arm/kernel/kprobes-test.h
+ * arch/arm/probes/kprobes/test-core.h
  *
  * Copyright (C) 2011 Jon Medhurst <tixy@yxit.co.uk>.
  *
diff --git a/arch/arm/kernel/kprobes-test-thumb.c b/arch/arm/probes/kprobes/test-thumb.c
similarity index 99%
rename from arch/arm/kernel/kprobes-test-thumb.c
rename to arch/arm/probes/kprobes/test-thumb.c
index 844dd10..6c6e9a9 100644
--- a/arch/arm/kernel/kprobes-test-thumb.c
+++ b/arch/arm/probes/kprobes/test-thumb.c
@@ -1,5 +1,5 @@
 /*
- * arch/arm/kernel/kprobes-test-thumb.c
+ * arch/arm/probes/kprobes/test-thumb.c
  *
  * Copyright (C) 2011 Jon Medhurst <tixy@yxit.co.uk>.
  *
@@ -12,7 +12,7 @@
 #include <linux/module.h>
 #include <asm/opcodes.h>
 
-#include "kprobes-test.h"
+#include "test-core.h"
 
 
 #define TEST_ISA "16"
diff --git a/arch/arm/probes/uprobes/Makefile b/arch/arm/probes/uprobes/Makefile
new file mode 100644
index 0000000..6c4c735
--- /dev/null
+++ b/arch/arm/probes/uprobes/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_UPROBES)		+= core.o actions-arm.o
+
diff --git a/arch/arm/kernel/uprobes-arm.c b/arch/arm/probes/uprobes/actions-arm.c
similarity index 98%
rename from arch/arm/kernel/uprobes-arm.c
rename to arch/arm/probes/uprobes/actions-arm.c
index d3b655f..1dd4916 100644
--- a/arch/arm/kernel/uprobes-arm.c
+++ b/arch/arm/probes/uprobes/actions-arm.c
@@ -13,9 +13,9 @@
 #include <linux/uprobes.h>
 #include <linux/module.h>
 
-#include "probes.h"
-#include "probes-arm.h"
-#include "uprobes.h"
+#include "../decode.h"
+#include "../decode-arm.h"
+#include "core.h"
 
 static int uprobes_substitute_pc(unsigned long *pinsn, u32 oregs)
 {
diff --git a/arch/arm/kernel/uprobes.c b/arch/arm/probes/uprobes/core.c
similarity index 98%
rename from arch/arm/kernel/uprobes.c
rename to arch/arm/probes/uprobes/core.c
index 56adf9c..b2954f6 100644
--- a/arch/arm/kernel/uprobes.c
+++ b/arch/arm/probes/uprobes/core.c
@@ -17,9 +17,9 @@
 #include <asm/opcodes.h>
 #include <asm/traps.h>
 
-#include "probes.h"
-#include "probes-arm.h"
-#include "uprobes.h"
+#include "../decode.h"
+#include "../decode-arm.h"
+#include "core.h"
 
 #define UPROBE_TRAP_NR	UINT_MAX
 
diff --git a/arch/arm/kernel/uprobes.h b/arch/arm/probes/uprobes/core.h
similarity index 100%
rename from arch/arm/kernel/uprobes.h
rename to arch/arm/probes/uprobes/core.h
-- 
1.8.4

