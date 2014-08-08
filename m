Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbaHHUtC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:49:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40692 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761AbaHHUs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:48:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 049/259] md: flush writes before starting a recovery.
Date: Fri,  8 Aug 2014 13:37:52 -0700
Message-Id: <1407530482-4483-50-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 133d4527eab8d199a62eee6bd433f0776842df2e upstream.

When we write to a degraded array which has a bitmap, we
make sure the relevant bit in the bitmap remains set when
the write completes (so a 're-add' can quickly rebuilt a
temporarily-missing device).

If, immediately after such a write starts, we incorporate a spare,
commence recovery, and skip over the region where the write is
happening (because the 'needs recovery' flag isn't set yet),
then that write will not get to the new device.

Once the recovery finishes the new device will be trusted, but will
have incorrect data, leading to possible corruption.

We cannot set the 'needs recovery' flag when we start the write as we
do not know easily if the write will be "degraded" or not.  That
depends on details of the particular raid level and particular write
request.

This patch fixes a corruption issue of long standing and so it
suitable for any -stable kernel.  It applied correctly to 3.0 at
least and will minor editing to earlier kernels.

Reported-by: Bill <billstuff2001@sbcglobal.net>
Tested-by: Bill <billstuff2001@sbcglobal.net>
Link: http://lkml.kernel.org/r/53A518BB.60709@sbcglobal.net
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/md.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index aa0eba3..09377ba 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7468,6 +7468,19 @@ void md_do_sync(struct md_thread *thread)
 			    rdev->recovery_offset < j)
 				j = rdev->recovery_offset;
 		rcu_read_unlock();
+
+		/* If there is a bitmap, we need to make sure all
+		 * writes that started before we added a spare
+		 * complete before we start doing a recovery.
+		 * Otherwise the write might complete and (via
+		 * bitmap_endwrite) set a bit in the bitmap after the
+		 * recovery has checked that bit and skipped that
+		 * region.
+		 */
+		if (mddev->bitmap) {
+			mddev->pers->quiesce(mddev, 1);
+			mddev->pers->quiesce(mddev, 0);
+		}
 	}
 
 	printk(KERN_INFO "md: %s of RAID array %s\n", desc, mdname(mddev));
-- 
1.9.1

