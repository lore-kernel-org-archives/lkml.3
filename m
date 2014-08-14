Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbaHNBJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 21:09:56 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:59816 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753075AbaHNBJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 21:09:30 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com, fabf@skynet.be
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] media: tuner xc5000 - try to avoid firmware load in resume path
Date: Wed, 13 Aug 2014 19:09:24 -0600
Message-Id: <142647dac9ba7b1cb56f1f7ea2937d318fab2e4a.1407977791.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1407977791.git.shuah.kh@samsung.com>
References: <cover.1407977791.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1407977791.git.shuah.kh@samsung.com>
References: <cover.1407977791.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xc5000 doesn't load firmware at attach time instead loads it
when it needs to set and change configuration from its init,
frequency, digital and analog mode set interffaces. As a result,
when system is suspended before firmware is loaded, firmware
load can be avoided during resume. Loading formware in this
scenario results in slowpath warnings during resume as it won't
be in the suspend firmware cache.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/tuners/xc5000.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index 31b1dec..d853cb3 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -1293,6 +1293,20 @@ static int xc5000_suspend(struct dvb_frontend *fe)
 	return 0;
 }
 
+static int xc5000_resume(struct dvb_frontend *fe)
+{
+	struct xc5000_priv *priv = fe->tuner_priv;
+
+	dprintk(1, "%s()\n", __func__);
+
+	/* suspended before firmware is loaded.
+	   Avoid firmware load in resume path. */
+	if (!priv->firmware)
+		return 0;
+
+	return xc5000_set_params(fe);
+}
+
 static int xc5000_init(struct dvb_frontend *fe)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
@@ -1360,7 +1374,7 @@ static const struct dvb_tuner_ops xc5000_tuner_ops = {
 	.init		   = xc5000_init,
 	.sleep		   = xc5000_sleep,
 	.suspend	   = xc5000_suspend,
-	.resume		   = xc5000_set_params,
+	.resume		   = xc5000_resume,
 
 	.set_config	   = xc5000_set_config,
 	.set_params	   = xc5000_set_digital_params,
-- 
1.7.10.4

