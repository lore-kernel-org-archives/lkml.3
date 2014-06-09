Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934517AbaFIWvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:51:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934306AbaFIWqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:46:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 3.10 22/40] md: always set MD_RECOVERY_INTR when interrupting a reshape thread.
Date: Mon,  9 Jun 2014 15:48:53 -0700
Message-Id: <20140609224839.901370193@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224839.127615063@linuxfoundation.org>
References: <20140609224839.127615063@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7790,6 +7790,7 @@ void md_check_recovery(struct mddev *mdd
 			/* There is no thread, but we need to call
 			 * ->spare_active and clear saved_raid_disk
 			 */
+			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			md_reap_sync_thread(mddev);
 			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			goto unlock;


