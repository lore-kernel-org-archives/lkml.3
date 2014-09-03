Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbaICJpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:45:30 -0400
Received: from mail.vectorindia.org ([208.85.3.102]:45293 "EHLO
	vectorindia.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756070AbaICJp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:45:29 -0400
X-Greylist: delayed 940 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Sep 2014 05:45:29 EDT
From: Sudip Mukherjee <sudip@vectorindia.org>
To: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudip@vectorindia.org>, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4] staging: unisys: uislib: uisqueue.c: rewrite of do_locked_client_insert
Date: Wed,  3 Sep 2014 14:59:21 +0530
Message-Id: <1409736561-23883-1-git-send-email-sudip@vectorindia.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) removed unused variables
2) fixed sparse warning of context imbalance in 'do_locked_client_insert'
                         different lock contexts for basic block
3) removed the call to visor_signalqueue_empty() , this function is
   checking whether a signal queue is empty, but the return value
   of the function is not beeing used, so it is safe to remove.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

v1 of the patch of the patch just fixed the sparse warning.
On suggestion of Dan Carpenter v2 is the total rewrite of the function.

change from v2 to v3 : i messed up in writing a comment , which greg k-h pointed out.
The comment was actually not needed , so that has been removed.

change from v3 to v4 : call to visor_signalqueue_empty() was removed and
in the if condition comparison with 1 was removed.


 drivers/staging/unisys/uislib/uisqueue.c | 37 ++++++--------------------------
 1 file changed, 7 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/unisys/uislib/uisqueue.c b/drivers/staging/unisys/uislib/uisqueue.c
index f52bca1..83f8761 100644
--- a/drivers/staging/unisys/uislib/uisqueue.c
+++ b/drivers/staging/unisys/uislib/uisqueue.c
@@ -78,41 +78,18 @@ do_locked_client_insert(struct uisqueue_info *queueinfo,
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
-	spin_unlock_irqrestore(lock, flags);
-	locked = 0;
-
-	queueinfo->packets_sent++;
-
-	rc = 1;
-Away:
-	if (acquired) {
-		ULTRA_CHANNEL_CLIENT_RELEASE_OS(queueinfo->chan, channelId,
-						NULL);
-		acquired = 0;
+		goto unlock;
+	if (visor_signal_insert(queueinfo->chan, whichqueue, pSignal)) {
+		queueinfo->packets_sent++;
+		rc = 1;
 	}
-	if (locked) {
-		spin_unlock_irqrestore((spinlock_t *) lock, flags);
-		locked = 0;
-	}
-
+	ULTRA_CHANNEL_CLIENT_RELEASE_OS(queueinfo->chan, channelId, NULL);
+unlock:
+	spin_unlock_irqrestore((spinlock_t *)lock, flags);
 	return rc;
 }

--
1.8.1.2

