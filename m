Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaI3Vgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:36:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60872 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaI3Vgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:36:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 027/103] md/raid10: Fix memory leak when raid10 reshape completes.
Date: Tue, 30 Sep 2014 14:30:32 -0700
Message-Id: <1412112708-27356-28-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit b39685526f46976bcd13aa08c82480092befa46c upstream.

When a raid10 commences a resync/recovery/reshape it allocates
some buffer space.
When a resync/recovery completes the buffer space is freed.  But not
when the reshape completes.
This can result in a small memory leak.

There is a subtle side-effect of this bug.  When a RAID10 is reshaped
to a larger array (more devices), the reshape is immediately followed
by a "resync" of the new space.  This "resync" will use the buffer
space which was allocated for "reshape".  This can cause problems
including a "BUG" in the SCSI layer.  So this is suitable for -stable.

Fixes: 3ea7daa5d7fde47cd41f4d56c2deb949114da9d6
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/raid10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 4800e56..1b707ad 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2967,6 +2967,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 		 */
 		if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)) {
 			end_reshape(conf);
+			close_sync(conf);
 			return 0;
 		}
 
-- 
1.9.1

