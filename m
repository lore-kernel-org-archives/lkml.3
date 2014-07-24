Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933843AbaGXQCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 12:02:22 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:46203
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932464AbaGXQCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 12:02:20 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com, olebowle@gmx.com, dheitmueller@kernellabs.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] media: dvb-core add new flag exit flag value for resume
Date: Thu, 24 Jul 2014 10:02:14 -0600
Message-Id: <e40686f1c07261e606bf5eee3facf3b139e51b6c.1406215947.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1406215947.git.shuah.kh@samsung.com>
References: <cover.1406215947.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1406215947.git.shuah.kh@samsung.com>
References: <cover.1406215947.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some fe drivers will have to do additional initialization
in their fe ops.init interfaces when called during resume.
Without the additional initialization, fe and tuner driver
resume fails. A new fe exit flag value DVB_FE_DEVICE_RESUME
is necessary to detect resume case. This patch adds a new
define and changes dvb_frontend_resume() to set it prior to
calling fe init and tuner init calls and resets it back to
DVB_FE_NO_EXIT once fe and tuner init is done.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c |    2 ++
 drivers/media/dvb-core/dvb_frontend.h |    1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index c833220..7c7f35c 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2568,12 +2568,14 @@ int dvb_frontend_resume(struct dvb_frontend *fe)
 	dev_dbg(fe->dvb->device, "%s: adap=%d fe=%d\n", __func__, fe->dvb->num,
 			fe->id);
 
+	fe->exit = DVB_FE_DEVICE_RESUME;
 	if (fe->ops.init)
 		ret = fe->ops.init(fe);
 
 	if (fe->ops.tuner_ops.init)
 		ret = fe->ops.tuner_ops.init(fe);
 
+	fe->exit = DVB_FE_NO_EXIT;
 	fepriv->state = FESTATE_RETUNE;
 	dvb_frontend_wakeup(fe);
 
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 625a340..d398de4 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -408,6 +408,7 @@ struct dtv_frontend_properties {
 #define DVB_FE_NO_EXIT  0
 #define DVB_FE_NORMAL_EXIT      1
 #define DVB_FE_DEVICE_REMOVED   2
+#define DVB_FE_DEVICE_RESUME    3
 
 struct dvb_frontend {
 	struct dvb_frontend_ops ops;
-- 
1.7.10.4

