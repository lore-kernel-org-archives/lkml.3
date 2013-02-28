Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab3B1Ory (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:47:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42090 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251Ab3B1Orp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:47:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: George Spelvin <linux@horizon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 048/139] pps: Fix a use-after free bug when unregistering a source.
Date: Thu, 28 Feb 2013 14:43:18 +0000
Message-Id: <1362062689-2567-49-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pps/pps.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index c50a556..f129f4d 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -247,12 +247,15 @@ static int pps_cdev_open(struct inode *inode, struct file *file)
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
 
@@ -274,8 +277,10 @@ static void pps_device_destruct(struct device *dev)
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
@@ -330,6 +335,7 @@ int pps_register_cdev(struct pps_device *pps)
 	if (IS_ERR(pps->dev))
 		goto del_cdev;
 
+	/* Override the release function with our own */
 	pps->dev->release = pps_device_destruct;
 
 	pr_debug("source %s got cdev (%d:%d)\n", pps->info.name,
@@ -350,9 +356,9 @@ free_idr:
 
 void pps_unregister_cdev(struct pps_device *pps)
 {
+	pr_debug("unregistering pps%d\n", pps->id);
 	pps->lookup_cookie = NULL;
 	device_destroy(pps_class, pps->dev->devt);
-	cdev_del(&pps->cdev);
 }
 
 /*
-- 
1.8.1.2

