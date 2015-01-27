Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958AbbA0VRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:17:23 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:40579 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759483AbbA0VRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:17:20 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Ralf Baechle <ralf@linux-mips.org>, <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 1/3] MIPS: Add arch CDMM definitions and probing
Date: Tue, 27 Jan 2015 21:16:39 +0000
Message-ID: <1422393401-13543-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <1422393401-13543-1-git-send-email-james.hogan@imgtec.com>
References: <1422393401-13543-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.110]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add architectural definitions and probing for the MIPS Common Device
Mapped Memory (CDMM) region. When supported and enabled at a particular
physical address, this region allows some number of per-CPU devices to
be discovered and controlled via MMIO.

A bit exists in Config3 to determine whether the feature is present, and
a CDMMBase CP0 register allows the region to be enabled at a particular
physical address.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/include/asm/cpu-features.h |  4 ++++
 arch/mips/include/asm/cpu.h          |  1 +
 arch/mips/include/asm/mipsregs.h     | 11 +++++++++++
 arch/mips/kernel/cpu-probe.c         |  2 ++
 4 files changed, 18 insertions(+)

diff --git a/arch/mips/include/asm/cpu-features.h b/arch/mips/include/asm/cpu-features.h
index 2897cfafcaf0..83e9db058a72 100644
--- a/arch/mips/include/asm/cpu-features.h
+++ b/arch/mips/include/asm/cpu-features.h
@@ -348,4 +348,8 @@
 # define cpu_has_fre		(cpu_data[0].options & MIPS_CPU_FRE)
 #endif
 
+#ifndef cpu_has_cdmm
+# define cpu_has_cdmm		(cpu_data[0].options & MIPS_CPU_CDMM)
+#endif
+
 #endif /* __ASM_CPU_FEATURES_H */
diff --git a/arch/mips/include/asm/cpu.h b/arch/mips/include/asm/cpu.h
index 33866fce4d63..2086372fa72a 100644
--- a/arch/mips/include/asm/cpu.h
+++ b/arch/mips/include/asm/cpu.h
@@ -370,6 +370,7 @@ enum cpu_type_enum {
 #define MIPS_CPU_RIXIEX		0x200000000ull /* CPU has unique exception codes for {Read, Execute}-Inhibit exceptions */
 #define MIPS_CPU_MAAR		0x400000000ull /* MAAR(I) registers are present */
 #define MIPS_CPU_FRE		0x800000000ull /* FRE & UFE bits implemented */
+#define MIPS_CPU_CDMM		0x10000000000ll /* CPU has Common Device Memory Map */
 
 /*
  * CPU ASE encodings
diff --git a/arch/mips/include/asm/mipsregs.h b/arch/mips/include/asm/mipsregs.h
index 5e4aef304b02..2969ceaecfd3 100644
--- a/arch/mips/include/asm/mipsregs.h
+++ b/arch/mips/include/asm/mipsregs.h
@@ -750,6 +750,14 @@
 #define MIPS_PWCTL_PSN_SHIFT	0
 #define MIPS_PWCTL_PSN_MASK	0x0000003f
 
+/* CDMMBase register bit definitions */
+#define MIPS_CDMMBASE_SIZE_SHIFT 0
+#define MIPS_CDMMBASE_SIZE	(_ULCAST_(511) << MIPS_CDMMBASE_SIZE_SHIFT)
+#define MIPS_CDMMBASE_CI	(_ULCAST_(1) << 9)
+#define MIPS_CDMMBASE_EN	(_ULCAST_(1) << 10)
+#define MIPS_CDMMBASE_ADDR_SHIFT 11
+#define MIPS_CDMMBASE_ADDR_START 15
+
 #ifndef __ASSEMBLY__
 
 /*
@@ -1279,6 +1287,9 @@ do {									\
 #define read_c0_ebase()		__read_32bit_c0_register($15, 1)
 #define write_c0_ebase(val)	__write_32bit_c0_register($15, 1, val)
 
+#define read_c0_cdmmbase()	__read_ulong_c0_register($15, 2)
+#define write_c0_cdmmbase(val)	__write_ulong_c0_register($15, 2, val)
+
 /* MIPSR3 */
 #define read_c0_segctl0()	__read_32bit_c0_register($5, 2)
 #define write_c0_segctl0(val)	__write_32bit_c0_register($5, 2, val)
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 5342674842f5..2eabcc023ed4 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -426,6 +426,8 @@ static inline unsigned int decode_config3(struct cpuinfo_mips *c)
 	/* Only tested on 32-bit cores */
 	if ((config3 & MIPS_CONF3_PW) && config_enabled(CONFIG_32BIT))
 		c->options |= MIPS_CPU_HTW;
+	if (config3 & MIPS_CONF3_CDMM)
+		c->options |= MIPS_CPU_CDMM;
 
 	return config3 & MIPS_CONF_M;
 }
-- 
2.0.5

