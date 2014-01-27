Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbaA0GeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 01:34:03 -0500
Received: from mga11.intel.com ([192.55.52.93]:34056 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbaA0GeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 01:34:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,727,1384329600"; 
   d="scan'208";a="471246753"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Jorg Otte <jrg.otte@gmail.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiang Liu <jiang.liu@linux.intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI: reduce log level for message "ACPI: \_PR_.CPU4: failed to get CPU APIC ID"
Date: Mon, 27 Jan 2014 14:34:58 +0800
Message-Id: <1390804498-30311-1-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CADDKRnDZt9Q4XKyJcO1htMrCJYj6_5yECURBHsJ7O==hup7ZRw@mail.gmail.com>
References: <CADDKRnDZt9Q4XKyJcO1htMrCJYj6_5yECURBHsJ7O==hup7ZRw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b981513f806d (ACPI / scan: bail out early if failed to parse
APIC ID for CPU) emits an error message if ACPI processor driver fails
to query APIC ID for the CPU.

Originally it's designed to catch BIOS bugs for CPU hot-addition. But
it accidently reveals another type of BIOS bug that:
1) BIOS implements ACPI objects for all possible instead of present
   CPUs. (It's legal per ACPI specification.)
2) BIOS doesn't implement _STA method for CPU objects. OSPM assumes
   that all CPU objects are present and functioning and binds ACPI
   processor driver to those CPU objects, which then triggers the error
   message. According to ACPI spec, BIOS should implement _STA method
   for those absent CPUs at least.

Though it's a BIOS bug in essential, there are some BIOSes in the fields
which are implmented in this way. So reduce the log level from ERR to
DEBUG to accommodate these existing BIOSes.

Fixes: b981513f806d (ACPI / scan: bail out early if failed to parse APIC ID for CPU)
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/acpi_processor.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index c9311be..c29c2c3 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -261,7 +261,7 @@ static int acpi_processor_get_info(struct acpi_device *device)
 
 	apic_id = acpi_get_apicid(pr->handle, device_declaration, pr->acpi_id);
 	if (apic_id < 0) {
-		acpi_handle_err(pr->handle, "failed to get CPU APIC ID.\n");
+		acpi_handle_debug(pr->handle, "failed to get CPU APIC ID.\n");
 		return -ENODEV;
 	}
 	pr->apic_id = apic_id;
-- 
1.7.10.4

