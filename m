Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbaBLI1D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:27:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50217 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094AbaBLIOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:04 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "NeilBrown" <neilb@suse.de>,
        "Damian Nowak" <spam@nowaker.net>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.617652727@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 69/79] md/raid10: fix two bugs in handling of
 known-bad-blocks.
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/raid10.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -997,7 +997,7 @@ read_again:
 			/* Could not read all from this device, so we will
 			 * need another r10_bio.
 			 */
-			sectors_handled = (r10_bio->sectors + max_sectors
+			sectors_handled = (r10_bio->sector + max_sectors
 					   - bio->bi_sector);
 			r10_bio->sectors = max_sectors;
 			spin_lock_irq(&conf->device_lock);
@@ -1005,7 +1005,7 @@ read_again:
 				bio->bi_phys_segments = 2;
 			else
 				bio->bi_phys_segments++;
-			spin_unlock(&conf->device_lock);
+			spin_unlock_irq(&conf->device_lock);
 			/* Cannot call generic_make_request directly
 			 * as that will be queued in __generic_make_request
 			 * and subsequent mempool_alloc might block

