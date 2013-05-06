Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518Ab3EFUyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:54:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59330 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758006Ab3EFUq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:46:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jonathan Brassow <jbrassow@redhat.com>, NeilBrown <neilb@suse.de>
Subject: [ 087/115] md: bad block list should default to disabled.
Date: Mon,  6 May 2013 13:45:23 -0700
Message-Id: <20130506203104.529438816@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1564,8 +1564,8 @@ static int super_1_load(struct md_rdev *
 					     sector, count, 1) == 0)
 				return -EINVAL;
 		}
-	} else if (sb->bblog_offset == 0)
-		rdev->badblocks.shift = -1;
+	} else if (sb->bblog_offset != 0)
+		rdev->badblocks.shift = 0;
 
 	if (!refdev) {
 		ret = 1;
@@ -3221,7 +3221,7 @@ int md_rdev_init(struct md_rdev *rdev)
 	 * be used - I wonder if that matters
 	 */
 	rdev->badblocks.count = 0;
-	rdev->badblocks.shift = 0;
+	rdev->badblocks.shift = -1; /* disabled until explicitly enabled */
 	rdev->badblocks.page = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	seqlock_init(&rdev->badblocks.lock);
 	if (rdev->badblocks.page == NULL)
@@ -3293,9 +3293,6 @@ static struct md_rdev *md_import_device(
 			goto abort_free;
 		}
 	}
-	if (super_format == -1)
-		/* hot-add for 0.90, or non-persistent: so no badblocks */
-		rdev->badblocks.shift = -1;
 
 	return rdev;
 


