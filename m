Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbaBGLsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:48:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41608 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbaBGLsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 046/233] rtlwifi: rtl8192cu: Add new firmware
Date: Fri,  7 Feb 2014 11:44:25 +0000
Message-Id: <1391773652-25214-47-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 62009b7f12793c932aaba0df946b04cb4a77d022 upstream.

Vendor driver rtl8188C_8192C_8192D_usb_linux_v3.4.2_3727.20120404 introduced
new firmware for these chips. The code try for the new file, and fall back to
the original firmware if the new file is not available.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rtlwifi/core.c         | 10 ++++++++++
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c | 16 +++++++++++++---
 drivers/net/wireless/rtlwifi/wifi.h         |  1 +
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index 733b7ce..0f12cd3 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -46,10 +46,20 @@ void rtl_fw_cb(const struct firmware *firmware, void *context)
 			 "Firmware callback routine entered!\n");
 	complete(&rtlpriv->firmware_loading_complete);
 	if (!firmware) {
+		if (rtlpriv->cfg->alt_fw_name) {
+			err = request_firmware(&firmware,
+					       rtlpriv->cfg->alt_fw_name,
+					       rtlpriv->io.dev);
+			pr_info("Loading alternative firmware %s\n",
+				rtlpriv->cfg->alt_fw_name);
+			if (!err)
+				goto found_alt;
+		}
 		pr_err("Firmware %s not available\n", rtlpriv->cfg->fw_name);
 		rtlpriv->max_fw_size = 0;
 		return;
 	}
+found_alt:
 	if (firmware->size > rtlpriv->max_fw_size) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "Firmware is too big!\n");
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
index 2bd5985..a5a1901 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -49,6 +49,9 @@ MODULE_AUTHOR("Larry Finger	<Larry.Finger@lwfinger.net>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Realtek 8192C/8188C 802.11n USB wireless");
 MODULE_FIRMWARE("rtlwifi/rtl8192cufw.bin");
+MODULE_FIRMWARE("rtlwifi/rtl8192cufw_A.bin");
+MODULE_FIRMWARE("rtlwifi/rtl8192cufw_B.bin");
+MODULE_FIRMWARE("rtlwifi/rtl8192cufw_TMSC.bin");
 
 static int rtl92cu_init_sw_vars(struct ieee80211_hw *hw)
 {
@@ -68,14 +71,21 @@ static int rtl92cu_init_sw_vars(struct ieee80211_hw *hw)
 			 "Can't alloc buffer for fw\n");
 		return 1;
 	}
-
+	if (IS_VENDOR_UMC_A_CUT(rtlpriv->rtlhal.version) &&
+	    !IS_92C_SERIAL(rtlpriv->rtlhal.version)) {
+		rtlpriv->cfg->fw_name = "rtlwifi/rtl8192cufw_A.bin";
+	} else if (IS_81xxC_VENDOR_UMC_B_CUT(rtlpriv->rtlhal.version)) {
+		rtlpriv->cfg->fw_name = "rtlwifi/rtl8192cufw_B.bin";
+	} else {
+		rtlpriv->cfg->fw_name = "rtlwifi/rtl8192cufw_TMSC.bin";
+	}
+	/* provide name of alternative file */
+	rtlpriv->cfg->alt_fw_name = "rtlwifi/rtl8192cufw.bin";
 	pr_info("Loading firmware %s\n", rtlpriv->cfg->fw_name);
 	rtlpriv->max_fw_size = 0x4000;
 	err = request_firmware_nowait(THIS_MODULE, 1,
 				      rtlpriv->cfg->fw_name, rtlpriv->io.dev,
 				      GFP_KERNEL, hw, rtl_fw_cb);
-
-
 	return err;
 }
 
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index ad9c37a..224cf61 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -1806,6 +1806,7 @@ struct rtl_hal_cfg {
 	bool write_readback;
 	char *name;
 	char *fw_name;
+	char *alt_fw_name;
 	struct rtl_hal_ops *ops;
 	struct rtl_mod_params *mod_params;
 	struct rtl_hal_usbint_cfg *usb_interface_cfg;
-- 
1.8.3.2

