Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab3FEP40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:56:26 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26739 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669Ab3FEPyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:54:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 9/9] xen/time: Free onlined per-cpu data structure if we want to online it again.
Date: Wed,  5 Jun 2013 11:54:38 -0400
Message-Id: <1370447678-22367-10-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370447678-22367-1-git-send-email-konrad.wilk@oracle.com>
References: <1370447678-22367-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the per-cpu time data structure has been onlined already and
we are trying to online it again, then free the previous copy
before blindly over-writting it.

A developer naturally should not call this function multiple times
but just in case.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/time.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 6a56ae0..aec0b14 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -401,6 +401,20 @@ static irqreturn_t xen_timer_interrupt(int irq, void *dev_id)
 	return ret;
 }
 
+void xen_teardown_timer(int cpu)
+{
+	struct clock_event_device *evt;
+	BUG_ON(cpu == 0);
+	evt = &per_cpu(xen_clock_events, cpu).evt;
+
+	if (evt->irq >= 0) {
+		unbind_from_irqhandler(evt->irq, NULL);
+		evt->irq = -1;
+		kfree(per_cpu(xen_clock_events, cpu).name);
+		per_cpu(xen_clock_events, cpu).name = NULL;
+	}
+}
+
 void xen_setup_timer(int cpu)
 {
 	char *name;
@@ -409,6 +423,8 @@ void xen_setup_timer(int cpu)
 
 	evt = &per_cpu(xen_clock_events, cpu).evt;
 	WARN(evt->irq >= 0, "IRQ%d for CPU%d is already allocated\n", evt->irq, cpu);
+	if (evt->irq >= 0)
+		xen_teardown_timer(cpu);
 
 	printk(KERN_INFO "installing Xen timer for CPU %d\n", cpu);
 
@@ -429,19 +445,6 @@ void xen_setup_timer(int cpu)
 	per_cpu(xen_clock_events, cpu).name = name;
 }
 
-void xen_teardown_timer(int cpu)
-{
-	struct clock_event_device *evt;
-	BUG_ON(cpu == 0);
-	evt = &per_cpu(xen_clock_events, cpu).evt;
-
-	if (evt->irq >= 0) {
-		unbind_from_irqhandler(evt->irq, NULL);
-		evt->irq = -1;
-		kfree(per_cpu(xen_clock_events, cpu).name);
-		per_cpu(xen_clock_events, cpu).name = NULL;
-	}
-}
 
 void xen_setup_cpu_clockevents(void)
 {
-- 
1.8.1.4

