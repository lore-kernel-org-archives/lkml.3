Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3CATqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:46:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab3CATqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olaf Hering <olaf@aepfle.de>, Jan Beulich <jbeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 16/46] xen-blkback: do not leak mode property
Date: Fri,  1 Mar 2013 11:45:04 -0800
Message-Id: <20130301194433.949652254@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194432.263409302@linuxfoundation.org>
References: <20130301194432.263409302@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/xen-blkback/xenbus.c |   49 ++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -367,6 +367,7 @@ static int xen_blkbk_remove(struct xenbu
 		be->blkif = NULL;
 	}
 
+	kfree(be->mode);
 	kfree(be);
 	dev_set_drvdata(&dev->dev, NULL);
 	return 0;
@@ -502,6 +503,7 @@ static void backend_changed(struct xenbu
 		= container_of(watch, struct backend_info, backend_watch);
 	struct xenbus_device *dev = be->dev;
 	int cdrom = 0;
+	unsigned long handle;
 	char *device_type;
 
 	DPRINTK("");
@@ -521,10 +523,10 @@ static void backend_changed(struct xenbu
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
 
@@ -542,36 +544,33 @@ static void backend_changed(struct xenbu
 		kfree(device_type);
 	}
 
-	if (be->major == 0 && be->minor == 0) {
-		/* Front end dir is a number, which is used as the handle. */
+	/* Front end dir is a number, which is used as the handle. */
+	err = strict_strtoul(strrchr(dev->otherend, '/') + 1, 0, &handle);
+	if (err)
+		return;
 
-		char *p = strrchr(dev->otherend, '/') + 1;
-		long handle;
-		err = strict_strtoul(p, 0, &handle);
-		if (err)
-			return;
+	be->major = major;
+	be->minor = minor;
 
-		be->major = major;
-		be->minor = minor;
-
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


