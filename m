Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3EJOVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:21:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57129 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755121Ab3EJOVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jonathan Brassow" <jbrassow@redhat.com>,
        "NeilBrown" <neilb@suse.de>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.679129749@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [067/118] md: bad block list should default to disabled.
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/md.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1588,8 +1588,8 @@ static int super_1_load(struct md_rdev *
 					     sector, count, 1) == 0)
 				return -EINVAL;
 		}
-	} else if (sb->bblog_offset == 0)
-		rdev->badblocks.shift = -1;
+	} else if (sb->bblog_offset != 0)
+		rdev->badblocks.shift = 0;
 
 	if (!refdev) {
 		ret = 1;
@@ -3063,7 +3063,7 @@ int md_rdev_init(struct md_rdev *rdev)
 	 * be used - I wonder if that matters
 	 */
 	rdev->badblocks.count = 0;
-	rdev->badblocks.shift = 0;
+	rdev->badblocks.shift = -1; /* disabled until explicitly enabled */
 	rdev->badblocks.page = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	seqlock_init(&rdev->badblocks.lock);
 	if (rdev->badblocks.page == NULL)
@@ -3135,9 +3135,6 @@ static struct md_rdev *md_import_device(
 			goto abort_free;
 		}
 	}
-	if (super_format == -1)
-		/* hot-add for 0.90, or non-persistent: so no badblocks */
-		rdev->badblocks.shift = -1;
 
 	return rdev;
 

