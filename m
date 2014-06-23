Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbaFWNTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:19:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37051 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544AbaFWNEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:04:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 59/93] md: always set MD_RECOVERY_INTR when aborting a reshape or other "resync".
Date: Mon, 23 Jun 2014 14:02:38 +0100
Message-Id: <1403528592-2163-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/md.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 78a848cc106e..c95b77132872 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7353,8 +7353,10 @@ void md_do_sync(struct md_thread *thread)
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

