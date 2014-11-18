Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465AbaKRQxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:53:25 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54382 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425AbaKRQxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:53:22 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-36-546b7980c9b2
Subject: [PATCH RFC 2/3] ARM: enable TTBR0/TTBR1 split in short mode
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 18 Nov 2014 19:53:19 +0400
Message-id: <20141118165319.9958.67009.stgit@buzz>
In-reply-to: <20141118165313.9958.1242.stgit@buzz>
References: <20141118165313.9958.1242.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFLMWRmVeSWpSXmKPExsVy+t/xy7oNldkhBh1HeSx+7Oxltdj0+Bqr
	xeVdc9gsbl/mdWDxaGnuYfPYvKTeo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDJWrbjGWnCF
	s2L1tgUsDYydHF2MnBwSAiYSu5veM0PYYhIX7q1n62Lk4hASWMoo8fjnBBYIp5FJYvWpeWBV
	wgIuEn/PPGYEsdkEzCS27bsNZosI5Et8PbCHDcRmEVCV+POxiR3E5hUwkjgzt58JxOYEsm8c
	7gOLCwkYSiy5/AHMFhWQk1h5uYUVol5Q4sfke0CLOTiYBdQlpkzJBQkzC8hLbF7zlnkCI/8s
	JFWzEKpmIalawMi8ilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMkPL/uYFx6zOoQowAHoxIP
	b8PGrBAh1sSy4srcQ4wSHMxKIrznuoFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGNOds5NOLC43
	6PRf16T77mVd/MffpnXca2xYbm246ZTieXdXXNGTvUEXLspNOdOw8+kW3sNpRyMXvhfq6HqU
	31Bbvq5XqVwmpcag3PSXecy7Pe8Of7qW/sdm+YfETnWL2kk36ljv8C0re6vIVKox44WLUB7v
	uwvvbzse+5u+Vi1biuHB3XkLJZRYijMSDbWYi4oTAYDLkeQtAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This feature was partially implemented long time ago. All cpus load
swapper_pg_dir into TTBR1 since commit d427958a46af24f75d0017c45eadd172273bbf33
("ARM: 6942/1: mm: make TTBR1 always point to swapper_pg_dir on ARMv6/7").
But TTBRx split is never been enabled in TTBCR.

This patch enables TTBRx split for 2Gb/2Gb and 1Gb/3Gb combinations.
Area covered by TTBR0 must be power of two, thus 3Gb/1Gb mode is unsupported.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
---
 arch/arm/include/asm/pgtable-2level-hwdef.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/include/asm/pgtable-2level-hwdef.h b/arch/arm/include/asm/pgtable-2level-hwdef.h
index c2ed1fa..605652c 100644
--- a/arch/arm/include/asm/pgtable-2level-hwdef.h
+++ b/arch/arm/include/asm/pgtable-2level-hwdef.h
@@ -90,6 +90,19 @@
 
 #define PHYS_MASK		(~0UL)
 
+/*
+ * TTBR0/TTBR1 split (PAGE_OFFSET):
+ *   0x40000000: TTBCR.N = 2
+ *   0x80000000: TTBCR.N = 1
+ *   0xc0000000: TTBCR.N = 0 (not used)
+ */
+
+#ifdef CONFIG_VMSPLIT_1G
+#define TTBR1_SIZE	2
+#elif defined CONFIG_VMSPLIT_2G
+#define TTBR1_SIZE	1
+#elif defined CONFIG_VMSPLIT_3G
 #define TTBR1_SIZE	0
+#endif
 
 #endif

