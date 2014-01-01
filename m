Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbaAAUJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 15:09:31 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46238 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbaAAUJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 15:09:29 -0500
Date: Wed, 1 Jan 2014 21:09:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        Ville Tervo <ville.tervo@nokia.com>, Sebastian Reichel <sre@ring0.de>
Subject: Re: [PATCH v2] Bluetooth: Add hci_h4p driver
Message-ID: <20140101200927.GA16417@amd.pavel.ucw.cz>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
 <1727897.LBX8128hIo@izba>
 <C8D1F470-7964-4EAC-82E0-D53CF54DE086@holtmann.org>
 <20131231221202.GB25336@amd.pavel.ucw.cz>
 <E7C15C38-8E0E-4D49-9E93-5E3DAF77E252@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E7C15C38-8E0E-4D49-9E93-5E3DAF77E252@holtmann.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>> +static struct task_struct *h4p_thread;
> >> 
> >> Can’t this be done using a work queue. You are looking at a 3.14
> >> kernel the earliest. We have way better primitives these days.
> > 
> > I tried to convert it to work queue, but was not too
> > succesfull. Workqueue is not really good match for what this is trying
> > to do... Nokia code relies on sleeping, than timing those sleeps for
> > signaling. I'm still trying to wrap my head around it.
> > 
> > Ok, I guess I could convert it to one big workqueue task, and leave
> > the logic alone. Was that what you wanted?
> 
> the Bluetooth subsystem moved away from tasklets and uses workqueues for everything. So this should be just fine for this driver as well. I do not know about what timings are required, but they should only matter during initial device setup. The HCI traffic is actually driven by the Bluetooth core.
>

I actually tried to convert it to workqueue... result is below but I
was not successful.

h4p driver actually has one long-running, mostly sleeping, thread and
communicates with it by sending it wakeups; the thread toggles some
power management options based on activity. (No, I don't like that
design). That is not something that can be easily converted to
workqueue, AFAICT.

I don't think other Bluetooth drivers do anything similar.

								Pavel


diff --git a/drivers/bluetooth/hci_h4p.h b/drivers/bluetooth/hci_h4p.h
index a2174ea..5dcbaa1 100644
--- a/drivers/bluetooth/hci_h4p.h
+++ b/drivers/bluetooth/hci_h4p.h
@@ -19,12 +19,13 @@
  *
  */
 
+#ifndef __DRIVERS_BLUETOOTH_HCI_H4P_H
+#define __DRIVERS_BLUETOOTH_HCI_H4P_H
+
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
 #include <net/bluetooth/hci.h>
-
-#ifndef __DRIVERS_BLUETOOTH_HCI_H4P_H
-#define __DRIVERS_BLUETOOTH_HCI_H4P_H
+#include <linux/workqueue.h>
 
 #define FW_NAME_TI1271_PRELE	"ti1273_prele.bin"
 #define FW_NAME_TI1271_LE	"ti1273_le.bin"
@@ -103,6 +104,13 @@ struct hci_h4p_info {
 	u16 ier;
 	u16 mdr1;
 	u16 efr;
+
+#if 1
+	struct work_struct work;
+	struct workqueue_struct work_queue; /* FIXME: init me */
+	unsigned long last_transfer_jiffies;
+	unsigned long transfer_timeout;
+#endif
 };
 
 struct hci_h4p_radio_hdr {
diff --git a/drivers/bluetooth/nokia_core.c b/drivers/bluetooth/nokia_core.c
index 07761a3..6e37866 100644
--- a/drivers/bluetooth/nokia_core.c
+++ b/drivers/bluetooth/nokia_core.c
@@ -35,7 +35,6 @@
 #include <linux/interrupt.h>
 #include <linux/gpio.h>
 #include <linux/timer.h>
-#include <linux/kthread.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
@@ -45,8 +44,6 @@
 
 #include "hci_h4p.h"
 
-static struct task_struct *h4p_thread;
-
 /* This should be used in function that cannot release clocks */
 static void hci_h4p_set_clk(struct hci_h4p_info *info, int *clock, int enable)
 {
@@ -103,13 +100,11 @@ void hci_h4p_smart_idle(struct hci_h4p_info *info, bool enable)
 
 static inline void h4p_schedule_pm(struct hci_h4p_info *info)
 {
-	if (unlikely(!h4p_thread))
-		return;
-
 	set_bit(H4P_SCHED_TRANSFER_MODE, &info->pm_flags);
 
 	if (unlikely(!test_bit(H4P_TRANSFER_MODE, &info->pm_flags)))
-		wake_up_process(h4p_thread);
+		/* FIXME */
+		/* wake_up_process(h4p_thread) */ ;
 }
 
 static void hci_h4p_disable_tx(struct hci_h4p_info *info)
@@ -723,18 +718,18 @@ static inline void hci_h4p_set_pm_limits(struct hci_h4p_info *info, bool set)
 	BT_DBG("pm constraints remains: %s", sset);
 }
 
-static int h4p_run(void *data)
+static int h4p_run(struct work_struct *work)
 {
 #define TIMEOUT_MIN msecs_to_jiffies(100)
 #define TIMEOUT_MAX msecs_to_jiffies(2000)
-	struct hci_h4p_info *info = data;
+	struct hci_h4p_info *info = container_of(work, struct hci_h4p_info, work);
 	unsigned long last_jiffies = jiffies;
 	unsigned long timeout = TIMEOUT_MIN;
 	unsigned long elapsed;
 	BT_DBG("");
 	set_user_nice(current, -10);
 
-	while (!kthread_should_stop()) {
+	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (!test_bit(H4P_SCHED_TRANSFER_MODE, &info->pm_flags)) {
 			if (timeout != TIMEOUT_MIN) {
@@ -998,7 +993,8 @@ static int hci_h4p_hci_close(struct hci_dev *hdev)
 		return 0;
 
 	/* Wake up h4p_thread which removes pm constraints */
-	wake_up_process(h4p_thread);
+	/* FIXME */
+//	wake_up_process(h4p_thread);
 
 	hci_h4p_hci_flush(hdev);
 	hci_h4p_set_clk(info, &info->tx_clocks_en, 1);
@@ -1272,12 +1268,11 @@ static int hci_h4p_probe(struct platform_device *pdev)
 		goto cleanup_irq;
 	}
 
-	h4p_thread = kthread_run(h4p_run, info, "h4p_pm");
-	if (IS_ERR(h4p_thread)) {
-		err = PTR_ERR(h4p_thread);
-		goto cleanup_irq;
-	}
+	INIT_WORK(&info->work, h4p_run);
+//	schedule_work(&info->work);
 
+//	info->work_queue = init_work
+	queue_work(info->work_queue, &info->work);
 	return 0;
 
 cleanup_irq:
@@ -1300,7 +1295,7 @@ static int hci_h4p_remove(struct platform_device *pdev)
 
 	info = platform_get_drvdata(pdev);
 
-	kthread_stop(h4p_thread);
+	cancel_work_sync(&info->work);
 
 	hci_h4p_sysfs_remove_files(info->dev);
 	hci_h4p_hci_close(info->hdev);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
