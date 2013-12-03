Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab3LCQkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:40:18 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:62908 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab3LCQkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:40:12 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jon Masters <jonathan@jonmasters.org>, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linaro-acpi@lists.linaro.org, Hanjun Guo <hanjun.guo@linaro.org>
Subject: [RFC part2 PATCH 3/9] ARM64 / ACPI: Introduce map_gic_id() to get apic id from MADT or _MAT method
Date: Wed,  4 Dec 2013 00:39:07 +0800
Message-Id: <1386088753-2850-4-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386088753-2850-1-git-send-email-hanjun.guo@linaro.org>
References: <1386088753-2850-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get apic id from MADT or _MAT method is not implemented on arm/arm64,
and ACPI 5.0 introduces GIC Structure for it, so this patch introduces
map_gic_id() to get apic id followed the ACPI 5.0 spec.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 drivers/acpi/processor_core.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 9931435..a83b01c 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -89,6 +89,27 @@ static int map_lsapic_id(struct acpi_subtable_header *entry,
 	return 1;
 }
 
+static int map_gic_id(struct acpi_subtable_header *entry,
+		int device_declaration, u32 acpi_id, int *apic_id)
+{
+	struct acpi_madt_generic_interrupt *gic =
+		(struct acpi_madt_generic_interrupt *)entry;
+
+	if (!(gic->flags & ACPI_MADT_ENABLED))
+		return 0;
+
+	/* In the GIC interrupt model, logical processors are
+	 * required to have a Processor Device object in the DSDT,
+	 * so we should check device_declaration here
+	 */
+	if (device_declaration && (gic->uid == acpi_id)) {
+		*apic_id = gic->gic_id;
+		return 1;
+	}
+
+	return 0;
+}
+
 static int map_madt_entry(int type, u32 acpi_id)
 {
 	unsigned long madt_end, entry;
@@ -124,6 +145,9 @@ static int map_madt_entry(int type, u32 acpi_id)
 		} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
 			if (map_lsapic_id(header, type, acpi_id, &apic_id))
 				break;
+		} else if (header->type == ACPI_MADT_TYPE_GENERIC_INTERRUPT) {
+			if (map_gic_id(header, type, acpi_id, &apic_id))
+				break;
 		}
 		entry += header->length;
 	}
@@ -154,6 +178,8 @@ static int map_mat_entry(acpi_handle handle, int type, u32 acpi_id)
 		map_lapic_id(header, acpi_id, &apic_id);
 	} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
 		map_lsapic_id(header, type, acpi_id, &apic_id);
+	} else if (header->type == ACPI_MADT_TYPE_GENERIC_INTERRUPT) {
+		map_gic_id(header, type, acpi_id, &apic_id);
 	}
 
 exit:
-- 
1.7.9.5

