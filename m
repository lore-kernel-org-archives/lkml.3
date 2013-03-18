Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab3CREtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:49:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33357 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750775Ab3CREaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:00 -0400
Message-Id: <20130318042145.251324384@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:21:54 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, NeilBrown <neilb@suse.de>
Subject: [ 10/82] md: fix two bugs when attempting to resize RAID0 array.
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/md.c    |    3 +++
 drivers/md/raid0.c |    3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2842,6 +2842,9 @@ rdev_size_store(struct md_rdev *rdev, co
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
@@ -330,7 +330,8 @@ static sector_t raid0_size(struct mddev
 		  "%s does not support generic reshape\n", __func__);
 
 	list_for_each_entry(rdev, &mddev->disks, same_set)
-		array_sectors += rdev->sectors;
+		array_sectors += (rdev->sectors &
+				  ~(sector_t)(mddev->chunk_sectors-1));
 
 	return array_sectors;
 }


