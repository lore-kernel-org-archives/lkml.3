Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbaHHUrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:47:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40543 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaHHUr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:47:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 187/259] staging: vt6655: Fix Warning on boot handle_irq_event_percpu.
Date: Fri,  8 Aug 2014 13:40:10 -0700
Message-Id: <1407530482-4483-188-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 6cff1f6ad4c615319c1a146b2aa0af1043c5e9f5 upstream.

WARNING: CPU: 0 PID: 929 at /home/apw/COD/linux/kernel/irq/handle.c:147 handle_irq_event_percpu+0x1d1/0x1e0()
irq 17 handler device_intr+0x0/0xa80 [vt6655_stage] enabled interrupts

Using spin_lock_irqsave appears to fix this.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/vt6655/device_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index e93fdc8..d3e8336a 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -2431,6 +2431,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
 	unsigned char byData = 0;
 	int             ii = 0;
 //    unsigned char byRSSI;
+	unsigned long flags;
 
 	MACvReadISR(pDevice->PortOffset, &pDevice->dwIsr);
 
@@ -2455,7 +2456,8 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
 
 	handled = 1;
 	MACvIntDisable(pDevice->PortOffset);
-	spin_lock_irq(&pDevice->lock);
+
+	spin_lock_irqsave(&pDevice->lock, flags);
 
 	//Make sure current page is 0
 	VNSvInPortB(pDevice->PortOffset + MAC_REG_PAGE1SEL, &byOrgPageSel);
@@ -2696,7 +2698,8 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
 		MACvSelectPage1(pDevice->PortOffset);
 	}
 
-	spin_unlock_irq(&pDevice->lock);
+	spin_unlock_irqrestore(&pDevice->lock, flags);
+
 	MACvIntEnable(pDevice->PortOffset, IMR_MASK_VALUE);
 
 	return IRQ_RETVAL(handled);
-- 
1.9.1

