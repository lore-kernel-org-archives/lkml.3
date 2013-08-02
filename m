Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab3HBKsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:48:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37211 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964830Ab3HBKKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:10:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Lawrence <joe.lawrence@stratus.com>, NeilBrown <neilb@suse.de>
Subject: [ 45/99] md: Remove recent change which allows devices to skip recovery.
Date: Fri,  2 Aug 2013 18:07:58 +0800
Message-Id: <20130802100232.361687043@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 5024c298311f3b97c85cb034f9edaa333fdb9338 upstream.

commit 7ceb17e87bde79d285a8b988cfed9eaeebe60b86
    md: Allow devices to be re-added to a read-only array.

allowed a bit more than just that.  It also allows devices to be added
to a read-write array and to end up skipping recovery.

This patch removes the offending piece of code pending a rewrite for a
subsequent release.

More specifically:
 If the array has a bitmap, then the device will still need a bitmap
 based resync ('saved_raid_disk' is set under different conditions
 is a bitmap is present).
 If the array doesn't have a bitmap, then this is correct as long as
 nothing has been written to the array since the metadata was checked
 by ->validate_super.  However there is no locking to ensure that there
 was no write.

Bug was introduced in 3.10 and causes data corruption so
patch is suitable for 3.10-stable.

Reported-by: Joe Lawrence <joe.lawrence@stratus.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7697,20 +7697,6 @@ static int remove_and_add_spares(struct
 			continue;
 
 		rdev->recovery_offset = 0;
-		if (rdev->saved_raid_disk >= 0 && mddev->in_sync) {
-			spin_lock_irq(&mddev->write_lock);
-			if (mddev->in_sync)
-				/* OK, this device, which is in_sync,
-				 * will definitely be noticed before
-				 * the next write, so recovery isn't
-				 * needed.
-				 */
-				rdev->recovery_offset = mddev->recovery_cp;
-			spin_unlock_irq(&mddev->write_lock);
-		}
-		if (mddev->ro && rdev->recovery_offset != MaxSector)
-			/* not safe to add this disk now */
-			continue;
 		if (mddev->pers->
 		    hot_add_disk(mddev, rdev) == 0) {
 			if (sysfs_link_rdev(mddev, rdev))


