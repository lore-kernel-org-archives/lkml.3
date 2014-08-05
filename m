Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbaHESqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:46:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52195 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbaHESOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3.15 36/42] staging: vt6655: Fix Warning on boot handle_irq_event_percpu.
Date: Tue,  5 Aug 2014 11:13:50 -0700
Message-Id: <20140805181322.094419960@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181321.018370988@linuxfoundation.org>
References: <20140805181321.018370988@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 6cff1f6ad4c615319c1a146b2aa0af1043c5e9f5 upstream.

WARNING: CPU: 0 PID: 929 at /home/apw/COD/linux/kernel/irq/handle.c:147 handle_irq_event_percpu+0x1d1/0x1e0()
irq 17 handler device_intr+0x0/0xa80 [vt6655_stage] enabled interrupts

Using spin_lock_irqsave appears to fix this.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/staging/vt6655/device_main.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -2430,6 +2430,7 @@ static  irqreturn_t  device_intr(int irq
 	int             handled = 0;
 	unsigned char byData = 0;
 	int             ii = 0;
+	unsigned long flags;
 //    unsigned char byRSSI;
 
 	MACvReadISR(pDevice->PortOffset, &pDevice->dwIsr);
@@ -2455,7 +2456,8 @@ static  irqreturn_t  device_intr(int irq
 
 	handled = 1;
 	MACvIntDisable(pDevice->PortOffset);
-	spin_lock_irq(&pDevice->lock);
+
+	spin_lock_irqsave(&pDevice->lock, flags);
 
 	//Make sure current page is 0
 	VNSvInPortB(pDevice->PortOffset + MAC_REG_PAGE1SEL, &byOrgPageSel);
@@ -2696,7 +2698,8 @@ static  irqreturn_t  device_intr(int irq
 		MACvSelectPage1(pDevice->PortOffset);
 	}
 
-	spin_unlock_irq(&pDevice->lock);
+	spin_unlock_irqrestore(&pDevice->lock, flags);
+
 	MACvIntEnable(pDevice->PortOffset, IMR_MASK_VALUE);
 
 	return IRQ_RETVAL(handled);


