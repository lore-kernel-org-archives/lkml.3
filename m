Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbaBEUF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:05:27 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48124 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbaBEUFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:23 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 074/213] tg3: Avoid null pointer dereference in tg3_interrupt in netconsole mode
Date: Wed, 5 Feb 2014 15:00:29 -0500
Message-ID: <1391630568-49251-75-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nithin Nayak Sujir <nsujir@broadcom.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 9c13cb8bb477a83b9a3c9e5a5478a4e21294a760 upstream.

When netconsole is enabled, logging messages generated during tg3_open
can result in a null pointer dereference for the uninitialized tg3
status block. Use the irq_sync flag to disable polling in the early
stages. irq_sync is cleared when the driver is enabling interrupts after
all initialization is completed.

Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[PG: drivers/net/ethernet/broadcom/tg3.c --> drivers/net/tg3.c in .34]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/tg3.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index ecc41cffb470..e6045d1998af 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -5278,6 +5278,9 @@ static void tg3_poll_controller(struct net_device *dev)
 	int i;
 	struct tg3 *tp = netdev_priv(dev);
 
+	if (tg3_irq_sync(tp))
+		return;
+
 	for (i = 0; i < tp->irq_cnt; i++)
 		tg3_interrupt(tp->napi[i].irq_vec, &tp->napi[i]);
 }
@@ -14476,6 +14479,7 @@ static int __devinit tg3_init_one(struct pci_dev *pdev,
 	tp->pm_cap = pm_cap;
 	tp->rx_mode = TG3_DEF_RX_MODE;
 	tp->tx_mode = TG3_DEF_TX_MODE;
+	tp->irq_sync = 1;
 
 	if (tg3_debug > 0)
 		tp->msg_enable = tg3_debug;
-- 
1.8.5.2

