Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933335Ab3EGNmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:42:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42573 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759364Ab3EGNmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:42:21 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <ben@decadent.org.uk>, 700333@bugs.debian.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 102/118] clockevents: Set dummy handler on CPU_DEAD shutdown
Date: Tue,  7 May 2013 14:39:08 +0100
Message-Id: <1367933964-1564-103-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/time/tick-broadcast.c | 4 ++++
 kernel/time/tick-common.c    | 1 +
 2 files changed, 5 insertions(+)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index a13987a..239a323 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -66,6 +66,8 @@ static void tick_broadcast_start_periodic(struct clock_event_device *bc)
  */
 int tick_check_broadcast_device(struct clock_event_device *dev)
 {
+	struct clock_event_device *cur = tick_broadcast_device.evtdev;
+
 	if ((dev->features & CLOCK_EVT_FEAT_DUMMY) ||
 	    (tick_broadcast_device.evtdev &&
 	     tick_broadcast_device.evtdev->rating >= dev->rating) ||
@@ -73,6 +75,8 @@ int tick_check_broadcast_device(struct clock_event_device *dev)
 		return 0;
 
 	clockevents_exchange_device(tick_broadcast_device.evtdev, dev);
+	if (cur)
+		cur->event_handler = clockevents_handle_noop;
 	tick_broadcast_device.evtdev = dev;
 	if (!cpumask_empty(tick_get_broadcast_mask()))
 		tick_broadcast_start_periodic(dev);
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index da6c9ec..ead79bc 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -323,6 +323,7 @@ static void tick_shutdown(unsigned int *cpup)
 		 */
 		dev->mode = CLOCK_EVT_MODE_UNUSED;
 		clockevents_exchange_device(dev, NULL);
+		dev->event_handler = clockevents_handle_noop;
 		td->evtdev = NULL;
 	}
 	raw_spin_unlock_irqrestore(&tick_device_lock, flags);
-- 
1.8.1.2

