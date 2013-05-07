Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933412Ab3EGNmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:42:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42616 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933370Ab3EGNm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:42:28 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 111/118] md: bad block list should default to disabled.
Date: Tue,  7 May 2013 14:39:17 +0100
Message-Id: <1367933964-1564-112-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 486adf72ccc0c235754923d47a2270c5dcb0c98b upstream.

Maintenance of a bad-block-list currently defaults to 'enabled'
and is then disabled when it cannot be supported.
This is backwards and causes problem for dm-raid which didn't know
to disable it.

So fix the defaults, and only enabled for v1.x metadata which
explicitly has bad blocks enabled.

The problem with dm-raid has been present since badblock support was
added in v3.1, so this patch is suitable for any -stable from 3.1
onwards.

Reported-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/md.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8a6f63c..cc4d68d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1629,8 +1629,8 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 					     sector, count, 1) == 0)
 				return -EINVAL;
 		}
-	} else if (sb->bblog_offset == 0)
-		rdev->badblocks.shift = -1;
+	} else if (sb->bblog_offset != 0)
+		rdev->badblocks.shift = 0;
 
 	if (!refdev) {
 		ret = 1;
@@ -3280,7 +3280,7 @@ int md_rdev_init(struct md_rdev *rdev)
 	 * be used - I wonder if that matters
 	 */
 	rdev->badblocks.count = 0;
-	rdev->badblocks.shift = 0;
+	rdev->badblocks.shift = -1; /* disabled until explicitly enabled */
 	rdev->badblocks.page = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	seqlock_init(&rdev->badblocks.lock);
 	if (rdev->badblocks.page == NULL)
@@ -3352,9 +3352,6 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 			goto abort_free;
 		}
 	}
-	if (super_format == -1)
-		/* hot-add for 0.90, or non-persistent: so no badblocks */
-		rdev->badblocks.shift = -1;
 
 	return rdev;
 
-- 
1.8.1.2

