Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbaIALu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:50:27 -0400
Received: from cernmx11.cern.ch ([188.184.36.50]:36619 "EHLO CERNMX11.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbaIALuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:50:25 -0400
From: Federico Vaga <federico.vaga@cern.ch>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <industrypack-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        Federico Vaga <federico.vaga@cern.ch>
Subject: [PATCH] ipoctal: clear break interrupt as soon as it occurs
Date: Mon, 1 Sep 2014 13:49:56 +0200
Message-ID: <1409572196-15015-1-git-send-email-federico.vaga@cern.ch>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.193.223]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some condition we receive the break interrupt but nothing is putted
in the Rx FIFO and the correspondend bit in the status register is not
set. Thus, no-one clear the interrupt and the handler will be called
forever.

This patch clear the break interrupt as soon as it occurs. Then, if the
break character '\0' is putted in the fifo we will manage it.

We can also unmask the Break interrupt but its bit in ISR is still set
on break. So I think is better to keep the registers clean.

Signed-off-by: Federico Vaga <federico.vaga@cern.ch>
---
 drivers/ipack/devices/ipoctal.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index e41bef0..90b96a1b 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -151,7 +151,6 @@ static void ipoctal_irq_rx(struct ipoctal_channel *channel, u8 sr)
 				flag = TTY_FRAME;
 			}
 			if (sr & SR_RECEIVED_BREAK) {
-				iowrite8(CR_CMD_RESET_BREAK_CHANGE, &channel->regs->w.cr);
 				channel->stats.rcv_break++;
 				flag = TTY_BREAK;
 			}
@@ -196,6 +195,9 @@ static void ipoctal_irq_channel(struct ipoctal_channel *channel)
 	isr = ioread8(&channel->block_regs->r.isr);
 	sr = ioread8(&channel->regs->r.sr);
 
+	if (isr & (IMR_DELTA_BREAK_A | IMR_DELTA_BREAK_B))
+		iowrite8(CR_CMD_RESET_BREAK_CHANGE, &channel->regs->w.cr);
+
 	if ((sr & SR_TX_EMPTY) && (channel->nb_bytes == 0)) {
 		iowrite8(CR_DISABLE_TX, &channel->regs->w.cr);
 		/* In case of RS-485, change from TX to RX when finishing TX.
-- 
1.7.10.4

