Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724AbbA0Qos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:44:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758705AbbA0Qoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:44:44 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v2 5/5] Drivers: hv: vmbus: Teardown clockevent devices on module unload
Date: Tue, 27 Jan 2015 17:44:19 +0100
Message-Id: <1422377059-7858-6-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1422377059-7858-1-git-send-email-vkuznets@redhat.com>
References: <1422377059-7858-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newly introduced clockevent devices made it impossible to unload hv_vmbus
module as clockevents_config_and_register() takes additional reverence to
the module. To make it possible again we do the following:
- avoid setting dev->owner for clockevent devices;
- implement hv_synic_clockevents_cleanup() doing clockevents_unbind_device();
- call it from vmbus_exit().

In theory hv_synic_clockevents_cleanup() can be merged with hv_synic_cleanup(),
however, we call hv_synic_cleanup() from smp_call_function_single() and this
doesn't work for clockevents_unbind_device() as it does such call on its own. I
opted for a separate function.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/hv.c           | 25 ++++++++++++++++++++++++-
 drivers/hv/hyperv_vmbus.h |  2 ++
 drivers/hv/vmbus_drv.c    |  1 +
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index 39531dc..d3943bc 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -312,7 +312,11 @@ static void hv_init_clockevent_device(struct clock_event_device *dev, int cpu)
 	dev->features = CLOCK_EVT_FEAT_ONESHOT;
 	dev->cpumask = cpumask_of(cpu);
 	dev->rating = 1000;
-	dev->owner = THIS_MODULE;
+	/*
+	 * Avoid settint dev->owner = THIS_MODULE deliberately as doing so will
+	 * result in clockevents_config_and_register() taking additional
+	 * references to the hv_vmbus module making it impossible to unload.
+	 */
 
 	dev->set_mode = hv_ce_setmode;
 	dev->set_next_event = hv_ce_set_next_event;
@@ -470,6 +474,20 @@ void hv_synic_init(void *arg)
 }
 
 /*
+ * hv_synic_clockevents_cleanup - Cleanup clockevent devices
+ */
+void hv_synic_clockevents_cleanup(void)
+{
+	int cpu;
+
+	if (!(ms_hyperv.features & HV_X64_MSR_SYNTIMER_AVAILABLE))
+		return;
+
+	for_each_online_cpu(cpu)
+		clockevents_unbind_device(hv_context.clk_evt[cpu], cpu);
+}
+
+/*
  * hv_synic_cleanup - Cleanup routine for hv_synic_init().
  */
 void hv_synic_cleanup(void *arg)
@@ -483,6 +501,11 @@ void hv_synic_cleanup(void *arg)
 	if (!hv_context.synic_initialized)
 		return;
 
+	/* Turn off clockevent device */
+	if (ms_hyperv.features & HV_X64_MSR_SYNTIMER_AVAILABLE)
+		hv_ce_setmode(CLOCK_EVT_MODE_SHUTDOWN,
+			      hv_context.clk_evt[cpu]);
+
 	rdmsrl(HV_X64_MSR_SINT0 + VMBUS_MESSAGE_SINT, shared_sint.as_uint64);
 
 	shared_sint.masked = 1;
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 6cf2de9..b055e53 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -572,6 +572,8 @@ extern void hv_synic_init(void *irqarg);
 
 extern void hv_synic_cleanup(void *arg);
 
+extern void hv_synic_clockevents_cleanup(void);
+
 /*
  * Host version information.
  */
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index f7e2c9e..fe6d35e 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -999,6 +999,7 @@ static void __exit vmbus_exit(void)
 	int cpu;
 
 	vmbus_connection.conn_state = DISCONNECTED;
+	hv_synic_clockevents_cleanup();
 	hv_remove_vmbus_irq();
 	vmbus_free_channels();
 	bus_unregister(&hv_bus);
-- 
1.9.3

