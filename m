Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933981AbaD2Tu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:50:59 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:46685 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965167AbaD2TuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:50:18 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, m.chehab@samsung.com, tj@kernel.org,
        olebowle@gmx.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 2/4] media: dvb-fe changes to use tuner token
Date: Tue, 29 Apr 2014 13:49:24 -0600
Message-Id: <9a211011e470e91ce4367529ba74cddb7fdaee60.1398797955.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1398797954.git.shuah.kh@samsung.com>
References: <cover.1398797954.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1398797954.git.shuah.kh@samsung.com>
References: <cover.1398797954.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new field tuner_tkn to struct dvb_frontend. Drivers can
create tuner token using devm_token_create() and initialize
the tuner_tkn when frontend is registered with the dvb-core.
This change enables drivers to provide a token devres for tuner
access control.

Change dvb_frontend to lock tuner token for exclusive access to
tuner function for digital TV function use. When Tuner token is
present, dvb_frontend_start() calls devm_token_lock() to lock
the token. If token is busy, -EBUSY is returned to the user-space.
Tuner token is unlocked if kdvb adapter fe kthread fails to start.
This token is held in use as long as the kdvb adapter fe kthread
is running. Tuner token is unlocked in dvb_frontend_thread() when
kdvb adapter fe thread exits.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c |   15 +++++++++++++++
 drivers/media/dvb-core/dvb_frontend.h |    1 +
 2 files changed, 16 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 6ce435a..2b35e3f 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -41,6 +41,7 @@
 #include <linux/jiffies.h>
 #include <linux/kthread.h>
 #include <asm/processor.h>
+#include <linux/token_devres.h>
 
 #include "dvb_frontend.h"
 #include "dvbdev.h"
@@ -747,6 +748,9 @@ restart:
 	if (semheld)
 		up(&fepriv->sem);
 	dvb_frontend_wakeup(fe);
+
+	if (fe->tuner_tkn)
+		devm_token_unlock(fe->dvb->device, fe->tuner_tkn);
 	return 0;
 }
 
@@ -840,6 +844,15 @@ static int dvb_frontend_start(struct dvb_frontend *fe)
 	fepriv->state = FESTATE_IDLE;
 	fepriv->exit = DVB_FE_NO_EXIT;
 	fepriv->thread = NULL;
+
+	if (fe->tuner_tkn) {
+		ret = devm_token_lock(fe->dvb->device, fe->tuner_tkn);
+		if (ret) {
+			dev_info(fe->dvb->device, "Tuner is busy %d\n", ret);
+			return ret;
+		}
+	}
+
 	mb();
 
 	fe_thread = kthread_run(dvb_frontend_thread, fe,
@@ -850,6 +863,8 @@ static int dvb_frontend_start(struct dvb_frontend *fe)
 				"dvb_frontend_start: failed to start kthread (%d)\n",
 				ret);
 		up(&fepriv->sem);
+		if (fe->tuner_tkn)
+			devm_token_unlock(fe->dvb->device, fe->tuner_tkn);
 		return ret;
 	}
 	fepriv->thread = fe_thread;
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 371b6ca..c9ba5fd 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -418,6 +418,7 @@ struct dvb_frontend {
 #define DVB_FRONTEND_COMPONENT_DEMOD 1
 	int (*callback)(void *adapter_priv, int component, int cmd, int arg);
 	int id;
+	char *tuner_tkn;
 };
 
 extern int dvb_register_frontend(struct dvb_adapter *dvb,
-- 
1.7.10.4

