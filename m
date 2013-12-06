Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162544Ab3LFXkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:40:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48692 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758741Ab3LFXRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:17:48 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 119/152] md: fix calculation of stacking limits on level change.
Date: Fri,  6 Dec 2013 15:10:43 -0800
Message-Id: <1386371476-2477-120-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 02e5f5c0a0f726e66e3d8506ea1691e344277969 upstream.

The various ->run routines of md personalities assume that the 'queue'
has been initialised by the blk_set_stacking_limits() call in
md_alloc().

However when the level is changed (by level_store()) the ->run routine
for the new level is called for an array which has already had the
stacking limits modified.  This can result in incorrect final
settings.

So call blk_set_stacking_limits() before ->run in level_store().

A specific consequence of this bug is that it causes
discard_granularity to be set incorrectly when reshaping a RAID4 to a
RAID0.

This is suitable for any -stable kernel since 3.3 in which
blk_set_stacking_limits() was introduced.

Reported-and-tested-by: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/md.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a240f16..8e27791 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3622,6 +3622,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->in_sync = 1;
 		del_timer_sync(&mddev->safemode_timer);
 	}
+	blk_set_stacking_limits(&mddev->queue->limits);
 	pers->run(mddev);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 	mddev_resume(mddev);
-- 
1.8.3.2

