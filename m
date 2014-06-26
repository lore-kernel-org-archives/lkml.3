Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaFZV6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 17:58:30 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:26290 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751912AbaFZV63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 17:58:29 -0400
To: bp@alien8.de, m.chehab@samsung.com
Cc: tony.luck@intel.com, hpa@zytor.com, mingo@kernel.org,
        dougthompson@xmission.com, mitake@dcl.info.waseda.ac.jp,
        aris@redhat.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <281f09da7ad01e5cea99737ec34d2399bdbbbf63.1403818526.git.jbaron@akamai.com>
In-Reply-To: <cover.1403818526.git.jbaron@akamai.com>
References: <cover.1403818526.git.jbaron@akamai.com>
From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH v2 1/3] readq/writeq: Add explicit lo_hi_[read|write]_q and hi_lo_[read|write]_q
Date: Thu, 26 Jun 2014 21:58:28 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even on x86-64, I've found the need to break up a readq() into 2 readl()
calls. According to the Intel datasheet for the E3-1200 processor:

"
Software must not access B0/D0/F0 32-bit memory-mapped registers with
requests that cross a DW boundary.
"

(http://www.intel.com/content/www/us/en/processors/xeon/xeon-e3-1200-family-vol-2-datasheet.html p. 16)

I can confirm this is true via several hard machine lockups.

Thus, add explicit hi_lo_[readq|write]_q and lo_hi_[read|write]_q so that these
uses are spelled out.

Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 include/asm-generic/io-64-nonatomic-hi-lo.h | 14 +++++++++-----
 include/asm-generic/io-64-nonatomic-lo-hi.h | 14 +++++++++-----
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/asm-generic/io-64-nonatomic-hi-lo.h b/include/asm-generic/io-64-nonatomic-hi-lo.h
index a6806a9..2e29d13 100644
--- a/include/asm-generic/io-64-nonatomic-hi-lo.h
+++ b/include/asm-generic/io-64-nonatomic-hi-lo.h
@@ -4,8 +4,7 @@
 #include <linux/io.h>
 #include <asm-generic/int-ll64.h>
 
-#ifndef readq
-static inline __u64 readq(const volatile void __iomem *addr)
+static inline __u64 hi_lo_readq(const volatile void __iomem *addr)
 {
 	const volatile u32 __iomem *p = addr;
 	u32 low, high;
@@ -15,14 +14,19 @@ static inline __u64 readq(const volatile void __iomem *addr)
 
 	return low + ((u64)high << 32);
 }
-#endif
 
-#ifndef writeq
-static inline void writeq(__u64 val, volatile void __iomem *addr)
+static inline void hi_lo_writeq(__u64 val, volatile void __iomem *addr)
 {
 	writel(val >> 32, addr + 4);
 	writel(val, addr);
 }
+
+#ifndef readq
+#define readq hi_lo_readq
+#endif
+
+#ifndef writeq
+#define writeq hi_lo_writeq
 #endif
 
 #endif	/* _ASM_IO_64_NONATOMIC_HI_LO_H_ */
diff --git a/include/asm-generic/io-64-nonatomic-lo-hi.h b/include/asm-generic/io-64-nonatomic-lo-hi.h
index ca546b1..0efacff 100644
--- a/include/asm-generic/io-64-nonatomic-lo-hi.h
+++ b/include/asm-generic/io-64-nonatomic-lo-hi.h
@@ -4,8 +4,7 @@
 #include <linux/io.h>
 #include <asm-generic/int-ll64.h>
 
-#ifndef readq
-static inline __u64 readq(const volatile void __iomem *addr)
+static inline __u64 lo_hi_readq(const volatile void __iomem *addr)
 {
 	const volatile u32 __iomem *p = addr;
 	u32 low, high;
@@ -15,14 +14,19 @@ static inline __u64 readq(const volatile void __iomem *addr)
 
 	return low + ((u64)high << 32);
 }
-#endif
 
-#ifndef writeq
-static inline void writeq(__u64 val, volatile void __iomem *addr)
+static inline void lo_hi_writeq(__u64 val, volatile void __iomem *addr)
 {
 	writel(val, addr);
 	writel(val >> 32, addr + 4);
 }
+
+#ifndef readq
+#define readq lo_hi_readq
+#endif
+
+#ifndef writeq
+#define writeq lo_hi_writeq
 #endif
 
 #endif	/* _ASM_IO_64_NONATOMIC_LO_HI_H_ */
-- 
1.8.2.rc2

