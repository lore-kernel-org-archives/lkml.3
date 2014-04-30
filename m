Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaD3F4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 01:56:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbaD3F4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 01:56:11 -0400
Date: Wed, 30 Apr 2014 13:55:03 +0800
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
        jiang.liu@linux.intel.com, vgoyal@redhat.com
Subject: [Patch v2] lapic need be checked if available when initialize acpi
 processor id
Message-ID: <20140430055503.GD4774@dhcp-16-105.nay.redhat.com>
References: <1397519754-10205-1-git-send-email-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397519754-10205-1-git-send-email-bhe@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In acpi_processor_get_info(), acpi processor info is initialized including
id, namely cpu index. Currently, if on UP system running SMP kerenl with
no LAPIC in MADT, cpu0_initialized is checked if acpi processor id is
initialized.

However this check maybe is not correct for kdump kernel. Most of time
only 1 CPU is supported because of known problems. So in 1st kernel
multiple CPUs are present, then crash happened in one specific CPU,
say 2nd CPU. Then it jump into kdump kernel with "nr_cpus=1" specified
in cmdline. In this situation, since kdump kernel is warm reset, it will
reuse the ACPI resource passed from crashed kernel directly, namely 1st
kernel. It means in MADT all LAPIC is enabled while only 1 CPU is
present in running system. The kdump kernel usually is the same as the
crashed 1st kernel. So now in kdump kernel, x86_cpu_to_apicid stored the
apicid and its related cpu id. If only check cpu0_initialized, it will
assign 0 to the acpi processor id of 1st CPU, it's not correct.

So in this patch, check acpi_lapic too. If acpi_lapic is 0, then LAPIC in
MADT is not available, assigne 0 to the handling acpi processor. If
acpi_lapic is 1, then LAPIC in MADT is available, let's get apic processor
id from x86_cpu_to_apicid.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 drivers/acpi/acpi_processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index c29c2c3..33f934d 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -267,7 +267,7 @@ static int acpi_processor_get_info(struct acpi_device *device)
 	pr->apic_id = apic_id;
 
 	cpu_index = acpi_map_cpuid(pr->apic_id, pr->acpi_id);
-	if (!cpu0_initialized) {
+	if (!cpu0_initialized && !acpi_lapic) {
 		cpu0_initialized = 1;
 		/* Handle UP system running SMP kernel, with no LAPIC in MADT */
 		if ((cpu_index == -1) && (num_online_cpus() == 1))
-- 
1.8.5.3

