Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab3BLUik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:38:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757728Ab3BLUhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:37:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 21/22] tg3: Avoid null pointer dereference in tg3_interrupt in netconsole mode
Date: Tue, 12 Feb 2013 12:37:04 -0800
Message-Id: <20130212203417.540048288@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203413.459836020@linuxfoundation.org>
References: <20130212203413.459836020@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tg3.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -5662,6 +5662,9 @@ static void tg3_poll_controller(struct n
 	int i;
 	struct tg3 *tp = netdev_priv(dev);
 
+	if (tg3_irq_sync(tp))
+		return;
+
 	for (i = 0; i < tp->irq_cnt; i++)
 		tg3_interrupt(tp->napi[i].irq_vec, &tp->napi[i]);
 }
@@ -14981,6 +14984,7 @@ static int __devinit tg3_init_one(struct
 	tp->pm_cap = pm_cap;
 	tp->rx_mode = TG3_DEF_RX_MODE;
 	tp->tx_mode = TG3_DEF_TX_MODE;
+	tp->irq_sync = 1;
 
 	if (tg3_debug > 0)
 		tp->msg_enable = tg3_debug;


