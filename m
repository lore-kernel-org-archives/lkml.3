Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933800Ab3AOXYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:24:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:47136 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933603Ab3AOWxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:53:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Yehuda Sadeh <yehuda@inktank.com>,
        Josh Durgin <josh.durgin@inktank.com>
Subject: [ 140/171] rbd: drop dev reference on error in rbd_open()
Date: Tue, 15 Jan 2013 14:45:05 -0800
Message-Id: <20130115224323.454813247@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alex Elder <elder@inktank.com>

If a read-only rbd device is opened for writing in rbd_open(), it
returns without dropping the just-acquired device reference.

Fix this by moving the read-only check before getting the reference.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Yehuda Sadeh <yehuda@inktank.com>
Reviewed-by: Josh Durgin <josh.durgin@inktank.com>
(cherry picked from commit 340c7a2b2c9a2da640af28a8c196356484ac8b50)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -250,13 +250,12 @@ static int rbd_open(struct block_device
 {
 	struct rbd_device *rbd_dev = bdev->bd_disk->private_data;
 
-	rbd_get_dev(rbd_dev);
-
-	set_device_ro(bdev, rbd_dev->read_only);
-
 	if ((mode & FMODE_WRITE) && rbd_dev->read_only)
 		return -EROFS;
 
+	rbd_get_dev(rbd_dev);
+	set_device_ro(bdev, rbd_dev->read_only);
+
 	return 0;
 }
 


