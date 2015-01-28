Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164AbbA2KOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:14:48 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753307AbbA2JBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:01:19 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Ahmed S. Darwish" <ahmed.darwish@valeo.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 118/176] can: kvaser_usb: Don't send a RESET_CHIP for non-existing channels
Date: Wed, 28 Jan 2015 15:29:08 +0100
Message-Id: <735874875b034f377a1caf6dec9acc221932d7d4.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ahmed S. Darwish" <ahmed.darwish@valeo.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5e7e6e0c9b47a45576c38b4a72d67927a5e049f7 upstream.

Recent Leaf firmware versions (>= 3.1.557) do not allow to send
commands for non-existing channels.  If a command is sent for a
non-existing channel, the firmware crashes.

Reported-by: Christopher Storah <Christopher.Storah@invetech.com.au>
Signed-off-by: Olivier Sobrie <olivier@sobrie.be>
Signed-off-by: Ahmed S. Darwish <ahmed.darwish@valeo.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/can/usb/kvaser_usb.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_usb.c
index 925273ca7879..63fb90b006ba 100644
--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -1494,6 +1494,10 @@ static int kvaser_usb_init_one(struct usb_interface *intf,
 	struct kvaser_usb_net_priv *priv;
 	int i, err;
 
+	err = kvaser_usb_send_simple_msg(dev, CMD_RESET_CHIP, channel);
+	if (err)
+		return err;
+
 	netdev = alloc_candev(sizeof(*priv), MAX_TX_URBS);
 	if (!netdev) {
 		dev_err(&intf->dev, "Cannot alloc candev\n");
@@ -1597,9 +1601,6 @@ static int kvaser_usb_probe(struct usb_interface *intf,
 
 	usb_set_intfdata(intf, dev);
 
-	for (i = 0; i < MAX_NET_DEVICES; i++)
-		kvaser_usb_send_simple_msg(dev, CMD_RESET_CHIP, i);
-
 	err = kvaser_usb_get_software_info(dev);
 	if (err) {
 		dev_err(&intf->dev,
-- 
2.2.2

