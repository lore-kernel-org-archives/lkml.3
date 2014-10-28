Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbaJ1SsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:48:25 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:64830 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbaJ1SsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:48:24 -0400
From: Fabio Falzoi <fabio.falzoi84@gmail.com>
To: gregkh@linuxfoundation.org
Cc: micky_ching@realsil.com.cn, dan.carpenter@oracle.com, joe@perches.com,
        giedrius.statkevicius@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Fabio Falzoi <fabio.falzoi84@gmail.com>
Subject: [PATCH RESEND v2 2/2] Staging: rts5208: helper function to enable interrupts during reset
Date: Tue, 28 Oct 2014 19:46:56 +0100
Message-Id: <1414522016-3961-3-git-send-email-fabio.falzoi84@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414522016-3961-1-git-send-email-fabio.falzoi84@gmail.com>
References: <1414522016-3961-1-git-send-email-fabio.falzoi84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the helper function rtsx_enable_pcie_intr to shorten the
rtsx_reset_chip code and get rid of the LONG_LINE checkpatch warnings.

Signed-off-by: Fabio Falzoi <fabio.falzoi84@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpente@oracle.com>
---
 drivers/staging/rts5208/rtsx_chip.c | 95 +++++++++++++++++++------------------
 1 file changed, 48 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/rts5208/rtsx_chip.c b/drivers/staging/rts5208/rtsx_chip.c
index ea6cfd1..9593d81 100644
--- a/drivers/staging/rts5208/rtsx_chip.c
+++ b/drivers/staging/rts5208/rtsx_chip.c
@@ -263,6 +263,51 @@ static int rtsx_reset_aspm(struct rtsx_chip *chip)
 	return STATUS_SUCCESS;
 }
 
+static int rtsx_enable_pcie_intr(struct rtsx_chip *chip)
+{
+	int ret;
+
+	if (!chip->asic_code || !CHECK_PID(chip, 0x5208)) {
+		rtsx_enable_bus_int(chip);
+		return STATUS_SUCCESS;
+	}
+
+	if (chip->phy_debug_mode) {
+		RTSX_WRITE_REG(chip, CDRESUMECTL, 0x77, 0);
+		rtsx_disable_bus_int(chip);
+	} else {
+		rtsx_enable_bus_int(chip);
+	}
+
+	if (chip->ic_version >= IC_VER_D) {
+		u16 reg;
+
+		ret = rtsx_read_phy_register(chip, 0x00, &reg);
+		if (ret != STATUS_SUCCESS)
+			TRACE_RET(chip, STATUS_FAIL);
+
+		reg &= 0xFE7F;
+		reg |= 0x80;
+		ret = rtsx_write_phy_register(chip, 0x00, reg);
+		if (ret != STATUS_SUCCESS)
+			TRACE_RET(chip, STATUS_FAIL);
+
+		ret = rtsx_read_phy_register(chip, 0x1C, &reg);
+		if (ret != STATUS_SUCCESS)
+			TRACE_RET(chip, STATUS_FAIL);
+
+		reg &= 0xFFF7;
+		ret = rtsx_write_phy_register(chip, 0x1C, reg);
+		if (ret != STATUS_SUCCESS)
+			TRACE_RET(chip, STATUS_FAIL);
+	}
+
+	if (chip->driver_first_load && (chip->ic_version < IC_VER_C))
+		rtsx_calibration(chip);
+
+	return STATUS_SUCCESS;
+}
+
 int rtsx_reset_chip(struct rtsx_chip *chip)
 {
 	int retval;
@@ -367,53 +412,9 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 
 	RTSX_WRITE_REG(chip, PERST_GLITCH_WIDTH, 0xFF, 0x80);
 
-	/* Enable PCIE interrupt */
-	if (chip->asic_code) {
-		if (CHECK_PID(chip, 0x5208)) {
-			if (chip->phy_debug_mode) {
-				RTSX_WRITE_REG(chip, CDRESUMECTL, 0x77, 0);
-				rtsx_disable_bus_int(chip);
-			} else {
-				rtsx_enable_bus_int(chip);
-			}
-
-			if (chip->ic_version >= IC_VER_D) {
-				u16 reg;
-
-				retval = rtsx_read_phy_register(chip, 0x00,
-								&reg);
-				if (retval != STATUS_SUCCESS)
-					TRACE_RET(chip, STATUS_FAIL);
-
-				reg &= 0xFE7F;
-				reg |= 0x80;
-				retval = rtsx_write_phy_register(chip, 0x00,
-								 reg);
-				if (retval != STATUS_SUCCESS)
-					TRACE_RET(chip, STATUS_FAIL);
-
-				retval = rtsx_read_phy_register(chip, 0x1C,
-								&reg);
-				if (retval != STATUS_SUCCESS)
-					TRACE_RET(chip, STATUS_FAIL);
-
-				reg &= 0xFFF7;
-				retval = rtsx_write_phy_register(chip, 0x1C,
-								 reg);
-				if (retval != STATUS_SUCCESS)
-					TRACE_RET(chip, STATUS_FAIL);
-			}
-
-			if (chip->driver_first_load &&
-			    (chip->ic_version < IC_VER_C))
-				rtsx_calibration(chip);
-
-		} else {
-			rtsx_enable_bus_int(chip);
-		}
-	} else {
-		rtsx_enable_bus_int(chip);
-	}
+	retval = rtsx_enable_pcie_intr(chip);
+	if (retval != STATUS_SUCCESS)
+		TRACE_RET(chip, STATUS_FAIL);
 
 	chip->need_reset = 0;
 
-- 
2.1.1

