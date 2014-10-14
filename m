Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbaJNO7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:59:36 -0400
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:34288 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932543AbaJNO7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:59:30 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: m.chehab@samsung.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, crope@iki.fi, olebowle@gmx.com,
        dheitmueller@kernellabs.com, hverkuil@xs4all.nl, ramakrmu@cisco.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        perex@perex.cz, tiwai@suse.de, prabhakar.csengg@gmail.com,
        tim.gardner@canonical.com, linux@eikelenboom.it
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/6] media: dvb-core changes to use media token api
Date: Tue, 14 Oct 2014 08:58:40 -0600
Message-Id: <6053de8c5ffb036ef5c4d4813072ceec6e57e326.1413246372.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1413246370.git.shuahkh@osg.samsung.com>
References: <cover.1413246370.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1413246370.git.shuahkh@osg.samsung.com>
References: <cover.1413246370.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change dvb_frontend_open() to hold tuner and audio tokens
when frontend is opened in R/W mode. Tuner and audio tokens
are released when frontend is released in frontend exit state.
This change allows main dvb application process to hold the
tokens for all threads it creates and be able to handle channel
change requests without releasing the tokens thereby risking
loosing tokens to another application.

Note that media_get_tuner_tkn() will do a get on audio token
and return with both tuner and audio tokens locked. When tuner
token released using media_put_tuner_tkn() , audio token is
released. Initialize dev_parent field struct video_device to
enable media tuner token lookup from v4l2-core.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index b8579ee..fcf5f08 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -41,6 +41,7 @@
 #include <linux/jiffies.h>
 #include <linux/kthread.h>
 #include <asm/processor.h>
+#include <linux/media_tknres.h>
 
 #include "dvb_frontend.h"
 #include "dvbdev.h"
@@ -2499,9 +2500,15 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
 		fepriv->tone = -1;
 		fepriv->voltage = -1;
 
+		/* get tuner and audio tokens - device is opened in R/W */
+		ret = media_get_tuner_tkn(fe->dvb->device);
+		if (ret == -EBUSY) {
+			dev_info(fe->dvb->device, "dvb: Tuner is busy\n");
+			goto err2;
+		}
 		ret = dvb_frontend_start (fe);
 		if (ret)
-			goto err2;
+			goto start_err;
 
 		/*  empty event queue */
 		fepriv->events.eventr = fepriv->events.eventw = 0;
@@ -2511,6 +2518,8 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
 		mutex_unlock (&adapter->mfe_lock);
 	return ret;
 
+start_err:
+	media_put_tuner_tkn(fe->dvb->device);
 err2:
 	dvb_generic_release(inode, file);
 err1:
@@ -2542,6 +2551,9 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
 		wake_up(&fepriv->wait_queue);
 		if (fe->exit != DVB_FE_NO_EXIT)
 			wake_up(&dvbdev->wait_queue);
+		/* release token if fe is in exit state */
+		else
+			media_put_tuner_tkn(fe->dvb->device);
 		if (fe->ops.ts_bus_ctrl)
 			fe->ops.ts_bus_ctrl(fe, 0);
 	}
-- 
1.7.10.4

