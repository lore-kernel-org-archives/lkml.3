Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaJAF0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 01:26:23 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:48522 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaJAF0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 01:26:19 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s915QGTq003001, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net 1/2] r8152: remove clearing bp
Date: Wed, 1 Oct 2014 13:25:10 +0800
Message-ID: <1394712342-15778-52-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-51-Taiwan-albertk@realtek.com>
References: <1394712342-15778-51-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The xxx_clear_bp() is used to halt the firmware. It only necessary
for updating the new firmware. Besides, depend on the version of
the current firmware, it may have problem to halt the firmware
directly. Finally, halt the firmware would let the firmware code
useless, and the bugs which are fixed by the firmware would occur.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 28 +---------------------------
 1 file changed, 1 insertion(+), 27 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index f68a4e6..18b9e0d 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -24,7 +24,7 @@
 #include <net/ip6_checksum.h>
 
 /* Version Information */
-#define DRIVER_VERSION "v1.06.0 (2014/03/03)"
+#define DRIVER_VERSION "v1.06.1 (2014/10/01)"
 #define DRIVER_AUTHOR "Realtek linux nic maintainers <nic_swsd@realtek.com>"
 #define DRIVER_DESC "Realtek RTL8152/RTL8153 Based USB Ethernet Adapters"
 #define MODULENAME "r8152"
@@ -2201,28 +2201,6 @@ static void rtl_phy_reset(struct r8152 *tp)
 	}
 }
 
-static void rtl_clear_bp(struct r8152 *tp)
-{
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_BP_0, 0);
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_BP_2, 0);
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_BP_4, 0);
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_BP_6, 0);
-	ocp_write_dword(tp, MCU_TYPE_USB, USB_BP_0, 0);
-	ocp_write_dword(tp, MCU_TYPE_USB, USB_BP_2, 0);
-	ocp_write_dword(tp, MCU_TYPE_USB, USB_BP_4, 0);
-	ocp_write_dword(tp, MCU_TYPE_USB, USB_BP_6, 0);
-	mdelay(3);
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_BA, 0);
-	ocp_write_word(tp, MCU_TYPE_USB, USB_BP_BA, 0);
-}
-
-static void r8153_clear_bp(struct r8152 *tp)
-{
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_BP_EN, 0);
-	ocp_write_byte(tp, MCU_TYPE_USB, USB_BP_EN, 0);
-	rtl_clear_bp(tp);
-}
-
 static void r8153_teredo_off(struct r8152 *tp)
 {
 	u32 ocp_data;
@@ -2265,8 +2243,6 @@ static void r8152b_hw_phy_cfg(struct r8152 *tp)
 		r8152_mdio_write(tp, MII_BMCR, data);
 	}
 
-	rtl_clear_bp(tp);
-
 	set_bit(PHY_RESET, &tp->flags);
 }
 
@@ -2417,8 +2393,6 @@ static void r8153_hw_phy_cfg(struct r8152 *tp)
 		r8152_mdio_write(tp, MII_BMCR, data);
 	}
 
-	r8153_clear_bp(tp);
-
 	if (tp->version == RTL_VER_03) {
 		data = ocp_reg_read(tp, OCP_EEE_CFG);
 		data &= ~CTAP_SHORT_EN;
-- 
1.9.3

