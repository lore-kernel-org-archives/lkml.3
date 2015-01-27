Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223AbbA0Wez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:34:55 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:59761
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933043AbbA0Wde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:33:34 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        vkuznets@redhat.com, tglx@linutronix.de
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 1/8] Drivers: hv: vmbus: prevent cpu offlining on newer hypervisors
Date: Tue, 27 Jan 2015 15:46:41 -0800
Message-Id: <1422402408-5504-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1422402376-5463-1-git-send-email-kys@microsoft.com>
References: <1422402376-5463-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

When an SMP Hyper-V guest is running on top of 2012R2 Server and secondary
cpus are sent offline (with echo 0 > /sys/devices/system/cpu/cpu$cpu/online)
the system freeze is observed. This happens due to the fact that on newer
hypervisors (Win8, WS2012R2, ...) vmbus channel handlers are distributed
across all cpus (see init_vp_index() function in drivers/hv/channel_mgmt.c)
and on cpu offlining nobody reassigns them to CPU0. Prevent cpu offlining
when vmbus is loaded until the issue is fixed host-side.

This patch also disables hibernation but it is OK as it is also broken (MCE
error is hit on resume). Suspend still works.

Tested with WS2008R2 and WS2012R2.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/vmbus_drv.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index f518b8d7..3b18a66 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -33,6 +33,7 @@
 #include <linux/hyperv.h>
 #include <linux/kernel_stat.h>
 #include <linux/clockchips.h>
+#include <linux/cpu.h>
 #include <asm/hyperv.h>
 #include <asm/hypervisor.h>
 #include <asm/mshyperv.h>
@@ -704,6 +705,39 @@ static void vmbus_isr(void)
 	}
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+static int hyperv_cpu_disable(void)
+{
+	return -ENOSYS;
+}
+
+static void hv_cpu_hotplug_quirk(bool vmbus_loaded)
+{
+	static void *previous_cpu_disable;
+
+	/*
+	 * Offlining a CPU when running on newer hypervisors (WS2012R2, Win8,
+	 * ...) is not supported at this moment as channel interrupts are
+	 * distributed across all of them.
+	 */
+
+	if ((vmbus_proto_version == VERSION_WS2008) ||
+	    (vmbus_proto_version == VERSION_WIN7))
+		return;
+
+	if (vmbus_loaded) {
+		previous_cpu_disable = smp_ops.cpu_disable;
+		smp_ops.cpu_disable = hyperv_cpu_disable;
+		pr_notice("CPU offlining is not supported by hypervisor\n");
+	} else if (previous_cpu_disable)
+		smp_ops.cpu_disable = previous_cpu_disable;
+}
+#else
+static void hv_cpu_hotplug_quirk(bool vmbus_loaded)
+{
+}
+#endif
+
 /*
  * vmbus_bus_init -Main vmbus driver initialization routine.
  *
@@ -744,6 +778,7 @@ static int vmbus_bus_init(int irq)
 	if (ret)
 		goto err_alloc;
 
+	hv_cpu_hotplug_quirk(true);
 	vmbus_request_offers();
 
 	return 0;
@@ -997,6 +1032,7 @@ static void __exit vmbus_exit(void)
 	bus_unregister(&hv_bus);
 	hv_cleanup();
 	acpi_bus_unregister_driver(&vmbus_acpi_driver);
+	hv_cpu_hotplug_quirk(false);
 }
 
 
-- 
1.7.4.1

