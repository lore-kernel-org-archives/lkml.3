Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbaFZHvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 03:51:45 -0400
Received: from cernmx13.cern.ch ([188.184.36.46]:51850 "EHLO CERNMX13.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668AbaFZHvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 03:51:44 -0400
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jun 2014 03:51:43 EDT
From: Federico Vaga <federico.vaga@cern.ch>
To: <siglesias@igalia.com>, <jens.taprogge@taprogge.org>,
        <gregkh@linuxfoundation.org>
CC: <industrypack-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        Federico Vaga <federico.vaga@cern.ch>
Subject: [PATCH] ipoctal: protect only the real critical section
Date: Thu, 26 Jun 2014 09:46:24 +0200
Message-ID: <1403768784-21605-1-git-send-email-federico.vaga@cern.ch>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.193.223]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some conditions (echo or particular sequence of special
characters), on buffer push, the tty layer calls the write operation
while we are holding the spinlock. This means deadlock within the same
process on kernels version < 3.12. It seems not a problem on recent
kernel, but the patch still valid as locking optimization.

The protected variables by the spinlock are: xmit_buf, nb_bytes,
pointer_read and pointer_write. So, this patch reduces the locked area
in the IRQ handler only to these variables. Most of the code inside the
locked area in the IRQ handler is not protected elsewhere; it means
that it is not protected at all.

Signed-off-by: Federico Vaga <federico.vaga@cern.ch>
---
 drivers/ipack/devices/ipoctal.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 141094e..69687f1 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -177,19 +177,20 @@ static void ipoctal_irq_tx(struct ipoctal_channel *channel)
 	if (channel->nb_bytes == 0)
 		return;
 
+	spin_lock(&channel->lock);
 	value = channel->tty_port.xmit_buf[*pointer_write];
 	iowrite8(value, &channel->regs->w.thr);
 	channel->stats.tx++;
 	(*pointer_write)++;
 	*pointer_write = *pointer_write % PAGE_SIZE;
 	channel->nb_bytes--;
+	spin_unlock(&channel->lock);
 }
 
 static void ipoctal_irq_channel(struct ipoctal_channel *channel)
 {
 	u8 isr, sr;
 
-	spin_lock(&channel->lock);
 	/* The HW is organized in pair of channels.  See which register we need
 	 * to read from */
 	isr = ioread8(&channel->block_regs->r.isr);
@@ -213,8 +214,6 @@ static void ipoctal_irq_channel(struct ipoctal_channel *channel)
 	/* TX of each character */
 	if ((isr & channel->isr_tx_rdy_mask) && (sr & SR_TX_READY))
 		ipoctal_irq_tx(channel);
-
-	spin_unlock(&channel->lock);
 }
 
 static irqreturn_t ipoctal_irq_handler(void *arg)
-- 
1.7.10.4

