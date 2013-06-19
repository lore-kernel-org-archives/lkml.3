Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934143Ab3FSI1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:27:35 -0400
Received: from know-smtprelay-omc-1.server.virginmedia.net ([80.0.253.65]:60795
	"EHLO know-smtprelay-omc-1.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934089Ab3FSI1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:27:33 -0400
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Jun 2013 04:27:32 EDT
X-Originating-IP: [86.2.11.244]
X-Spam: 0
X-Authority: v=2.0 cv=RN7rhPe+ c=1 sm=1 a=n6O9K/ebToSnNVE6TGWEMw==:17
 a=xFrwVLZJWjEA:10 a=oH62K7DSUIUA:10 a=uObrxnre4hsA:10 a=8nJEP1OIZ-IA:10
 a=NLZqzBF-AAAA:8 a=1m2CDDXWOmUA:10 a=wF40tRKJAAAA:8 a=rfE2Ouawvx9tNapf_V4A:9
 a=wPNLvfGTeEIA:10 a=_dQi-Dcv4p4A:10 a=NI8CjpVk9IE8u0a0:21
 a=L_HKfa-HgEMiMFQu:21 a=n6O9K/ebToSnNVE6TGWEMw==:117
Message-ID: <51C16A07.3070903@ntlworld.com>
Date: Wed, 19 Jun 2013 09:21:27 +0100
From: Stephen Moorby <steve.moorby@ntlworld.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: davem@davemloft.net, jiri@resnulli.us, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] drivers/net: param for lapbether for specific ethernet
 device
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From 35607dd0607bca5322860703143c31cb04377764 Mon Sep 17 00:00:00 2001
From: Stephen Moorby <steve.moorby@ntlworld.com>
Date: Wed, 19 Jun 2013 08:22:51 +0100
Subject: [PATCH 1/1] drivers/net: param for lapbether for specific ethernet
  device

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
@@ -381,8 +382,14 @@ static int lapbeth_device_event(struct 
notifier_block *this,
      switch (event) {
      case NETDEV_UP:
          /* New ethernet device -> new LAPB interface     */
-        if (lapbeth_get_x25_dev(dev) == NULL)
-            lapbeth_new_device(dev);
+        if (lapbeth_get_x25_dev(dev) == NULL) {
+            if (NULL != eth_dev) {
+                if (0 == strcmp(dev->name, eth_dev))
+                    lapbeth_new_device(dev);
+            } else {
+                lapbeth_new_device(dev);
+            }
+        }
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

