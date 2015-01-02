Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbbABRo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 12:44:29 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39026 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbbABRo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 12:44:27 -0500
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Santosh <ssantosh@kernel.org>,
        Sekhar Nori <nsekhar@ti.com>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 2/2] ARM: l2c: AM437x: Introduce support for cache filter programming
Date: Fri, 2 Jan 2015 11:43:48 -0600
Message-ID: <1420220628-23742-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1420220628-23742-1-git-send-email-nm@ti.com>
References: <1420220628-23742-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AM437x generation of processors support programming the PL310 L2Cache
controller's address filter start and end registers using a secure
montior service.

Unfortunately, this secure monitor service is not supported on OMAP4
generation of processors.

Information based on:
OMAP4430 Public ROM Code API Functional Specfication revision 0.6 (Oct
27, 2010)
OMAP4440 Public ROM Code API Functional Specfication revision 0.1 (Oct
27, 2010)
Aegis ROM Code Memory and Peripheral Booting Functional Specification
version 1.00 (Jan 21, 2014)

Signed-off-by: Nishanth Menon <nm@ti.com>
---

Changes in V2:
	- smc call should use filter start in r0 and filter end in r1.
	- Document version update.

V1: https://patchwork.kernel.org/patch/5560111/
 arch/arm/mach-omap2/omap-secure.h  |    1 +
 arch/arm/mach-omap2/omap4-common.c |   21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/arm/mach-omap2/omap-secure.h b/arch/arm/mach-omap2/omap-secure.h
index 338fdab..569e167 100644
--- a/arch/arm/mach-omap2/omap-secure.h
+++ b/arch/arm/mach-omap2/omap-secure.h
@@ -44,6 +44,7 @@
 #define OMAP4_MON_L2X0_AUXCTRL_INDEX	0x109
 #define OMAP4_MON_L2X0_SETLATENCY_INDEX	0x112
 #define OMAP4_MON_L2X0_PREFETCH_INDEX	0x113
+#define AM43X_MON_L2X0_SETFILTER_INDEX	0x114
 
 #define OMAP5_DRA7_MON_SET_CNTFRQ_INDEX	0x109
 #define OMAP5_MON_AMBA_IF_INDEX		0x108
diff --git a/arch/arm/mach-omap2/omap4-common.c b/arch/arm/mach-omap2/omap4-common.c
index 25a0b2f..0b1454d 100644
--- a/arch/arm/mach-omap2/omap4-common.c
+++ b/arch/arm/mach-omap2/omap4-common.c
@@ -206,6 +206,27 @@ void omap4_l2c310_write_sec(unsigned long val, unsigned reg)
 		return;
 	}
 
+	case L310_ADDR_FILTER_START:
+	case L310_ADDR_FILTER_END:
+	{
+		void __iomem *base;
+		u32 filter_start, filter_end;
+
+		if (!soc_is_am437x()) {
+			pr_info_once("OMAP L2C310: ROM does not support filter setting\n");
+			return;
+		}
+
+		base = omap4_get_l2cache_base();
+		filter_start = (reg == L310_ADDR_FILTER_START) ? val :
+			       readl_relaxed(base + L310_ADDR_FILTER_START);
+		filter_end = (reg == L310_ADDR_FILTER_END) ? val :
+			       readl_relaxed(base + L310_ADDR_FILTER_END);
+		omap_smc1_2(AM43X_MON_L2X0_SETFILTER_INDEX, filter_start,
+			    filter_end);
+		return;
+	}
+
 	default:
 		WARN_ONCE(1, "OMAP L2C310: ignoring write to reg 0x%x\n", reg);
 		return;
-- 
1.7.9.5

