Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933764AbaKLEB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:01:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbaKLBYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:24:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH 3.17 072/319] UBI: block: Fix block device size setting
Date: Wed, 12 Nov 2014 10:13:30 +0900
Message-Id: <20141112011004.523484440@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

commit 978d6496758d19de2431ebf163337fc7b92f8c45 upstream.

We are currently taking the block device size from the ubi_volume_info.size
field. However, this is not the amount of data in the volume, but the
number of reserved physical eraseblocks, and hence leads to an incorrect
representation of the volume.

In particular, this produces I/O errors on static volumes as the block
interface may attempt to read unmapped PEBs:

$ cat /dev/ubiblock0_0 > /dev/null
UBI error: ubiblock_read_to_buf: ubiblock0_0 ubi_read error -22
end_request: I/O error, dev ubiblock0_0, sector 9536
Buffer I/O error on device ubiblock0_0, logical block 2384
[snip]

Fix this by using the ubi_volume_info.used_bytes field which is set to the
actual number of data bytes for both static and dynamic volumes.

While here, improve the error message to be less stupid and more useful:
UBI error: ubiblock_read_to_buf: ubiblock0_1 ubi_read error -9 on LEB=0, off=15872, len=512

It's worth noticing that the 512-byte sector representation of the volume
is only correct if the volume size is multiple of 512-bytes. This is true for
virtually any NAND device, given eraseblocks and pages are 512-byte multiple
and hence so is the LEB size.

Artem: tweak the error message and make it look more like other UBI error
messages.

Fixes: 9d54c8a33eec ("UBI: R/O block driver on top of UBI volumes")
Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/ubi/block.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/mtd/ubi/block.c
+++ b/drivers/mtd/ubi/block.c
@@ -188,8 +188,9 @@ static int ubiblock_read_to_buf(struct u
 
 	ret = ubi_read(dev->desc, leb, buffer, offset, len);
 	if (ret) {
-		ubi_err("%s ubi_read error %d",
-			dev->gd->disk_name, ret);
+		ubi_err("%s: error %d while reading from LEB %d (offset %d, "
+		        "length %d)", dev->gd->disk_name, ret, leb, offset,
+			len);
 		return ret;
 	}
 	return 0;
@@ -378,7 +379,7 @@ int ubiblock_create(struct ubi_volume_in
 {
 	struct ubiblock *dev;
 	struct gendisk *gd;
-	u64 disk_capacity = ((u64)vi->size * vi->usable_leb_size) >> 9;
+	u64 disk_capacity = vi->used_bytes >> 9;
 	int ret;
 
 	if ((sector_t)disk_capacity != disk_capacity)
@@ -502,7 +503,7 @@ int ubiblock_remove(struct ubi_volume_in
 static int ubiblock_resize(struct ubi_volume_info *vi)
 {
 	struct ubiblock *dev;
-	u64 disk_capacity = ((u64)vi->size * vi->usable_leb_size) >> 9;
+	u64 disk_capacity = vi->used_bytes >> 9;
 
 	if ((sector_t)disk_capacity != disk_capacity) {
 		ubi_warn("%s: the volume is too big, cannot resize (%d LEBs)",
@@ -523,7 +524,7 @@ static int ubiblock_resize(struct ubi_vo
 
 	mutex_lock(&dev->dev_mutex);
 	set_capacity(dev->gd, disk_capacity);
-	ubi_msg("%s resized to %d LEBs", dev->gd->disk_name, vi->size);
+	ubi_msg("%s resized to %lld bytes", dev->gd->disk_name, vi->used_bytes);
 	mutex_unlock(&dev->dev_mutex);
 	mutex_unlock(&devices_mutex);
 	return 0;


