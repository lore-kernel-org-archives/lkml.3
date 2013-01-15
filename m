Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953Ab3AOWgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:36:35 -0500
Received: from mail.kernel.org ([198.145.19.201]:44008 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758384Ab3AOWgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:36:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 210/221] rbd: do not allow remove of mounted-on image
Date: Tue, 15 Jan 2013 10:52:17 -0800
Message-Id: <20130115185013.200056008@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alex Elder <elder@inktank.com>

(cherry picked from commit 42382b709bd1d143b9f0fa93e0a3a1f2f4210707)

There is no check in rbd_remove() to see if anybody holds open the
image being removed.  That's not cool.

Add a simple open count that goes up and down with opens and closes
(releases) of the device, and don't allow an rbd image to be removed
if the count is non-zero.

Protect the updates of the open count value with ctl_mutex to ensure
the underlying rbd device doesn't get removed while concurrently
being opened.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -207,6 +207,7 @@ struct rbd_device {
 
 	/* sysfs related */
 	struct device		dev;
+	unsigned long		open_count;
 };
 
 static DEFINE_MUTEX(ctl_mutex);	  /* Serialize open/close/setup/teardown */
@@ -280,8 +281,11 @@ static int rbd_open(struct block_device
 	if ((mode & FMODE_WRITE) && rbd_dev->mapping.read_only)
 		return -EROFS;
 
+	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
 	rbd_get_dev(rbd_dev);
 	set_device_ro(bdev, rbd_dev->mapping.read_only);
+	rbd_dev->open_count++;
+	mutex_unlock(&ctl_mutex);
 
 	return 0;
 }
@@ -290,7 +294,11 @@ static int rbd_release(struct gendisk *d
 {
 	struct rbd_device *rbd_dev = disk->private_data;
 
+	mutex_lock_nested(&ctl_mutex, SINGLE_DEPTH_NESTING);
+	rbd_assert(rbd_dev->open_count > 0);
+	rbd_dev->open_count--;
 	rbd_put_dev(rbd_dev);
+	mutex_unlock(&ctl_mutex);
 
 	return 0;
 }
@@ -3221,6 +3229,11 @@ static ssize_t rbd_remove(struct bus_typ
 		goto done;
 	}
 
+	if (rbd_dev->open_count) {
+		ret = -EBUSY;
+		goto done;
+	}
+
 	rbd_remove_all_snaps(rbd_dev);
 	rbd_bus_del_dev(rbd_dev);
 


