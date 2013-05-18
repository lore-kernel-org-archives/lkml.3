Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab3ERCSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:18:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26005 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817Ab3ERCRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:17:00 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Fp4bBEs0It8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=PyxvwjimkMMA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=Nc5lta3nJawr1F_pDB8A:9 a=0kPLrQdw3YYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021652.096107875@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jonathan Brassow <jbrassow@redhat.com>, NeilBrown <neilb@suse.de>
Subject: [ 064/136 ] md: bad block list should default to disabled.
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0064-md-bad-block-list-should-default-to-disabled.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 486adf72ccc0c235754923d47a2270c5dcb0c98b ]

Maintenance of a bad-block-list currently defaults to 'enabled'
and is then disabled when it cannot be supported.
This is backwards and causes problem for dm-raid which didn't know
to disable it.

So fix the defaults, and only enabled for v1.x metadata which
explicitly has bad blocks enabled.

The problem with dm-raid has been present since badblock support was
added in v3.1, so this patch is suitable for any -stable from 3.1
onwards.

Cc: stable@vger.kernel.org (3.1+)
Reported-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/md/md.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c7b000f..833957e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1576,8 +1576,8 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 					     sector, count, 1) == 0)
 				return -EINVAL;
 		}
-	} else if (sb->bblog_offset == 0)
-		rdev->badblocks.shift = -1;
+	} else if (sb->bblog_offset != 0)
+		rdev->badblocks.shift = 0;
 
 	if (!refdev) {
 		ret = 1;
@@ -3224,7 +3224,7 @@ int md_rdev_init(struct md_rdev *rdev)
 	 * be used - I wonder if that matters
 	 */
 	rdev->badblocks.count = 0;
-	rdev->badblocks.shift = 0;
+	rdev->badblocks.shift = -1; /* disabled until explicitly enabled */
 	rdev->badblocks.page = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	seqlock_init(&rdev->badblocks.lock);
 	if (rdev->badblocks.page == NULL)
@@ -3296,9 +3296,6 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 			goto abort_free;
 		}
 	}
-	if (super_format == -1)
-		/* hot-add for 0.90, or non-persistent: so no badblocks */
-		rdev->badblocks.shift = -1;
 
 	return rdev;
 
-- 
1.7.10.4


