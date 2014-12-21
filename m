Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaLUUyw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 15:54:52 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:35155 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbaLUUyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 15:54:21 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>, linux-crypto@vger.kernel.org,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH 2/5] MIPS: OCTEON: crypto: add instruction definitions for MD5
Date: Sun, 21 Dec 2014 22:53:59 +0200
Message-Id: <1419195242-546-3-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 2.2.0
In-Reply-To: <1419195242-546-1-git-send-email-aaro.koskinen@iki.fi>
References: <1419195242-546-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add instruction definitions for MD5. Based on information extracted
from EdgeRouter Pro GPL source tarball.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 arch/mips/cavium-octeon/crypto/octeon-crypto.h | 56 ++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/arch/mips/cavium-octeon/crypto/octeon-crypto.h b/arch/mips/cavium-octeon/crypto/octeon-crypto.h
index 5ca86d4..3f65bc6 100644
--- a/arch/mips/cavium-octeon/crypto/octeon-crypto.h
+++ b/arch/mips/cavium-octeon/crypto/octeon-crypto.h
@@ -4,14 +4,70 @@
  * for more details.
  *
  * Copyright (C) 2012-2013 Cavium Inc., All Rights Reserved.
+ *
+ * MD5 instruction definitions added by Aaro Koskinen <aaro.koskinen@iki.fi>.
+ *
  */
 #ifndef __LINUX_OCTEON_CRYPTO_H
 #define __LINUX_OCTEON_CRYPTO_H
 
 #include <linux/sched.h>
+#include <asm/mipsregs.h>
 
 extern unsigned long octeon_crypto_enable(struct octeon_cop2_state *state);
 extern void octeon_crypto_disable(struct octeon_cop2_state *state,
 				  unsigned long flags);
 
+/*
+ * Macros needed to implement MD5:
+ */
+
+/*
+ * The index can be 0-1.
+ */
+#define write_octeon_64bit_hash_dword(value, index)	\
+do {							\
+	__asm__ __volatile__ (				\
+	"dmtc2 %[rt],0x0048+" STR(index)		\
+	:						\
+	: [rt] "d" (value));				\
+} while (0)
+
+/*
+ * The index can be 0-1.
+ */
+#define read_octeon_64bit_hash_dword(index)		\
+({							\
+	u64 __value;					\
+							\
+	__asm__ __volatile__ (				\
+	"dmfc2 %[rt],0x0048+" STR(index)		\
+	: [rt] "=d" (__value)				\
+	: );						\
+							\
+	__value;					\
+})
+
+/*
+ * The index can be 0-6.
+ */
+#define write_octeon_64bit_block_dword(value, index)	\
+do {							\
+	__asm__ __volatile__ (				\
+	"dmtc2 %[rt],0x0040+" STR(index)		\
+	:						\
+	: [rt] "d" (value));				\
+} while (0)
+
+/*
+ * The value is the final block dword (64-bit).
+ */
+#define octeon_md5_start(value)				\
+do {							\
+	__asm__ __volatile__ (				\
+	"dmtc2 %[rt],0x4047"				\
+	:						\
+	: [rt] "d" (value));				\
+} while (0)
+
 #endif /* __LINUX_OCTEON_CRYPTO_H */
-- 
2.2.0

