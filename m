Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbbAYS3J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:29:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbbAYSK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christopher Storah <Christopher.Storah@invetech.com.au>,
        Olivier Sobrie <olivier@sobrie.be>,
        "Ahmed S. Darwish" <ahmed.darwish@valeo.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.18 157/183] can: kvaser_usb: Dont send a RESET_CHIP for non-existing channels
Date: Sun, 25 Jan 2015 10:07:59 -0800
Message-Id: <20150125180817.000163083@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Ahmed S. Darwish" <ahmed.darwish@valeo.com>

commit 5e7e6e0c9b47a45576c38b4a72d67927a5e049f7 upstream.

Recent Leaf firmware versions (>= 3.1.557) do not allow to send
commands for non-existing channels.  If a command is sent for a
non-existing channel, the firmware crashes.

Reported-by: Christopher Storah <Christopher.Storah@invetech.com.au>
Signed-off-by: Olivier Sobrie <olivier@sobrie.be>
Signed-off-by: Ahmed S. Darwish <ahmed.darwish@valeo.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/usb/kvaser_usb.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -1503,6 +1503,10 @@ static int kvaser_usb_init_one(struct us
 	struct kvaser_usb_net_priv *priv;
 	int i, err;
 
+	err = kvaser_usb_send_simple_msg(dev, CMD_RESET_CHIP, channel);
+	if (err)
+		return err;
+
 	netdev = alloc_candev(sizeof(*priv), MAX_TX_URBS);
 	if (!netdev) {
 		dev_err(&intf->dev, "Cannot alloc candev\n");
@@ -1607,9 +1611,6 @@ static int kvaser_usb_probe(struct usb_i
 
 	usb_set_intfdata(intf, dev);
 
-	for (i = 0; i < MAX_NET_DEVICES; i++)
-		kvaser_usb_send_simple_msg(dev, CMD_RESET_CHIP, i);
-
 	err = kvaser_usb_get_software_info(dev);
 	if (err) {
 		dev_err(&intf->dev,


