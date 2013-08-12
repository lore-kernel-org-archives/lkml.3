Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab3HLPrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 11:47:35 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:39114 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214Ab3HLPrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 11:47:31 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: rjw@sisk.pl
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, isimatu.yasuaki@jp.fujitsu.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 2/2] ACPI: Acquire writer lock to update cpu maps
Date: Mon, 12 Aug 2013 09:45:54 -0600
Message-Id: <1376322354-13026-3-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376322354-13026-1-git-send-email-toshi.kani@hp.com>
References: <1376322354-13026-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_map_lsapic() is called from acpi_processor_hotadd_init() to update
cpu_possible_mask and cpu_present_mask.  acpi_unmap_lsapic() is called
from acpi_processor_remove() to update cpu_possible_mask.  Currently,
they are either unprotected or protected with the reader lock, which is
not correct.

This patch protects them with the writer lock with cpu_hotplug_begin()
along with cpu_maps_update_begin(), which must be held before calling
cpu_hotplug_begin().  It also protects arch_register_cpu() /
arch_unregister_cpu(), which creates / deletes a sysfs cpu device
interface.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/acpi_processor.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index 5a74a9c..f29e06e 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -178,14 +178,17 @@ static int acpi_processor_hotadd_init(struct acpi_processor *pr)
 	if (ACPI_FAILURE(status) || !(sta & ACPI_STA_DEVICE_PRESENT))
 		return -ENODEV;
 
+	cpu_maps_update_begin();
+	cpu_hotplug_begin();
+
 	ret = acpi_map_lsapic(pr->handle, &pr->id);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = arch_register_cpu(pr->id);
 	if (ret) {
 		acpi_unmap_lsapic(pr->id);
-		return ret;
+		goto out;
 	}
 
 	/*
@@ -195,7 +198,11 @@ static int acpi_processor_hotadd_init(struct acpi_processor *pr)
 	 */
 	pr_info("CPU%d has been hot-added\n", pr->id);
 	pr->flags.need_hotplug_init = 1;
-	return 0;
+
+out:
+	cpu_hotplug_done();
+	cpu_maps_update_done();
+	return ret;
 }
 #else
 static inline int acpi_processor_hotadd_init(struct acpi_processor *pr)
@@ -452,11 +459,15 @@ static void acpi_processor_remove(struct acpi_device *device)
 	per_cpu(processor_device_array, pr->id) = NULL;
 	per_cpu(processors, pr->id) = NULL;
 
+	cpu_maps_update_begin();
+	cpu_hotplug_begin();
+
 	/* Remove the CPU. */
-	get_online_cpus();
 	arch_unregister_cpu(pr->id);
 	acpi_unmap_lsapic(pr->id);
-	put_online_cpus();
+
+	cpu_hotplug_done();
+	cpu_maps_update_done();
 
 	try_offline_node(cpu_to_node(pr->id));
 
