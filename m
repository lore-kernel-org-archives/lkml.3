Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab3KLWJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 17:09:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:4632 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757035Ab3KLWJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 17:09:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="434167694"
From: David Cohen <david.a.cohen@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH 1/3] sfi: add private data to sfi_parse_table()
Date: Tue, 12 Nov 2013 14:13:38 -0800
Message-Id: <1384294420-9124-2-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1384294420-9124-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1384294420-9124-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sfi_parse_table() receives a callback as argument to call during its
execution. This patch adds private data argument to send to such
callback.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>
---
 arch/x86/include/asm/intel-mid.h             |  4 ++--
 arch/x86/platform/intel-mid/intel-mid.c      |  2 +-
 arch/x86/platform/intel-mid/intel_mid_vrtc.c |  2 +-
 arch/x86/platform/intel-mid/sfi.c            | 13 +++++++------
 arch/x86/platform/sfi/sfi.c                  |  8 ++++----
 drivers/sfi/sfi_acpi.c                       |  5 +++--
 drivers/sfi/sfi_core.c                       |  4 ++--
 include/linux/sfi.h                          |  8 +++++---
 8 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/intel-mid.h b/arch/x86/include/asm/intel-mid.h
index e34e097b6f9d..c810abd5178c 100644
--- a/arch/x86/include/asm/intel-mid.h
+++ b/arch/x86/include/asm/intel-mid.h
@@ -17,8 +17,8 @@
 extern int intel_mid_pci_init(void);
 extern int get_gpio_by_name(const char *name);
 extern void intel_scu_device_register(struct platform_device *pdev);
-extern int __init sfi_parse_mrtc(struct sfi_table_header *table);
-extern int __init sfi_parse_mtmr(struct sfi_table_header *table);
+extern int __init sfi_parse_mrtc(struct sfi_table_header *table, void *const priv);
+extern int __init sfi_parse_mtmr(struct sfi_table_header *table, void *const priv);
 extern int sfi_mrtc_num;
 extern struct sfi_rtc_table_entry sfi_mrtc_array[];
 
