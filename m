Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750816Ab3JMEO7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 00:14:59 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56018 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750726Ab3JMEO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 00:14:58 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] various char drivers: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 06:14:42 +0200
Message-Id: <1381637682-6349-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/char/nwbutton.c   | 2 +-
 drivers/char/rtc.c        | 5 ++---
 drivers/char/snsc.c       | 3 +--
 drivers/char/snsc_event.c | 3 +--
 4 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/char/nwbutton.c b/drivers/char/nwbutton.c
index cfdfe49..1fd00dc 100644
--- a/drivers/char/nwbutton.c
+++ b/drivers/char/nwbutton.c
@@ -220,7 +220,7 @@ static int __init nwbutton_init(void)
 		return -EBUSY;
 	}
 
-	if (request_irq (IRQ_NETWINDER_BUTTON, button_handler, IRQF_DISABLED,
+	if (request_irq (IRQ_NETWINDER_BUTTON, button_handler, 0,
 			"nwbutton", NULL)) {
 		printk (KERN_WARNING "nwbutton: IRQ %d is not free.\n",
 				IRQ_NETWINDER_BUTTON);
diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index c0cbbd4..3525996 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -227,7 +227,7 @@ static inline unsigned char rtc_is_updating(void)
 
 #ifdef RTC_IRQ
 /*
- *	A very tiny interrupt handler. It runs with IRQF_DISABLED set,
+ *	A very tiny interrupt handler. It runs with interrupts disabled,
  *	but there is possibility of conflicting with the set_rtc_mmss()
  *	call (the rtc irq and the timer irq can easily run at the same
  *	time in two different CPUs). So we need to serialize
@@ -1040,8 +1040,7 @@ no_irq:
 		rtc_int_handler_ptr = rtc_interrupt;
 	}
 
-	if (request_irq(RTC_IRQ, rtc_int_handler_ptr, IRQF_DISABLED,
-			"rtc", NULL)) {
+	if (request_irq(RTC_IRQ, rtc_int_handler_ptr, 0, "rtc", NULL)) {
 		/* Yeah right, seeing as irq 8 doesn't even hit the bus. */
 		rtc_has_irq = 0;
 		printk(KERN_ERR "rtc: IRQ %d is not free.\n", RTC_IRQ);
diff --git a/drivers/char/snsc.c b/drivers/char/snsc.c
index 5816b39..8bab592 100644
--- a/drivers/char/snsc.c
+++ b/drivers/char/snsc.c
@@ -108,8 +108,7 @@ scdrv_open(struct inode *inode, struct file *file)
 	/* hook this subchannel up to the system controller interrupt */
 	mutex_lock(&scdrv_mutex);
 	rv = request_irq(SGI_UART_VECTOR, scdrv_interrupt,
-			 IRQF_SHARED | IRQF_DISABLED,
-			 SYSCTL_BASENAME, sd);
+			 IRQF_SHARED, SYSCTL_BASENAME, sd);
 	if (rv) {
 		ia64_sn_irtr_close(sd->sd_nasid, sd->sd_subch);
 		kfree(sd);
diff --git a/drivers/char/snsc_event.c b/drivers/char/snsc_event.c
index ee15694..59bcefd 100644
--- a/drivers/char/snsc_event.c
+++ b/drivers/char/snsc_event.c
@@ -292,8 +292,7 @@ scdrv_event_init(struct sysctl_data_s *scd)
 
 	/* hook event subchannel up to the system controller interrupt */
 	rv = request_irq(SGI_UART_VECTOR, scdrv_event_interrupt,
-			 IRQF_SHARED | IRQF_DISABLED,
-			 "system controller events", event_sd);
+			 IRQF_SHARED, "system controller events", event_sd);
 	if (rv) {
 		printk(KERN_WARNING "%s: irq request failed (%d)\n",
 		       __func__, rv);
-- 
1.8.1.2

