Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab3GVIcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:32:53 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:36614 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756701Ab3GVIct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:32:49 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: linux-media@vger.kernel.org
Cc: alipowski@interia.pl, Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org, srinivas.kandagatla@gmail.com,
        srinivas.kandagatla@st.com, sean@mess.org
Subject: [PATCH v2 2/2] media: lirc: Allow lirc dev to talk to rc device
Date: Mon, 22 Jul 2013 09:23:07 +0100
Message-Id: <1374481387-3424-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1374481319-3293-1-git-send-email-srinivas.kandagatla@st.com>
References: <1374481319-3293-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

The use case is simple, if any rc device has allowed protocols =
RC_TYPE_LIRC and map_name = RC_MAP_LIRC set, the driver open will be never
called. The reason for this is, all of the key maps except lirc have some
KEYS in there map, so during rc_register_device process these keys are
matched against the input drivers and open is performed, so for the case
of RC_MAP_EMPTY, a vt/keyboard is matched and the driver open is
performed.

In case of lirc, there is no match and result is that there is no open
performed, however the lirc-dev will go ahead and create a /dev/lirc0
node. Now when lircd/mode2 opens this device, no data is available
because the driver was never opened.

Other case pointed by Sean Young, As rc device gets opened via the
input interface. If the input device is never opened (e.g. embedded with
no console) then the rc open is never called and lirc will not work
either. So that's another case.

lirc_dev seems to have no link with actual rc device w.r.t open/close.
This patch adds rc_dev pointer to lirc_driver structure for cases like
this, so that it can do the open/close of the real driver in accordance
to lircd/mode2 open/close.

Without this patch its impossible to open a rc device which has
RC_TYPE_LIRC ad RC_MAP_LIRC set.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/media/rc/ir-lirc-codec.c |    1 +
 drivers/media/rc/lirc_dev.c      |   10 ++++++++++
 include/media/lirc_dev.h         |    1 +
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index e456126..6858685 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -375,6 +375,7 @@ static int ir_lirc_register(struct rc_dev *dev)
 	drv->code_length = sizeof(struct ir_raw_event) * 8;
 	drv->fops = &lirc_fops;
 	drv->dev = &dev->dev;
+	drv->rdev = dev;
 	drv->owner = THIS_MODULE;
 
 	drv->minor = lirc_register_driver(drv);
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 8dc057b..dc5cbff 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -35,6 +35,7 @@
 #include <linux/device.h>
 #include <linux/cdev.h>
 
+#include <media/rc-core.h>
 #include <media/lirc.h>
 #include <media/lirc_dev.h>
 
@@ -467,6 +468,12 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
 		goto error;
 	}
 
+	if (ir->d.rdev) {
+		retval = rc_open(ir->d.rdev);
+		if (retval)
+			goto error;
+	}
+
 	cdev = ir->cdev;
 	if (try_module_get(cdev->owner)) {
 		ir->open++;
@@ -511,6 +518,9 @@ int lirc_dev_fop_close(struct inode *inode, struct file *file)
 
 	WARN_ON(mutex_lock_killable(&lirc_dev_lock));
 
+	if (ir->d.rdev)
+		rc_close(ir->d.rdev);
+
 	ir->open--;
 	if (ir->attached) {
 		ir->d.set_use_dec(ir->d.data);
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 168dd0b..78f0637 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -139,6 +139,7 @@ struct lirc_driver {
 	struct lirc_buffer *rbuf;
 	int (*set_use_inc) (void *data);
 	void (*set_use_dec) (void *data);
+	struct rc_dev *rdev;
 	const struct file_operations *fops;
 	struct device *dev;
 	struct module *owner;
-- 
1.7.6.5

