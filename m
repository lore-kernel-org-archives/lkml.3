Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbaATLN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:13:56 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:60696 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaATLNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:13:53 -0500
From: Jonas Jensen <jonas.jensen@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, f.fainelli@gmail.com, bhutchings@solarflare.com,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v3 1/7] net: moxa: clear TX descriptor length bits between sends
Date: Mon, 20 Jan 2014 12:13:13 +0100
Message-Id: <1390216399-27028-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add TX_DESC1_BUF_SIZE_MASK to bits that are cleared, before the TX buffer
length is set. Failing to do so can cause the controller to drop dead
i.e. all TX interrupts stop, resulting in complete communication failure.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=69031

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Applies to next-20140120

 drivers/net/ethernet/moxa/moxart_ether.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index 5020fd4..aa45607 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -348,7 +348,8 @@ static int moxart_mac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	txdes1 = readl(desc + TX_REG_OFFSET_DESC1);
 	txdes1 |= TX_DESC1_LTS | TX_DESC1_FTS;
-	txdes1 &= ~(TX_DESC1_FIFO_COMPLETE | TX_DESC1_INTR_COMPLETE);
+	txdes1 &= ~(TX_DESC1_FIFO_COMPLETE | TX_DESC1_INTR_COMPLETE |
+		    TX_DESC1_BUF_SIZE_MASK);
 	txdes1 |= (len & TX_DESC1_BUF_SIZE_MASK);
 	writel(txdes1, desc + TX_REG_OFFSET_DESC1);
 	writel(TX_DESC0_DMA_OWN, desc + TX_REG_OFFSET_DESC0);
-- 
1.8.2.1

