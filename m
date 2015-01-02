Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbbABRpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 12:45:09 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:46155 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbbABRoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 12:44:25 -0500
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Santosh <ssantosh@kernel.org>,
        Sekhar Nori <nsekhar@ti.com>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 1/2] ARM: l2c: OMAP4/AM437x: Introduce support for cache latency programming
Date: Fri, 2 Jan 2015 11:43:47 -0600
Message-ID: <1420220628-23742-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1420220628-23742-1-git-send-email-nm@ti.com>
References: <1420220628-23742-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP4 and AM437x generations of processors support programming the
PL310 L2Cache controller's Latency control registers using a secure
montior call. Unfortunately, this varies from other PL310 programming
sequence with a requirement of two parameters instead of the generic
single parameter configuration.

Information based on:
OMAP4430 Public ROM Code API Functional Specfication revision 0.6 (Oct
27, 2010)
OMAP4440 Public ROM Code API Functional Specfication revision 0.1 (Oct
27, 2010)
Aegis ROM Code Memory and Peripheral Booting Functional Specification
version 1.00 (Jan 21, 2014)

Signed-off-by: Nishanth Menon <nm@ti.com>
---
Changed in V2: document data update for Aegis rom code doc

V1: https://patchwork.kernel.org/patch/5560131/

 arch/arm/mach-omap2/common.h       |    1 +
 arch/arm/mach-omap2/omap-secure.h  |    1 +
 arch/arm/mach-omap2/omap-smc.S     |   20 ++++++++++++++++++++
 arch/arm/mach-omap2/omap4-common.c |   15 +++++++++++++++
 4 files changed, 37 insertions(+)

diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index 19c9144..d5f8a9c 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -240,6 +240,7 @@ extern void gic_dist_enable(void);
 extern bool gic_dist_disabled(void);
 extern void gic_timer_retrigger(void);
 extern void omap_smc1(u32 fn, u32 arg);
+extern void omap_smc1_2(u32 fn, u32 arg1, u32 arg2);
 extern void __iomem *omap4_get_sar_ram_base(void);
 extern void omap_do_wfi(void);
 
diff --git a/arch/arm/mach-omap2/omap-secure.h b/arch/arm/mach-omap2/omap-secure.h
index dec2b05..338fdab 100644
--- a/arch/arm/mach-omap2/omap-secure.h
+++ b/arch/arm/mach-omap2/omap-secure.h
@@ -42,6 +42,7 @@
 #define OMAP4_MON_L2X0_DBG_CTRL_INDEX	0x100
 #define OMAP4_MON_L2X0_CTRL_INDEX	0x102
 #define OMAP4_MON_L2X0_AUXCTRL_INDEX	0x109
+#define OMAP4_MON_L2X0_SETLATENCY_INDEX	0x112
 #define OMAP4_MON_L2X0_PREFETCH_INDEX	0x113
 
 #define OMAP5_DRA7_MON_SET_CNTFRQ_INDEX	0x109
diff --git a/arch/arm/mach-omap2/omap-smc.S b/arch/arm/mach-omap2/omap-smc.S
index fd90125..caf2bd1 100644
--- a/arch/arm/mach-omap2/omap-smc.S
+++ b/arch/arm/mach-omap2/omap-smc.S
@@ -33,6 +33,26 @@ ENTRY(omap_smc1)
 	ldmfd   sp!, {r2-r12, pc}
 ENDPROC(omap_smc1)
 
+/*
+ * This is common routine to manage secure monitor API
+ * used to modify the PL310 secure registers.
+ * 'r0' and 'r1' contains the value to be modified and 'r12' contains
+ * the monitor API number. It uses few CPU registers
+ * internally and hence they need be backed up including
+ * link register "lr".
+ * Function signature : void omap_smc1_2(u32 fn, u32 arg1, u32 arg2)
+ */
+
+ENTRY(omap_smc1_2)
+	stmfd   sp!, {r2-r12, lr}
+	mov	r12, r0
+	mov 	r0, r1
+	mov 	r1, r2
+	dsb
+	smc	#0
+	ldmfd   sp!, {r2-r12, pc}
+ENDPROC(omap_smc1_2)
+
 /**
  * u32 omap_smc2(u32 id, u32 falg, u32 pargs)
  * Low level common routine for secure HAL and PPA APIs.
diff --git a/arch/arm/mach-omap2/omap4-common.c b/arch/arm/mach-omap2/omap4-common.c
index fe99cef..25a0b2f 100644
--- a/arch/arm/mach-omap2/omap4-common.c
+++ b/arch/arm/mach-omap2/omap4-common.c
@@ -191,6 +191,21 @@ void omap4_l2c310_write_sec(unsigned long val, unsigned reg)
 		pr_info_once("OMAP L2C310: ROM does not support power control setting\n");
 		return;
 
+	case L310_TAG_LATENCY_CTRL:
+	case L310_DATA_LATENCY_CTRL:
+	{
+		void __iomem *base = omap4_get_l2cache_base();
+		u32 data_latency, tag_latency;
+
+		tag_latency = (reg == L310_TAG_LATENCY_CTRL) ? val :
+			       readl_relaxed(base + L310_TAG_LATENCY_CTRL);
+		data_latency = (reg == L310_DATA_LATENCY_CTRL) ? val :
+			       readl_relaxed(base + L310_DATA_LATENCY_CTRL);
+		omap_smc1_2(OMAP4_MON_L2X0_SETLATENCY_INDEX, tag_latency,
+			    data_latency);
+		return;
+	}
+
 	default:
 		WARN_ONCE(1, "OMAP L2C310: ignoring write to reg 0x%x\n", reg);
 		return;
-- 
1.7.9.5

