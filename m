Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbaIVPHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:07:20 -0400
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:56349 "EHLO
	resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754021AbaIVPHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:07:14 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: m.chehab@samsung.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, crope@iki.fi, olebowle@gmx.com,
        dheitmueller@kernellabs.co, hverkuil@xs4all.nl, ramakrmu@cisco.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 4/5] media: dvb-core changes to use media tuner token api
Date: Mon, 22 Sep 2014 09:00:48 -0600
Message-Id: <cc4b6198b88277b2c0d56d288bde0e4c35e14d8b.1411397045.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1411397045.git.shuahkh@osg.samsung.com>
References: <cover.1411397045.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1411397045.git.shuahkh@osg.samsung.com>
References: <cover.1411397045.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change to hold media tuner token exclusive mode in
dvb_frontend_start() before starting the dvb thread
and release from dvb_frontend_thread() when thread
exits. dvb frontend thread is started only when the
dvb device is opened in Read/Write mode.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index c862ad7..22833c6 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -41,6 +41,7 @@
 #include <linux/jiffies.h>
 #include <linux/kthread.h>
 #include <asm/processor.h>
+#include <linux/media_tknres.h>
 
 #include "dvb_frontend.h"
 #include "dvbdev.h"
@@ -742,6 +743,7 @@ restart:
 	if (semheld)
 		up(&fepriv->sem);
 	dvb_frontend_wakeup(fe);
+	media_put_tuner_tkn(fe->dvb->device, MEDIA_MODE_DVB);
 	return 0;
 }
 
@@ -836,6 +838,13 @@ static int dvb_frontend_start(struct dvb_frontend *fe)
 	fepriv->state = FESTATE_IDLE;
 	fe->exit = DVB_FE_NO_EXIT;
 	fepriv->thread = NULL;
+
+	ret = media_get_tuner_tkn(fe->dvb->device, MEDIA_MODE_DVB);
+	if (ret == -EBUSY) {
+		dev_info(fe->dvb->device, "dvb: Tuner is busy\n");
+		return ret;
+	}
+
 	mb();
 
 	fe_thread = kthread_run(dvb_frontend_thread, fe,
@@ -846,6 +855,7 @@ static int dvb_frontend_start(struct dvb_frontend *fe)
 				"dvb_frontend_start: failed to start kthread (%d)\n",
 				ret);
 		up(&fepriv->sem);
+		media_put_tuner_tkn(fe->dvb->device, MEDIA_MODE_DVB);
 		return ret;
 	}
 	fepriv->thread = fe_thread;
-- 
1.7.10.4

