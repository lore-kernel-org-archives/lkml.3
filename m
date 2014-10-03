Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbaJCU12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 16:27:28 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:62955 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaJCU1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 16:27:25 -0400
From: Giedrius Statkevicius <giedrius.statkevicius@gmail.com>
To: gregkh@linuxfoundation.org
Cc: micky_ching@realsil.com.cn, fabio.falzoi84@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] Combine ifs into one where possible to avoid unnecessary indentation level increase
Date: Fri,  3 Oct 2014 23:27:04 +0300
Message-Id: <1412368028-18935-2-git-send-email-giedrius.statkevicius@gmail.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1412368028-18935-1-git-send-email-giedrius.statkevicius@gmail.com>
References: <1412368028-18935-1-git-send-email-giedrius.statkevicius@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Giedrius Statkevičius <giedrius.statkevicius@gmail.com>

Join together chained if's where possible to lower the indentation level.

Signed-off-by: Giedrius Statkevičius <giedrius.statkevicius@gmail.com>
---
 drivers/staging/rts5208/rtsx_chip.c | 100 ++++++++++++++++--------------------
 1 file changed, 44 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/rts5208/rtsx_chip.c b/drivers/staging/rts5208/rtsx_chip.c
index a7ade8b..0db63fb 100644
--- a/drivers/staging/rts5208/rtsx_chip.c
+++ b/drivers/staging/rts5208/rtsx_chip.c
@@ -289,12 +289,10 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 	/* Enable ASPM */
 	if (chip->aspm_l0s_l1_en) {
 		if (chip->dynamic_aspm) {
-			if (CHK_SDIO_EXIST(chip)) {
-				if (CHECK_PID(chip, 0x5288)) {
-					retval = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFF, chip->aspm_l0s_l1_en);
-					if (retval != STATUS_SUCCESS)
-						TRACE_RET(chip, STATUS_FAIL);
-				}
+			if (CHK_SDIO_EXIST(chip) && CHECK_PID(chip, 0x5288)) {
+				retval = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFF, chip->aspm_l0s_l1_en);
+				if (retval != STATUS_SUCCESS)
+					TRACE_RET(chip, STATUS_FAIL);
 			}
 		} else {
 			if (CHECK_PID(chip, 0x5208))
@@ -350,18 +348,14 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 
 	}
 
-	if (CHECK_PID(chip, 0x5288)) {
-		if (!CHK_SDIO_EXIST(chip)) {
-			retval = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFFFF,
-						0x0103);
-			if (retval != STATUS_SUCCESS)
-				TRACE_RET(chip, STATUS_FAIL);
-
-			retval = rtsx_write_cfg_dw(chip, 2, 0x84, 0xFF, 0x03);
-			if (retval != STATUS_SUCCESS)
-				TRACE_RET(chip, STATUS_FAIL);
+	if (CHECK_PID(chip, 0x5288) && !CHK_SDIO_EXIST(chip)) {
+		retval = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFFFF, 0x0103);
+		if (retval != STATUS_SUCCESS)
+			TRACE_RET(chip, STATUS_FAIL);
 
-		}
+		retval = rtsx_write_cfg_dw(chip, 2, 0x84, 0xFF, 0x03);
+		if (retval != STATUS_SUCCESS)
+			TRACE_RET(chip, STATUS_FAIL);
 	}
 
 	RTSX_WRITE_REG(chip, IRQSTAT0, LINK_RDY_INT, LINK_RDY_INT);
@@ -1727,10 +1721,8 @@ int rtsx_pre_handle_interrupt(struct rtsx_chip *chip)
 	chip->ocp_int = ocp_int & status;
 #endif
 
-	if (chip->sd_io) {
-		if (chip->int_reg & DATA_DONE_INT)
-			chip->int_reg &= ~(u32)DATA_DONE_INT;
-	}
+	if (chip->sd_io && (chip->int_reg & DATA_DONE_INT))
+		chip->int_reg &= ~(u32)DATA_DONE_INT;
 
 	return STATUS_SUCCESS;
 }
