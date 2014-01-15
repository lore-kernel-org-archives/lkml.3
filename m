Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaAOV52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:57:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40930 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbaAOV5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:57:12 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 128/166] mfd: rtsx_pcr: Disable interrupts before cancelling delayed works
Date: Wed, 15 Jan 2014 13:52:22 -0800
Message-Id: <1389822780-4729-129-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 73beb63d290f961c299526852884846b0d868840 upstream.

This fixes a kernel panic when resuming from suspend to RAM.
Without this fix an interrupt hits after the delayed work is canceled
and thus requeues it. So we end up freeing an armed timer.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mfd/rtsx_pcr.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 148aa18..0c0a84d 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -1188,8 +1188,14 @@ static void rtsx_pci_remove(struct pci_dev *pcidev)
 
 	pcr->remove_pci = true;
 
-	cancel_delayed_work(&pcr->carddet_work);
-	cancel_delayed_work(&pcr->idle_work);
+	/* Disable interrupts at the pcr level */
+	spin_lock_irq(&pcr->lock);
+	rtsx_pci_writel(pcr, RTSX_BIER, 0);
+	pcr->bier = 0;
+	spin_unlock_irq(&pcr->lock);
+
+	cancel_delayed_work_sync(&pcr->carddet_work);
+	cancel_delayed_work_sync(&pcr->idle_work);
 
 	mfd_remove_devices(&pcidev->dev);
 
-- 
1.8.3.2

