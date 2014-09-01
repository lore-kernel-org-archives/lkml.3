Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbaIAPoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:44:37 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:35975 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbaIAPof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:44:35 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 5/8] staging: rtl8188eu: Rename HalPwrSeqCmd.c to pwrseqcmd.c
Date: Mon,  1 Sep 2014 21:13:40 +0530
Message-Id: <1409586223-5915-5-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409586223-5915-1-git-send-email-navin.patidar@gmail.com>
References: <1409586223-5915-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/Makefile           |    2 +-
 drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c |  123 --------------------------
 drivers/staging/rtl8188eu/hal/pwrseqcmd.c    |  123 ++++++++++++++++++++++++++
 3 files changed, 124 insertions(+), 124 deletions(-)
 delete mode 100644 drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c
 create mode 100644 drivers/staging/rtl8188eu/hal/pwrseqcmd.c

diff --git a/drivers/staging/rtl8188eu/Makefile b/drivers/staging/rtl8188eu/Makefile
index a309451..8723794 100644
--- a/drivers/staging/rtl8188eu/Makefile
+++ b/drivers/staging/rtl8188eu/Makefile
@@ -22,7 +22,7 @@ r8188eu-y :=				\
 		hal/bb_cfg.o \
 		hal/rf_cfg.o \
 		hal/HalPhyRf_8188e.o	\
-		hal/HalPwrSeqCmd.o	\
+		hal/pwrseqcmd.o \
 		hal/pwrseq.o \
 		hal/Hal8188ERateAdaptive.o\
 		hal/hal_intf.o		\
