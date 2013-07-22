Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab3GVIco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:32:44 -0400
Received: from eu1sys200aog123.obsmtp.com ([207.126.144.155]:46773 "EHLO
	eu1sys200aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753959Ab3GVIcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:32:41 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: linux-media@vger.kernel.org
Cc: alipowski@interia.pl, Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org, srinivas.kandagatla@gmail.com,
        srinivas.kandagatla@st.com, sean@mess.org
Subject: [PATCH v2 1/2] media: rc: Add rc_open/close and use count to rc_dev.
Date: Mon, 22 Jul 2013 09:22:57 +0100
Message-Id: <1374481377-3365-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1374481319-3293-1-git-send-email-srinivas.kandagatla@st.com>
References: <1374481319-3293-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch adds user count to rc_dev structure, the reason to add this
new member is to allow other code like lirc to open rc device directly.
In the existing code, rc device is only opened by input subsystem which
works ok if we have any input drivers to match. But in case like lirc
where there will be no input driver, rc device will be never opened.

Having this user count variable will be usefull to allow rc device to be
opened from code other than rc-main.

This patch also adds rc_open and rc_close functions for other drivers
like lirc to open and close rc devices. This functions safely increment
and decrement the user count. Other driver wanting to open rc device
should call rc_open and rc_close, rather than directly modifying the
rc_dev structure.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/media/rc/rc-main.c |   46 ++++++++++++++++++++++++++++++++++++++++---
 include/media/rc-core.h    |    4 +++
 2 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 1cf382a..1dedebd 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -699,19 +699,50 @@ void rc_keydown_notimeout(struct rc_dev *dev, int scancode, u8 toggle)
 }
 EXPORT_SYMBOL_GPL(rc_keydown_notimeout);
 
+int rc_open(struct rc_dev *rdev)
+{
+	int rval = 0;
+
+	if (!rdev)
+		return -EINVAL;
+
+	mutex_lock(&rdev->lock);
+	if (!rdev->users++)
+		rval = rdev->open(rdev);
+
+	if (rval)
+		rdev->users--;
+
+	mutex_unlock(&rdev->lock);
+
+	return rval;
+}
+EXPORT_SYMBOL_GPL(rc_open);
+
 static int ir_open(struct input_dev *idev)
 {
 	struct rc_dev *rdev = input_get_drvdata(idev);
 
-	return rdev->open(rdev);
+	return rc_open(rdev);
+}
+
+void rc_close(struct rc_dev *rdev)
+{
+	if (rdev) {
+		mutex_lock(&rdev->lock);
+
+		 if (!--rdev->users)
+			rdev->close(rdev);
+
+		mutex_unlock(&rdev->lock);
+	}
 }
+EXPORT_SYMBOL_GPL(rc_close);
 
 static void ir_close(struct input_dev *idev)
 {
 	struct rc_dev *rdev = input_get_drvdata(idev);
-
-	 if (rdev)
-		rdev->close(rdev);
+	rc_close(rdev);
 }
 
 /* class for /sys/class/rc */
@@ -1076,7 +1107,14 @@ int rc_register_device(struct rc_dev *dev)
 	memcpy(&dev->input_dev->id, &dev->input_id, sizeof(dev->input_id));
 	dev->input_dev->phys = dev->input_phys;
 	dev->input_dev->name = dev->input_name;
+
+	/* input_register_device can call ir_open, so unlock mutex here */
+	mutex_unlock(&dev->lock);
+
 	rc = input_register_device(dev->input_dev);
+
+	mutex_lock(&dev->lock);
+
 	if (rc)
 		goto out_table;
 
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 06a75de..2f6f1f7 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -101,6 +101,7 @@ struct rc_dev {
 	bool				idle;
 	u64				allowed_protos;
 	u64				enabled_protocols;
+	u32				users;
 	u32				scanmask;
 	void				*priv;
 	spinlock_t			keylock;
@@ -142,6 +143,9 @@ void rc_free_device(struct rc_dev *dev);
 int rc_register_device(struct rc_dev *dev);
 void rc_unregister_device(struct rc_dev *dev);
 
+int rc_open(struct rc_dev *rdev);
+void rc_close(struct rc_dev *rdev);
+
 void rc_repeat(struct rc_dev *dev);
 void rc_keydown(struct rc_dev *dev, int scancode, u8 toggle);
 void rc_keydown_notimeout(struct rc_dev *dev, int scancode, u8 toggle);
-- 
1.7.6.5

