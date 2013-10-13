Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab3JMHOo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 03:14:44 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56350 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753781Ab3JMHOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 03:14:42 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: gregkh@linuxfoundation.org
Cc: stern@rowland.harvard.edu, sarah.a.sharp@linux.intel.com,
        tianyu.lan@intel.com, broonie@linaro.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] usb/hcd: remove unnecessary local_irq_save
Date: Sun, 13 Oct 2013 09:14:19 +0200
Message-Id: <1381648459-2957-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the use of local_irq_save() and IRQF_DISABLED, no longer needed since
interrupt handlers are always run with interrupts disabled on the
current CPU.

Tested successfully with 3.12.0-rc4 on my PC. Didn't find
any issue because of this change.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/usb/core/hcd.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index d6a8d23..1c309f1 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2324,15 +2324,8 @@ EXPORT_SYMBOL_GPL(usb_bus_start_enum);
 irqreturn_t usb_hcd_irq (int irq, void *__hcd)
 {
 	struct usb_hcd		*hcd = __hcd;
-	unsigned long		flags;
 	irqreturn_t		rc;
 
-	/* IRQF_DISABLED doesn't work correctly with shared IRQs
-	 * when the first handler doesn't use it.  So let's just
-	 * assume it's never used.
-	 */
-	local_irq_save(flags);
-
 	if (unlikely(HCD_DEAD(hcd) || !HCD_HW_ACCESSIBLE(hcd)))
 		rc = IRQ_NONE;
 	else if (hcd->driver->irq(hcd) == IRQ_NONE)
@@ -2340,7 +2333,6 @@ irqreturn_t usb_hcd_irq (int irq, void *__hcd)
 	else
 		rc = IRQ_HANDLED;
 
-	local_irq_restore(flags);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(usb_hcd_irq);
@@ -2547,13 +2539,6 @@ static int usb_hcd_request_irqs(struct usb_hcd *hcd,
 
 	if (hcd->driver->irq) {
 
-		/* IRQF_DISABLED doesn't work as advertised when used together
-		 * with IRQF_SHARED. As usb_hcd_irq() will always disable
-		 * interrupts we can remove it here.
-		 */
-		if (irqflags & IRQF_SHARED)
-			irqflags &= ~IRQF_DISABLED;
-
 		snprintf(hcd->irq_descr, sizeof(hcd->irq_descr), "%s:usb%d",
 				hcd->driver->description, hcd->self.busnum);
 		retval = request_irq(irqnum, &usb_hcd_irq, irqflags,
-- 
1.8.1.2

