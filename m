Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbaHRJv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:51:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42871 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbaHRJfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:35:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 085/137] staging: vt6655: Fix Warning on boot handle_irq_event_percpu.
Date: Mon, 18 Aug 2014 10:32:26 +0100
Message-Id: <1408354398-10226-86-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 6cff1f6ad4c615319c1a146b2aa0af1043c5e9f5 upstream.

WARNING: CPU: 0 PID: 929 at /home/apw/COD/linux/kernel/irq/handle.c:147 handle_irq_event_percpu+0x1d1/0x1e0()
irq 17 handler device_intr+0x0/0xa80 [vt6655_stage] enabled interrupts

Using spin_lock_irqsave appears to fix this.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/vt6655/device_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 08b250f01dae..d170b6f9db7c 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -2434,6 +2434,7 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
 	int             handled = 0;
 	unsigned char byData = 0;
 	int             ii = 0;
+	unsigned long flags;
 //    unsigned char byRSSI;
 
 	MACvReadISR(pDevice->PortOffset, &pDevice->dwIsr);
@@ -2459,7 +2460,8 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
 
 	handled = 1;
 	MACvIntDisable(pDevice->PortOffset);
-	spin_lock_irq(&pDevice->lock);
+
+	spin_lock_irqsave(&pDevice->lock, flags);
 
 	//Make sure current page is 0
 	VNSvInPortB(pDevice->PortOffset + MAC_REG_PAGE1SEL, &byOrgPageSel);
@@ -2700,7 +2702,8 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
 		MACvSelectPage1(pDevice->PortOffset);
 	}
 
-	spin_unlock_irq(&pDevice->lock);
+	spin_unlock_irqrestore(&pDevice->lock, flags);
+
 	MACvIntEnable(pDevice->PortOffset, IMR_MASK_VALUE);
 
 	return IRQ_RETVAL(handled);
-- 
1.9.1

