Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099Ab3B0BPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:15:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760042Ab3BZX5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        George Spelvin <linux@horizon.com>,
        Rodolfo Giometti <giometti@enneenne.com>
Subject: [ 029/150] pps: Fix a use-after free bug when unregistering a source.
Date: Tue, 26 Feb 2013 15:54:46 -0800
Message-Id: <20130226235527.261015941@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Spelvin <linux@horizon.com>

commit d953e0e837e65ecc1ddaa4f9560f7925878a0de6 upstream.

Remove the cdev from the system (with cdev_del) *before* deallocating it
(in pps_device_destruct, called via kobject_put from device_destroy).

Also prevent deallocating a device with open file handles.

A better long-term fix is probably to remove the cdev from the pps_device
entirely, and instead have all devices reference one global cdev.  Then
the deallocation ordering becomes simpler.

But that's more complex and invasive change, so we leave that
for later.

Signed-off-by: George Spelvin <linux@horizon.com>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pps/pps.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -247,12 +247,15 @@ static int pps_cdev_open(struct inode *i
 	struct pps_device *pps = container_of(inode->i_cdev,
 						struct pps_device, cdev);
 	file->private_data = pps;
-
+	kobject_get(&pps->dev->kobj);
 	return 0;
 }
 
 static int pps_cdev_release(struct inode *inode, struct file *file)
 {
+	struct pps_device *pps = container_of(inode->i_cdev,
+						struct pps_device, cdev);
+	kobject_put(&pps->dev->kobj);
 	return 0;
 }
 
@@ -274,8 +277,10 @@ static void pps_device_destruct(struct d
 {
 	struct pps_device *pps = dev_get_drvdata(dev);
 
-	/* release id here to protect others from using it while it's
-	 * still in use */
+	cdev_del(&pps->cdev);
+
+	/* Now we can release the ID for re-use */
+	pr_debug("deallocating pps%d\n", pps->id);
 	mutex_lock(&pps_idr_lock);
 	idr_remove(&pps_idr, pps->id);
 	mutex_unlock(&pps_idr_lock);
@@ -332,6 +337,7 @@ int pps_register_cdev(struct pps_device
 		goto del_cdev;
 	}
 
+	/* Override the release function with our own */
 	pps->dev->release = pps_device_destruct;
 
 	pr_debug("source %s got cdev (%d:%d)\n", pps->info.name,
@@ -352,9 +358,9 @@ free_idr:
 
 void pps_unregister_cdev(struct pps_device *pps)
 {
+	pr_debug("unregistering pps%d\n", pps->id);
 	pps->lookup_cookie = NULL;
 	device_destroy(pps_class, pps->dev->devt);
-	cdev_del(&pps->cdev);
 }
 
 /*


