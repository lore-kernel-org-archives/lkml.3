Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbaIBSQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 14:16:49 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:61791 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710AbaIBSQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 14:16:48 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: sparmaintainer@unisys.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: unisys: uislib: uisqueue.c: rewrite of do_locked_client_insert
Date: Tue,  2 Sep 2014 23:46:35 +0530
Message-Id: <1409681795-23262-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sudip Mukherjee <sudip@vectorindia.org>

removed unused variables
fixed sparse warning of context imbalance in 'do_locked_client_insert'
                         different lock contexts for basic block

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

v1 of the patch of the patch just fixed the sparse warning.
On suggestion of Dan Carpenter v2 is the total rewrite of the function.
Two of the function arguments (interruptHandle,channelId) are also not used. Wanted to remove them as well , 
but then thought maybe the original author have planned for some use of those variables.

 drivers/staging/unisys/uislib/uisqueue.c | 37 ++++++++------------------------
 1 file changed, 9 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/unisys/uislib/uisqueue.c b/drivers/staging/unisys/uislib/uisqueue.c
index 63dbe7c..acfa46d 100644
--- a/drivers/staging/unisys/uislib/uisqueue.c
+++ b/drivers/staging/unisys/uislib/uisqueue.c
@@ -78,39 +78,20 @@ do_locked_client_insert(struct uisqueue_info *queueinfo,
 			u64 interruptHandle, u8 *channelId)
 {
 	unsigned long flags;
-	unsigned char queueWasEmpty;
-	unsigned int locked = 0;
-	unsigned int acquired = 0;
 	u8 rc = 0;
 
 	spin_lock_irqsave(lock, flags);
-	locked = 1;
-
 	if (!ULTRA_CHANNEL_CLIENT_ACQUIRE_OS(queueinfo->chan, channelId, NULL))
-		goto Away;
-
-	acquired = 1;
-
-	queueWasEmpty = visor_signalqueue_empty(queueinfo->chan, whichqueue);
-	if (!visor_signal_insert(queueinfo->chan, whichqueue, pSignal))
-		goto Away;
-	ULTRA_CHANNEL_CLIENT_RELEASE_OS(queueinfo->chan, channelId, NULL);
-	acquired = 0;
-
-	queueinfo->packets_sent++;
-
-	rc = 1;
-Away:
-	if (acquired) {
-		ULTRA_CHANNEL_CLIENT_RELEASE_OS(queueinfo->chan, channelId,
-						NULL);
-		acquired = 0;
-	}
-	if (locked) {
-		spin_unlock_irqrestore((spinlock_t *) lock, flags);
-		locked = 0;
+		goto unlock;
+	visor_signalqueue_empty(queueinfo->chan, whichqueue);
+	/*visor_signal_insert() only return 0 or 1 */
+	if (visor_signal_insert(queueinfo->chan, whichqueue, pSignal) == 1) {
+		queueinfo->packets_sent++;
+		rc = 1;
 	}
-
+	ULTRA_CHANNEL_CLIENT_RELEASE_OS(queueinfo->chan, channelId, NULL);
+unlock:
+	spin_unlock_irqrestore((spinlock_t *)lock, flags);
 	return rc;
 }
 
-- 
1.8.1.2

