Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214AbaBRN4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:56:18 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:56481 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbaBRN4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:56:15 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>
Subject: [PATCH v4 2/5] ACPI / processor_core: Rework _PDC related stuff to make it more arch-independent
Date: Tue, 18 Feb 2014 21:54:57 +0800
Message-Id: <1392731700-10992-3-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392731700-10992-1-git-send-email-hanjun.guo@linaro.org>
References: <1392731700-10992-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_PDC related stuff in processor_core.c is little bit X86/IA64 dependent,
rework the code to make it more arch-independent, no functional change
in this patch.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
---
 arch/ia64/include/asm/acpi.h  |    5 +----
 arch/ia64/kernel/acpi.c       |   14 ++++++++++++++
 arch/x86/include/asm/acpi.h   |   19 +------------------
 arch/x86/kernel/acpi/cstate.c |   29 +++++++++++++++++++++++++++++
 drivers/acpi/processor_core.c |   19 +------------------
 5 files changed, 46 insertions(+), 40 deletions(-)

diff --git a/arch/ia64/include/asm/acpi.h b/arch/ia64/include/asm/acpi.h
index d651102..d2b8b9d 100644
--- a/arch/ia64/include/asm/acpi.h
+++ b/arch/ia64/include/asm/acpi.h
@@ -152,10 +152,7 @@ extern int __initdata nid_to_pxm_map[MAX_NUMNODES];
 #endif
 
 static inline bool arch_has_acpi_pdc(void) { return true; }
-static inline void arch_acpi_set_pdc_bits(u32 *buf)
-{
-	buf[2] |= ACPI_PDC_EST_CAPABILITY_SMP;
-}
+extern void arch_acpi_set_pdc_bits(u32 *buf);
 
 #define acpi_unlazy_tlb(x)
 
diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index 07d209c..af9d9e4 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -1014,3 +1014,17 @@ EXPORT_SYMBOL(acpi_unregister_ioapic);
  * TBD when when IA64 starts to support suspend...
  */
 int acpi_suspend_lowlevel(void) { return 0; }
+
+void arch_acpi_set_pdc_bits(u32 *buf)
+{
+	/* Enable coordination with firmware's _TSD info */
+	buf[2] |= ACPI_PDC_SMP_T_SWCOORD | ACPI_PDC_EST_CAPABILITY_SMP;
+	if (boot_option_idle_override == IDLE_NOMWAIT) {
+		/*
+		 * If mwait is disabled for CPU C-states, the C2C3_FFH access
+		 * mode will be disabled in the parameter of _PDC object.
+		 * Of course C1_FFH access mode will also be disabled.
+		 */
+		buf[2] &= ~(ACPI_PDC_C_C2C3_FFH | ACPI_PDC_C_C1_FFH);
+	}
+}
diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index c8c1e70..e9f71bc 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -147,24 +147,7 @@ static inline bool arch_has_acpi_pdc(void)
 		c->x86_vendor == X86_VENDOR_CENTAUR);
 }
 
-static inline void arch_acpi_set_pdc_bits(u32 *buf)
-{
-	struct cpuinfo_x86 *c = &cpu_data(0);
-
-	buf[2] |= ACPI_PDC_C_CAPABILITY_SMP;
-
-	if (cpu_has(c, X86_FEATURE_EST))
-		buf[2] |= ACPI_PDC_EST_CAPABILITY_SWSMP;
-
-	if (cpu_has(c, X86_FEATURE_ACPI))
-		buf[2] |= ACPI_PDC_T_FFH;
-
-	/*
-	 * If mwait/monitor is unsupported, C2/C3_FFH will be disabled
-	 */
-	if (!cpu_has(c, X86_FEATURE_MWAIT))
-		buf[2] &= ~(ACPI_PDC_C_C2C3_FFH);
-}
+extern void arch_acpi_set_pdc_bits(u32 *buf);
 
 #else /* !CONFIG_ACPI */
 
diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index e69182f..a36638f 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -16,6 +16,35 @@
 #include <asm/mwait.h>
 #include <asm/special_insns.h>
 
+void arch_acpi_set_pdc_bits(u32 *buf)
+{
+	struct cpuinfo_x86 *c = &cpu_data(0);
+
+	/* Enable coordination with firmware's _TSD info */
+	buf[2] |= ACPI_PDC_SMP_T_SWCOORD | ACPI_PDC_C_CAPABILITY_SMP;
+
+	if (cpu_has(c, X86_FEATURE_EST))
+		buf[2] |= ACPI_PDC_EST_CAPABILITY_SWSMP;
+
+	if (cpu_has(c, X86_FEATURE_ACPI))
+		buf[2] |= ACPI_PDC_T_FFH;
+
+	/*
+	 * If mwait/monitor is unsupported, C2/C3_FFH will be disabled
+	 */
+	if (!cpu_has(c, X86_FEATURE_MWAIT))
+		buf[2] &= ~(ACPI_PDC_C_C2C3_FFH);
+
+	if (boot_option_idle_override == IDLE_NOMWAIT) {
+		/*
+		 * If mwait is disabled for CPU C-states, the C2C3_FFH access
+		 * mode will be disabled in the parameter of _PDC object.
+		 * Of course C1_FFH access mode will also be disabled.
+		 */
+		buf[2] &= ~(ACPI_PDC_C_C2C3_FFH | ACPI_PDC_C_C1_FFH);
+	}
+}
+
 /*
  * Initialize bm_flags based on the CPU cache properties
  * On SMP it depends on cache configuration
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 636fd59..5bbc255 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -255,9 +255,6 @@ static void acpi_set_pdc_bits(u32 *buf)
 	buf[0] = ACPI_PDC_REVISION_ID;
 	buf[1] = 1;
 
-	/* Enable coordination with firmware's _TSD info */
-	buf[2] = ACPI_PDC_SMP_T_SWCOORD;
-
 	/* Twiddle arch-specific bits needed for _PDC */
 	arch_acpi_set_pdc_bits(buf);
 }
@@ -282,7 +279,7 @@ static struct acpi_object_list *acpi_processor_alloc_pdc(void)
 		return NULL;
 	}
 
-	buf = kmalloc(12, GFP_KERNEL);
+	buf = kzalloc(12, GFP_KERNEL);
 	if (!buf) {
 		printk(KERN_ERR "Memory allocation error\n");
 		kfree(obj);
@@ -310,20 +307,6 @@ acpi_processor_eval_pdc(acpi_handle handle, struct acpi_object_list *pdc_in)
 {
 	acpi_status status = AE_OK;
 
-	if (boot_option_idle_override == IDLE_NOMWAIT) {
-		/*
-		 * If mwait is disabled for CPU C-states, the C2C3_FFH access
-		 * mode will be disabled in the parameter of _PDC object.
-		 * Of course C1_FFH access mode will also be disabled.
-		 */
-		union acpi_object *obj;
-		u32 *buffer = NULL;
-
-		obj = pdc_in->pointer;
-		buffer = (u32 *)(obj->buffer.pointer);
-		buffer[2] &= ~(ACPI_PDC_C_C2C3_FFH | ACPI_PDC_C_C1_FFH);
-
-	}
 	status = acpi_evaluate_object(handle, "_PDC", pdc_in, NULL);
 
 	if (ACPI_FAILURE(status))
-- 
1.7.9.5