@@ -1796,31 +1788,29 @@ void rtsx_do_before_power_down(struct rtsx_chip *chip, int pm_stat)
 
 void rtsx_enable_aspm(struct rtsx_chip *chip)
 {
-	if (chip->aspm_l0s_l1_en && chip->dynamic_aspm) {
-		if (!chip->aspm_enabled) {
-			dev_dbg(rtsx_dev(chip), "Try to enable ASPM\n");
-			chip->aspm_enabled = 1;
+	if (chip->aspm_l0s_l1_en && chip->dynamic_aspm && !chip->aspm_enabled) {
+		dev_dbg(rtsx_dev(chip), "Try to enable ASPM\n");
+		chip->aspm_enabled = 1;
 
-			if (chip->asic_code && CHECK_PID(chip, 0x5208))
-				rtsx_write_phy_register(chip, 0x07, 0);
-			if (CHECK_PID(chip, 0x5208)) {
-				rtsx_write_register(chip, ASPM_FORCE_CTL, 0xF3,
-					0x30 | chip->aspm_level[0]);
-			} else {
-				rtsx_write_config_byte(chip, LCTLR,
-						chip->aspm_l0s_l1_en);
-			}
+		if (chip->asic_code && CHECK_PID(chip, 0x5208))
+			rtsx_write_phy_register(chip, 0x07, 0);
+		if (CHECK_PID(chip, 0x5208)) {
+			rtsx_write_register(chip, ASPM_FORCE_CTL, 0xF3,
+				0x30 | chip->aspm_level[0]);
+		} else {
+			rtsx_write_config_byte(chip, LCTLR,
+					chip->aspm_l0s_l1_en);
+		}
 
-			if (CHK_SDIO_EXIST(chip)) {
-				u16 val = chip->aspm_l0s_l1_en | 0x0100;
+		if (CHK_SDIO_EXIST(chip)) {
+			u16 val = chip->aspm_l0s_l1_en | 0x0100;
 
-				if (CHECK_PID(chip, 0x5288))
-					rtsx_write_cfg_dw(chip, 2, 0xC0,
-							0xFFFF, val);
-				else
-					rtsx_write_cfg_dw(chip, 1, 0xC0,
-							0xFFFF, val);
-			}
+			if (CHECK_PID(chip, 0x5288))
+				rtsx_write_cfg_dw(chip, 2, 0xC0,
+						0xFFFF, val);
+			else
+				rtsx_write_cfg_dw(chip, 1, 0xC0,
+					0xFFFF, val);
 		}
 	}
 }
@@ -1830,21 +1820,19 @@ void rtsx_disable_aspm(struct rtsx_chip *chip)
 	if (CHECK_PID(chip, 0x5208))
 		rtsx_monitor_aspm_config(chip);
 
-	if (chip->aspm_l0s_l1_en && chip->dynamic_aspm) {
-		if (chip->aspm_enabled) {
-			dev_dbg(rtsx_dev(chip), "Try to disable ASPM\n");
-			chip->aspm_enabled = 0;
+	if (chip->aspm_l0s_l1_en && chip->dynamic_aspm && chip->aspm_enabled) {
+		dev_dbg(rtsx_dev(chip), "Try to disable ASPM\n");
+		chip->aspm_enabled = 0;
 
-			if (chip->asic_code && CHECK_PID(chip, 0x5208))
-				rtsx_write_phy_register(chip, 0x07, 0x0129);
-			if (CHECK_PID(chip, 0x5208))
-				rtsx_write_register(chip, ASPM_FORCE_CTL,
-						0xF3, 0x30);
-			else
-				rtsx_write_config_byte(chip, LCTLR, 0x00);
+		if (chip->asic_code && CHECK_PID(chip, 0x5208))
+			rtsx_write_phy_register(chip, 0x07, 0x0129);
+		if (CHECK_PID(chip, 0x5208))
+			rtsx_write_register(chip, ASPM_FORCE_CTL,
+					0xF3, 0x30);
+		else
+			rtsx_write_config_byte(chip, LCTLR, 0x00);
 
-			wait_timeout(1);
-		}
+		wait_timeout(1);
 	}
 }
 
-- 
2.1.2

