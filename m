Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbaHTMJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:09:06 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58902 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495AbaHTLoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Malcolm Priestley <tvboxspy@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 026/104] staging: vt6655: Fix Warning on boot handle_irq_event_percpu.
Date: Wed, 20 Aug 2014 13:42:49 +0200
Message-Id: <6e1af05639abfc6f1841e6bf8b5c8492971ed1f2.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Malcolm Priestley <tvboxspy@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6cff1f6ad4c615319c1a146b2aa0af1043c5e9f5 upstream.

WARNING: CPU: 0 PID: 929 at /home/apw/COD/linux/kernel/irq/handle.c:147 handle_irq_event_percpu+0x1d1/0x1e0()
irq 17 handler device_intr+0x0/0xa80 [vt6655_stage] enabled interrupts

Using spin_lock_irqsave appears to fix this.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/staging/vt6655/device_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 7f36a7103c3e..7268354e139a 100644
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
2.0.4

