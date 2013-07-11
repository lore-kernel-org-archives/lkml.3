Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257Ab3GKOks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:40:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43112 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927Ab3GKO0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 60/98] aacraid: Fix for arrays are going offline in the system. System hangs
Date: Thu, 11 Jul 2013 15:24:30 +0100
Message-Id: <1373552708-15235-61-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/aacraid/src.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 7628206..4de2612 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -101,6 +101,9 @@ static irqreturn_t aac_src_intr_message(int irq, void *dev_id)
 			struct list_head *entry;
 			int send_it = 0;
 
+			src_writel(dev, MUnit.ODR_C, bellbits);
+			src_readl(dev, MUnit.ODR_C);
+
 			if (dev->sync_fib) {
 				our_interrupt = 1;
 				if (dev->sync_fib->callback)
-- 
1.8.1.2

