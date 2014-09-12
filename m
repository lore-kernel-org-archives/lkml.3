Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbaILOBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:01:40 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:48324 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbaILOBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:01:37 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Jon Masters <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH v4 10/18] ACPI / table: Print GIC information when MADT is parsed
Date: Fri, 12 Sep 2014 22:00:08 +0800
Message-Id: <1410530416-30200-11-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When MADT is parsed, print GIC information to make the boot
log look pretty.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
---
 drivers/acpi/tables.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index b18e45e..47f36d4 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -183,6 +183,49 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
 		}
 		break;
 
+	case ACPI_MADT_TYPE_GENERIC_INTERRUPT:
+		{
+			struct acpi_madt_generic_interrupt *p =
+				(struct acpi_madt_generic_interrupt *)header;
+			pr_info("GICC (acpi_id[0x%04x] address[%p] MPDIR[0x%llx] %s)\n",
+				p->uid, (void *)(unsigned long)p->base_address,
+				p->arm_mpidr,
+				(p->flags & ACPI_MADT_ENABLED) ? "enabled" : "disabled");
+
+		}
+		break;
+
+	case ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR:
+		{
+			struct acpi_madt_generic_distributor *p =
+				(struct acpi_madt_generic_distributor *)header;
+			pr_info("GIC Distributor (gic_id[0x%04x] address[%p] gsi_base[%d])\n",
+				p->gic_id,
+				(void *)(unsigned long)p->base_address,
+				p->global_irq_base);
+		}
+		break;
+
+	case ACPI_MADT_TYPE_GENERIC_MSI_FRAME:
+		{
+			struct acpi_madt_generic_msi_frame *p =
+				(struct acpi_madt_generic_msi_frame *)header;
+			pr_info("GIC MSI Frame (msi_fame_id[%d] address[%p])\n",
+				p->msi_frame_id,
+				(void *)(unsigned long)p->base_address);
+		}
+		break;
+
+	case ACPI_MADT_TYPE_GENERIC_REDISTRIBUTOR:
+		{
+			struct acpi_madt_generic_redistributor *p =
+				(struct acpi_madt_generic_redistributor *)header;
+			pr_info("GIC Redistributor (address[%p] region_size[0x%x])\n",
+				(void *)(unsigned long)p->base_address,
+				p->length);
+		}
+		break;
+
 	default:
 		pr_warn("Found unsupported MADT entry (type = 0x%x)\n",
 			header->type);
-- 
1.7.9.5

