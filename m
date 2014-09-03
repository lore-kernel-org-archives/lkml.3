Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbaICIll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:41:41 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:36503 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaICIlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:41:39 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
X-Google-Original-From: Sudip Mukherjee <sudip@vectorindia.org>
To: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sudip Mukherjee <sudip@vectorindia.org>
Subject: [PATCH v3] staging: unisys: uislib: uisqueue.c: rewrite of do_locked_client_insert
Date: Wed,  3 Sep 2014 14:11:20 +0530
Message-Id: <1409733680-934-1-git-send-email-sudip@vectorindia.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>

removed unused variables
fixed sparse warning of context imbalance in 'do_locked_client_insert'
                         different lock contexts for basic block
 
Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

v1 of the patch of the patch just fixed the sparse warning.
On suggestion of Dan Carpenter v2 is the total rewrite of the function.
Two of the function arguments (interruptHandle,channelId) are also not used. Wanted to remove them as well ,
    but then thought maybe the original author have planned for some use of those variables.
change from v2 to v3 : i messed up in writing a comment , which greg k-h pointed out.
The comment was actually not needed , so that has been removed.

 drivers/staging/unisys/uislib/uisqueue.c | 38 +++++++-------------------------
 1 file changed, 8 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/unisys/uislib/uisqueue.c b/drivers/staging/unisys/uislib/uisqueue.c
index f52bca1..91bc855 100644
--- a/drivers/staging/unisys/uislib/uisqueue.c
+++ b/drivers/staging/unisys/uislib/uisqueue.c
@@ -78,41 +78,19 @@ do_locked_client_insert(struct uisqueue_info *queueinfo,
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
+	visor_signalqueue_empty(queueinfo->chan, whichqueue);
+	if (visor_signal_insert(queueinfo->chan, whichqueue, pSignal) == 1) {
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

