Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355AbaICVU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:20:29 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:57865 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbaICVT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:19:29 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pinskia@gmail.com
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 07/24] ARM64:ILP32: Use the same size and layout of the signal structures for ILP32 as for LP64
Date: Wed,  3 Sep 2014 14:19:01 -0700
Message-Id: <1409779158-30963-8-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1409779158-30963-1-git-send-email-apinski@cavium.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Defines the macros which allow the signal structures to be the same between ILP32 and LP64.

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/include/uapi/asm/siginfo.h |   33 ++++++++++++++++++++++++++++++++
 arch/arm64/include/uapi/asm/signal.h  |   34 +++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/siginfo.h b/arch/arm64/include/uapi/asm/siginfo.h
index 5a74a08..c80c612 100644
--- a/arch/arm64/include/uapi/asm/siginfo.h
+++ b/arch/arm64/include/uapi/asm/siginfo.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2012 ARM Ltd.
+ * Copyright (C) 2014 Cavium Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -18,6 +19,38 @@
 
 #define __ARCH_SI_PREAMBLE_SIZE	(4 * sizeof(int))
 
+#ifdef __ILP32__
+
+/*
+ * For ILP32, the siginfo structures should share the same layout and
+ * alignement requirements as LP64 ABI.
+ * To do this, use an extra pad field and add aligned attribute
+ * to the structure.
+ */
+
+# ifdef __AARCH64EB__
+#  define __SIGINFO_INNER(type, field)		\
+		int __pad#field;		\
+		type field
+# else
+#  define __SIGINFO_INNER(type, field)		\
+		type field;			\
+		int __pad#field
+# endif
+
+# undef __SIGINFO_VOIDPTR
+# define __SIGINFO_VOIDPTR(field)		\
+		__SIGINFO_INNER(void __user*, field)
+# undef __SIGINFO_BAND
+
+# define __SIGINFO_BAND(field)			\
+	__SIGINFO_INNER(long, field)
+
+/* Make the alignment of siginfo always 8 byte aligned. */
+#define __ARCH_SI_ATTRIBUTES __attribute__((aligned(8)))
+
+#endif
+
 #include <asm-generic/siginfo.h>
 
 #endif
diff --git a/arch/arm64/include/uapi/asm/signal.h b/arch/arm64/include/uapi/asm/signal.h
index 8d1e723..d33a5f7 100644
--- a/arch/arm64/include/uapi/asm/signal.h
+++ b/arch/arm64/include/uapi/asm/signal.h
@@ -16,9 +16,43 @@
 #ifndef __ASM_SIGNAL_H
 #define __ASM_SIGNAL_H
 
+#include <asm/posix-types.h>
+
 /* Required for AArch32 compatibility. */
 #define SA_RESTORER	0x04000000
 
+/*
+ * Since sigset is a bitmask, we need the same size fields for ILP32
+ * and LP64.  With big-endian, 32bit bitmask does not match up to
+ * 64bit bitmask (unlike with little-endian).
+ */
+#ifdef __ILP32__
+
+#define __SIGSET_INNER_TYPE __kernel_ulong_t
+#define _NSIG_BPW 64
+
+# ifdef __AARCH64EB__
+#  define __SIGNAL_INNER(type, field)		\
+		int __pad_##field;		\
+		type field;
+# else
+#  define __SIGNAL_INNER(type, field)		\
+		type field;			\
+		int __pad_##field;
+# endif
+
+# define __SIGACTION_HANDLER(field)		\
+	__SIGNAL_INNER(__sighandler_t, field)
+
+
+#define __SIGACTION_FLAGS(field)		\
+	__kernel_ulong_t field
+
+#define __SIGACTION_RESTORER(field)		\
+	__SIGNAL_INNER(__sigrestore_t, field)
+
+#endif
+
 #include <asm-generic/signal.h>
 
 #endif
-- 
1.7.2.5

