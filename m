Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934683AbaGXU3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 16:29:34 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:39510 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934565AbaGXU3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 16:29:32 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com, dheitmueller@kernellabs.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: drx39xyj - use drxj_set_lna_state() and remove duplicate LNA code
Date: Thu, 24 Jul 2014 14:29:28 -0600
Message-Id: <1406233768-7976-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drx39xxj_set_lna() and drx39xxj_set_frontend() set LNA. Instead of
duplicating LNA configure code, change to use drxj_set_lna_state()
which sets LNA to the caller requested state (on or off).

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---

This patch depends on previous patch that added drxj_set_lna_state().
https://lkml.org/lkml/2014/7/24/469

 drivers/media/dvb-frontends/drx39xyj/drxj.c |   29 ++-------------------------
 1 file changed, 2 insertions(+), 27 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 31fee7b..d6d2930 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -12154,13 +12154,7 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 		return -EINVAL;
 	}
 	/* Just for giggles, let's shut off the LNA again.... */
-	uio_data.uio = DRX_UIO1;
-	uio_data.value = false;
-	result = ctrl_uio_write(demod, &uio_data);
-	if (result != 0) {
-		pr_err("Failed to disable LNA!\n");
-		return 0;
-	}
+	drxj_set_lna_state(demod, false);
 
 	/* After set_frontend, except for strength, stats aren't available */
 	p->strength.stat[0].scale = FE_SCALE_RELATIVE;
@@ -12243,26 +12237,7 @@ static int drx39xxj_set_lna(struct dvb_frontend *fe)
 		}
 	}
 
-	/* Turn off the LNA */
-	uio_cfg.uio = DRX_UIO1;
-	uio_cfg.mode = DRX_UIO_MODE_READWRITE;
-	/* Configure user-I/O #3: enable read/write */
-	result = ctrl_set_uio_cfg(demod, &uio_cfg);
-	if (result) {
-		pr_err("Failed to setup LNA GPIO!\n");
-		return result;
-	}
-
-	uio_data.uio = DRX_UIO1;
-	uio_data.value = c->lna;
-	result = ctrl_uio_write(demod, &uio_data);
-	if (result != 0) {
-		pr_err("Failed to %sable LNA!\n",
-		       c->lna ? "en" : "dis");
-		return result;
-	}
-
-	return 0;
+	return drxj_set_lna_state(demod, c->lna);
 }
 
 static int drx39xxj_get_tune_settings(struct dvb_frontend *fe,
-- 
1.7.10.4

