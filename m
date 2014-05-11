Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934342AbaEKTfl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:35:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933855AbaEKTZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:25:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 79/83] ACPI / processor: Fix failure of loading acpi-cpufreq driver
Date: Sun, 11 May 2014 21:20:20 +0200
Message-Id: <20140511191917.236711029@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lan Tianyu <tianyu.lan@intel.com>

commit 4985c32ee4241d1aba1beeac72294faa46aaff10 upstream.

According commit d640113fe (ACPI: processor: fix acpi_get_cpuid for UP
processor),  BIOS may not provide _MAT or MADT tables and acpi_get_apicid()
always returns -1. For these cases, original code will pass apic_id with
vaule of -1 to acpi_map_cpuid() and it will check the acpi_id. If acpi_id
is equal to zero, ignores apic_id and return zero for CPU0.

Commit b981513 (ACPI / scan: bail out early if failed to parse APIC
ID for CPU) changed the behavior. Return ENODEV when find apic_id is
less than zero after calling acpi_get_apicid(). This causes acpi-cpufreq
driver fails to be loaded on some machines. This patch is to fix it.

Fixes: b981513f806d (ACPI / scan: bail out early if failed to parse APIC ID for CPU)
References: https://bugzilla.kernel.org/show_bug.cgi?id=73781
Reported-and-tested-by: KATO Hiroshi <katoh@mikage.ne.jp>
Reported-and-tested-by: Stuart Foster <smf.linux@ntlworld.com>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpi_processor.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -170,6 +170,9 @@ static int acpi_processor_hotadd_init(st
 	acpi_status status;
 	int ret;
 
+	if (pr->apic_id == -1)
+		return -ENODEV;
+
 	status = acpi_evaluate_integer(pr->handle, "_STA", NULL, &sta);
 	if (ACPI_FAILURE(status) || !(sta & ACPI_STA_DEVICE_PRESENT))
 		return -ENODEV;
@@ -260,10 +263,8 @@ static int acpi_processor_get_info(struc
 	}
 
 	apic_id = acpi_get_apicid(pr->handle, device_declaration, pr->acpi_id);
-	if (apic_id < 0) {
+	if (apic_id < 0)
 		acpi_handle_debug(pr->handle, "failed to get CPU APIC ID.\n");
-		return -ENODEV;
-	}
 	pr->apic_id = apic_id;
 
 	cpu_index = acpi_map_cpuid(pr->apic_id, pr->acpi_id);


