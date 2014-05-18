Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaERQLn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 12:11:43 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:49648 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaERQLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 12:11:41 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jiri Kosina <jkosina@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        Masanari Iida <standby24x7@gmail.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: mvsas: mv_sas.c:  Fix for possible null pointer dereference
Date: Sun, 18 May 2014 18:12:26 +0200
Message-Id: <1400429547-11342-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/mvsas/mv_sas.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 6c1f223..ac52f7c 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1344,19 +1344,23 @@ void mvs_dev_gone_notify(struct domain_device *dev)
 {
 	unsigned long flags = 0;
 	struct mvs_device *mvi_dev = dev->lldd_dev;
-	struct mvs_info *mvi = mvi_dev->mvi_info;
-
-	spin_lock_irqsave(&mvi->lock, flags);
+	struct mvs_info *mvi;
 
-	if (mvi_dev) {
-		mv_dprintk("found dev[%d:%x] is gone.\n",
-			mvi_dev->device_id, mvi_dev->dev_type);
-		mvs_release_task(mvi, dev);
-		mvs_free_reg_set(mvi, mvi_dev);
-		mvs_free_dev(mvi_dev);
-	} else {
+	if (!mvi_dev) {
 		mv_dprintk("found dev has gone.\n");
+		return;
 	}
+
+	mvi = mvi_dev->mvi_info;
+
+	spin_lock_irqsave(&mvi->lock, flags);
+
+	mv_dprintk("found dev[%d:%x] is gone.\n",
+		mvi_dev->device_id, mvi_dev->dev_type);
+	mvs_release_task(mvi, dev);
+	mvs_free_reg_set(mvi, mvi_dev);
+	mvs_free_dev(mvi_dev);
+
 	dev->lldd_dev = NULL;
 	mvi_dev->sas_device = NULL;
 
-- 
1.7.10.4

