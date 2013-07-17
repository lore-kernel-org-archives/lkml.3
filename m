Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934647Ab3GQW5C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:57:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56892 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934615Ab3GQW46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:56:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 045/145] [SCSI] aacraid: Fix for arrays are going offline in the system. System hangs
Date: Wed, 17 Jul 2013 15:46:17 -0700
Message-Id: <1374101277-7915-46-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

commit c5bebd829dd95602c15f8da8cc50fa938b5e0254 upstream.

One of the customer had reported that the set of raid logical arrays will
become unavailable (I/O offline) after a long hours of IO stress test.  The OS
wouldn`t be accessible afterwards and require a hard reset.

This driver patch has a fix for race condition between the doorbell and the
circular buffer. The driver is modified to do an extra read after clearing the
doorbell in case there had been a completion posted during the small timing
window.

With this fix, we ran IO stress for ~13 days. There were no IO failures.

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/aacraid/src.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 3b021ec..e34418f 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -93,6 +93,9 @@ static irqreturn_t aac_src_intr_message(int irq, void *dev_id)
 			int send_it = 0;
 			extern int aac_sync_mode;
 
+			src_writel(dev, MUnit.ODR_C, bellbits);
+			src_readl(dev, MUnit.ODR_C);
+
 			if (!aac_sync_mode) {
 				src_writel(dev, MUnit.ODR_C, bellbits);
 				src_readl(dev, MUnit.ODR_C);
-- 
1.8.1.2

