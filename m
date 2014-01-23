Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbaAWKcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:32:39 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:60447 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbaAWKca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:32:30 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, computersforpeace@gmail.com,
        Angus.Clark@st.com, DCG_UPD_stlinux_kernel@list.st.com,
        olivier.clergeaud@st.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH RESEND v4 19/37] mtd: st_spi_fsm: Add a check to if the chip can handle an SoC reset
Date: Thu, 23 Jan 2014 10:31:07 +0000
Message-Id: <1390473085-24626-20-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390473085-24626-1-git-send-email-lee.jones@linaro.org>
References: <1390473085-24626-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on information we can obtain though platform specific data and/or
chip capabilities we are able to determine whether or not we can handle
a SoC reset or not. To find out why this is important please read the
comment provided in the patch.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index fc23354..b21929b 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -246,6 +246,8 @@ struct stfsm {
 
 	uint32_t                fifo_dir_delay;
 	bool                    booted_from_spi;
+	bool                    reset_signal;
+	bool                    reset_por;
 };
 
 struct stfsm_seq {
@@ -552,6 +554,40 @@ static void stfsm_read_fifo(struct stfsm *fsm, uint32_t *buf,
 	}
 }
 
+/*
+ * SoC reset on 'boot-from-spi' systems
+ *
+ * Certain modes of operation cause the Flash device to enter a particular state
+ * for a period of time (e.g. 'Erase Sector', 'Quad Enable', and 'Enter 32-bit
+ * Addr' commands).  On boot-from-spi systems, it is important to consider what
+ * happens if a warm reset occurs during this period.  The SPIBoot controller
+ * assumes that Flash device is in its default reset state, 24-bit address mode,
+ * and ready to accept commands.  This can be achieved using some form of
+ * on-board logic/controller to force a device POR in response to a SoC-level
+ * reset or by making use of the device reset signal if available (limited
+ * number of devices only).
+ *
+ * Failure to take such precautions can cause problems following a warm reset.
+ * For some operations (e.g. ERASE), there is little that can be done.  For
+ * other modes of operation (e.g. 32-bit addressing), options are often
+ * available that can help minimise the window in which a reset could cause a
+ * problem.
+ *
+ */
+static bool stfsm_can_handle_soc_reset(struct stfsm *fsm)
+{
+	/* Reset signal is available on the board and supported by the device */
+	if (fsm->reset_signal && fsm->info->flags & FLASH_FLAG_RESET)
+		return true;
+
+	/* Board-level logic forces a power-on-reset */
+	if (fsm->reset_por)
+		return true;
+
+	/* Reset is not properly handled and may result in failure to reboot */
+	return false;
+}
+
 /* Configure 'addr_cfg' according to addressing mode */
 static void stfsm_prepare_erasesec_seq(struct stfsm *fsm,
 				       struct stfsm_seq *seq)
@@ -824,6 +860,10 @@ static void stfsm_fetch_platform_configs(struct platform_device *pdev)
 		goto boot_device_fail;
 	}
 
+	fsm->reset_signal = of_property_read_bool(np, "st,reset-signal");
+
+	fsm->reset_por = of_property_read_bool(np, "st,reset-por");
+
 	/* Where in the syscon the boot device information lives */
 	ret = of_property_read_u32(np, "st,boot-device-reg", &boot_device_reg);
 	if (ret)
-- 
1.8.3.2

