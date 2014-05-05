Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbaEEEt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 00:49:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbaEEEt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 00:49:56 -0400
From: Baoquan He <bhe@redhat.com>
To: rjw@rjwysocki.net, linux-acpi@vger.kernel.org, linux-ia64@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dyoung@redhat.com,
        Baoquan He <bhe@redhat.com>
Subject: [Patch v3 2/2] lapic need be checked if available when initialize acpi processor id
Date: Mon,  5 May 2014 12:48:26 +0800
Message-Id: <1399265306-8553-2-git-send-email-bhe@redhat.com>
In-Reply-To: <1399265306-8553-1-git-send-email-bhe@redhat.com>
References: <1399265306-8553-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In acpi_processor_get_info(), acpi processor info is initialized including
id, namely cpu index. Currently, if on UP system running SMP kerenl with
no LAPIC in MADT, cpu0_initialized is checked if acpi processor id is
initialized.

However this check maybe is not sufficient for kdump kernel. Most of time
only 1 CPU is supported because of known problems in kdump kernel. So in
1st kernel multiple CPUs are present, then crash happened in one specific
CPU, say 2nd CPU. Then it jumped into kdump kernel with "nr_cpus=1" specified
in cmdline. In this situation, since kdump kernel is warm reset, it will
reuse the ACPI resource passed from crashed kernel directly, namely 1st
kernel. It means in MADT all LAPIC is enabled while only 1 CPU is
present in running system. The kdump kernel usually is the same as the
crashed 1st kernel. So now in kdump kernel, x86_cpu_to_apicid stored the
apicid and its related cpu id. If only check cpu0_initialized, it will
assign 0 to the acpi processor id of 1st CPU, it's not correct.

So in this patch, check acpi_lapic too. If acpi_lapic is 0, then LAPIC in
MADT is not available, assigne 0 to the handling acpi processor id. If
acpi_lapic is 1, then LAPIC in MADT is available, let's get apic processor
id from x86_cpu_to_apicid.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 drivers/acpi/acpi_processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index b06f5f5..bf0cce9 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -268,7 +268,7 @@ static int acpi_processor_get_info(struct acpi_device *device)
 	pr->apic_id = apic_id;
 
 	cpu_index = acpi_map_cpuid(pr->apic_id, pr->acpi_id);
-	if (!cpu0_initialized) {
+	if (!cpu0_initialized && !acpi_lapic) {
 		cpu0_initialized = 1;
 		/* Handle UP system running SMP kernel, with no LAPIC in MADT */
 		if ((cpu_index == -1) && (num_online_cpus() == 1))
-- 
1.8.5.3

