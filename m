Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbaIZKPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:15:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913AbaIZJqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:21 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 096/142] md/raid10: Fix memory leak when raid10 reshape completes.
Date: Fri, 26 Sep 2014 11:45:07 +0200
Message-Id: <326d57f8a0437e8d1296e6e76f1ee81728b0afda.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/raid10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d1cf7734e55e..9ccb107c982e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2969,6 +2969,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 		 */
 		if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)) {
 			end_reshape(conf);
+			close_sync(conf);
 			return 0;
 		}
 
-- 
2.1.0

