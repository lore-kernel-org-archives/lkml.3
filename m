Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379Ab3DAN4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:56:41 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:38824 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758337Ab3DAN4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:56:39 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r31DuWDa009660, This message is released by code: ctlocs8528
From: Hayes Wang <hayeswang@realtek.com>
To: <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 7/7] r8169: fix could not dump registers
Date: Mon, 1 Apr 2013 21:55:39 +0800
Message-ID: <1364824539-4156-7-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1364824539-4156-1-git-send-email-hayeswang@realtek.com>
References: <1364824539-4156-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For new version of Fedora and Ubuntu, we see all 0xff when dumping
the hw regs through ethtool. Using a loop to read registers could
fix it.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/ethernet/realtek/r8169.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 876e088..c9cd64c 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -1889,12 +1889,16 @@ static void rtl8169_get_regs(struct net_device *dev, struct ethtool_regs *regs,
 			     void *p)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
+	void __iomem *ioaddr = tp->mmio_addr;
+	u8 *d = (u8 *)p;
+	int i;
 
 	if (regs->len > R8169_REGS_SIZE)
 		regs->len = R8169_REGS_SIZE;
 
 	rtl_lock_work(tp);
-	memcpy_fromio(p, tp->mmio_addr, regs->len);
+	for (i = 0; i < regs->len; i++)
+		*d++ = RTL_R8(i);
 	rtl_unlock_work(tp);
 }
 
-- 
1.8.1

