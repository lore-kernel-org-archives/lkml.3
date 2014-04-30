Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbaD3Hyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 03:54:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:65180 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014AbaD3Hyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 03:54:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,956,1389772800"; 
   d="scan'208";a="425784120"
From: Lan Tianyu <tianyu.lan@intel.com>
To: rjw@rjwysocki.net, lenb@kernel.org, katoh@mikage.ne.jp,
        smf.linux@ntlworld.com, jiang.liu@linux.intel.com
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2] ACPI/Processor: Fix failure of loading acpi-cpufreq driver
Date: Wed, 30 Apr 2014 15:46:33 +0800
Message-Id: <1398843993-26942-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According commit d640113fe(ACPI: processor: fix acpi_get_cpuid for UP
processor),  Bios may not provide _MAT or MADT tables and acpi_get_apicid()
always returns -1. For these cases, original code will pass apic_id with
vaule of -1 to acpi_map_cpuid() and it will check the acpi_id. If acpi_id
is equal to zero, ignores apic_id and return zero for CPU0.

Commit b981513(ACPI / scan: bail out early if failed to parse APIC
ID for CPU) changed the behavior. Return ENODEV when find apic_id is
less than zero after calling acpi_get_apicid(). This causes acpi-cpufreq
driver fails to be loaded on some machines. This patch is to fix it.

Reference:https://bugzilla.kernel.org/show_bug.cgi?id=73781
Cc: stable@vger.kernel.org v3.14
Reported-and-tested-by: KATO Hiroshi <katoh@mikage.ne.jp>
Reported-and-tested-by: Stuart Foster <smf.linux@ntlworld.com>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
Change since V1:
	Add a check for pr->apic_id in the acpi_processor_hotadd_init()
to avoid invalid memory access.

 drivers/acpi/acpi_processor.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index c29c2c3..b06f5f5 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -170,6 +170,9 @@ static int acpi_processor_hotadd_init(struct acpi_processor *pr)
 	acpi_status status;
 	int ret;
 
+	if (pr->apic_id == -1)
+		return -ENODEV;
+
 	status = acpi_evaluate_integer(pr->handle, "_STA", NULL, &sta);
 	if (ACPI_FAILURE(status) || !(sta & ACPI_STA_DEVICE_PRESENT))
 		return -ENODEV;
@@ -260,10 +263,8 @@ static int acpi_processor_get_info(struct acpi_device *device)
 	}
 
 	apic_id = acpi_get_apicid(pr->handle, device_declaration, pr->acpi_id);
-	if (apic_id < 0) {
+	if (apic_id < 0)
 		acpi_handle_debug(pr->handle, "failed to get CPU APIC ID.\n");
-		return -ENODEV;
-	}
 	pr->apic_id = apic_id;
 
 	cpu_index = acpi_map_cpuid(pr->apic_id, pr->acpi_id);
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

