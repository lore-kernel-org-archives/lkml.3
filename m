Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482AbaLEA47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 19:56:59 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:59748
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933379AbaLEA46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 19:56:58 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: vmbus: Implement a clockevent device
Date: Thu,  4 Dec 2014 18:06:46 -0800
Message-Id: <1417745206-10781-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 arch/x86/include/uapi/asm/hyperv.h |   11 +++++
 drivers/hv/hv.c                    |   78 ++++++++++++++++++++++++++++++++++++
 drivers/hv/hyperv_vmbus.h          |   21 ++++++++++
 drivers/hv/vmbus_drv.c             |   40 +++++++++++++++++-
 4 files changed, 148 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/hyperv.h b/arch/x86/include/uapi/asm/hyperv.h
index 462efe7..90c458e 100644
--- a/arch/x86/include/uapi/asm/hyperv.h
+++ b/arch/x86/include/uapi/asm/hyperv.h
@@ -187,6 +187,17 @@
 #define HV_X64_MSR_SINT14			0x4000009E
 #define HV_X64_MSR_SINT15			0x4000009F
 
+/*
+ * Synthetic Timer MSRs. Four timers per vcpu.
+ */
+#define HV_X64_MSR_STIMER0_CONFIG		0x400000B0
+#define HV_X64_MSR_STIMER0_COUNT		0x400000B1
+#define HV_X64_MSR_STIMER1_CONFIG		0x400000B2
+#define HV_X64_MSR_STIMER1_COUNT		0x400000B3
+#define HV_X64_MSR_STIMER2_CONFIG		0x400000B4
+#define HV_X64_MSR_STIMER2_COUNT		0x400000B5
+#define HV_X64_MSR_STIMER3_CONFIG		0x400000B6
+#define HV_X64_MSR_STIMER3_COUNT		0x400000B7
 
 #define HV_X64_MSR_HYPERCALL_ENABLE		0x00000001
 #define HV_X64_MSR_HYPERCALL_PAGE_ADDRESS_SHIFT	12
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index 3e4235c..e2749c0 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -28,7 +28,9 @@
 #include <linux/hyperv.h>
 #include <linux/version.h>
 #include <linux/interrupt.h>
+#include <linux/clockchips.h>
 #include <asm/hyperv.h>
+#include <asm/mshyperv.h>
 #include "hyperv_vmbus.h"
 
 /* The one and only */
@@ -37,6 +39,10 @@ struct hv_context hv_context = {
 	.hypercall_page		= NULL,
 };
 
+#define HV_TIMER_FREQUENCY (10 * 1000 * 1000) /* 100ns period */
+#define HV_MAX_MAX_DELTA_TICKS 0xffffffff
+#define HV_MIN_DELTA_TICKS 1
+
 /*
  * query_hypervisor_info - Get version info of the windows hypervisor
  */
@@ -144,6 +150,8 @@ int hv_init(void)
 	       sizeof(int) * NR_CPUS);
 	memset(hv_context.event_dpc, 0,
 	       sizeof(void *) * NR_CPUS);
+	memset(hv_context.clk_evt, 0,
+	       sizeof(void *) * NR_CPUS);
 
 	max_leaf = query_hypervisor_info();
 
@@ -258,10 +266,63 @@ u16 hv_signal_event(void *con_id)
 	return status;
 }
 
