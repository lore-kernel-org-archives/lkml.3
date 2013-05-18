Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab3ERDB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:01:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5799 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758833Ab3ERDAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:33 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=QZcOtUkd5toA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=-pFCWkjq_roA:10 a=xNf9USuDAAAA:8 a=Bxc6kcJUAAAA:8 a=8T59DR07AAAA:8 a=VwQbUJbxAAAA:8 a=31FYUmqyeZ1yupaIOyYA:9 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021651.264575808@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Vitaliy Fillipov <vitalif@yourcmc.ru>, Ben Hutchings <ben@decadent.org.uk>,
        <700333@bugs.debian.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [ 059/136 ] clockevents: Set dummy handler on CPU_DEAD shutdown
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0059-clockevents-Set-dummy-handler-on-CPU_DEAD-shutdown.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 6f7a05d7018de222e40ca003721037a530979974 ]

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
Cc: stable@vger.kernel.org
Cc: 700333@bugs.debian.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/time/tick-broadcast.c |    4 ++++
 kernel/time/tick-common.c    |    1 +
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
1.7.10.4


