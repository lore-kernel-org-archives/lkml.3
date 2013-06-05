Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab3FEP42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:56:28 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26738 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab3FEPyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:54:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 6/9] xen/time: Encapsulate the struct clock_event_device in another structure.
Date: Wed,  5 Jun 2013 11:54:35 -0400
Message-Id: <1370447678-22367-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370447678-22367-1-git-send-email-konrad.wilk@oracle.com>
References: <1370447678-22367-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't do any code movement. We just encapsulate the struct clock_event_device
in a new structure which contains said structure and a pointer to
a char *name. The 'name' will be used in 'xen/time: Don't leak interrupt
name when offlining'.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/time.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 3d88bfd..5190687 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -377,11 +377,16 @@ static const struct clock_event_device xen_vcpuop_clockevent = {
 
 static const struct clock_event_device *xen_clockevent =
 	&xen_timerop_clockevent;
-static DEFINE_PER_CPU(struct clock_event_device, xen_clock_events) = { .irq = -1 };
+
+struct xen_clock_event_device {
+	struct clock_event_device evt;
+	char *name;
+};
+static DEFINE_PER_CPU(struct xen_clock_event_device, xen_clock_events) = { .evt.irq = -1 };
 
 static irqreturn_t xen_timer_interrupt(int irq, void *dev_id)
 {
-	struct clock_event_device *evt = &__get_cpu_var(xen_clock_events);
+	struct clock_event_device *evt = &__get_cpu_var(xen_clock_events).evt;
 	irqreturn_t ret;
 
 	ret = IRQ_NONE;
@@ -401,7 +406,7 @@ void xen_setup_timer(int cpu)
 	struct clock_event_device *evt;
 	int irq;
 
-	evt = &per_cpu(xen_clock_events, cpu);
+	evt = &per_cpu(xen_clock_events, cpu).evt;
 	WARN(evt->irq >= 0, "IRQ%d for CPU%d is already allocated\n", evt->irq, cpu);
 
 	printk(KERN_INFO "installing Xen timer for CPU %d\n", cpu);
@@ -426,7 +431,7 @@ void xen_teardown_timer(int cpu)
 {
 	struct clock_event_device *evt;
 	BUG_ON(cpu == 0);
-	evt = &per_cpu(xen_clock_events, cpu);
+	evt = &per_cpu(xen_clock_events, cpu).evt;
 	unbind_from_irqhandler(evt->irq, NULL);
 	evt->irq = -1;
 }
@@ -435,7 +440,7 @@ void xen_setup_cpu_clockevents(void)
 {
 	BUG_ON(preemptible());
 
-	clockevents_register_device(&__get_cpu_var(xen_clock_events));
+	clockevents_register_device(&__get_cpu_var(xen_clock_events).evt);
 }
 
 void xen_timer_resume(void)
-- 
1.8.1.4

