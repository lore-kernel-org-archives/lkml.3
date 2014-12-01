Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770AbaLAWgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:36:13 -0500
Received: from mout.web.de ([212.227.17.11]:55468 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932636AbaLAWgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:36:08 -0500
Message-ID: <547CED4A.9000207@users.sourceforge.net>
Date: Mon, 01 Dec 2014 23:35:54 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 2/2] [media] mn88473: One function call less in mn88473_init()
 after error detection
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <547CEBF5.4040004@users.sourceforge.net>
In-Reply-To: <547CEBF5.4040004@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:b6zOUHHH5owZzw6MxhpoUHK0M3qlX9J7Z5wuauNDzaV/ON/vzKC
 stTL5blL/+EGr1Csd7Qvbvpq4UPy1YqNVZoGPQOXR8MWUEe7d5EImKD3qxcPOXSG9fCDUjk
 JgfK6plnNrZXnuoLYELpszW52tBt+eSisCxeWjchvChJbA2PtK2HC6yTE3Nt6g/V1fY7mgP
 RIIDmqeuAvodEuztcG1nA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 1 Dec 2014 23:15:20 +0100

The release_firmware() function was called by the mn88473_init() function even
if a previous function call "request_firmware" failed.
This implementation detail could be improved by the introduction of another
jump label.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/staging/media/mn88473/mn88473.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/mn88473/mn88473.c b/drivers/staging/media/mn88473/mn88473.c
index 52180bb..a333744 100644
--- a/drivers/staging/media/mn88473/mn88473.c
+++ b/drivers/staging/media/mn88473/mn88473.c
@@ -225,7 +225,7 @@ static int mn88473_init(struct dvb_frontend *fe)
 	ret = request_firmware(&fw, fw_file, &client->dev);
 	if (ret) {
 		dev_err(&client->dev, "firmare file '%s' not found\n", fw_file);
-		goto err;
+		goto err_request_firmware;
 	}
 
 	dev_info(&client->dev, "downloading firmware from file '%s'\n",
@@ -261,9 +261,10 @@ static int mn88473_init(struct dvb_frontend *fe)
 	dev->warm = true;
 
 	return 0;
+
 err:
 	release_firmware(fw);
-
+err_request_firmware:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
-- 
2.1.3

