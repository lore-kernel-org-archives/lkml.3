Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaB1Dyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 22:54:35 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:18395 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751078AbaB1Dye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 22:54:34 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        <perex@perex.cz>, <tiwai@suse.de>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] ASoC: cache: Do the codec->reg_cache zero pionter check
Date: Fri, 28 Feb 2014 10:48:19 +0800
Message-ID: <1393555699-12752-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the snd_soc_cache_init(), the reg_size maybe zero and then the value
of codec->reg_cache, which is alloced via kzalloc, maybe equal to
ZERO_SIZE_PTR. If the reg parameter of snd_soc_cache_write() is large enough,
the cache[idx] = val maybe cause the kernel crash...

So this patch fix this via doing the zero pionter check of it.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/soc-cache.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/sound/soc/soc-cache.c b/sound/soc/soc-cache.c
index 375dc6d..bfed3e4 100644
--- a/sound/soc/soc-cache.c
+++ b/sound/soc/soc-cache.c
@@ -96,8 +96,7 @@ int snd_soc_cache_exit(struct snd_soc_codec *codec)
 {
 	dev_dbg(codec->dev, "ASoC: Destroying cache for %s codec\n",
 			codec->name);
-	if (!codec->reg_cache)
-		return 0;
+
 	kfree(codec->reg_cache);
 	codec->reg_cache = NULL;
 	return 0;
@@ -117,8 +116,9 @@ int snd_soc_cache_read(struct snd_soc_codec *codec,
 		return -EINVAL;
 
 	mutex_lock(&codec->cache_rw_mutex);
-	*value = snd_soc_get_cache_val(codec->reg_cache, reg,
-				       codec->driver->reg_word_size);
+	if (!ZERO_OR_NULL_PTR(codec->reg_cache))
+		*value = snd_soc_get_cache_val(codec->reg_cache, reg,
+					       codec->driver->reg_word_size);
 	mutex_unlock(&codec->cache_rw_mutex);
 
 	return 0;
@@ -136,8 +136,9 @@ int snd_soc_cache_write(struct snd_soc_codec *codec,
 			unsigned int reg, unsigned int value)
 {
 	mutex_lock(&codec->cache_rw_mutex);
-	snd_soc_set_cache_val(codec->reg_cache, reg, value,
-			      codec->driver->reg_word_size);
+	if (!ZERO_OR_NULL_PTR(codec->reg_cache))
+		snd_soc_set_cache_val(codec->reg_cache, reg, value,
+				      codec->driver->reg_word_size);
 	mutex_unlock(&codec->cache_rw_mutex);
 
 	return 0;
-- 
1.8.4


