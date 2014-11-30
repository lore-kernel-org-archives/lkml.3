Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbaK3U27 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 15:28:59 -0500
Received: from mout.web.de ([212.227.15.3]:55139 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbaK3U25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 15:28:57 -0500
Message-ID: <547B7DF8.8020601@users.sourceforge.net>
Date: Sun, 30 Nov 2014 21:28:40 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 2/2] [media] tuners-si2157: One function call less in si2157_init()
 after error detection
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <547B7C36.1070600@users.sourceforge.net>
In-Reply-To: <547B7C36.1070600@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:VLanTlNKvVoTxg92Lm6d81kGNjwT7ItBWH6H4nPSr4tCwXsdLRG
 0aXvDKboanqAmqrS2acdtK4pIB48K+CHWCLGJbXLSBPW4buy9s/hHxcTzyw6xs/FOMwzr7E
 EqXJAU7DozbgXvISYzFt15AGluOrdPNqFjP3mLDMVw9/F5T1f8K1uCEQgVHkv7SLjLoaLP2
 VMdiaSakWLxUVkvIq5uow==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 30 Nov 2014 20:48:24 +0100

The release_firmware() function was called in some cases by the si2157_init()
function during error handling even if the passed variable contained still
a null pointer. This implementation detail could be improved
by the introduction of another jump label.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/tuners/si2157.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index e17ab1f..2180de9 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -157,7 +157,7 @@ static int si2157_init(struct dvb_frontend *fe)
 		dev_err(&s->client->dev, "firmware file '%s' is invalid\n",
 				fw_file);
 		ret = -EINVAL;
-		goto err;
+		goto fw_release_exit;
 	}
 
 	dev_info(&s->client->dev, "downloading firmware from file '%s'\n",
@@ -173,7 +173,7 @@ static int si2157_init(struct dvb_frontend *fe)
 			dev_err(&s->client->dev,
 					"firmware download failed=%d\n",
 					ret);
-			goto err;
+			goto fw_release_exit;
 		}
 	}
 
@@ -195,9 +195,9 @@ warm:
 	s->active = true;
 	return 0;
 
-err:
+fw_release_exit:
 	release_firmware(fw);
-
+err:
 	dev_dbg(&s->client->dev, "failed=%d\n", ret);
 	return ret;
 }
-- 
2.1.3

