Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966801AbaFQVvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:51:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54554 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966746AbaFQVvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:51:14 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 195/212] md: always set MD_RECOVERY_INTR when aborting a reshape or other "resync".
Date: Tue, 17 Jun 2014 14:44:49 -0700
Message-Id: <1403041506-13646-196-git-send-email-kamal@canonical.com>
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

commit 3991b31ea072b070081ca3bfa860a077eda67de5 upstream.

If mddev->ro is set, md_to_sync will (correctly) abort.
However in that case MD_RECOVERY_INTR isn't set.

If a RESHAPE had been requested, then ->finish_reshape() will be
called and it will think the reshape was successful even though
nothing happened.

Normally a resync will not be requested if ->ro is set, but if an
array is stopped while a reshape is on-going, then when the array is
started, the reshape will be restarted.  If the array is also set
read-only at this point, the reshape will instantly appear to success,
resulting in data corruption.

Consequently, this patch is suitable for any -stable kernel.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/md.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ddb71d8..c0ceacf 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7358,8 +7358,10 @@ void md_do_sync(struct md_thread *thread)
 	/* just incase thread restarts... */
 	if (test_bit(MD_RECOVERY_DONE, &mddev->recovery))
 		return;
-	if (mddev->ro) /* never try to sync a read-only array */
+	if (mddev->ro) {/* never try to sync a read-only array */
+		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 		return;
+	}
 
 	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
 		if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)) {
-- 
1.9.1