diff --git a/drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c b/drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c
deleted file mode 100644
index 2565d6e..0000000
--- a/drivers/staging/rtl8188eu/hal/HalPwrSeqCmd.c
+++ /dev/null
@@ -1,123 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- ******************************************************************************/
-
-#include <HalPwrSeqCmd.h>
-#include <usb_ops_linux.h>
-
-/* This routine deals with the Power Configuration CMDs parsing
- * for RTL8723/RTL8188E Series IC.
- */
-u8 rtl88eu_pwrseqcmdparsing(struct adapter *padapter, u8 cut_vers, u8 fab_vers,
-			    u8 ifacetype, struct wl_pwr_cfg pwrseqcmd[])
-{
-	struct wl_pwr_cfg pwrcfgcmd = {0};
-	u8 poll_bit = false;
-	u32 aryidx = 0;
-	u8 value = 0;
-	u32 offset = 0;
-	u32 poll_count = 0; /*  polling autoload done. */
-	u32 max_poll_count = 5000;
-
-	do {
-		pwrcfgcmd = pwrseqcmd[aryidx];
-
-		RT_TRACE(_module_hal_init_c_ , _drv_info_,
-			 ("rtl88eu_pwrseqcmdparsing: offset(%#x) cut_msk(%#x)"
-			  "fab_msk(%#x) interface_msk(%#x) base(%#x) cmd(%#x)"
-			  "msk(%#x) value(%#x)\n",
-			 GET_PWR_CFG_OFFSET(pwrcfgcmd),
-			 GET_PWR_CFG_CUT_MASK(pwrcfgcmd),
-			 GET_PWR_CFG_FAB_MASK(pwrcfgcmd),
-			 GET_PWR_CFG_INTF_MASK(pwrcfgcmd),
-			 GET_PWR_CFG_BASE(pwrcfgcmd),
-			 GET_PWR_CFG_CMD(pwrcfgcmd),
-			 GET_PWR_CFG_MASK(pwrcfgcmd),
-			 GET_PWR_CFG_VALUE(pwrcfgcmd)));
-
-		/* Only Handle the command whose FAB, CUT, and Interface are matched */
-		if ((GET_PWR_CFG_FAB_MASK(pwrcfgcmd) & fab_vers) &&
-		    (GET_PWR_CFG_CUT_MASK(pwrcfgcmd) & cut_vers) &&
-		    (GET_PWR_CFG_INTF_MASK(pwrcfgcmd) & ifacetype)) {
-			switch (GET_PWR_CFG_CMD(pwrcfgcmd)) {
-			case PWR_CMD_READ:
-				RT_TRACE(_module_hal_init_c_, _drv_info_,
-					 ("rtl88eu_pwrseqcmdparsing: PWR_CMD_READ\n"));
-				break;
-			case PWR_CMD_WRITE:
-				RT_TRACE(_module_hal_init_c_, _drv_info_,
-					 ("rtl88eu_pwrseqcmdparsing: PWR_CMD_WRITE\n"));
-				offset = GET_PWR_CFG_OFFSET(pwrcfgcmd);
-
-				/*  Read the value from system register */
-				value = usb_read8(padapter, offset);
-
-				value &= ~(GET_PWR_CFG_MASK(pwrcfgcmd));
-				value |= (GET_PWR_CFG_VALUE(pwrcfgcmd) &
-					  GET_PWR_CFG_MASK(pwrcfgcmd));
-
-				/*  Write the value back to system register */
-				usb_write8(padapter, offset, value);
-				break;
-			case PWR_CMD_POLLING:
-				RT_TRACE(_module_hal_init_c_, _drv_info_,
-					 ("rtl88eu_pwrseqcmdparsing: PWR_CMD_POLLING\n"));
-
-				poll_bit = false;
-				offset = GET_PWR_CFG_OFFSET(pwrcfgcmd);
-				do {
-					value = usb_read8(padapter, offset);
-					value &= GET_PWR_CFG_MASK(pwrcfgcmd);
-
-					if (value == (GET_PWR_CFG_VALUE(pwrcfgcmd) &
-						      GET_PWR_CFG_MASK(pwrcfgcmd)))
-						poll_bit = true;
-					else
-						udelay(10);
-
-					if (poll_count++ > max_poll_count) {
-						DBG_88E("Fail to polling Offset[%#x]\n", offset);
-						return false;
-					}
-				} while (!poll_bit);
-				break;
-			case PWR_CMD_DELAY:
-				RT_TRACE(_module_hal_init_c_, _drv_info_,
-					 ("rtl88eu_pwrseqcmdparsing: PWR_CMD_DELAY\n"));
-				if (GET_PWR_CFG_VALUE(pwrcfgcmd) == PWRSEQ_DELAY_US)
-					udelay(GET_PWR_CFG_OFFSET(pwrcfgcmd));
-				else
-					udelay(GET_PWR_CFG_OFFSET(pwrcfgcmd)*1000);
-				break;
-			case PWR_CMD_END:
-				/* When this command is parsed, end the process */
-				RT_TRACE(_module_hal_init_c_, _drv_info_,
-					 ("rtl88eu_pwrseqcmdparsing: PWR_CMD_END\n"));
-				return true;
-				break;
-			default:
-				RT_TRACE(_module_hal_init_c_, _drv_err_,
-					 ("rtl88eu_pwrseqcmdparsing: Unknown CMD!!\n"));
-				break;
-			}
-		}
-
-		aryidx++;/* Add Array Index */
-	} while (1);
-	return true;
-}
diff --git a/drivers/staging/rtl8188eu/hal/pwrseqcmd.c b/drivers/staging/rtl8188eu/hal/pwrseqcmd.c
new file mode 100644
index 0000000..2565d6e
--- /dev/null
+++ b/drivers/staging/rtl8188eu/hal/pwrseqcmd.c
@@ -0,0 +1,123 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ ******************************************************************************/
+
+#include <HalPwrSeqCmd.h>
+#include <usb_ops_linux.h>
+
+/* This routine deals with the Power Configuration CMDs parsing
+ * for RTL8723/RTL8188E Series IC.
+ */
+u8 rtl88eu_pwrseqcmdparsing(struct adapter *padapter, u8 cut_vers, u8 fab_vers,
+			    u8 ifacetype, struct wl_pwr_cfg pwrseqcmd[])
+{
+	struct wl_pwr_cfg pwrcfgcmd = {0};
+	u8 poll_bit = false;
+	u32 aryidx = 0;
+	u8 value = 0;
+	u32 offset = 0;
+	u32 poll_count = 0; /*  polling autoload done. */
+	u32 max_poll_count = 5000;
+
+	do {
+		pwrcfgcmd = pwrseqcmd[aryidx];
+
+		RT_TRACE(_module_hal_init_c_ , _drv_info_,
+			 ("rtl88eu_pwrseqcmdparsing: offset(%#x) cut_msk(%#x)"
+			  "fab_msk(%#x) interface_msk(%#x) base(%#x) cmd(%#x)"
+			  "msk(%#x) value(%#x)\n",
+			 GET_PWR_CFG_OFFSET(pwrcfgcmd),
+			 GET_PWR_CFG_CUT_MASK(pwrcfgcmd),
+			 GET_PWR_CFG_FAB_MASK(pwrcfgcmd),
+			 GET_PWR_CFG_INTF_MASK(pwrcfgcmd),
+			 GET_PWR_CFG_BASE(pwrcfgcmd),
+			 GET_PWR_CFG_CMD(pwrcfgcmd),
+			 GET_PWR_CFG_MASK(pwrcfgcmd),
+			 GET_PWR_CFG_VALUE(pwrcfgcmd)));
+
+		/* Only Handle the command whose FAB, CUT, and Interface are matched */
+		if ((GET_PWR_CFG_FAB_MASK(pwrcfgcmd) & fab_vers) &&
+		    (GET_PWR_CFG_CUT_MASK(pwrcfgcmd) & cut_vers) &&
+		    (GET_PWR_CFG_INTF_MASK(pwrcfgcmd) & ifacetype)) {
+			switch (GET_PWR_CFG_CMD(pwrcfgcmd)) {
+			case PWR_CMD_READ:
+				RT_TRACE(_module_hal_init_c_, _drv_info_,
+					 ("rtl88eu_pwrseqcmdparsing: PWR_CMD_READ\n"));
+				break;
+			case PWR_CMD_WRITE:
+				RT_TRACE(_module_hal_init_c_, _drv_info_,
+					 ("rtl88eu_pwrseqcmdparsing: PWR_CMD_WRITE\n"));
+				offset = GET_PWR_CFG_OFFSET(pwrcfgcmd);
+
+				/*  Read the value from system register */
+				value = usb_read8(padapter, offset);
+
+				value &= ~(GET_PWR_CFG_MASK(pwrcfgcmd));
+				value |= (GET_PWR_CFG_VALUE(pwrcfgcmd) &
+					  GET_PWR_CFG_MASK(pwrcfgcmd));
+
+				/*  Write the value back to system register */
+				usb_write8(padapter, offset, value);
+				break;
+			case PWR_CMD_POLLING:
+				RT_TRACE(_module_hal_init_c_, _drv_info_,
+					 ("rtl88eu_pwrseqcmdparsing: PWR_CMD_POLLING\n"));
+
+				poll_bit = false;
+				offset = GET_PWR_CFG_OFFSET(pwrcfgcmd);
+				do {
+					value = usb_read8(padapter, offset);
+					value &= GET_PWR_CFG_MASK(pwrcfgcmd);
+
+					if (value == (GET_PWR_CFG_VALUE(pwrcfgcmd) &
+						      GET_PWR_CFG_MASK(pwrcfgcmd)))
+						poll_bit = true;
+					else
+						udelay(10);
+
+					if (poll_count++ > max_poll_count) {
+						DBG_88E("Fail to polling Offset[%#x]\n", offset);
+						return false;
+					}
+				} while (!poll_bit);
+				break;
+			case PWR_CMD_DELAY:
+				RT_TRACE(_module_hal_init_c_, _drv_info_,
+					 ("rtl88eu_pwrseqcmdparsing: PWR_CMD_DELAY\n"));
+				if (GET_PWR_CFG_VALUE(pwrcfgcmd) == PWRSEQ_DELAY_US)
+					udelay(GET_PWR_CFG_OFFSET(pwrcfgcmd));
+				else
+					udelay(GET_PWR_CFG_OFFSET(pwrcfgcmd)*1000);
+				break;
+			case PWR_CMD_END:
+				/* When this command is parsed, end the process */
+				RT_TRACE(_module_hal_init_c_, _drv_info_,
+					 ("rtl88eu_pwrseqcmdparsing: PWR_CMD_END\n"));
+				return true;
+				break;
+			default:
+				RT_TRACE(_module_hal_init_c_, _drv_err_,
+					 ("rtl88eu_pwrseqcmdparsing: Unknown CMD!!\n"));
+				break;
+			}
+		}
+
+		aryidx++;/* Add Array Index */
+	} while (1);
+	return true;
+}
-- 
1.7.10.4

