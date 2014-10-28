Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbaJ1SsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:48:12 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64757 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaJ1SsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:48:10 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: micky_ching@realsil.com.cn, dan.carpenter@oracle.com, joe@perches.com,
        giedrius.statkevicius@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH RESEND v2 1/2] Staging: rts5208: helper function to manage aspm during reset
Date: Tue, 28 Oct 2014 19:46:55 +0100
Message-Id: <1414522016-3961-2-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414522016-3961-1-git-send-email-fabio.falzoi84@gmail.com>
References: <1414522016-3961-1-git-send-email-fabio.falzoi84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the helper function rtsx_reset_aspm to shorten the
rtsx_reset_chip code and get rid of the LONG_LINE checkpatch warnings.

Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpente@oracle.com>
---
 drivers/staging/rts5208/rtsx_chip.c | 70 +++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/rts5208/rtsx_chip.c b/drivers/staging/rts5208/rtsx_chip.c
index ffcf5de..ea6cfd1 100644
--- a/drivers/staging/rts5208/rtsx_chip.c
+++ b/drivers/staging/rts5208/rtsx_chip.c
@@ -227,6 +227,42 @@ static int rtsx_pre_handle_sdio_new(struct rtsx_chip *chip)
 }
 #endif
 
+static int rtsx_reset_aspm(struct rtsx_chip *chip)
+{
+	int ret;
+
+	if (chip->dynamic_aspm) {
+		if (!CHK_SDIO_EXIST(chip) || !CHECK_PID(chip, 0x5288))
+			return STATUS_SUCCESS;
+
+		ret = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFF,
+					chip->aspm_l0s_l1_en);
+		if (ret != STATUS_SUCCESS)
+			TRACE_RET(chip, STATUS_FAIL);
+
+		return STATUS_SUCCESS;
+	}
+
+	if (CHECK_PID(chip, 0x5208))
+		RTSX_WRITE_REG(chip, ASPM_FORCE_CTL, 0xFF, 0x3F);
+	ret = rtsx_write_config_byte(chip, LCTLR, chip->aspm_l0s_l1_en);
+	if (ret != STATUS_SUCCESS)
+		TRACE_RET(chip, STATUS_FAIL);
+
+	chip->aspm_level[0] = chip->aspm_l0s_l1_en;
+	if (CHK_SDIO_EXIST(chip)) {
+		chip->aspm_level[1] = chip->aspm_l0s_l1_en;
+		ret = rtsx_write_cfg_dw(chip, CHECK_PID(chip, 0x5288) ? 2 : 1,
+					0xC0, 0xFF, chip->aspm_l0s_l1_en);
+		if (ret != STATUS_SUCCESS)
+			TRACE_RET(chip, STATUS_FAIL);
+	}
+
+	chip->aspm_enabled = 1;
+
+	return STATUS_SUCCESS;
+}
+
 int rtsx_reset_chip(struct rtsx_chip *chip)
 {
 	int retval;
@@ -289,37 +325,9 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 
 	/* Enable ASPM */
 	if (chip->aspm_l0s_l1_en) {
-		if (chip->dynamic_aspm) {
-			if (CHK_SDIO_EXIST(chip) && CHECK_PID(chip, 0x5288)) {
-				retval = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFF,
-						chip->aspm_l0s_l1_en);
-				if (retval != STATUS_SUCCESS)
-					TRACE_RET(chip, STATUS_FAIL);
-			}
-		} else {
-			if (CHECK_PID(chip, 0x5208))
-				RTSX_WRITE_REG(chip, ASPM_FORCE_CTL,
-					       0xFF, 0x3F);
-
-			retval = rtsx_write_config_byte(chip, LCTLR,
-							chip->aspm_l0s_l1_en);
-			if (retval != STATUS_SUCCESS)
-				TRACE_RET(chip, STATUS_FAIL);
-
-			chip->aspm_level[0] = chip->aspm_l0s_l1_en;
-			if (CHK_SDIO_EXIST(chip)) {
-				chip->aspm_level[1] = chip->aspm_l0s_l1_en;
-				retval = rtsx_write_cfg_dw(chip,
-						CHECK_PID(chip, 0x5288) ? 2 : 1,
-						0xC0, 0xFF,
-						chip->aspm_l0s_l1_en);
-
-				if (retval != STATUS_SUCCESS)
-					TRACE_RET(chip, STATUS_FAIL);
-			}
-
-			chip->aspm_enabled = 1;
-		}
+		retval = rtsx_reset_aspm(chip);
+		if (retval != STATUS_SUCCESS)
+			TRACE_RET(chip, STATUS_FAIL);
 	} else {
 		if (chip->asic_code && CHECK_PID(chip, 0x5208)) {
 			retval = rtsx_write_phy_register(chip, 0x07, 0x0129);
-- 
2.1.1

