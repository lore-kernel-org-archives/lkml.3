Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaAQCGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 21:06:22 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:51377 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaAQCGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 21:06:20 -0500
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
        linaro-acpi@lists.linaro.org, Hanjun Guo <hanjun.guo@linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>
Subject: [PATCH 2/3] ACPI / processor_core: Rework _PDC related stuff to make it more arch-independent
Date: Fri, 17 Jan 2014 10:03:26 +0800
Message-Id: <1389924207-7360-3-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389924207-7360-1-git-send-email-hanjun.guo@linaro.org>
References: <1389924207-7360-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_PDC related stuff in processor_core.c is little bit X86/IA64 dependent,
rework the code to make it more arch-independent, no functional change
in this patch.

The return value of acpi_processor_eval_pdc() should be 'acpi_status' but
defined as 'int', fix it too.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
---
 arch/ia64/include/asm/acpi.h  |  5 +----
 arch/ia64/kernel/acpi.c       | 17 +++++++++++++++++
 arch/x86/include/asm/acpi.h   | 19 +------------------
 arch/x86/kernel/acpi/cstate.c | 31 +++++++++++++++++++++++++++++++
 drivers/acpi/processor_core.c | 21 ++-------------------
 5 files changed, 52 insertions(+), 41 deletions(-)

diff --git a/arch/ia64/include/asm/acpi.h b/arch/ia64/include/asm/acpi.h
index faa1bf0..3348d07 100644
--- a/arch/ia64/include/asm/acpi.h
+++ b/arch/ia64/include/asm/acpi.h
@@ -154,10 +154,7 @@ extern int __initdata nid_to_pxm_map[MAX_NUMNODES];
 #endif
 
 static inline bool arch_has_acpi_pdc(void) { return true; }
-static inline void arch_acpi_set_pdc_bits(u32 *buf)
-{
-	buf[2] |= ACPI_PDC_EST_CAPABILITY_SMP;
-}
+extern void arch_acpi_set_pdc_bits(u32 *buf);
 
 #define acpi_unlazy_tlb(x)
 
diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index 59d52e3..d126f15 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -1018,3 +1018,20 @@ EXPORT_SYMBOL(acpi_unregister_ioapic);
  * TBD when when IA64 starts to support suspend...
  */
 int acpi_suspend_lowlevel(void) { return 0; }
+
+void arch_acpi_set_pdc_bits(u32 *buf)
+{
+	/* Enable coordination with firmware's _TSD info */
+	buf[2] |= ACPI_PDC_SMP_T_SWCOORD;
+	if (boot_option_idle_override == IDLE_NOMWAIT) {
+		/*
+		 * If mwait is disabled for CPU C-states, the C2C3_FFH access
+		 * mode will be disabled in the parameter of _PDC object.
+		 * Of course C1_FFH access mode will also be disabled.
+		 */
+		buf[2] &= ~(ACPI_PDC_C_C2C3_FFH | ACPI_PDC_C_C1_FFH);
+
+	}
+
+	buf[2] |= ACPI_PDC_EST_CAPABILITY_SMP;
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
index d2b7f27..b132748 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -16,6 +16,37 @@
 #include <asm/mwait.h>
 #include <asm/special_insns.h>
 
+void arch_acpi_set_pdc_bits(u32 *buf)
+{
+	struct cpuinfo_x86 *c = &cpu_data(0);
+
+	/* Enable coordination with firmware's _TSD info */
+	buf[2] |= ACPI_PDC_SMP_T_SWCOORD;
+	if (boot_option_idle_override == IDLE_NOMWAIT) {
+		/*
+		 * If mwait is disabled for CPU C-states, the C2C3_FFH access
+		 * mode will be disabled in the parameter of _PDC object.
+		 * Of course C1_FFH access mode will also be disabled.
+		 */
+		buf[2] &= ~(ACPI_PDC_C_C2C3_FFH | ACPI_PDC_C_C1_FFH);
+
+	}
+
+	buf[2] |= ACPI_PDC_C_CAPABILITY_SMP;
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
+}
+
 /*
  * Initialize bm_flags based on the CPU cache properties
  * On SMP it depends on cache configuration
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index b3171f3..cd7b5fe 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -274,9 +274,6 @@ static void acpi_set_pdc_bits(u32 *buf)
 	buf[0] = ACPI_PDC_REVISION_ID;
 	buf[1] = 1;
 
-	/* Enable coordination with firmware's _TSD info */
-	buf[2] = ACPI_PDC_SMP_T_SWCOORD;
-
 	/* Twiddle arch-specific bits needed for _PDC */
 	arch_acpi_set_pdc_bits(buf);
 }
@@ -301,7 +298,7 @@ static struct acpi_object_list *acpi_processor_alloc_pdc(void)
 		return NULL;
 	}
 
-	buf = kmalloc(12, GFP_KERNEL);
+	buf = kzalloc(12, GFP_KERNEL);
 	if (!buf) {
 		printk(KERN_ERR "Memory allocation error\n");
 		kfree(obj);
@@ -324,25 +321,11 @@ static struct acpi_object_list *acpi_processor_alloc_pdc(void)
  * _PDC is required for a BIOS-OS handshake for most of the newer
  * ACPI processor features.
  */
-static int
+static acpi_status
 acpi_processor_eval_pdc(acpi_handle handle, struct acpi_object_list *pdc_in)
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
1.8.2.2

