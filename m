Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbaHYM53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 08:57:29 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:49480 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634AbaHYM52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 08:57:28 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Adam.Thomson.Opensource@diasemi.com,
        knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iio: core: Propagate error codes from OF layer to client drivers
Date: Mon, 25 Aug 2014 15:57:17 +0300
Message-Id: <1408971437-10751-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not overwrite error codes returned from of_iio_channel_get().
Error codes are used to distinguish between "io-channel-names"
not present in DT bindings, property is optional, and IIO channel
provider driver still not being loaded, defer probe.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/iio/inkern.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index c749700..66a6cde 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -162,7 +162,7 @@ err_free_channel:
 static struct iio_channel *of_iio_channel_get_by_name(struct device_node *np,
 						      const char *name)
 {
-	struct iio_channel *chan = NULL;
+	struct iio_channel *chan = ERR_PTR(-ENODEV);
 
 	/* Walk up the tree of devices looking for a matching iio channel */
 	while (np) {
@@ -183,7 +183,7 @@ static struct iio_channel *of_iio_channel_get_by_name(struct device_node *np,
 		else if (name && index >= 0) {
 			pr_err("ERROR: could not get IIO channel %s:%s(%i)\n",
 				np->full_name, name ? name : "", index);
-			return NULL;
+			break;
 		}
 
 		/*
@@ -193,7 +193,7 @@ static struct iio_channel *of_iio_channel_get_by_name(struct device_node *np,
 		 */
 		np = np->parent;
 		if (np && !of_get_property(np, "io-channel-ranges", NULL))
-			return NULL;
+			break;
 	}
 
 	return chan;
@@ -243,12 +243,12 @@ error_free_chans:
 static inline struct iio_channel *
 of_iio_channel_get_by_name(struct device_node *np, const char *name)
 {
-	return NULL;
+	return ERR_PTR(-ENODEV);
 }
 
 static inline struct iio_channel *of_iio_channel_get_all(struct device *dev)
 {
-	return NULL;
+	return ERR_PTR(-ENODEV);
 }
 
 #endif /* CONFIG_OF */
@@ -312,14 +312,14 @@ struct iio_channel *iio_channel_get(struct device *dev,
 	const char *name = dev ? dev_name(dev) : NULL;
 	struct iio_channel *channel;
 
-	if (dev) {
-		channel = of_iio_channel_get_by_name(dev->of_node,
-						     channel_name);
-		if (channel != NULL)
-			return channel;
-	}
+	channel = iio_channel_get_sys(name, channel_name);
+	if (!IS_ERR(channel))
+		return channel;
+
+	if (!dev)
+		return channel;
 
-	return iio_channel_get_sys(name, channel_name);
+	return of_iio_channel_get_by_name(dev->of_node, channel_name);
 }
 EXPORT_SYMBOL_GPL(iio_channel_get);
 
-- 
1.9.1

