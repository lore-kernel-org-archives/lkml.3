Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaFWIcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:32:32 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55455 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752341AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 040/111] md: always set MD_RECOVERY_INTR when interrupting a reshape thread.
Date: Mon, 23 Jun 2014 10:31:15 +0200
Message-Id: <ab41ac4c4983f4d7d21e5801d601be34df0b58db.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/md.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f167b82e7218..c98e681fc9fc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7827,6 +7827,7 @@ void md_check_recovery(struct mddev *mddev)
 			/* There is no thread, but we need to call
 			 * ->spare_active and clear saved_raid_disk
 			 */
+			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			md_reap_sync_thread(mddev);
 			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			goto unlock;
-- 
2.0.0

