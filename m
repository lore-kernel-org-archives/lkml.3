Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab3BQWzm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:55:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45657 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755109Ab3BQWzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:20 -0500
Message-Id: <20130217225009.055170156@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:51:05 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 64/66] tg3: Avoid null pointer dereference in tg3_interrupt  in netconsole mode
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nithin Nayak Sujir <nsujir@broadcom.com>

[ Upstream commit 9c13cb8bb477a83b9a3c9e5a5478a4e21294a760 ]

When netconsole is enabled, logging messages generated during tg3_open
can result in a null pointer dereference for the uninitialized tg3
status block. Use the irq_sync flag to disable polling in the early
stages. irq_sync is cleared when the driver is enabling interrupts after
all initialization is completed.

Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/broadcom/tg3.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 01bc102..c3197d9 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -6353,6 +6353,9 @@ static void tg3_poll_controller(struct net_device *dev)
 	int i;
 	struct tg3 *tp = netdev_priv(dev);
 
+	if (tg3_irq_sync(tp))
+		return;
+
 	for (i = 0; i < tp->irq_cnt; i++)
 		tg3_interrupt(tp->napi[i].irq_vec, &tp->napi[i]);
 }
@@ -15388,6 +15391,7 @@ static int __devinit tg3_init_one(struct pci_dev *pdev,
 	tp->pm_cap = pm_cap;
 	tp->rx_mode = TG3_DEF_RX_MODE;
 	tp->tx_mode = TG3_DEF_TX_MODE;
+	tp->irq_sync = 1;
 
 	if (tg3_debug > 0)
 		tp->msg_enable = tg3_debug;


