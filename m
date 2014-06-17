Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966838AbaFQVvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:51:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54577 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966798AbaFQVvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:51:19 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 197/212] md: always set MD_RECOVERY_INTR when interrupting a reshape thread.
Date: Tue, 17 Jun 2014 14:44:51 -0700
Message-Id: <1403041506-13646-198-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 2ac295a544dcae9299cba13ce250419117ae7fd1 upstream.

Commit 8313b8e57f55b15e5b7f7fc5d1630bbf686a9a97
   md: fix problem when adding device to read-only array with bitmap.

added a called to md_reap_sync_thread() which cause a reshape thread
to be interrupted (in particular, it could cause md_thread() to never even
call md_do_sync()).
However it didn't set MD_RECOVERY_INTR so ->finish_reshape() would not
know that the reshape didn't complete.

This only happens when mddev->ro is set and normally reshape threads
don't run in that situation.  But raid5 and raid10 can start a reshape
thread during "run" is the array is in the middle of a reshape.
They do this even if ->ro is set.

So it is best to set MD_RECOVERY_INTR before abortingg the
sync thread, just in case.

Though it rare for this to trigger a problem it can cause data corruption
because the reshape isn't finished properly.
So it is suitable for any stable which the offending commit was applied to.
(3.2 or later)

Fixes: 8313b8e57f55b15e5b7f7fc5d1630bbf686a9a97
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/md.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c0ceacf..aa0eba3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7802,6 +7802,7 @@ void md_check_recovery(struct mddev *mddev)
 			/* There is no thread, but we need to call
 			 * ->spare_active and clear saved_raid_disk
 			 */
+			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			md_reap_sync_thread(mddev);
 			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			goto unlock;
-- 
1.9.1

