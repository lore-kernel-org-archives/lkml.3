Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab3CZRzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:55:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14679 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab3CZRgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:13 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=GCV4Q67ITfwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ho8QEOVhyT0A:10 a=Q-fNiiVtAAAA:8 a=J1Y8HTJGAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=lcTMV_K9oDIA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173605.370705281@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 34/86] tg3: Avoid null pointer dereference in tg3_interrupt in netconsole
 mode
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0034-tg3-Avoid-null-pointer-dereference-in-tg3_interrupt-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

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
---
 drivers/net/ethernet/broadcom/tg3.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 711eb14..5c2bae8 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -6703,6 +6703,9 @@ static void tg3_poll_controller(struct net_device *dev)
 	int i;
 	struct tg3 *tp = netdev_priv(dev);
 
+	if (tg3_irq_sync(tp))
+		return;
+
 	for (i = 0; i < tp->irq_cnt; i++)
 		tg3_interrupt(tp->napi[i].irq_vec, &tp->napi[i]);
 }
@@ -15806,6 +15809,7 @@ static int __devinit tg3_init_one(struct pci_dev *pdev,
 	tp->pm_cap = pm_cap;
 	tp->rx_mode = TG3_DEF_RX_MODE;
 	tp->tx_mode = TG3_DEF_TX_MODE;
+	tp->irq_sync = 1;
 
 	if (tg3_debug > 0)
 		tp->msg_enable = tg3_debug;
-- 
1.7.10.4


