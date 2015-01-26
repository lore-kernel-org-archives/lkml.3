Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbbAZKjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:39:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679AbbAZKjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:39:06 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org,
        Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: Re: [PATCH v3] Drivers: hv: vmbus: prevent cpu offlining on newer hypervisors
References: <1417431161-12845-1-git-send-email-vkuznets@redhat.com>
	<1421081411-5759-1-git-send-email-vkuznets@redhat.com>
	<20150125133659.GA21552@kroah.com>
Date: Mon, 26 Jan 2015 11:38:54 +0100
In-Reply-To: <20150125133659.GA21552@kroah.com> (Greg Kroah-Hartman's message
	of "Sun, 25 Jan 2015 21:36:59 +0800")
Message-ID: <87k309g729.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Mon, Jan 12, 2015 at 05:50:11PM +0100, Vitaly Kuznetsov wrote:
>> When an SMP Hyper-V guest is running on top of 2012R2 Server and secondary
>> cpus are sent offline (with echo 0 > /sys/devices/system/cpu/cpu$cpu/online)
>> the system freeze is observed. This happens due to the fact that on newer
>> hypervisors (Win8, WS2012R2, ...) vmbus channel handlers are distributed
>> across all cpus (see init_vp_index() function in drivers/hv/channel_mgmt.c)
>> and on cpu offlining nobody reassigns them to CPU0. Prevent cpu offlining
>> when vmbus is loaded until the issue is fixed host-side.
>> 
>> This patch also disables hibernation but it is OK as it is also broken (MCE
>> error is hit on resume). Suspend still works.
>> 
>> Tested with WS2008R2 and WS2012R2.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
>> ---
>> Changes since v2:
>> - repair the build when vmbus is builded as a module [Greg KH] by saving
>>   current cpu_disable pointer to previous_cpu_disable and restoring it on
>>   unload;
>> - return -ENOSYS (same as native_cpu_disable when !CONFIG_HOTPLUG_CPU) instead
>>   of -1 in hyperv_cpu_disable().
>> 
>> Changes since v1:
>> - introduce hv_cpu_hotplug_quirk() function to not spread #ifdefs [Greg KH];
>> - add pr_notice() message "hv_vmbus: CPU offlining is not supported by
>>   hypervisor".
>> ---
>>  drivers/hv/vmbus_drv.c | 36 ++++++++++++++++++++++++++++++++++++
>>  1 file changed, 36 insertions(+)
>
> Doesn't apply to my char-misc-test branch at all :(

Another mid-air collision with K.Y's "Drivers: hv: vmbus: Implement a
clockevent device", please use the attached version. No functional
changes are required, I just fixed the merge conflict (includes).

Othere than that (and sorry for meddling), would it it be better if
you switch to 'pull requests' workflow with K.Y? There is a lot of
ongoing work in hyperv nowdays and such collisions seem otherwise
inevitable ...

-- 
  Vitaly


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0001-Drivers-hv-vmbus-prevent-cpu-offlining-on-newer-hype.patch

>From 95f9b0ff3f73c3bbe8aa9c525414097c2c26a3ef Mon Sep 17 00:00:00 2001
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Mon, 12 Jan 2015 17:50:11 +0100
Subject: [PATCH] Drivers: hv: vmbus: prevent cpu offlining on newer
 hypervisors

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
 drivers/hv/vmbus_drv.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 35e3f42..90c3400 100644
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
1.9.3


--=-=-=--
