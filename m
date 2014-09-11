Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbaIKMeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:34:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51467 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754970AbaIKMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Malcolm Priestley" <tvboxspy@gmail.com>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.729514735@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 019/131] staging: vt6655: Fix Warning on boot
 handle_irq_event_percpu.
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 6cff1f6ad4c615319c1a146b2aa0af1043c5e9f5 upstream.

WARNING: CPU: 0 PID: 929 at /home/apw/COD/linux/kernel/irq/handle.c:147 handle_irq_event_percpu+0x1d1/0x1e0()
irq 17 handler device_intr+0x0/0xa80 [vt6655_stage] enabled interrupts

Using spin_lock_irqsave appears to fix this.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/vt6655/device_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -2679,6 +2679,7 @@ static  irqreturn_t  device_intr(int irq
     unsigned char byData = 0;
     int             ii= 0;
 //    unsigned char byRSSI;
+    unsigned long flags;
 
 
     MACvReadISR(pDevice->PortOffset, &pDevice->dwIsr);
@@ -2704,7 +2705,8 @@ static  irqreturn_t  device_intr(int irq
 
     handled = 1;
     MACvIntDisable(pDevice->PortOffset);
-    spin_lock_irq(&pDevice->lock);
+
+    spin_lock_irqsave(&pDevice->lock, flags);
 
     //Make sure current page is 0
     VNSvInPortB(pDevice->PortOffset + MAC_REG_PAGE1SEL, &byOrgPageSel);
@@ -2952,7 +2954,8 @@ static  irqreturn_t  device_intr(int irq
         MACvSelectPage1(pDevice->PortOffset);
     }
 
-    spin_unlock_irq(&pDevice->lock);
+    spin_unlock_irqrestore(&pDevice->lock, flags);
+
     MACvIntEnable(pDevice->PortOffset, IMR_MASK_VALUE);
 
     return IRQ_RETVAL(handled);

