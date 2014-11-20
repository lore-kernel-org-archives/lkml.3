Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbaKTI3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:29:48 -0500
Received: from mout.web.de ([212.227.17.12]:52803 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755854AbaKTI3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:29:46 -0500
Message-ID: <546DA65E.4020100@users.sourceforge.net>
Date: Thu, 20 Nov 2014 09:29:18 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 2/3] [media] m88ds3103: One function call less in m88ds3103_init()
 after error detection
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <546DA419.7050405@users.sourceforge.net>
In-Reply-To: <546DA419.7050405@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:MJcsOqb1fLelhqyL+CS2hkbYUJPcePrTFkdKcXC0FG5/r324Rir
 k/bgGSqURdoya7IfqPf1Spq7gUUHSpOeODBY2JPll5tWk0OGnkxaA+/LgJBICJgDv59jpC1
 wb60OMYpzJPxzMHqykGlAQ+8UgEtQyAZxt68rodtTS7rhj5IkvE19i59denepxIDHXpErR3
 wzosSKxsaRGX7yerHKgzg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 19 Nov 2014 23:20:51 +0100

The release_firmware() function was called in some cases by the
m88ds3103_init() function during error handling even if the passed variable
contained still a null pointer. This implementation detail could be improved
by the introduction of another jump label.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-frontends/m88ds3103.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index e88f0f6..82da715 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -590,7 +590,7 @@ static int m88ds3103_init(struct dvb_frontend *fe)
 
 	ret = m88ds3103_wr_reg(priv, 0xb2, 0x01);
 	if (ret)
-		goto err;
+		goto error_fw_release;
 
 	for (remaining = fw->size; remaining > 0;
 			remaining -= (priv->cfg->i2c_wr_max - 1)) {
@@ -604,13 +604,13 @@ static int m88ds3103_init(struct dvb_frontend *fe)
 			dev_err(&priv->i2c->dev,
 					"%s: firmware download failed=%d\n",
 					KBUILD_MODNAME, ret);
-			goto err;
+			goto error_fw_release;
 		}
 	}
 
 	ret = m88ds3103_wr_reg(priv, 0xb2, 0x00);
 	if (ret)
-		goto err;
+		goto error_fw_release;
 
 	release_firmware(fw);
 	fw = NULL;
@@ -636,9 +636,10 @@ skip_fw_download:
 	priv->warm = true;
 
 	return 0;
-err:
-	release_firmware(fw);
 
+error_fw_release:
+	release_firmware(fw);
+err:
 	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
-- 
2.1.3

