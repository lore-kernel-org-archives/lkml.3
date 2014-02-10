Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbaBJHu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 02:50:29 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:62458 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaBJHuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 02:50:24 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v3 3/3] ACPI / processor: Introduce map_gic_id() to get apic id from MADT or _MAT method
Date: Mon, 10 Feb 2014 15:49:02 +0800
Message-Id: <1392018542-10949-4-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392018542-10949-1-git-send-email-hanjun.guo@linaro.org>
References: <1392018542-10949-1-git-send-email-hanjun.guo@linaro.org>
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
index 575c500..eaaeebc 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -71,6 +71,27 @@ static int map_lsapic_id(struct acpi_subtable_header *entry,
 	return 0;
 }
 
+static int map_gic_id(struct acpi_subtable_header *entry,
+		int device_declaration, u32 acpi_id, int *apic_id)
+{
+	struct acpi_madt_generic_interrupt *gic =
+		(struct acpi_madt_generic_interrupt *)entry;
+
+	if (!(gic->flags & ACPI_MADT_ENABLED))
+		return -ENODEV;
+
+	/* In the GIC interrupt model, logical processors are
+	 * required to have a Processor Device object in the DSDT,
+	 * so we should check device_declaration here
+	 */
+	if (device_declaration && (gic->uid == acpi_id)) {
+		*apic_id = gic->gic_id;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 static int map_madt_entry(int type, u32 acpi_id)
 {
 	unsigned long madt_end, entry;
@@ -106,6 +127,9 @@ static int map_madt_entry(int type, u32 acpi_id)
 		} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
 			if (!map_lsapic_id(header, type, acpi_id, &apic_id))
 				break;
+		} else if (header->type == ACPI_MADT_TYPE_GENERIC_INTERRUPT) {
+			if (!map_gic_id(header, type, acpi_id, &apic_id))
+				break;
 		}
 		entry += header->length;
 	}
@@ -136,6 +160,8 @@ static int map_mat_entry(acpi_handle handle, int type, u32 acpi_id)
 		map_lapic_id(header, acpi_id, &apic_id);
 	} else if (header->type == ACPI_MADT_TYPE_LOCAL_SAPIC) {
 		map_lsapic_id(header, type, acpi_id, &apic_id);
+	} else if (header->type == ACPI_MADT_TYPE_GENERIC_INTERRUPT) {
+		map_gic_id(header, type, acpi_id, &apic_id);
 	}
 
 exit:
-- 
1.7.9.5

