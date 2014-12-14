Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbaLNUlw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:41:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbaLNUbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:31:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Catalin Iacob <iacobcatalin@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.18 13/19] rtlwifi: rtl8192ce: Fix kernel crashes due to missing callback entry
Date: Sun, 14 Dec 2014 12:21:24 -0800
Message-Id: <20141214201823.921782512@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201823.543296369@linuxfoundation.org>
References: <20141214201823.543296369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit f892914c03131a445b926b82815b03162c19288e upstream.

In the major update of the rtlwifi-family of drivers, one of the callback entries
was missed, which leads to memory corruption. Unfortunately, this corruption
never caused a kernel oops, but showed up in other parts of the system.
This patch is one of three needed to fix the kernel regression reported at
https://bugzilla.kernel.org/show_bug.cgi?id=88951.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: Catalin Iacob <iacobcatalin@gmail.com>
Tested-by: Catalin Iacob <iacobcatalin@gmail.com>
Cc: Catalin Iacob <iacobcatalin@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c  |    3 +++
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c |   17 +++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h |    2 ++
 3 files changed, 22 insertions(+)

--- a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -228,6 +228,7 @@ static struct rtl_hal_ops rtl8192ce_hal_
 	.led_control = rtl92ce_led_control,
 	.set_desc = rtl92ce_set_desc,
 	.get_desc = rtl92ce_get_desc,
+	.is_tx_desc_closed = rtl92ce_is_tx_desc_closed,
 	.tx_polling = rtl92ce_tx_polling,
 	.enable_hw_sec = rtl92ce_enable_hw_security_config,
 	.set_key = rtl92ce_set_key,
@@ -271,6 +272,8 @@ static struct rtl_hal_cfg rtl92ce_hal_cf
 	.maps[MAC_RCR_ACRC32] = ACRC32,
 	.maps[MAC_RCR_ACF] = ACF,
 	.maps[MAC_RCR_AAP] = AAP,
+	.maps[MAC_HIMR] = REG_HIMR,
+	.maps[MAC_HIMRE] = REG_HIMRE,
 
 	.maps[EFUSE_TEST] = REG_EFUSE_TEST,
 	.maps[EFUSE_CTRL] = REG_EFUSE_CTRL,
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -739,6 +739,23 @@ u32 rtl92ce_get_desc(u8 *p_desc, bool is
 	return ret;
 }
 
+bool rtl92ce_is_tx_desc_closed(struct ieee80211_hw *hw,
+			       u8 hw_queue, u16 index)
+{
+	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
+	struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[hw_queue];
+	u8 *entry = (u8 *)(&ring->desc[ring->idx]);
+	u8 own = (u8)rtl92ce_get_desc(entry, true, HW_DESC_OWN);
+
+	/*beacon packet will only use the first
+	 *descriptor defautly,and the own may not
+	 *be cleared by the hardware
+	 */
+	if (own)
+		return false;
+	return true;
+}
+
 void rtl92ce_tx_polling(struct ieee80211_hw *hw, u8 hw_queue)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
@@ -723,6 +723,8 @@ bool rtl92ce_rx_query_desc(struct ieee80
 void rtl92ce_set_desc(struct ieee80211_hw *hw, u8 *pdesc, bool istx,
 		      u8 desc_name, u8 *val);
 u32 rtl92ce_get_desc(u8 *pdesc, bool istx, u8 desc_name);
+bool rtl92ce_is_tx_desc_closed(struct ieee80211_hw *hw,
+			       u8 hw_queue, u16 index);
 void rtl92ce_tx_polling(struct ieee80211_hw *hw, u8 hw_queue);
 void rtl92ce_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc,
 			     bool b_firstseg, bool b_lastseg,


