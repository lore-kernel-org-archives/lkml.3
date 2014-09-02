Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaIBPcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:32:10 -0400
Received: from cernmx11.cern.ch ([188.184.36.50]:23796 "EHLO CERNMX11.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbaIBPcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:32:02 -0400
From: Federico Vaga <federico.vaga@cern.ch>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <industrypack-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        Federico Vaga <federico.vaga@cern.ch>
Subject: [PATCH 1/3] ipoctal: reset function istead of duplicate code
Date: Tue, 2 Sep 2014 17:31:39 +0200
Message-ID: <1409671901-4009-2-git-send-email-federico.vaga@cern.ch>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409671901-4009-1-git-send-email-federico.vaga@cern.ch>
References: <1409671901-4009-1-git-send-email-federico.vaga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.193.223]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Federico Vaga <federico.vaga@cern.ch>
---
 drivers/ipack/devices/ipoctal.c |   35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 90b96a1b..e531379 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -55,6 +55,16 @@ struct ipoctal {
 	u8 __iomem			*int_space;
 };
 
+static void ipoctal_reset_channel(struct ipoctal_channel *channel)
+{
+	iowrite8(CR_DISABLE_RX | CR_DISABLE_TX, &channel->regs->w.cr);
+	channel->rx_enable = 0;
+	iowrite8(CR_CMD_RESET_RX, &channel->regs->w.cr);
+	iowrite8(CR_CMD_RESET_TX, &channel->regs->w.cr);
+	iowrite8(CR_CMD_RESET_ERR_STATUS, &channel->regs->w.cr);
+	iowrite8(CR_CMD_RESET_MR, &channel->regs->w.cr);
+}
+
 static int ipoctal_port_activate(struct tty_port *port, struct tty_struct *tty)
 {
 	struct ipoctal_channel *channel;
@@ -306,10 +316,7 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 			channel->isr_rx_rdy_mask = ISR_RxRDY_FFULL_A;
 		}
 
-		iowrite8(CR_DISABLE_RX | CR_DISABLE_TX, &channel->regs->w.cr);
-		channel->rx_enable = 0;
-		iowrite8(CR_CMD_RESET_RX, &channel->regs->w.cr);
-		iowrite8(CR_CMD_RESET_TX, &channel->regs->w.cr);
+		ipoctal_reset_channel(channel);
 		iowrite8(MR1_CHRL_8_BITS | MR1_ERROR_CHAR | MR1_RxINT_RxRDY,
 			 &channel->regs->w.mr); /* mr1 */
 		iowrite8(0, &channel->regs->w.mr); /* mr2 */
@@ -469,11 +476,7 @@ static void ipoctal_set_termios(struct tty_struct *tty,
 	cflag = tty->termios.c_cflag;
 
 	/* Disable and reset everything before change the setup */
-	iowrite8(CR_DISABLE_RX | CR_DISABLE_TX, &channel->regs->w.cr);
-	iowrite8(CR_CMD_RESET_RX, &channel->regs->w.cr);
-	iowrite8(CR_CMD_RESET_TX, &channel->regs->w.cr);
-	iowrite8(CR_CMD_RESET_ERR_STATUS, &channel->regs->w.cr);
-	iowrite8(CR_CMD_RESET_MR, &channel->regs->w.cr);
+	ipoctal_reset_channel(channel);
 
 	/* Set Bits per chars */
 	switch (cflag & CSIZE) {
@@ -611,12 +614,7 @@ static void ipoctal_hangup(struct tty_struct *tty)
 
 	tty_port_hangup(&channel->tty_port);
 
-	iowrite8(CR_DISABLE_RX | CR_DISABLE_TX, &channel->regs->w.cr);
-	channel->rx_enable = 0;
-	iowrite8(CR_CMD_RESET_RX, &channel->regs->w.cr);
-	iowrite8(CR_CMD_RESET_TX, &channel->regs->w.cr);
-	iowrite8(CR_CMD_RESET_ERR_STATUS, &channel->regs->w.cr);
-	iowrite8(CR_CMD_RESET_MR, &channel->regs->w.cr);
+	ipoctal_reset_channel(channel);
 
 	clear_bit(ASYNCB_INITIALIZED, &channel->tty_port.flags);
 	wake_up_interruptible(&channel->tty_port.open_wait);
@@ -629,12 +627,7 @@ static void ipoctal_shutdown(struct tty_struct *tty)
 	if (channel == NULL)
 		return;
 
-	iowrite8(CR_DISABLE_RX | CR_DISABLE_TX, &channel->regs->w.cr);
-	channel->rx_enable = 0;
-	iowrite8(CR_CMD_RESET_RX, &channel->regs->w.cr);
-	iowrite8(CR_CMD_RESET_TX, &channel->regs->w.cr);
-	iowrite8(CR_CMD_RESET_ERR_STATUS, &channel->regs->w.cr);
-	iowrite8(CR_CMD_RESET_MR, &channel->regs->w.cr);
+	ipoctal_reset_channel(channel);
 	clear_bit(ASYNCB_INITIALIZED, &channel->tty_port.flags);
 }
 
-- 
1.7.10.4

