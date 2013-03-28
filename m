Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab3C1QMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:12:06 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:58386 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab3C1QMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:12:03 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/33] ARM: ux500: Setup external regulator supply #2 for HREF v20 boards
Date: Thu, 28 Mar 2013 16:11:05 +0000
Message-Id: <1364487093-19551-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v20 HREFs require non-standard configuration of EXT_SUPPLY2 to
function correctly (specific information is commented). Here we make
use of the recently added mechanism to adapt initialisation values
for such use-cases.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   28 +++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 2a2751e..c1173a1 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -510,4 +510,32 @@ void mop500_regulator_init(void)
 		regulator->constraints.state_mem.disabled = 1;
 		regulator->constraints.state_standby.disabled = 1;
 	}
+
+	/*
+	 * Handle AB8500_EXT_SUPPLY2 on HREFP_V20_V50 boards (do it for
+	 * all HREFP_V20 boards)
+	 */
+	if (cpu_is_u8500v20()) {
+		/* VextSupply2RequestCtrl =  HP/OFF depending on VxRequest */
+		ab8500_modify_reg_init(AB8500_REGUREQUESTCTRL3, 0x01, 0x01);
+
+		/* VextSupply2SysClkReq1HPValid = SysClkReq1 controlled */
+		ab8500_modify_reg_init(AB8500_REGUSYSCLKREQ1HPVALID2,
+			0x20, 0x20);
+
+		/* VextSupply2 = force HP at initialization */
+		ab8500_modify_reg_init(AB8500_EXTSUPPLYREGU, 0x0c, 0x04);
+
+		/* enable VextSupply2 during platform active */
+		regulator = &ab8500_ext_regulators[AB8500_EXT_SUPPLY2];
+		regulator->constraints.always_on = 1;
+
+		/* disable VextSupply2 in suspend */
+		regulator = &ab8500_ext_regulators[AB8500_EXT_SUPPLY2];
+		regulator->constraints.state_mem.disabled = 1;
+		regulator->constraints.state_standby.disabled = 1;
+
+		/* enable VextSupply2 HW control (used in suspend) */
+		regulator->driver_data = (void *)&ab8500_ext_supply2;
+	}
 }
-- 
1.7.10.4

