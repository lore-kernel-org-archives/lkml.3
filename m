Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbaDNX51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 19:57:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754607AbaDNX5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 19:57:23 -0400
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
        jiang.liu@linux.intel.com, vgoyal@redhat.com,
        Baoquan He <bhe@redhat.com>
Subject: [PATCH] acpi: try to trust cpu_index from x86_cpu_to_apicid
Date: Tue, 15 Apr 2014 07:55:54 +0800
Message-Id: <1397519754-10205-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In smp with multi cpus, when enter into kdump kernel with only 1 cpu,
a warning message is printed out:

acpi LNXCPU:0a: BIOS reported wrong ACPI id 0 for the processor

In this case kdump kernel use the same ACPI tables as 1st kernel,
means lapic information is got from MADT. The acpi_id related to
this cpu index and lapic_id may not be 0, so the code to assign
value to cpu_index is not correct in this case per cpu0_initialized.
cpu index stored in x86_cpu_to_apicid need be respected.

Now fix it in this patch per boot_cpu_physical_apicid. When cpu index
related to boot_cpu_physical_apicid is not stored in x86_cpu_to_apicid,
then we can say this is UP system running SMP kernel with no LAPIC in MADT

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 drivers/acpi/acpi_processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index c29c2c3..1ae460c 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -267,7 +267,7 @@ static int acpi_processor_get_info(struct acpi_device *device)
 	pr->apic_id = apic_id;
 
 	cpu_index = acpi_map_cpuid(pr->apic_id, pr->acpi_id);
-	if (!cpu0_initialized) {
+	if (!cpu0_initialized && (boot_cpu_physical_apicid == pr->apic_id)) {
 		cpu0_initialized = 1;
 		/* Handle UP system running SMP kernel, with no LAPIC in MADT */
 		if ((cpu_index == -1) && (num_online_cpus() == 1))
-- 
1.8.5.3

