Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab3CNKuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:50:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51958 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196Ab3CNKhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 52/88] md: fix two bugs when attempting to resize RAID0 array.
Date: Thu, 14 Mar 2013 10:35:45 +0000
Message-Id: <1363257381-15900-53-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/md.c    | 3 +++
 drivers/md/raid0.c | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b7a551d..8a6f63c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3057,6 +3057,9 @@ rdev_size_store(struct md_rdev *rdev, const char *buf, size_t len)
 		} else if (!sectors)
 			sectors = (i_size_read(rdev->bdev->bd_inode) >> 9) -
 				rdev->data_offset;
+		if (!my_mddev->pers->resize)
+			/* Cannot change size for RAID0 or Linear etc */
+			return -EINVAL;
 	}
 	if (sectors < my_mddev->dev_sectors)
 		return -EINVAL; /* component must fit device */
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index de63a1f..08e1734 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -402,7 +402,8 @@ static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int raid_disks
 		  "%s does not support generic reshape\n", __func__);
 
 	rdev_for_each(rdev, mddev)
-		array_sectors += rdev->sectors;
+		array_sectors += (rdev->sectors &
+				  ~(sector_t)(mddev->chunk_sectors-1));
 
 	return array_sectors;
 }
-- 
1.8.1.2

