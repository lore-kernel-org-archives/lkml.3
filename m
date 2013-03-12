Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933634Ab3CLXJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:09:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab3CLWdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: [ 040/100] md: fix two bugs when attempting to resize RAID0 array.
Date: Tue, 12 Mar 2013 15:31:25 -0700
Message-Id: <20130312223127.308152681@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit a64685399181780998281fe07309a94b25dd24c3 upstream.

You cannot resize a RAID0 array (in terms of making the devices
bigger), but the code doesn't entirely stop you.
So:

 disable setting of the available size on each device for
 RAID0 and Linear devices.  This must not change as doing so
 can change the effective layout of data.

 Make sure that the size that raid0_size() reports is accurate,
 but rounding devices sizes to chunk sizes.  As the device sizes
 cannot change now, this isn't so important, but it is best to be
 safe.

Without this change:
  mdadm --grow /dev/md0 -z max
  mdadm --grow /dev/md0 -Z max
  then read to the end of the array

can cause a BUG in a RAID0 array.

These bugs have been present ever since it became possible
to resize any device, which is a long time.  So the fix is
suitable for any -stable kerenl.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c    |    3 +++
 drivers/md/raid0.c |    3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2998,6 +2998,9 @@ rdev_size_store(struct md_rdev *rdev, co
 		} else if (!sectors)
 			sectors = (i_size_read(rdev->bdev->bd_inode) >> 9) -
 				rdev->data_offset;
+		if (!my_mddev->pers->resize)
+			/* Cannot change size for RAID0 or Linear etc */
+			return -EINVAL;
 	}
 	if (sectors < my_mddev->dev_sectors)
 		return -EINVAL; /* component must fit device */
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -411,7 +411,8 @@ static sector_t raid0_size(struct mddev
 		  "%s does not support generic reshape\n", __func__);
 
 	rdev_for_each(rdev, mddev)
-		array_sectors += rdev->sectors;
+		array_sectors += (rdev->sectors &
+				  ~(sector_t)(mddev->chunk_sectors-1));
 
 	return array_sectors;
 }


