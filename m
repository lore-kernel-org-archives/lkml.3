Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab3IBEAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 00:00:22 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:59502 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758090Ab3IBEAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 00:00:20 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiang Liu <jiang.liu@huawei.com>,
        linux-acpi@vger.kernel.org, x86@kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linaro-acpi@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v2 1/6] ACPI / processor: Introduce apic_id in struct processor to save parsed APIC id
Date: Mon,  2 Sep 2013 11:57:34 +0800
Message-Id: <1378094259-5922-2-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378094259-5922-1-git-send-email-hanjun.guo@linaro.org>
References: <1378094259-5922-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

For cpu hot add, we evaluate _MAT or parse MADT twice to get APIC id,
here is the code logic:
acpi_processor_add()
	acpi_processor_get_info()
		acpi_get_cpuid() will evaluate _MAT or parse MADT;
	acpi_processor_hotadd_init()
		acpi_map_lsapic() will evaluate _MAT again;

This can be done more effectively, this patch introduces apic_id in struct
processor to save parsed APIC id, and then we can use it and remove the
duplicated _MAT evaluation.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 drivers/acpi/acpi_processor.c |    4 +++-
 drivers/acpi/processor_core.c |   26 +++++++++++++++++++++-----
 include/acpi/processor.h      |    3 +++
 3 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index f29e06e..f89f914 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -270,7 +270,9 @@ static int acpi_processor_get_info(struct acpi_device *device)
 		device_declaration = 1;
 		pr->acpi_id = value;
 	}
-	cpu_index = acpi_get_cpuid(pr->handle, device_declaration, pr->acpi_id);
+	pr->apic_id = acpi_get_apicid(pr->handle, device_declaration,
+					pr->acpi_id);
+	cpu_index = acpi_map_cpuid(pr->apic_id, pr->acpi_id);
 
 	/* Handle UP system running SMP kernel, with no LAPIC in MADT */
 	if (!cpu0_initialized && (cpu_index == -1) &&
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index cf34d90..b3171f3 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -162,16 +162,23 @@ exit:
 	return apic_id;
 }
 
-int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
+int acpi_get_apicid(acpi_handle handle, int type, u32 acpi_id)
 {
-#ifdef CONFIG_SMP
-	int i;
-#endif
-	int apic_id = -1;
+	int apic_id;
 
 	apic_id = map_mat_entry(handle, type, acpi_id);
 	if (apic_id == -1)
 		apic_id = map_madt_entry(type, acpi_id);
+
+	return apic_id;
+}
+
+int acpi_map_cpuid(int apic_id, u32 acpi_id)
+{
+#ifdef CONFIG_SMP
+	int i;
+#endif
+
 	if (apic_id == -1) {
 		/*
 		 * On UP processor, there is no _MAT or MADT table.
@@ -211,6 +218,15 @@ int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
 #endif
 	return -1;
 }
+
+int acpi_get_cpuid(acpi_handle handle, int type, u32 acpi_id)
+{
+	int apic_id;
+
+	apic_id = acpi_get_apicid(handle, type, acpi_id);
+
+	return acpi_map_cpuid(apic_id, acpi_id);
+}
 EXPORT_SYMBOL_GPL(acpi_get_cpuid);
 
 static bool __init processor_physically_present(acpi_handle handle)
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index 66096d0..7816e45 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -199,6 +199,7 @@ struct acpi_processor_flags {
 struct acpi_processor {
 	acpi_handle handle;
 	u32 acpi_id;
+	u32 apic_id;
 	u32 id;
 	u32 pblk;
 	int performance_platform_limit;
@@ -314,6 +315,8 @@ static inline int acpi_processor_get_bios_limit(int cpu, unsigned int *limit)
 
 /* in processor_core.c */
 void acpi_processor_set_pdc(acpi_handle handle);
+int acpi_get_apicid(acpi_handle, int type, u32 acpi_id);
+int acpi_map_cpuid(int apic_id, u32 acpi_id);
 int acpi_get_cpuid(acpi_handle, int type, u32 acpi_id);
 
 /* in processor_throttling.c */
-- 
1.7.9.5

