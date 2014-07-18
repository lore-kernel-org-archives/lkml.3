Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161145AbaGRNPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:15:45 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17832 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161129AbaGRNPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:15:41 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 117/170] md: flush writes before starting a recovery.
Date: Fri, 18 Jul 2014 14:12:02 +0200
Message-Id: <ff2828f6090b15eefc0b5c747bff20fffdef60f0.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/md.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c98e681fc9fc..bf030d4b09a7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7484,6 +7484,19 @@ void md_do_sync(struct md_thread *thread)
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
2.0.0

