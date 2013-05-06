Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760815Ab3EFXWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:22:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304Ab3EFXOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:14:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vitaliy Fillipov <vitalif@yourcmc.ru>,
        Ben Hutchings <ben@decadent.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, 700333@bugs.debian.org
Subject: [ 076/104] clockevents: Set dummy handler on CPU_DEAD shutdown
Date: Mon,  6 May 2013 16:12:35 -0700
Message-Id: <20130506230051.463897222@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506230043.526528358@linuxfoundation.org>
References: <20130506230043.526528358@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 6f7a05d7018de222e40ca003721037a530979974 upstream.

Vitaliy reported that a per cpu HPET timer interrupt crashes the
system during hibernation. What happens is that the per cpu HPET timer
gets shut down when the nonboot cpus are stopped. When the nonboot
cpus are onlined again the HPET code sets up the MSI interrupt which
fires before the clock event device is registered. The event handler
is still set to hrtimer_interrupt, which then crashes the machine due
to highres mode not being active.

See http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=700333

There is no real good way to avoid that in the HPET code. The HPET
code alrady has a mechanism to detect spurious interrupts when event
handler == NULL for a similar reason.

We can handle that in the clockevent/tick layer and replace the
previous functional handler with a dummy handler like we do in
tick_setup_new_device().

The original clockevents code did this in clockevents_exchange_device(),
but that got removed by commit 7c1e76897 (clockevents: prevent
clockevent event_handler ending up handler_noop) which forgot to fix
it up in tick_shutdown(). Same issue with the broadcast device.

Reported-by: Vitaliy Fillipov <vitalif@yourcmc.ru>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: 700333@bugs.debian.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/tick-broadcast.c |    4 ++++
 kernel/time/tick-common.c    |    1 +
 2 files changed, 5 insertions(+)

--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -66,6 +66,8 @@ static void tick_broadcast_start_periodi
  */
 int tick_check_broadcast_device(struct clock_event_device *dev)
 {
+	struct clock_event_device *cur = tick_broadcast_device.evtdev;
+
 	if ((dev->features & CLOCK_EVT_FEAT_DUMMY) ||
 	    (tick_broadcast_device.evtdev &&
 	     tick_broadcast_device.evtdev->rating >= dev->rating) ||
@@ -73,6 +75,8 @@ int tick_check_broadcast_device(struct c
 		return 0;
 
 	clockevents_exchange_device(tick_broadcast_device.evtdev, dev);
+	if (cur)
+		cur->event_handler = clockevents_handle_noop;
 	tick_broadcast_device.evtdev = dev;
 	if (!cpumask_empty(tick_get_broadcast_mask()))
 		tick_broadcast_start_periodic(dev);
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -323,6 +323,7 @@ static void tick_shutdown(unsigned int *
 		 */
 		dev->mode = CLOCK_EVT_MODE_UNUSED;
 		clockevents_exchange_device(dev, NULL);
+		dev->event_handler = clockevents_handle_noop;
 		td->evtdev = NULL;
 	}
 	raw_spin_unlock_irqrestore(&tick_device_lock, flags);


