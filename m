Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab3GJQXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 12:23:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50250 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756Ab3GJQXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 12:23:40 -0400
From: Roger Quadros <rogerq@ti.com>
To: <stern@rowland.harvard.edu>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <sergei.shtylyov@cogentembedded.com>, <khilman@linaro.org>,
        <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH 5/6] USB: Support wakeup IRQ for suspended controllers
Date: Wed, 10 Jul 2013 19:23:13 +0300
Message-ID: <1373473393-27552-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1373473081-27181-1-git-send-email-rogerq@ti.com>
References: <1373473081-27181-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms e.g. ehci-omap can generate an interrupt
(i.e. remote wakeup) even when the controller is suspended i.e.
HW_ACCESSIBLE is cleared.

Introduce a flag "has_wakeup_irq" in struct usb_hcd to indicate
such cases.

We tackle this case by disabling the IRQ, scheduling a
hub resume and enabling back the IRQ after the controller has
resumed. This ensures that the IRQ handler runs only after the
controller is accessible.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/core/hcd.c  |   21 ++++++++++++++++++++-
 include/linux/usb/hcd.h |    3 +++
 2 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 014dc99..933d8f1 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2161,6 +2161,11 @@ static void hcd_resume_work(struct work_struct *work)
 	usb_lock_device(udev);
 	usb_remote_wakeup(udev);
 	usb_unlock_device(udev);
+	if (HCD_IRQ_DISABLED(hcd)) {
+		/* We can now process IRQs so enable IRQ */
+		clear_bit(HCD_FLAG_IRQ_DISABLED, &hcd->flags);
+		enable_irq(hcd->irq);
+	}
 }
 
 /**
@@ -2248,7 +2253,21 @@ irqreturn_t usb_hcd_irq (int irq, void *__hcd)
 	 */
 	local_irq_save(flags);
 
-	if (unlikely(HCD_DEAD(hcd) || !HCD_HW_ACCESSIBLE(hcd)))
+	if (unlikely(HCD_DEAD(hcd)))
+		rc = IRQ_NONE;
+	else if (unlikely(!HCD_HW_ACCESSIBLE(hcd) && hcd->has_wakeup_irq)) {
+		/*
+		 * We got a wakeup interrupt while the controller was
+		 * suspending or suspended.  We can't handle it now, so
+		 * disable the IRQ and resume the root hub (and hence
+		 * the controller too).
+		 */
+		disable_irq_nosync(hcd->irq);
+		set_bit(HCD_FLAG_IRQ_DISABLED, &hcd->flags);
+		usb_hcd_resume_root_hub(hcd);
+
+		rc = IRQ_HANDLED;
+	} else if (unlikely(!HCD_HW_ACCESSIBLE(hcd)))
 		rc = IRQ_NONE;
 	else if (hcd->driver->irq(hcd) == IRQ_NONE)
 		rc = IRQ_NONE;
diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
index 1e88377..5eb9f85 100644
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -110,6 +110,7 @@ struct usb_hcd {
 #define HCD_FLAG_WAKEUP_PENDING		4	/* root hub is resuming? */
 #define HCD_FLAG_RH_RUNNING		5	/* root hub is running? */
 #define HCD_FLAG_DEAD			6	/* controller has died? */
+#define HCD_FLAG_IRQ_DISABLED		7	/* Interrupt was disabled */
 
 	/* The flags can be tested using these macros; they are likely to
 	 * be slightly faster than test_bit().
@@ -120,6 +121,7 @@ struct usb_hcd {
 #define HCD_WAKEUP_PENDING(hcd)	((hcd)->flags & (1U << HCD_FLAG_WAKEUP_PENDING))
 #define HCD_RH_RUNNING(hcd)	((hcd)->flags & (1U << HCD_FLAG_RH_RUNNING))
 #define HCD_DEAD(hcd)		((hcd)->flags & (1U << HCD_FLAG_DEAD))
+#define HCD_IRQ_DISABLED(hcd)	((hcd)->flags & (1U << HCD_FLAG_IRQ_DISABLED))
 
 	/* Flags that get set only during HCD registration or removal. */
 	unsigned		rh_registered:1;/* is root hub registered? */
@@ -132,6 +134,7 @@ struct usb_hcd {
 	unsigned		wireless:1;	/* Wireless USB HCD */
 	unsigned		authorized_default:1;
 	unsigned		has_tt:1;	/* Integrated TT in root hub */
+	unsigned		has_wakeup_irq:1; /* Can IRQ when suspended */
 
 	unsigned int		irq;		/* irq allocated */
 	void __iomem		*regs;		/* device memory/io */
-- 
1.7.4.1

