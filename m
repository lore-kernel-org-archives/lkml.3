Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaBGLYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:24:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40815 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaBGLXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:23:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 04/88] md/raid10: fix two bugs in handling of known-bad-blocks.
Date: Fri,  7 Feb 2014 11:22:01 +0000
Message-Id: <1391772205-22239-5-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/raid10.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 2070e9c..a5229e4 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1203,7 +1203,7 @@ read_again:
 			/* Could not read all from this device, so we will
 			 * need another r10_bio.
 			 */
-			sectors_handled = (r10_bio->sectors + max_sectors
+			sectors_handled = (r10_bio->sector + max_sectors
 					   - bio->bi_sector);
 			r10_bio->sectors = max_sectors;
 			spin_lock_irq(&conf->device_lock);
@@ -1211,7 +1211,7 @@ read_again:
 				bio->bi_phys_segments = 2;
 			else
 				bio->bi_phys_segments++;
-			spin_unlock(&conf->device_lock);
+			spin_unlock_irq(&conf->device_lock);
 			/* Cannot call generic_make_request directly
 			 * as that will be queued in __generic_make_request
 			 * and subsequent mempool_alloc might block
-- 
1.8.3.2

