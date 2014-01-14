Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbaANA73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:59:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbaANA1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:27:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 3.10 51/62] mfd: rtsx_pcr: Disable interrupts before cancelling delayed works
Date: Mon, 13 Jan 2014 16:27:16 -0800
Message-Id: <20140114002711.910775199@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
References: <20140114002710.464561569@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 73beb63d290f961c299526852884846b0d868840 upstream.

This fixes a kernel panic when resuming from suspend to RAM.
Without this fix an interrupt hits after the delayed work is canceled
and thus requeues it. So we end up freeing an armed timer.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/rtsx_pcr.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -1195,8 +1195,14 @@ static void rtsx_pci_remove(struct pci_d
 
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
 


