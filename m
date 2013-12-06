Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471Ab3LFVxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:53:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759440Ab3LFVxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Chang <dchang@suse.com>, Hayes Wang <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 34/58] r8169: check ALDPS bit and disable it if enabled for the 8168g
Date: Fri,  6 Dec 2013 13:52:05 -0800
Message-Id: <20131206214848.064183413@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214844.906193530@linuxfoundation.org>
References: <20131206214844.906193530@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -3456,6 +3456,11 @@ static void rtl8168g_1_hw_phy_config(str
 	rtl_writephy(tp, 0x14, 0x9065);
 	rtl_writephy(tp, 0x14, 0x1065);
 
+	/* Check ALDPS bit, disable it if enabled */
+	rtl_writephy(tp, 0x1f, 0x0a43);
+	if (rtl_readphy(tp, 0x10) & 0x0004)
+		rtl_w1w0_phy(tp, 0x10, 0x0000, 0x0004);
+
 	rtl_writephy(tp, 0x1f, 0x0000);
 }
 


