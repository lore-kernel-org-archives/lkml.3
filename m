Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaAZDFw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 22:05:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52722 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbaAZDEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 22:04:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Damian Nowak <spam@nowaker.net>, NeilBrown <neilb@suse.de>
Subject: [PATCH 3.4 09/12] md/raid10: fix two bugs in handling of known-bad-blocks.
Date: Sat, 25 Jan 2014 19:05:12 -0800
Message-Id: <20140126030452.668477722@linuxfoundation.org>
X-Mailer: git-send-email 1.9.rc0.19.gb594c97
In-Reply-To: <20140126030451.934281002@linuxfoundation.org>
References: <20140126030451.934281002@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit b50c259e25d9260b9108dc0c2964c26e5ecbe1c1 upstream.

If we discover a bad block when reading we split the request and
potentially read some of it from a different device.

The code path of this has two bugs in RAID10.
1/ we get a spin_lock with _irq, but unlock without _irq!!
2/ The calculation of 'sectors_handled' is wrong, as can be clearly
   seen by comparison with raid1.c

This leads to at least 2 warnings and a probable crash is a RAID10
ever had known bad blocks.

Fixes: 856e08e23762dfb92ffc68fd0a8d228f9e152160
Reported-by: Damian Nowak <spam@nowaker.net>
URL: https://bugzilla.kernel.org/show_bug.cgi?id=68181
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid10.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1117,7 +1117,7 @@ read_again:
 			/* Could not read all from this device, so we will
 			 * need another r10_bio.
 			 */
-			sectors_handled = (r10_bio->sectors + max_sectors
+			sectors_handled = (r10_bio->sector + max_sectors
 					   - bio->bi_sector);
 			r10_bio->sectors = max_sectors;
 			spin_lock_irq(&conf->device_lock);
@@ -1125,7 +1125,7 @@ read_again:
 				bio->bi_phys_segments = 2;
 			else
 				bio->bi_phys_segments++;
-			spin_unlock(&conf->device_lock);
+			spin_unlock_irq(&conf->device_lock);
 			/* Cannot call generic_make_request directly
 			 * as that will be queued in __generic_make_request
 			 * and subsequent mempool_alloc might block


