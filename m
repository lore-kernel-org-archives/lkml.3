Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965149Ab3GRUID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:08:03 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49723 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759187Ab3GRUHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 16:07:42 -0400
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/3] ARM: msm: Consolidate gpiomux for older architectures
Date: Thu, 18 Jul 2013 13:07:15 -0700
Message-Id: <1374178035-19943-4-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374178035-19943-1-git-send-email-davidb@codeaurora.org>
References: <1374178035-19943-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rohit Vaswani <rvaswani@codeaurora.org>

Msm gpiomux can be used only for 7x30 and 8x50.
Prevent compilation and fix build issues on 7X00, 8X60 and 8960.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig      |  3 +--
 arch/arm/mach-msm/gpiomux-v1.c | 33 ---------------------------------
 arch/arm/mach-msm/gpiomux.h    | 10 ----------
 3 files changed, 1 insertion(+), 45 deletions(-)
 delete mode 100644 arch/arm/mach-msm/gpiomux-v1.c

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 614e41e..905efc8 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -121,8 +121,7 @@ config MSM_SMD
 	bool
 
 config MSM_GPIOMUX
-	depends on !(ARCH_MSM8X60 || ARCH_MSM8960)
-	bool "MSM V1 TLMM GPIOMUX architecture"
+	bool
 	help
 	  Support for MSM V1 TLMM GPIOMUX architecture.
 
diff --git a/arch/arm/mach-msm/gpiomux-v1.c b/arch/arm/mach-msm/gpiomux-v1.c
deleted file mode 100644
index 27de2ab..0000000
--- a/arch/arm/mach-msm/gpiomux-v1.c
+++ /dev/null
@@ -1,33 +0,0 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- */
-#include <linux/kernel.h>
-#include "gpiomux.h"
-#include "proc_comm.h"
-
-void __msm_gpiomux_write(unsigned gpio, gpiomux_config_t val)
-{
-	unsigned tlmm_config  = (val & ~GPIOMUX_CTL_MASK) |
-				((gpio & 0x3ff) << 4);
-	unsigned tlmm_disable = 0;
-	int rc;
-
-	rc = msm_proc_comm(PCOM_RPC_GPIO_TLMM_CONFIG_EX,
-			   &tlmm_config, &tlmm_disable);
-	if (rc)
-		pr_err("%s: unexpected proc_comm failure %d: %08x %08x\n",
-		       __func__, rc, tlmm_config, tlmm_disable);
-}
diff --git a/arch/arm/mach-msm/gpiomux.h b/arch/arm/mach-msm/gpiomux.h
index 8e82f41..4410d77 100644
--- a/arch/arm/mach-msm/gpiomux.h
+++ b/arch/arm/mach-msm/gpiomux.h
@@ -73,16 +73,6 @@ extern struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS];
 int msm_gpiomux_write(unsigned gpio,
 		      gpiomux_config_t active,
 		      gpiomux_config_t suspended);
-
-/* Architecture-internal function for use by the framework only.
- * This function can assume the following:
- * - the gpio value has passed a bounds-check
- * - the gpiomux spinlock has been obtained
- *
- * This function is not for public consumption.  External users
- * should use msm_gpiomux_write.
- */
-void __msm_gpiomux_write(unsigned gpio, gpiomux_config_t val);
 #else
 static inline int msm_gpiomux_write(unsigned gpio,
 				    gpiomux_config_t active,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

