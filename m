Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651AbaJIVqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:46:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58995 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937AbaJIVF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:05:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 130/163] md/raid1:  be more cautious where we read-balance during resync.
Date: Thu,  9 Oct 2014 14:02:35 -0700
Message-Id: <1412888588-26755-131-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit c6d119cf1b5a778e9ed60a006e2a434fcc4471a2 upstream.

commit 79ef3a8aa1cb1523cc231c9a90a278333c21f761 made
it possible for reads to happen concurrently with resync.
This means that we need to be more careful where read_balancing
is allowed during resync - we can no longer be sure that any
resync that has already started will definitely finish.

So keep read_balancing to before recovery_cp, which is conservative
but safe.

This bug makes it possible to read from a device that doesn't
have up-to-date data, so it can cause data corruption.
So it is suitable for any kernel since 3.11.

Fixes: 79ef3a8aa1cb1523cc231c9a90a278333c21f761
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/raid1.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index b806da4..e124f01 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -542,11 +542,7 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 	has_nonrot_disk = 0;
 	choose_next_idle = 0;
 
-	if (conf->mddev->recovery_cp < MaxSector &&
-	    (this_sector + sectors >= conf->next_resync))
-		choose_first = 1;
-	else
-		choose_first = 0;
+	choose_first = (conf->mddev->recovery_cp < this_sector + sectors);
 
 	for (disk = 0 ; disk < conf->raid_disks * 2 ; disk++) {
 		sector_t dist;
-- 
1.9.1

