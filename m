Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbaKLBYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:24:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbaKLBYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:24:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH 3.17 073/319] UBI: block: Add support for the UBI_VOLUME_UPDATED notification
Date: Wed, 12 Nov 2014 10:13:31 +0900
Message-Id: <20141112011004.656413377@linuxfoundation.org>
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

commit 06d9c2905f745c8b1920a335cbb366ba6b0fc754 upstream.

Static volumes can change its 'used_bytes' when they get updated,
and so the block interface must listen to the UBI_VOLUME_UPDATED
notification to resize the block device accordingly.

Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/ubi/block.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/mtd/ubi/block.c
+++ b/drivers/mtd/ubi/block.c
@@ -523,8 +523,12 @@ static int ubiblock_resize(struct ubi_vo
 	}
 
 	mutex_lock(&dev->dev_mutex);
-	set_capacity(dev->gd, disk_capacity);
-	ubi_msg("%s resized to %lld bytes", dev->gd->disk_name, vi->used_bytes);
+
+	if (get_capacity(dev->gd) != disk_capacity) {
+		set_capacity(dev->gd, disk_capacity);
+		ubi_msg("%s resized to %lld bytes", dev->gd->disk_name,
+			vi->used_bytes);
+	}
 	mutex_unlock(&dev->dev_mutex);
 	mutex_unlock(&devices_mutex);
 	return 0;
@@ -548,6 +552,14 @@ static int ubiblock_notify(struct notifi
 	case UBI_VOLUME_RESIZED:
 		ubiblock_resize(&nt->vi);
 		break;
+	case UBI_VOLUME_UPDATED:
+		/*
+		 * If the volume is static, a content update might mean the
+		 * size (i.e. used_bytes) was also changed.
+		 */
+		if (nt->vi.vol_type == UBI_STATIC_VOLUME)
+			ubiblock_resize(&nt->vi);
+		break;
 	default:
 		break;
 	}


