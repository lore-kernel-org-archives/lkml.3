Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbaKTIj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:39:58 -0500
Received: from mout.web.de ([212.227.17.12]:52435 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbaKTIj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:39:57 -0500
Message-ID: <546DA8BF.70005@users.sourceforge.net>
Date: Thu, 20 Nov 2014 09:39:27 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 3/3] [media] si2168: One function call less in si2168_init()
 after error detection
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <546DA419.7050405@users.sourceforge.net>
In-Reply-To: <546DA419.7050405@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:rCRalrcfXkxdxLrAN2C9QNaa7SH3haOq3pAdSkF+np+d6mfyeDW
 GEmpIbCD21e/ZFdpg82cxyW/6uJjb2MYnR++yOb8plHBvjSUZjXGJaAHMtLj/zCpuVv/72G
 FZ1KGGezSs9EmgHYCmSW6ASshJ/zGiQWSNrtkIPBaQj6b1cNvQ/k2JFG7kHwnPYubhKdPuw
 9xChEinSJ0evx+6l/2JIA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 19 Nov 2014 23:23:15 +0100

The release_firmware() function was called in some cases by the
si2168_init() function during error handling even if the passed variable
contained still a null pointer. This implementation detail could be improved
by the introduction of another jump label.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-frontends/si2168.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 6a455f9..b8c6372 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -428,7 +428,7 @@ static int si2168_init(struct dvb_frontend *fe)
 			dev_err(&s->client->dev,
 					"%s: firmware file '%s' not found\n",
 					KBUILD_MODNAME, fw_file);
-			goto err;
+			goto error_fw_release;
 		}
 	}
 
@@ -448,7 +448,7 @@ static int si2168_init(struct dvb_frontend *fe)
 			dev_err(&s->client->dev,
 					"%s: firmware download failed=%d\n",
 					KBUILD_MODNAME, ret);
-			goto err;
+			goto error_fw_release;
 		}
 	}
 
@@ -468,9 +468,10 @@ static int si2168_init(struct dvb_frontend *fe)
 	s->active = true;
 
 	return 0;
-err:
-	release_firmware(fw);
 
+error_fw_release:
+	release_firmware(fw);
+err:
 	dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
-- 
2.1.3

