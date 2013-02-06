Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab3BFOre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 09:47:34 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:59449 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275Ab3BFOrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 09:47:04 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r16EkrS0011385
From: Hayes Wang <hayeswang@realtek.com>
To: <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH 5/5] r8169: fix could not dump registers
Date: Wed, 6 Feb 2013 22:46:27 +0800
Message-ID: <1360161987-3268-5-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360161987-3268-1-git-send-email-hayeswang@realtek.com>
References: <1360161987-3268-1-git-send-email-hayeswang@realtek.com>
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
index c25a329..4ae3c55 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -1880,12 +1880,16 @@ static void rtl8169_get_regs(struct net_device *dev, struct ethtool_regs *regs,
 			     void *p)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
+	void __iomem *ioaddr = tp->mmio_addr;
+	u32 *d = (u32 *)p;
+	int i;
 
 	if (regs->len > R8169_REGS_SIZE)
 		regs->len = R8169_REGS_SIZE;
 
 	rtl_lock_work(tp);
-	memcpy_fromio(p, tp->mmio_addr, regs->len);
+	for (i = 0; i < regs->len; i += 4)
+		*d++ = RTL_R32(i);
 	rtl_unlock_work(tp);
 }
 
-- 
1.8.1

