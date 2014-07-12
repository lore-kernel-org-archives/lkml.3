Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbaGLQoh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 12:44:37 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:34346
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412AbaGLQog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 12:44:36 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com, dheitmueller@kernellabs.com, olebowle@gmx.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] media: dvb-core move fe exit flag from fepriv to fe for driver access
Date: Sat, 12 Jul 2014 10:44:12 -0600
Message-Id: <0e218d94e375945cd42a6d65aae151b9ee28b34d.1405179280.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1405179280.git.shuah.kh@samsung.com>
References: <cover.1405179280.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1405179280.git.shuah.kh@samsung.com>
References: <cover.1405179280.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some fe drivers attempt to access the device for power control from
their release routines. When release routines are called after device
is disconnected, the attempts fail. fe drivers should avoid accessing
the device, from their release interfaces when called from disconnect
path. dvb-frontend maintains exit flag to keep track when fe device is
disconnected in its private data structures. Export the flag in fe to
enable drivers to check the device status from their release interfaces.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c |   26 +++++++++++---------------
 drivers/media/dvb-core/dvb_frontend.h |    5 +++++
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 6ce435a..c833220 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -96,10 +96,6 @@ MODULE_PARM_DESC(dvb_mfe_wait_time, "Wait up to <mfe_wait_time> seconds on open(
  * FESTATE_LOSTLOCK. When the lock has been lost, and we're searching it again.
  */
 
-#define DVB_FE_NO_EXIT	0
-#define DVB_FE_NORMAL_EXIT	1
-#define DVB_FE_DEVICE_REMOVED	2
-
 static DEFINE_MUTEX(frontend_mutex);
 
 struct dvb_frontend_private {
@@ -113,7 +109,6 @@ struct dvb_frontend_private {
 	wait_queue_head_t wait_queue;
 	struct task_struct *thread;
 	unsigned long release_jiffies;
-	unsigned int exit;
 	unsigned int wakeup;
 	fe_status_t status;
 	unsigned long tune_mode_flags;
@@ -565,7 +560,7 @@ static int dvb_frontend_is_exiting(struct dvb_frontend *fe)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 
-	if (fepriv->exit != DVB_FE_NO_EXIT)
+	if (fe->exit != DVB_FE_NO_EXIT)
 		return 1;
 
 	if (fepriv->dvbdev->writers == 1)
@@ -629,7 +624,7 @@ restart:
 			/* got signal or quitting */
 			if (!down_interruptible(&fepriv->sem))
 				semheld = true;
-			fepriv->exit = DVB_FE_NORMAL_EXIT;
+			fe->exit = DVB_FE_NORMAL_EXIT;
 			break;
 		}
 
@@ -739,9 +734,9 @@ restart:
 
 	fepriv->thread = NULL;
 	if (kthread_should_stop())
-		fepriv->exit = DVB_FE_DEVICE_REMOVED;
+		fe->exit = DVB_FE_DEVICE_REMOVED;
 	else
-		fepriv->exit = DVB_FE_NO_EXIT;
+		fe->exit = DVB_FE_NO_EXIT;
 	mb();
 
 	if (semheld)
@@ -756,7 +751,8 @@ static void dvb_frontend_stop(struct dvb_frontend *fe)
 
 	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
-	fepriv->exit = DVB_FE_NORMAL_EXIT;
+	if (fe->exit != DVB_FE_DEVICE_REMOVED)
+		fe->exit = DVB_FE_NORMAL_EXIT;
 	mb();
 
 	if (!fepriv->thread)
@@ -826,7 +822,7 @@ static int dvb_frontend_start(struct dvb_frontend *fe)
 	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
 	if (fepriv->thread) {
-		if (fepriv->exit == DVB_FE_NO_EXIT)
+		if (fe->exit == DVB_FE_NO_EXIT)
 			return 0;
 		else
 			dvb_frontend_stop (fe);
@@ -838,7 +834,7 @@ static int dvb_frontend_start(struct dvb_frontend *fe)
 		return -EINTR;
 
 	fepriv->state = FESTATE_IDLE;
-	fepriv->exit = DVB_FE_NO_EXIT;
+	fe->exit = DVB_FE_NO_EXIT;
 	fepriv->thread = NULL;
 	mb();
 
@@ -1906,7 +1902,7 @@ static int dvb_frontend_ioctl(struct file *file,
 	if (down_interruptible(&fepriv->sem))
 		return -ERESTARTSYS;
 
-	if (fepriv->exit != DVB_FE_NO_EXIT) {
+	if (fe->exit != DVB_FE_NO_EXIT) {
 		up(&fepriv->sem);
 		return -ENODEV;
 	}
@@ -2424,7 +2420,7 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
 	int ret;
 
 	dev_dbg(fe->dvb->device, "%s:\n", __func__);
-	if (fepriv->exit == DVB_FE_DEVICE_REMOVED)
+	if (fe->exit == DVB_FE_DEVICE_REMOVED)
 		return -ENODEV;
 
 	if (adapter->mfe_shared) {
@@ -2529,7 +2525,7 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
 
 	if (dvbdev->users == -1) {
 		wake_up(&fepriv->wait_queue);
-		if (fepriv->exit != DVB_FE_NO_EXIT)
+		if (fe->exit != DVB_FE_NO_EXIT)
 			wake_up(&dvbdev->wait_queue);
 		if (fe->ops.ts_bus_ctrl)
 			fe->ops.ts_bus_ctrl(fe, 0);
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 371b6ca..625a340 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -405,6 +405,10 @@ struct dtv_frontend_properties {
 	struct dtv_fe_stats	block_count;
 };
 
+#define DVB_FE_NO_EXIT  0
+#define DVB_FE_NORMAL_EXIT      1
+#define DVB_FE_DEVICE_REMOVED   2
+
 struct dvb_frontend {
 	struct dvb_frontend_ops ops;
 	struct dvb_adapter *dvb;
@@ -418,6 +422,7 @@ struct dvb_frontend {
 #define DVB_FRONTEND_COMPONENT_DEMOD 1
 	int (*callback)(void *adapter_priv, int component, int cmd, int arg);
 	int id;
+	unsigned int exit;
 };
 
 extern int dvb_register_frontend(struct dvb_adapter *dvb,
-- 
1.7.10.4

