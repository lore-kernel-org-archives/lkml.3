Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbbAZFYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 00:24:14 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34144 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbbAZFYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 00:24:12 -0500
Date: Mon, 26 Jan 2015 07:24:06 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: Olivier Sobrie <olivier@sobrie.be>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Andri Yngvason <andri.yngvason@marel.com>
Cc: Linux-CAN <linux-can@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 3/7] can: kvaser_usb: Retry the first bulk transfer on
 -ETIMEDOUT
Message-ID: <20150126052406.GD3014@Darwish.PC>
References: <20141223154654.GB6460@vivalin-002>
 <20150126051755.GA3014@Darwish.PC>
 <20150126052039.GB3014@Darwish.PC>
 <20150126052254.GC3014@Darwish.PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126052254.GC3014@Darwish.PC>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ahmed S. Darwish <ahmed.darwish@valeo.com>

On some x86 laptops, plugging a Kvaser device again after an
unplug makes the firmware always ignore the very first command.
For such a case, provide some room for retries instead of
completely exiting the driver init code.

Signed-off-by: Ahmed S. Darwish <ahmed.darwish@valeo.com>
---
 drivers/net/can/usb/kvaser_usb.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_usb.c
index f0c6207..55407b9 100644
--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -1585,7 +1585,7 @@ static int kvaser_usb_probe(struct usb_interface *intf,
 {
 	struct kvaser_usb *dev;
 	int err = -ENOMEM;
-	int i;
+	int i, retry = 3;
 
 	dev = devm_kzalloc(&intf->dev, sizeof(*dev), GFP_KERNEL);
 	if (!dev)
@@ -1603,7 +1603,15 @@ static int kvaser_usb_probe(struct usb_interface *intf,
 
 	usb_set_intfdata(intf, dev);
 
-	err = kvaser_usb_get_software_info(dev);
+	/* On some x86 laptops, plugging a Kvaser device again after
+	 * an unplug makes the firmware always ignore the very first
+	 * command. For such a case, provide some room for retries
+	 * instead of completely exiting the driver.
+	 */
+	do {
+		err = kvaser_usb_get_software_info(dev);
+	} while (--retry && err == -ETIMEDOUT);
+
 	if (err) {
 		dev_err(&intf->dev,
 			"Cannot get software infos, error %d\n", err);
-- 
1.7.7.6

