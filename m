Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbaAWTQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:16:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbaAWTGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:06:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Damian Nowak <spam@nowaker.net>, NeilBrown <neilb@suse.de>
Subject: [PATCH 3.12 21/27] md/raid10: fix two bugs in handling of known-bad-blocks.
Date: Thu, 23 Jan 2014 11:06:58 -0800
Message-Id: <20140123190650.878710483@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140123190648.720195687@linuxfoundation.org>
References: <20140123190648.720195687@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1319,7 +1319,7 @@ read_again:
 			/* Could not read all from this device, so we will
 			 * need another r10_bio.
 			 */
-			sectors_handled = (r10_bio->sectors + max_sectors
+			sectors_handled = (r10_bio->sector + max_sectors
 					   - bio->bi_sector);
 			r10_bio->sectors = max_sectors;
 			spin_lock_irq(&conf->device_lock);
@@ -1327,7 +1327,7 @@ read_again:
 				bio->bi_phys_segments = 2;
 			else
 				bio->bi_phys_segments++;
-			spin_unlock(&conf->device_lock);
+			spin_unlock_irq(&conf->device_lock);
 			/* Cannot call generic_make_request directly
 			 * as that will be queued in __generic_make_request
 			 * and subsequent mempool_alloc might block


