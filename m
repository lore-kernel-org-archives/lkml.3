Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaJSJ4h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 05:56:37 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:57556 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaJSJ4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 05:56:31 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: micky_ching@realsil.com.cn, joe@perches.com,
        giedrius.statkevicius@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH 1/2] Staging: rts5208: helper function to manage aspm during reset
Date: Sun, 19 Oct 2014 11:55:53 +0200
Message-Id: <1413712554-4872-2-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413712554-4872-1-git-send-email-fabio.falzoi84@gmail.com>
References: <1413712554-4872-1-git-send-email-fabio.falzoi84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the helper function rtsx_reset_aspm to shorten the
rtsx_reset_chip code and get rid of the LONG_LINE checkpatch warnings.

Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
---
 drivers/staging/rts5208/rtsx_chip.c | 72 ++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/rts5208/rtsx_chip.c b/drivers/staging/rts5208/rtsx_chip.c
index a7ade8b..17f68b8 100644
--- a/drivers/staging/rts5208/rtsx_chip.c
+++ b/drivers/staging/rts5208/rtsx_chip.c
@@ -226,6 +226,42 @@ static int rtsx_pre_handle_sdio_new(struct rtsx_chip *chip)
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
@@ -288,39 +324,9 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 
 	/* Enable ASPM */
 	if (chip->aspm_l0s_l1_en) {
-		if (chip->dynamic_aspm) {
-			if (CHK_SDIO_EXIST(chip)) {
-				if (CHECK_PID(chip, 0x5288)) {
-					retval = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFF, chip->aspm_l0s_l1_en);
-					if (retval != STATUS_SUCCESS)
-						TRACE_RET(chip, STATUS_FAIL);
-				}
-			}
-		} else {
-			if (CHECK_PID(chip, 0x5208))
-				RTSX_WRITE_REG(chip, ASPM_FORCE_CTL,
-					0xFF, 0x3F);
-
-			retval = rtsx_write_config_byte(chip, LCTLR,
-							chip->aspm_l0s_l1_en);
-			if (retval != STATUS_SUCCESS)
-				TRACE_RET(chip, STATUS_FAIL);
-
-			chip->aspm_level[0] = chip->aspm_l0s_l1_en;
-			if (CHK_SDIO_EXIST(chip)) {
-				chip->aspm_level[1] = chip->aspm_l0s_l1_en;
-				if (CHECK_PID(chip, 0x5288))
-					retval = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFF, chip->aspm_l0s_l1_en);
-				else
-					retval = rtsx_write_cfg_dw(chip, 1, 0xC0, 0xFF, chip->aspm_l0s_l1_en);
-
-				if (retval != STATUS_SUCCESS)
-					TRACE_RET(chip, STATUS_FAIL);
-
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

