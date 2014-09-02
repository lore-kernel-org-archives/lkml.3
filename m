Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbaIBPcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:32:06 -0400
Received: from cernmx11.cern.ch ([188.184.36.50]:23796 "EHLO CERNMX11.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbaIBPcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:32:04 -0400
From: Federico Vaga <federico.vaga@cern.ch>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <industrypack-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        Federico Vaga <federico.vaga@cern.ch>
Subject: [PATCH 3/3] ipoctal: get carrier driver to avoid rmmod
Date: Tue, 2 Sep 2014 17:31:41 +0200
Message-ID: <1409671901-4009-4-git-send-email-federico.vaga@cern.ch>
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
 drivers/ipack/devices/ipoctal.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index e531379..035d544 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -55,6 +55,12 @@ struct ipoctal {
 	u8 __iomem			*int_space;
 };
 
+static inline struct ipoctal *chan_to_ipoctal(struct ipoctal_channel *chan,
+					      unsigned int index)
+{
+	return container_of(chan, struct ipoctal, channel[index]);
+}
+
 static void ipoctal_reset_channel(struct ipoctal_channel *channel)
 {
 	iowrite8(CR_DISABLE_RX | CR_DISABLE_TX, &channel->regs->w.cr);
@@ -82,12 +88,20 @@ static int ipoctal_port_activate(struct tty_port *port, struct tty_struct *tty)
 
 static int ipoctal_open(struct tty_struct *tty, struct file *file)
 {
-	struct ipoctal_channel *channel;
+	struct ipoctal_channel *channel = dev_get_drvdata(tty->dev);
+	struct ipoctal *ipoctal = chan_to_ipoctal(channel, tty->index);
+	int err;
 
-	channel = dev_get_drvdata(tty->dev);
 	tty->driver_data = channel;
 
-	return tty_port_open(&channel->tty_port, tty, file);
+	if (!ipack_get_carrier(ipoctal->dev))
+		return -EBUSY;
+
+	err = tty_port_open(&channel->tty_port, tty, file);
+	if (err)
+		ipack_put_carrier(ipoctal->dev);
+
+	return err;
 }
 
 static void ipoctal_reset_stats(struct ipoctal_stats *stats)
@@ -631,6 +645,15 @@ static void ipoctal_shutdown(struct tty_struct *tty)
 	clear_bit(ASYNCB_INITIALIZED, &channel->tty_port.flags);
 }
 
+static void ipoctal_cleanup(struct tty_struct *tty)
+{
+	struct ipoctal_channel *channel = tty->driver_data;
+	struct ipoctal *ipoctal = chan_to_ipoctal(channel, tty->index);
+
+	/* release the carrier driver */
+	ipack_put_carrier(ipoctal->dev);
+}
+
 static const struct tty_operations ipoctal_fops = {
 	.ioctl =		NULL,
 	.open =			ipoctal_open,
@@ -642,6 +665,7 @@ static const struct tty_operations ipoctal_fops = {
 	.get_icount =		ipoctal_get_icount,
 	.hangup =		ipoctal_hangup,
 	.shutdown =		ipoctal_shutdown,
+	.cleanup =              ipoctal_cleanup,
 };
 
 static int ipoctal_probe(struct ipack_device *dev)
-- 
1.7.10.4

