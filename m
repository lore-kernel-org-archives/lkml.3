Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab3LSNCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:02:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44560 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab3LSL4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:56:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Chang <dchang@suse.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 037/208] r8169: check ALDPS bit and disable it if enabled for the 8168g
Date: Thu, 19 Dec 2013 11:52:15 +0000
Message-Id: <1387454106-19326-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Chang <dchang@suse.com>

commit 1bac1072425c86f1ac85bd5967910706677ef8b3 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/realtek/r8169.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 7ba68e0..5186136 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -3464,6 +3464,11 @@ static void rtl8168g_1_hw_phy_config(struct rtl8169_private *tp)
 	rtl_writephy(tp, 0x14, 0x9065);
 	rtl_writephy(tp, 0x14, 0x1065);
 
+	/* Check ALDPS bit, disable it if enabled */
+	rtl_writephy(tp, 0x1f, 0x0a43);
+	if (rtl_readphy(tp, 0x10) & 0x0004)
+		rtl_w1w0_phy(tp, 0x10, 0x0000, 0x0004);
+
 	rtl_writephy(tp, 0x1f, 0x0000);
 }
 
-- 
1.8.3.2

