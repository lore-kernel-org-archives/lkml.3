Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab3CNKgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:36:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51717 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688Ab3CNKgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:36:52 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Beulich <jbeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 06/88] xen-blkback: do not leak mode property
Date: Thu, 14 Mar 2013 10:34:59 +0000
Message-Id: <1363257381-15900-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <JBeulich@suse.com>

commit 9d092603cc306ee6edfe917bf9ab8beb5f32d7bc upstream.

"be->mode" is obtained from xenbus_read(), which does a kmalloc() for
the message body. The short string is never released, so do it along
with freeing "be" itself, and make sure the string isn't kept when
backend_changed() doesn't complete successfully (which made it
desirable to slightly re-structure that function, so that the error
cleanup can be done in one place).

Reported-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/xen-blkback/xenbus.c | 49 +++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 4f66171..a155254 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -367,6 +367,7 @@ static int xen_blkbk_remove(struct xenbus_device *dev)
 		be->blkif = NULL;
 	}
 
+	kfree(be->mode);
 	kfree(be);
 	dev_set_drvdata(&dev->dev, NULL);
 	return 0;
@@ -502,6 +503,7 @@ static void backend_changed(struct xenbus_watch *watch,
 		= container_of(watch, struct backend_info, backend_watch);
 	struct xenbus_device *dev = be->dev;
 	int cdrom = 0;
+	unsigned long handle;
 	char *device_type;
 
 	DPRINTK("");
@@ -521,10 +523,10 @@ static void backend_changed(struct xenbus_watch *watch,
 		return;
 	}
 
-	if ((be->major || be->minor) &&
-	    ((be->major != major) || (be->minor != minor))) {
-		pr_warn(DRV_PFX "changing physical device (from %x:%x to %x:%x) not supported.\n",
-			be->major, be->minor, major, minor);
+	if (be->major | be->minor) {
+		if (be->major != major || be->minor != minor)
+			pr_warn(DRV_PFX "changing physical device (from %x:%x to %x:%x) not supported.\n",
+				be->major, be->minor, major, minor);
 		return;
 	}
 
@@ -542,36 +544,33 @@ static void backend_changed(struct xenbus_watch *watch,
 		kfree(device_type);
 	}
 
-	if (be->major == 0 && be->minor == 0) {
-		/* Front end dir is a number, which is used as the handle. */
-
-		char *p = strrchr(dev->otherend, '/') + 1;
-		long handle;
-		err = strict_strtoul(p, 0, &handle);
-		if (err)
-			return;
+	/* Front end dir is a number, which is used as the handle. */
+	err = strict_strtoul(strrchr(dev->otherend, '/') + 1, 0, &handle);
+	if (err)
+		return;
 
-		be->major = major;
-		be->minor = minor;
+	be->major = major;
+	be->minor = minor;
 
-		err = xen_vbd_create(be->blkif, handle, major, minor,
-				 (NULL == strchr(be->mode, 'w')), cdrom);
-		if (err) {
-			be->major = 0;
-			be->minor = 0;
-			xenbus_dev_fatal(dev, err, "creating vbd structure");
-			return;
-		}
+	err = xen_vbd_create(be->blkif, handle, major, minor,
+			     !strchr(be->mode, 'w'), cdrom);
 
+	if (err)
+		xenbus_dev_fatal(dev, err, "creating vbd structure");
+	else {
 		err = xenvbd_sysfs_addif(dev);
 		if (err) {
 			xen_vbd_free(&be->blkif->vbd);
-			be->major = 0;
-			be->minor = 0;
 			xenbus_dev_fatal(dev, err, "creating sysfs entries");
-			return;
 		}
+	}
 
+	if (err) {
+		kfree(be->mode);
+		be->mode = NULL;
+		be->major = 0;
+		be->minor = 0;
+	} else {
 		/* We're potentially connected now */
 		xen_update_blkif_status(be->blkif);
 	}
-- 
1.8.1.2

