Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934114AbaGXQCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 12:02:54 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:55174
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933693AbaGXQCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 12:02:20 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com, olebowle@gmx.com, dheitmueller@kernellabs.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] media: drx39xyj - add resume support
Date: Thu, 24 Jul 2014 10:02:15 -0600
Message-Id: <a5094ff11ea86fc0c4609956fcf7223ea1d308e4.1406215947.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1406215947.git.shuah.kh@samsung.com>
References: <cover.1406215947.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1406215947.git.shuah.kh@samsung.com>
References: <cover.1406215947.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drx39xyj driver lacks resume support. Add support by changing
its fe ops init interface to detect the resume status by checking
fe exit flag and do the necessary initialization. With this change,
driver resume correctly in both dvb adapter is not in use and in use
by an application cases.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c |   65 +++++++++++++++++----------
 1 file changed, 42 insertions(+), 23 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index c3931cc..31fee7b 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -11315,6 +11315,7 @@ rw_error:
 static int drx_ctrl_u_code(struct drx_demod_instance *demod,
 		       struct drxu_code_info *mc_info,
 		       enum drxu_code_action action);
+static int drxj_set_lna_state(struct drx_demod_instance *demod, bool state);
 
 /**
 * \fn drxj_open()
@@ -11527,6 +11528,7 @@ static int drxj_open(struct drx_demod_instance *demod)
 	ext_attr->aud_data = drxj_default_aud_data_g;
 
 	demod->my_common_attr->is_opened = true;
+	drxj_set_lna_state(demod, false);
 	return 0;
 rw_error:
 	common_attr->is_opened = false;
@@ -11890,6 +11892,33 @@ release:
 	return rc;
 }
 
+/* caller is expeced to check if lna is supported before enabling */
+static int drxj_set_lna_state(struct drx_demod_instance *demod, bool state)
+{
+	struct drxuio_cfg uio_cfg;
+	struct drxuio_data uio_data;
+	int result;
+
+	uio_cfg.uio = DRX_UIO1;
+	uio_cfg.mode = DRX_UIO_MODE_READWRITE;
+	/* Configure user-I/O #3: enable read/write */
+	result = ctrl_set_uio_cfg(demod, &uio_cfg);
+	if (result) {
+		pr_err("Failed to setup LNA GPIO!\n");
+		return result;
+	}
+
+	uio_data.uio = DRX_UIO1;
+	uio_data.value = state;
+	result = ctrl_uio_write(demod, &uio_data);
+	if (result != 0) {
+		pr_err("Failed to %sable LNA!\n",
+		       state ? "en" : "dis");
+		return result;
+	}
+	return 0;
+}
+
 /*
  * The Linux DVB Driver for Micronas DRX39xx family (drx3933j)
  *
@@ -12180,10 +12209,20 @@ static int drx39xxj_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 
 static int drx39xxj_init(struct dvb_frontend *fe)
 {
-	/* Bring the demod out of sleep */
-	drx39xxj_set_powerstate(fe, 1);
+	struct drx39xxj_state *state = fe->demodulator_priv;
+	struct drx_demod_instance *demod = state->demod;
+	int rc = 0;
 
-	return 0;
+	if (fe->exit == DVB_FE_DEVICE_RESUME) {
+		/* so drxj_open() does what it needs to do */
+		demod->my_common_attr->is_opened = false;
+		rc = drxj_open(demod);
+		if (rc != 0)
+			pr_err("drx39xxj_init(): DRX open failed rc=%d!\n", rc);
+	} else
+		drx39xxj_set_powerstate(fe, 1);
+
+	return rc;
 }
 
 static int drx39xxj_set_lna(struct dvb_frontend *fe)
@@ -12261,8 +12300,6 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	struct drxj_data *demod_ext_attr = NULL;
 	struct drx_demod_instance *demod = NULL;
 	struct dtv_frontend_properties *p;
-	struct drxuio_cfg uio_cfg;
-	struct drxuio_data uio_data;
 	int result;
 
 	/* allocate memory for the internal state */
@@ -12315,24 +12352,6 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 		goto error;
 	}
 
-	/* Turn off the LNA */
-	uio_cfg.uio = DRX_UIO1;
-	uio_cfg.mode = DRX_UIO_MODE_READWRITE;
-	/* Configure user-I/O #3: enable read/write */
-	result = ctrl_set_uio_cfg(demod, &uio_cfg);
-	if (result) {
-		pr_err("Failed to setup LNA GPIO!\n");
-		goto error;
-	}
-
-	uio_data.uio = DRX_UIO1;
-	uio_data.value = false;
-	result = ctrl_uio_write(demod, &uio_data);
-	if (result != 0) {
-		pr_err("Failed to disable LNA!\n");
-		goto error;
-	}
-
 	/* create dvb_frontend */
 	memcpy(&state->frontend.ops, &drx39xxj_ops,
 	       sizeof(struct dvb_frontend_ops));
-- 
1.7.10.4

