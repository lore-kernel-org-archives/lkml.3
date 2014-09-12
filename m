Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbaILOCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:02:00 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:46986 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222AbaILOBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:01:54 -0400
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
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v4 13/18] ARM64 / ACPI: Introduce ACPI_IRQ_MODEL_GIC and register device's gsi
Date: Fri, 12 Sep 2014 22:00:11 +0800
Message-Id: <1410530416-30200-14-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce ACPI_IRQ_MODEL_GIC which is needed for ARM64 as GIC is
used, and then register device's gsi with the core IRQ subsystem.

acpi_register_gsi() is similar to DT based irq_of_parse_and_map(),
since gsi is unique in the system, so use hwirq number directly
for the mapping.

Originally-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/kernel/acpi.c |   73 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/bus.c       |    3 ++
 include/linux/acpi.h     |    1 +
 3 files changed, 77 insertions(+)

diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 2ef8721..5b3546b 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -37,6 +37,12 @@ EXPORT_SYMBOL(acpi_pci_disabled);
 static int enabled_cpus;	/* Processors (GICC) with enabled flag in MADT */
 
 /*
+ * Since we're on ARM, the default interrupt routing model
+ * clearly has to be GIC.
+ */
+enum acpi_irq_model_id acpi_irq_model = ACPI_IRQ_MODEL_GIC;
+
+/*
  * __acpi_map_table() will be called before page_init(), so early_ioremap()
  * or early_memremap() should be called here to for ACPI table mapping.
  */
@@ -181,6 +187,73 @@ void __init acpi_smp_init_cpus(void)
 	pr_info("%d CPUs enabled, %d CPUs total\n", enabled_cpus, total_cpus);
 }
 
+int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
+{
+	*irq = irq_find_mapping(NULL, gsi);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(acpi_gsi_to_irq);
+
+/*
+ * success: return IRQ number (>0)
+ * failure: return =< 0
+ */
+int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
+{
+	unsigned int irq;
+	unsigned int irq_type;
+
+	/*
+	 * ACPI have no bindings to indicate SPI or PPI, so we
+	 * use different mappings from DT in ACPI.
+	 *
+	 * For FDT
+	 * PPI interrupt: in the range [0, 15];
+	 * SPI interrupt: in the range [0, 987];
+	 *
+	 * For ACPI, GSI should be unique so using
+	 * the hwirq directly for the mapping:
+	 * PPI interrupt: in the range [16, 31];
+	 * SPI interrupt: in the range [32, 1019];
+	 */
+
+	if (trigger == ACPI_EDGE_SENSITIVE &&
+				polarity == ACPI_ACTIVE_LOW)
+		irq_type = IRQ_TYPE_EDGE_FALLING;
+	else if (trigger == ACPI_EDGE_SENSITIVE &&
+				polarity == ACPI_ACTIVE_HIGH)
+		irq_type = IRQ_TYPE_EDGE_RISING;
+	else if (trigger == ACPI_LEVEL_SENSITIVE &&
+				polarity == ACPI_ACTIVE_LOW)
+		irq_type = IRQ_TYPE_LEVEL_LOW;
+	else if (trigger == ACPI_LEVEL_SENSITIVE &&
+				polarity == ACPI_ACTIVE_HIGH)
+		irq_type = IRQ_TYPE_LEVEL_HIGH;
+	else
+		irq_type = IRQ_TYPE_NONE;
+
+	/*
+	 * Since only one GIC is supported in ACPI 5.0, we can
+	 * create mapping refer to the default domain
+	 */
+	irq = irq_create_mapping(NULL, gsi);
+	if (!irq)
+		return irq;
+
+	/* Set irq type if specified and different than the current one */
+	if (irq_type != IRQ_TYPE_NONE &&
+		irq_type != irq_get_trigger_type(irq))
+		irq_set_irq_type(irq, irq_type);
+	return irq;
+}
+EXPORT_SYMBOL_GPL(acpi_register_gsi);
+
+void acpi_unregister_gsi(u32 gsi)
+{
+}
+EXPORT_SYMBOL_GPL(acpi_unregister_gsi);
+
 static int __init acpi_parse_fadt(struct acpi_table_header *table)
 {
 	struct acpi_table_fadt *fadt = (struct acpi_table_fadt *)table;
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 8581f5b..d132c1b 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -458,6 +458,9 @@ static int __init acpi_bus_init_irq(void)
 	case ACPI_IRQ_MODEL_IOSAPIC:
 		message = "IOSAPIC";
 		break;
+	case ACPI_IRQ_MODEL_GIC:
+		message = "GIC";
+		break;
 	case ACPI_IRQ_MODEL_PLATFORM:
 		message = "platform specific model";
 		break;
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 36d5012..4615eb1 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -71,6 +71,7 @@ enum acpi_irq_model_id {
 	ACPI_IRQ_MODEL_IOAPIC,
 	ACPI_IRQ_MODEL_IOSAPIC,
 	ACPI_IRQ_MODEL_PLATFORM,
+	ACPI_IRQ_MODEL_GIC,
 	ACPI_IRQ_MODEL_COUNT
 };
 
-- 
1.7.9.5