+static int hv_ce_set_next_event(unsigned long delta,
+				struct clock_event_device *evt)
+{
+	cycle_t current_tick;
+
+	WARN_ON(evt->mode != CLOCK_EVT_MODE_ONESHOT);
+
+	rdmsrl(HV_X64_MSR_TIME_REF_COUNT, current_tick);
+	current_tick += delta;
+	wrmsrl(HV_X64_MSR_STIMER0_COUNT, current_tick);
+	return 0;
+}
+
+static void hv_ce_setmode(enum clock_event_mode mode,
+			  struct clock_event_device *evt)
+{
+	union hv_timer_config timer_cfg;
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		/* unsupported */
+		break;
+
+	case CLOCK_EVT_MODE_ONESHOT:
+		timer_cfg.enable = 1;
+		timer_cfg.auto_enable = 1;
+		timer_cfg.sintx = VMBUS_MESSAGE_SINT;
+		wrmsrl(HV_X64_MSR_STIMER0_CONFIG, timer_cfg.as_uint64);
+		break;
+
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		wrmsrl(HV_X64_MSR_STIMER0_COUNT, 0);
+		wrmsrl(HV_X64_MSR_STIMER0_CONFIG, 0);
+		break;
+	case CLOCK_EVT_MODE_RESUME:
+		break;
+	}
+}
+
+static void hv_init_clockevent_device(struct clock_event_device *dev, int cpu)
+{
+	dev->name = "Hyper-V clockevent";
+	dev->features = CLOCK_EVT_FEAT_ONESHOT;
+	dev->cpumask = cpumask_of(cpu);
+	dev->rating = 1000,
+	dev->owner = THIS_MODULE,
+
+	dev->set_mode = hv_ce_setmode;
+	dev->set_next_event = hv_ce_set_next_event;
+}
+
 
 int hv_synic_alloc(void)
 {
 	size_t size = sizeof(struct tasklet_struct);
+	size_t ced_size = sizeof(struct clock_event_device);
 	int cpu;
 
 	for_each_online_cpu(cpu) {
@@ -272,6 +333,13 @@ int hv_synic_alloc(void)
 		}
 		tasklet_init(hv_context.event_dpc[cpu], vmbus_on_event, cpu);
 
+		hv_context.clk_evt[cpu] = kzalloc(ced_size, GFP_ATOMIC);
+		if (hv_context.clk_evt[cpu] == NULL) {
+			pr_err("Unable to allocate clock event device\n");
+			goto err;
+		}
+		hv_init_clockevent_device(hv_context.clk_evt[cpu], cpu);
+
 		hv_context.synic_message_page[cpu] =
 			(void *)get_zeroed_page(GFP_ATOMIC);
 
@@ -305,6 +373,7 @@ err:
 static void hv_synic_free_cpu(int cpu)
 {
 	kfree(hv_context.event_dpc[cpu]);
+	kfree(hv_context.clk_evt[cpu]);
 	if (hv_context.synic_event_page[cpu])
 		free_page((unsigned long)hv_context.synic_event_page[cpu]);
 	if (hv_context.synic_message_page[cpu])
@@ -388,6 +457,15 @@ void hv_synic_init(void *arg)
 	hv_context.vp_index[cpu] = (u32)vp_index;
 
 	INIT_LIST_HEAD(&hv_context.percpu_list[cpu]);
+
+	/*
+	 * Register the per-cpu clockevent source.
+	 */
+	if (ms_hyperv.features & HV_X64_MSR_SYNTIMER_AVAILABLE)
+		clockevents_config_and_register(hv_context.clk_evt[cpu],
+						HV_TIMER_FREQUENCY,
+						HV_MIN_DELTA_TICKS,
+						HV_MAX_MAX_DELTA_TICKS);
 	return;
 }
 
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index c386d8d..44b1c94 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -178,6 +178,23 @@ struct hv_message_header {
 	};
 };
 
+/*
+ * Timer configuration register.
+ */
+union hv_timer_config {
+	u64 as_uint64;
+	struct {
+		u64 enable:1;
+		u64 periodic:1;
+		u64 lazy:1;
+		u64 auto_enable:1;
+		u64 reserved_z0:12;
+		u64 sintx:4;
+		u64 reserved_z1:44;
+	};
+};
+
+
 /* Define timer message payload structure. */
 struct hv_timer_message_payload {
 	u32 timer_index;
@@ -519,6 +536,10 @@ struct hv_context {
 	 * buffer to post messages to the host.
 	 */
 	void *post_msg_page[NR_CPUS];
+	/*
+	 * Support PV clockevent device.
+	 */
+	struct clock_event_device *clk_evt[NR_CPUS];
 };
 
 extern struct hv_context hv_context;
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 4d6b269..9e57c07 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -32,6 +32,7 @@
 #include <linux/completion.h>
 #include <linux/hyperv.h>
 #include <linux/kernel_stat.h>
+#include <linux/clockchips.h>
 #include <asm/hyperv.h>
 #include <asm/hypervisor.h>
 #include <asm/mshyperv.h>
@@ -578,6 +579,37 @@ static void vmbus_onmessage_work(struct work_struct *work)
 	kfree(ctx);
 }
 
+void hv_process_timer_expiration(struct hv_message *msg, int cpu)
+{
+	struct clock_event_device *dev = hv_context.clk_evt[cpu];
+
+	if (msg->header.message_type == HVMSG_NONE)
+		return;
+
+	if (dev->event_handler)
+		dev->event_handler(dev);
+
+	msg->header.message_type = HVMSG_NONE;
+
+	/*
+	 * Make sure the write to MessageType (ie set to
+	 * HVMSG_NONE) happens before we read the
+	 * MessagePending and EOMing. Otherwise, the EOMing
+	 * will not deliver any more messages since there is
+	 * no empty slot
+	 */
+	mb();
+
+	if (msg->header.message_flags.msg_pending) {
+		/*
+		 * This will cause message queue rescan to
+		 * possibly deliver another msg from the
+		 * hypervisor
+		 */
+		wrmsrl(HV_X64_MSR_EOM, 0);
+	}
+}
+
 static void vmbus_on_msg_dpc(unsigned long data)
 {
 	int cpu = smp_processor_id();
@@ -667,8 +699,12 @@ static void vmbus_isr(void)
 	msg = (struct hv_message *)page_addr + VMBUS_MESSAGE_SINT;
 
 	/* Check if there are actual msgs to be processed */
-	if (msg->header.message_type != HVMSG_NONE)
-		tasklet_schedule(&msg_dpc);
+	if (msg->header.message_type != HVMSG_NONE) {
+		if (msg->header.message_type == HVMSG_TIMER_EXPIRED)
+			hv_process_timer_expiration(msg, cpu);
+		else
+			tasklet_schedule(&msg_dpc);
+	}
 }
 
 /*
-- 
1.7.4.1

