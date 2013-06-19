Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934880Ab3FSP1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:27:30 -0400
Received: from know-smtprelay-omc-1.server.virginmedia.net ([80.0.253.65]:37178
	"EHLO know-smtprelay-omc-1.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934858Ab3FSP12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:27:28 -0400
X-Originating-IP: [86.2.11.244]
X-Spam: 0
X-Authority: v=2.0 cv=RN7rhPe+ c=1 sm=1 a=n6O9K/ebToSnNVE6TGWEMw==:17
 a=oH62K7DSUIUA:10 a=uObrxnre4hsA:10 a=NLZqzBF-AAAA:8 a=1m2CDDXWOmUA:10
 a=wF40tRKJAAAA:8 a=p4vZysDjZFJbH7jmPloA:9 a=_dQi-Dcv4p4A:10
 a=WZxe208khsEVdVIw:21 a=WTZQ6aMUQR_oiqzt:21 a=n6O9K/ebToSnNVE6TGWEMw==:117
From: Stephen Moorby <steve.moorby@ntlworld.com>
To: davem@davemloft.net, jiri@resnulli.us, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Stephen Moorby <steve.moorby@ntlworld.com>
Subject: [PATCH 1/1] drivers/net: param for lapbether for specific ethernet device
Date: Wed, 19 Jun 2013 16:26:53 +0100
Message-Id: <1371655613-31969-1-git-send-email-steve.moorby@ntlworld.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lapbether driver binds to the first ethernet device that comes up.
This causes problems in hardware with multiple ethernet interfaces,
potentially resulting in the LAPB traffic on the wrong interface.
Have added a module parameter 'eth_dev' to specify the ethernet
interface over which lapbether should operate.  The module behaves
as before if no device is specified.

Patch created on linux-next 18-Jun-2013.
Tested on 2.6.32-45-generic.

Signed-off-by: Stephen Moorby <steve.moorby@ntlworld.com>
---
 drivers/net/wan/lapbether.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index a33a46f..510fc4a 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -47,6 +47,7 @@
 
 #include <net/x25device.h>
 
+static char *eth_dev;
 static const u8 bcast_addr[6] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
 /* If this number is made larger, check that the temporary string buffer
@@ -381,8 +382,14 @@ static int lapbeth_device_event(struct notifier_block *this,
 	switch (event) {
 	case NETDEV_UP:
 		/* New ethernet device -> new LAPB interface	 */
-		if (lapbeth_get_x25_dev(dev) == NULL)
-			lapbeth_new_device(dev);
+		if (lapbeth_get_x25_dev(dev) == NULL) {
+			if (NULL != eth_dev) {
+				if (0 == strcmp(dev->name, eth_dev))
+					lapbeth_new_device(dev);
+			} else {
+				lapbeth_new_device(dev);
+			}
+		}
 		break;
 	case NETDEV_DOWN:	
 		/* ethernet device closed -> close LAPB interface */
@@ -446,6 +453,10 @@ static void __exit lapbeth_cleanup_driver(void)
 }
 module_exit(lapbeth_cleanup_driver);
 
+module_param(eth_dev, charp, S_IRUGO);
+MODULE_PARM_DESC(eth_dev, "Ethernet device to use");
+
+
 MODULE_AUTHOR("Jonathan Naylor <g4klx@g4klx.demon.co.uk>");
 MODULE_DESCRIPTION("The unofficial LAPB over Ethernet driver");
 MODULE_LICENSE("GPL");
-- 
1.8.1.2

