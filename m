Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaAWKtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:49:24 -0500
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:58608
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751977AbaAWKtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:49:23 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] regmap: fix _regmap_update_bits()
Date: Thu, 23 Jan 2014 17:50:24 +0800
Message-ID: <1390470624-28400-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since sometimes the 'config' parameter is no use, it should be NULL.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/base/regmap/regmap.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index c2e0021..737b874 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1958,9 +1958,11 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 
 	if (tmp != orig) {
 		ret = _regmap_write(map, reg, tmp);
-		*change = true;
+		if (change)
+			*change = true;
 	} else {
-		*change = false;
+		if (change)
+			*change = false;
 	}
 
 	return ret;
@@ -1979,11 +1981,10 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 int regmap_update_bits(struct regmap *map, unsigned int reg,
 		       unsigned int mask, unsigned int val)
 {
-	bool change;
 	int ret;
 
 	map->lock(map->lock_arg);
-	ret = _regmap_update_bits(map, reg, mask, val, &change);
+	ret = _regmap_update_bits(map, reg, mask, val, NULL);
 	map->unlock(map->lock_arg);
 
 	return ret;
@@ -2008,14 +2009,13 @@ EXPORT_SYMBOL_GPL(regmap_update_bits);
 int regmap_update_bits_async(struct regmap *map, unsigned int reg,
 			     unsigned int mask, unsigned int val)
 {
-	bool change;
 	int ret;
 
 	map->lock(map->lock_arg);
 
 	map->async = true;
 
-	ret = _regmap_update_bits(map, reg, mask, val, &change);
+	ret = _regmap_update_bits(map, reg, mask, val, NULL);
 
 	map->async = false;
 
-- 
1.8.4


