Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbaIHIgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:36:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:39341 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbaIHIgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:36:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="382877649"
From: "Subhransu S. Prusty" <subhransu.s.prusty@intel.com>
To: hpa@zytor.com
Cc: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, vinod.koul@intel.com,
        "Subhransu S. Prusty" <subhransu.s.prusty@intel.com>
Subject: [PATCH] x86_64: Add memcpy32_toio to write to PCI MMIO
Date: Mon,  8 Sep 2014 13:44:06 +0530
Message-Id: <1410164046-15577-1-git-send-email-subhransu.s.prusty@intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed because the hardware does not support 64-bit moveq
insructions while writing to PCI MMIO.

Signed-off-by: Subhransu S. Prusty <subhransu.s.prusty@intel.com>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 arch/x86/include/asm/io.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index b8237d8..fa095fb 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -218,6 +218,28 @@ memcpy_toio(volatile void __iomem *dst, const void *src, size_t count)
 	memcpy((void __force *)dst, src, count);
 }
 
+#ifndef CONFIG_X86_64
+#define MEMCPY_TOIO memcpy_toio
+#else
+#define MEMCPY_TOIO memcpy32_toio
+#endif
+
+/**
+ * memcpy32_toio: Copy using writel commands
+ *
+ * This is needed because the hardware does not support
+ * 64-bit moveq insructions while writing to PCI MMIO
+ */
+static inline void memcpy32_toio(void *dst, const void *src, int count)
+{
+	int i;
+	const u32 *src_32 = src;
+	u32 *dst_32 = dst;
+
+	for (i = 0; i < count/sizeof(u32); i++)
+		writel(*src_32++, dst_32++);
+}
+
 /*
  * ISA space is 'always mapped' on a typical x86 system, no need to
  * explicitly ioremap() it. The fact that the ISA IO space is mapped
-- 
1.9.0

