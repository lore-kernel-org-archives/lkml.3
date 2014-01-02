Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaABRZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:25:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40301 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbaABRHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:07:33 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Chang <dchang@suse.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 32/91] r8169: check ALDPS bit and disable it if enabled for the 8168g
Date: Thu,  2 Jan 2014 09:04:07 -0800
Message-Id: <1388682306-30859-33-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Chang <dchang@suse.com>

[ Upstream commit 1bac1072425c86f1ac85bd5967910706677ef8b3 ]

Windows driver will enable ALDPS function, but linux driver and firmware
do not have any configuration related to ALDPS function for 8168g.
So restart system to linux and remove the NIC cable, LAN enter ALDPS,
then LAN RX will be disabled.

This issue can be easily reproduced on dual boot windows and linux
system with RTL_GIGA_MAC_VER_40 chip.

Realtek said, ALDPS function can be disabled by configuring to PHY,
switch to page 0x0A43, reg0x10 bit2=0.

Signed-off-by: David Chang <dchang@suse.com>
Acked-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ David Chang: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/realtek/r8169.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 996318b..ef0226a 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -3414,6 +3414,11 @@ static void rtl8168g_1_hw_phy_config(struct rtl8169_private *tp)
 	rtl_w1w0_phy_ocp(tp, 0xa438, 0x8000, 0x0000);
 
 	rtl_w1w0_phy_ocp(tp, 0xc422, 0x4000, 0x2000);
+
+	/* Check ALDPS bit, disable it if enabled */
+	rtl_writephy(tp, 0x1f, 0x0a43);
+	if (rtl_readphy(tp, 0x10) & 0x0004)
+		rtl_w1w0_phy(tp, 0x10, 0x0000, 0x0004);
 }
 
 static void rtl8102e_hw_phy_config(struct rtl8169_private *tp)
-- 
1.8.3.2

