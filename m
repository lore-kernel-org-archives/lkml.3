Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbaAMQLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:11:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53815 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbaAMQF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:05:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 197/208] mfd: rtsx_pcr: Disable interrupts before cancelling delayed works
Date: Mon, 13 Jan 2014 16:00:38 +0000
Message-Id: <1389628849-1614-198-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 73beb63d290f961c299526852884846b0d868840 upstream.

This fixes a kernel panic when resuming from suspend to RAM.
Without this fix an interrupt hits after the delayed work is canceled
and thus requeues it. So we end up freeing an armed timer.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mfd/rtsx_pcr.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index dd186c4..ccf79a1 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -1200,8 +1200,14 @@ static void rtsx_pci_remove(struct pci_dev *pcidev)
 
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

