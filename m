Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433AbaFUPKE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 11:10:04 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:39643 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758403AbaFUPKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 11:10:00 -0400
Date: Sat, 21 Jun 2014 20:39:51 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] Staging: rtl8192e: adjust error handling
Message-ID: <20140621150951.GA3418@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a test in error handling code by adding a return
path.

The Coccinelle semantic match that found the problem is:

// <smpl>
@@
expression E,E1,E2;
@@

E = alloc_etherdev(...)
... when != E = E1
if (...) { ... free_netdev(E); ... return ...; }
... when != E = E2
(
  if (...)
   {
   ... when != free_netdev(E);
   return dev; }
|
* if (...)
   {
   ... when != free_netdev(E);
   return ...; }
|
register_netdev(E)
)

// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/staging/rtl8192e/rtllib_module.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtllib_module.c b/drivers/staging/rtl8192e/rtllib_module.c
index 136909e..ba95149 100644
--- a/drivers/staging/rtl8192e/rtllib_module.c
+++ b/drivers/staging/rtl8192e/rtllib_module.c
@@ -111,7 +111,7 @@ struct net_device *alloc_rtllib(int sizeof_priv)
 	dev = alloc_etherdev(sizeof(struct rtllib_device) + sizeof_priv);
 	if (!dev) {
 		RTLLIB_ERROR("Unable to network device.\n");
-		goto failed;
+		return NULL;
 	}
 	ieee = (struct rtllib_device *)netdev_priv_rsl(dev);
 	memset(ieee, 0, sizeof(struct rtllib_device)+sizeof_priv);
@@ -180,8 +180,7 @@ struct net_device *alloc_rtllib(int sizeof_priv)
 	return dev;
 
  failed:
-	if (dev)
-		free_netdev(dev);
+	free_netdev(dev);
 	return NULL;
 }
 EXPORT_SYMBOL(alloc_rtllib);
-- 
1.9.1

