Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab3FDWmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:42:47 -0400
Received: from 1wt.eu ([62.212.114.60]:35555 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312Ab3FDWmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:44 -0400
Message-Id: <20130604172134.206916425@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:04 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 094/184] tg3: Avoid null pointer dereference in tg3_interrupt
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 in netconsole mode

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/tg3.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index fd6622c..89aa69c 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -4994,6 +4994,9 @@ static void tg3_poll_controller(struct net_device *dev)
 	int i;
 	struct tg3 *tp = netdev_priv(dev);
 
+	if (tg3_irq_sync(tp))
+		return;
+
 	for (i = 0; i < tp->irq_cnt; i++)
 		tg3_interrupt(tp->napi[i].irq_vec, &tp->napi[i]);
 }
@@ -13888,6 +13891,7 @@ static int __devinit tg3_init_one(struct pci_dev *pdev,
 	tp->pm_cap = pm_cap;
 	tp->rx_mode = TG3_DEF_RX_MODE;
 	tp->tx_mode = TG3_DEF_TX_MODE;
+	tp->irq_sync = 1;
 
 	if (tg3_debug > 0)
 		tp->msg_enable = tg3_debug;
-- 
1.7.12.2.21.g234cd45.dirty



