Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbaFWJGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:06:09 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55456 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752274AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 039/111] md: always set MD_RECOVERY_INTR when aborting a reshape or other "resync".
Date: Mon, 23 Jun 2014 10:31:14 +0200
Message-Id: <73e620da4004e2dc8e3ada21cb2974a34ff4288b.1403512281.git.jslaby@suse.cz>
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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/md.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0ed6daf3b1e4..f167b82e7218 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7371,8 +7371,10 @@ void md_do_sync(struct md_thread *thread)
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
2.0.0