diff --git a/arch/x86/platform/intel-mid/intel-mid.c b/arch/x86/platform/intel-mid/intel-mid.c
index 1bbedc4b0f88..68124ed102c3 100644
--- a/arch/x86/platform/intel-mid/intel-mid.c
+++ b/arch/x86/platform/intel-mid/intel-mid.c
@@ -83,7 +83,7 @@ static unsigned long __init intel_mid_calibrate_tsc(void)
 
 static void __init intel_mid_time_init(void)
 {
-	sfi_table_parse(SFI_SIG_MTMR, NULL, NULL, sfi_parse_mtmr);
+	sfi_table_parse(SFI_SIG_MTMR, NULL, NULL, sfi_parse_mtmr, NULL);
 	switch (intel_mid_timer_options) {
 	case INTEL_MID_TIMER_APBT_ONLY:
 		break;
diff --git a/arch/x86/platform/intel-mid/intel_mid_vrtc.c b/arch/x86/platform/intel-mid/intel_mid_vrtc.c
index 4762cff7facd..3afb51ad745b 100644
--- a/arch/x86/platform/intel-mid/intel_mid_vrtc.c
+++ b/arch/x86/platform/intel-mid/intel_mid_vrtc.c
@@ -120,7 +120,7 @@ void __init intel_mid_rtc_init(void)
 {
 	unsigned long vrtc_paddr;
 
-	sfi_table_parse(SFI_SIG_MRTC, NULL, NULL, sfi_parse_mrtc);
+	sfi_table_parse(SFI_SIG_MRTC, NULL, NULL, sfi_parse_mrtc, NULL);
 
 	vrtc_paddr = sfi_mrtc_array[0].phys_addr;
 	if (!sfi_mrtc_num || !vrtc_paddr)
diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
index 438306ebed05..2c66024b7067 100644
--- a/arch/x86/platform/intel-mid/sfi.c
+++ b/arch/x86/platform/intel-mid/sfi.c
@@ -73,7 +73,7 @@ EXPORT_SYMBOL_GPL(intel_scu_notifier);
 	((dev)->get_platform_data ? (dev)->get_platform_data(priv) : NULL)
 
 /* parse all the mtimer info to a static mtimer array */
-int __init sfi_parse_mtmr(struct sfi_table_header *table)
+int __init sfi_parse_mtmr(struct sfi_table_header *table, void *const priv)
 {
 	struct sfi_table_simple *sb;
 	struct sfi_timer_table_entry *pentry;
@@ -146,7 +146,7 @@ void sfi_free_mtmr(struct sfi_timer_table_entry *mtmr)
 }
 
 /* parse all the mrtc info to a global mrtc array */
-int __init sfi_parse_mrtc(struct sfi_table_header *table)
+int __init sfi_parse_mrtc(struct sfi_table_header *table, void *const priv)
 {
 	struct sfi_table_simple *sb;
 	struct sfi_rtc_table_entry *pentry;
@@ -185,7 +185,8 @@ int __init sfi_parse_mrtc(struct sfi_table_header *table)
  * Parsing GPIO table first, since the DEVS table will need this table
  * to map the pin name to the actual pin.
  */
-static int __init sfi_parse_gpio(struct sfi_table_header *table)
+static int __init sfi_parse_gpio(struct sfi_table_header *table,
+				 void *const priv)
 {
 	struct sfi_table_simple *sb;
 	struct sfi_gpio_table_entry *pentry;
@@ -427,7 +428,7 @@ static struct devs_id __init *get_device_id(u8 type, char *name)
 	return NULL;
 }
 
-static int __init sfi_parse_devs(struct sfi_table_header *table)
+static int __init sfi_parse_devs(struct sfi_table_header *table, void *const priv)
 {
 	struct sfi_table_simple *sb;
 	struct sfi_device_table_entry *pentry;
@@ -509,8 +510,8 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
 
 static int __init intel_mid_platform_init(void)
 {
-	sfi_table_parse(SFI_SIG_GPIO, NULL, NULL, sfi_parse_gpio);
-	sfi_table_parse(SFI_SIG_DEVS, NULL, NULL, sfi_parse_devs);
+	sfi_table_parse(SFI_SIG_GPIO, NULL, NULL, sfi_parse_gpio, NULL);
+	sfi_table_parse(SFI_SIG_DEVS, NULL, NULL, sfi_parse_devs, NULL);
 	return 0;
 }
 arch_initcall(intel_mid_platform_init);
diff --git a/arch/x86/platform/sfi/sfi.c b/arch/x86/platform/sfi/sfi.c
index bcd1a703e3e6..8b022f5e30e8 100644
--- a/arch/x86/platform/sfi/sfi.c
+++ b/arch/x86/platform/sfi/sfi.c
@@ -48,7 +48,7 @@ static void __init mp_sfi_register_lapic(u8 id)
 	generic_processor_info(id, GET_APIC_VERSION(apic_read(APIC_LVR)));
 }
 
-static int __init sfi_parse_cpus(struct sfi_table_header *table)
+static int __init sfi_parse_cpus(struct sfi_table_header *table, void *priv)
 {
 	struct sfi_table_simple *sb;
 	struct sfi_cpu_table_entry *pentry;
@@ -71,7 +71,7 @@ static int __init sfi_parse_cpus(struct sfi_table_header *table)
 
 #ifdef CONFIG_X86_IO_APIC
 
-static int __init sfi_parse_ioapic(struct sfi_table_header *table)
+static int __init sfi_parse_ioapic(struct sfi_table_header *table, void *priv)
 {
 	struct sfi_table_simple *sb;
 	struct sfi_apic_table_entry *pentry;
@@ -100,10 +100,10 @@ int __init sfi_platform_init(void)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
 	register_lapic_address(sfi_lapic_addr);
-	sfi_table_parse(SFI_SIG_CPUS, NULL, NULL, sfi_parse_cpus);
+	sfi_table_parse(SFI_SIG_CPUS, NULL, NULL, sfi_parse_cpus, NULL);
 #endif
 #ifdef CONFIG_X86_IO_APIC
-	sfi_table_parse(SFI_SIG_APIC, NULL, NULL, sfi_parse_ioapic);
+	sfi_table_parse(SFI_SIG_APIC, NULL, NULL, sfi_parse_ioapic, NULL);
 #endif
 	return 0;
 }
diff --git a/drivers/sfi/sfi_acpi.c b/drivers/sfi/sfi_acpi.c
index f5b4ca581541..be71be084a5f 100644
--- a/drivers/sfi/sfi_acpi.c
+++ b/drivers/sfi/sfi_acpi.c
@@ -96,7 +96,8 @@ static inline struct acpi_table_header *sfi_to_acpi_th(
  *
  * Parse the ACPI XSDT for later access by sfi_acpi_table_parse().
  */
-static int __init sfi_acpi_parse_xsdt(struct sfi_table_header *th)
+static int __init
+sfi_acpi_parse_xsdt(struct sfi_table_header *th, void *const priv)
 {
 	struct sfi_table_key key = SFI_ANY_KEY;
 	int tbl_cnt, i;
@@ -119,7 +120,7 @@ int __init sfi_acpi_init(void)
 {
 	struct sfi_table_key xsdt_key = { .sig = SFI_SIG_XSDT };
 
-	sfi_table_parse(SFI_SIG_XSDT, NULL, NULL, sfi_acpi_parse_xsdt);
+	sfi_table_parse(SFI_SIG_XSDT, NULL, NULL, sfi_acpi_parse_xsdt, NULL);
 
 	/* Only call the get_table to keep the table mapped */
 	xsdt_va = (struct acpi_table_xsdt *)sfi_get_table(&xsdt_key);
diff --git a/drivers/sfi/sfi_core.c b/drivers/sfi/sfi_core.c
index 1e824fb1649b..8289d95be04a 100644
--- a/drivers/sfi/sfi_core.c
+++ b/drivers/sfi/sfi_core.c
@@ -278,7 +278,7 @@ void sfi_put_table(struct sfi_table_header *th)
 
 /* Find table with signature, run handler on it */
 int sfi_table_parse(char *signature, char *oem_id, char *oem_table_id,
-			sfi_table_handler handler)
+			sfi_table_handler handler, void *const priv)
 {
 	struct sfi_table_header *table = NULL;
 	struct sfi_table_key key;
@@ -295,7 +295,7 @@ int sfi_table_parse(char *signature, char *oem_id, char *oem_table_id,
 	if (!table)
 		goto exit;
 
-	ret = handler(table);
+	ret = handler(table, priv);
 	sfi_put_table(table);
 exit:
 	return ret;
diff --git a/include/linux/sfi.h b/include/linux/sfi.h
index d9b436f09925..3d2be5c02256 100644
--- a/include/linux/sfi.h
+++ b/include/linux/sfi.h
@@ -170,14 +170,15 @@ struct sfi_gpio_table_entry {
 	char	pin_name[SFI_NAME_LEN];
 } __packed;
 
-typedef int (*sfi_table_handler) (struct sfi_table_header *table);
+typedef int (*sfi_table_handler) (struct sfi_table_header *table,
+				  void *const priv);
 
 #ifdef CONFIG_SFI
 extern void __init sfi_init(void);
 extern int __init sfi_platform_init(void);
 extern void __init sfi_init_late(void);
 extern int sfi_table_parse(char *signature, char *oem_id, char *oem_table_id,
-				sfi_table_handler handler);
+				sfi_table_handler handler, void *const priv);
 
 extern int sfi_disabled;
 static inline void disable_sfi(void)
@@ -199,7 +200,8 @@ static inline void sfi_init_late(void)
 
 static inline int sfi_table_parse(char *signature, char *oem_id,
 					char *oem_table_id,
-					sfi_table_handler handler)
+					sfi_table_handler handler,
+					void *const priv)
 {
 	return -1;
 }
-- 
1.8.4.2

