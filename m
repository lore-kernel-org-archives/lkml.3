Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278AbaAFWmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:42:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48577 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933256AbaAFWmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:42:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Elder <elder@inktank.com>, Josh Durgin <josh.durgin@inktank.com>
Subject: [PATCH 3.10 095/129] rbd: set removing flag while holding list lock
Date: Mon,  6 Jan 2014 14:38:44 -0800
Message-Id: <20140106223902.324063401@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit 751cc0e3cfabdda87c4c21519253c6751e97a8d4 upstream.

When unmapping a device, its id is supplied, and that is used to
look up which rbd device should be unmapped.  Looking up the
device involves searching the rbd device list while holding
a spinlock that protects access to that list.

Currently all of this is done under protection of the control lock,
but that protection is going away soon.  To ensure the rbd_dev is
still valid (still on the list) while setting its REMOVING flag, do
so while still holding the list lock.  To do so, get rid of
__rbd_get_dev(), and open code what it did in the one place it
was used.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Josh Durgin <josh.durgin@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/rbd.c |   53 +++++++++++++++++++++-------------------------------
 1 file changed, 22 insertions(+), 31 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -5061,23 +5061,6 @@ err_out_module:
 	return (ssize_t)rc;
 }
 
-static struct rbd_device *__rbd_get_dev(unsigned long dev_id)
-{
-	struct list_head *tmp;
-	struct rbd_device *rbd_dev;
-
-	spin_lock(&rbd_dev_list_lock);
-	list_for_each(tmp, &rbd_dev_list) {
-		rbd_dev = list_entry(tmp, struct rbd_device, node);
-		if (rbd_dev->dev_id == dev_id) {
-			spin_unlock(&rbd_dev_list_lock);
-			return rbd_dev;
-		}
-	}
-	spin_unlock(&rbd_dev_list_lock);
-	return NULL;
-}
-
 static void rbd_dev_device_release(struct device *dev)
 {
 	struct rbd_device *rbd_dev = dev_to_rbd_dev(dev);
@@ -5122,7 +5105,8 @@ static ssize_t rbd_remove(struct bus_typ
 			  size_t count)
 {
 	struct rbd_device *rbd_dev = NULL;
-	int target_id;
+	struct list_head *tmp;
+	int dev_id;
 	unsigned long ul;
 	int ret;
 
@@ -5131,26 +5115,33 @@ static ssize_t rbd_remove(struct bus_typ
 		return ret;
 
 	/* convert to int; abort if we lost anything in the conversion */
-	target_id = (int) ul;
-	if (target_id != ul)
+	dev_id = (int)ul;
+	if (dev_id != ul)
 		return -EINVAL;
 
 	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
 
-	rbd_dev = __rbd_get_dev(target_id);
-	if (!rbd_dev) {
-		ret = -ENOENT;
-		goto done;
+	ret = -ENOENT;
+	spin_lock(&rbd_dev_list_lock);
+	list_for_each(tmp, &rbd_dev_list) {
+		rbd_dev = list_entry(tmp, struct rbd_device, node);
+		if (rbd_dev->dev_id == dev_id) {
+			ret = 0;
+			break;
+		}
 	}
-
-	spin_lock_irq(&rbd_dev->lock);
-	if (rbd_dev->open_count)
-		ret = -EBUSY;
-	else
-		set_bit(RBD_DEV_FLAG_REMOVING, &rbd_dev->flags);
-	spin_unlock_irq(&rbd_dev->lock);
+	if (!ret) {
+		spin_lock_irq(&rbd_dev->lock);
+		if (rbd_dev->open_count)
+			ret = -EBUSY;
+		else
+			set_bit(RBD_DEV_FLAG_REMOVING, &rbd_dev->flags);
+		spin_unlock_irq(&rbd_dev->lock);
+	}
+	spin_unlock(&rbd_dev_list_lock);
 	if (ret < 0)
 		goto done;
+
 	rbd_bus_del_dev(rbd_dev);
 	ret = rbd_dev_header_watch_sync(rbd_dev, false);
 	if (ret)


