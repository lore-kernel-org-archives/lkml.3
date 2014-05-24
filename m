Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaEXHEK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 03:04:10 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:54333 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaEXHCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 03:02:25 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 07/24] ARM64:ILP32: Use the same size and layout of the signal structures for ILP32 as for LP64.
Date: Sat, 24 May 2014 00:02:02 -0700
Message-Id: <1400914939-9708-8-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1400914939-9708-1-git-send-email-apinski@cavium.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Defines the macros which allow the signal structures to be the same between ILP32 and LP64.

Thanks,
Andrew Pinski

Signed-off-by: Andrew Pinski <apinski@cavium.com>

---
 arch/arm64/include/uapi/asm/siginfo.h |   21 +++++++++++++++++++++
 arch/arm64/include/uapi/asm/signal.h  |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/siginfo.h b/arch/arm64/include/uapi/asm/siginfo.h
index 5a74a08..1a6aa32 100644
--- a/arch/arm64/include/uapi/asm/siginfo.h
+++ b/arch/arm64/include/uapi/asm/siginfo.h
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2012 ARM Ltd.
+ * Copyright (C) 2014 Cavium Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -18,6 +19,26 @@
 
 #define __ARCH_SI_PREAMBLE_SIZE	(4 * sizeof(int))
 
+#ifdef __ILP32__
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
+# undef __SIGINFO_VOIDPOINTER
+# define __SIGINFO_VOIDPOINTER(field)		\
+		__SIGINFO_INNER(void __user*, field)
+# undef __SIGINFO_BAND
+
+# define __SIGINFO_BAND(field)			\
+	__SIGINFO_INNER(long, field)
+#endif
+
 #include <asm-generic/siginfo.h>
 
 #endif
diff --git a/arch/arm64/include/uapi/asm/signal.h b/arch/arm64/include/uapi/asm/signal.h
index 8d1e723..d90d53b 100644
--- a/arch/arm64/include/uapi/asm/signal.h
+++ b/arch/arm64/include/uapi/asm/signal.h
@@ -19,6 +19,38 @@
 /* Required for AArch32 compatibility. */
 #define SA_RESTORER	0x04000000
 
+/* For ILP32, sigset should be the same size fields as LP64 so use
+   unsigned long long. */
+#ifdef __ILP32__
+#define __SIGSET_INNER_TYPE __extension__ unsigned long long
+#define _NSIG_BPW 64
+
+# ifdef __AARCH64EB__
+#  define __SIGNAL_INNER(type, field)		\
+	__extension__ struct {			\
+		int __pad_##field;		\
+		type field;			\
+	} __attribute__((aligned(8)))
+# else
+#  define __SIGNAL_INNER(type, field)		\
+	__extension__ struct {			\
+		type field;			\
+		int __pad_##field;		\
+	} __attribute__((aligned(8)))
+# endif
+
+# define __SIGACTION_HANDLER(field)		\
+	__SIGNAL_INNER(__sighandler_t, field)
+
+
+#define __SIGACTION_FLAGS(field)		\
+	__extension__ unsigned long long field
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

