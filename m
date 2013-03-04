Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab3CDDoI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:44:08 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32953 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756387Ab3CDDoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:00 -0500
Message-Id: <20130304033715.248408825@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:25 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Jan Beulich <JBeulich@suse.com>,
        Olaf Hering <olaf@aepfle.de>, Jan Beulich <jbeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 078/153] xen-blkback: do not leak mode property
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/xen-blkback/xenbus.c |   49 ++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -364,6 +364,7 @@ static int xen_blkbk_remove(struct xenbu
 		be->blkif = NULL;
 	}
 
+	kfree(be->mode);
 	kfree(be);
 	dev_set_drvdata(&dev->dev, NULL);
 	return 0;
@@ -513,6 +514,7 @@ static void backend_changed(struct xenbu
 		= container_of(watch, struct backend_info, backend_watch);
 	struct xenbus_device *dev = be->dev;
 	int cdrom = 0;
+	unsigned long handle;
 	char *device_type;
 
 	DPRINTK("");
@@ -532,10 +534,10 @@ static void backend_changed(struct xenbu
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
 
@@ -553,36 +555,33 @@ static void backend_changed(struct xenbu
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


