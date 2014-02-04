Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934616AbaBDVMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:12:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57177 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934463AbaBDVLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:11:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.13 029/140] rtlwifi: rtl8192cu: Add new firmware
Date: Tue,  4 Feb 2014 13:10:16 -0800
Message-Id: <20140204211037.798648266@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 62009b7f12793c932aaba0df946b04cb4a77d022 upstream.

Vendor driver rtl8188C_8192C_8192D_usb_linux_v3.4.2_3727.20120404 introduced
new firmware for these chips. The code try for the new file, and fall back to
the original firmware if the new file is not available.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/core.c         |   10 ++++++++++
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c |   16 +++++++++++++---
 drivers/net/wireless/rtlwifi/wifi.h         |    1 +
 3 files changed, 24 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -46,10 +46,20 @@ void rtl_fw_cb(const struct firmware *fi
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
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -50,6 +50,9 @@ MODULE_AUTHOR("Larry Finger	<Larry.Finge
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Realtek 8192C/8188C 802.11n USB wireless");
 MODULE_FIRMWARE("rtlwifi/rtl8192cufw.bin");
+MODULE_FIRMWARE("rtlwifi/rtl8192cufw_A.bin");
+MODULE_FIRMWARE("rtlwifi/rtl8192cufw_B.bin");
+MODULE_FIRMWARE("rtlwifi/rtl8192cufw_TMSC.bin");
 
 static int rtl92cu_init_sw_vars(struct ieee80211_hw *hw)
 {
@@ -69,14 +72,21 @@ static int rtl92cu_init_sw_vars(struct i
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
 
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -1804,6 +1804,7 @@ struct rtl_hal_cfg {
 	bool write_readback;
 	char *name;
 	char *fw_name;
+	char *alt_fw_name;
 	struct rtl_hal_ops *ops;
 	struct rtl_mod_params *mod_params;
 	struct rtl_hal_usbint_cfg *usb_interface_cfg;


