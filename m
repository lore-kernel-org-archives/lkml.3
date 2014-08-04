Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaHDPbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 11:31:39 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46158 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaHDPbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 11:31:35 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
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
        Al Stone <al.stone@linaro.org>, Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v2 15/18] ARM64 / ACPI: Introduce early_param for "acpi" and set ACPI default off
Date: Mon,  4 Aug 2014 23:28:22 +0800
Message-Id: <1407166105-17675-16-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407166105-17675-1-git-send-email-hanjun.guo@linaro.org>
References: <1407166105-17675-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Stone <al.stone@linaro.org>

Introduce one early parameters "on" for "acpi" to enable ACPI on
ARM64.

Disable ACPI before early parameters parsed, and enable it to pass
"acpi=on" if people want use ACPI on ARM64.

Signed-off-by: Al Stone <al.stone@linaro.org>
Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 Documentation/kernel-parameters.txt |    5 +++--
 arch/arm64/include/asm/acpi.h       |    9 +++++++++
 arch/arm64/kernel/acpi.c            |   17 +++++++++++++++++
 arch/arm64/kernel/setup.c           |    3 +++
 4 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b7fa2f5..1f63156 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -165,9 +165,9 @@ multipliers 'Kilo', 'Mega', and 'Giga', equalling 2^10, 2^20, and 2^30
 bytes respectively. Such letter suffixes can also be entirely omitted.
 
 
-	acpi=		[HW,ACPI,X86]
+	acpi=		[HW,ACPI,X86,ARM]
 			Advanced Configuration and Power Interface
-			Format: { force | off | strict | noirq | rsdt }
+			Format: { force | off | strict | noirq | rsdt | on}
 			force -- enable ACPI if default was off
 			off -- disable ACPI if default was on
 			noirq -- do not use ACPI for IRQ routing
@@ -175,6 +175,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 				strictly ACPI specification compliant.
 			rsdt -- prefer RSDT over (default) XSDT
 			copy_dsdt -- copy DSDT to memory
+			"acpi=on" is ONLY available for ARM64.
 
 			See also Documentation/power/runtime_pm.txt, pci=noacpi
 
diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index 009303d..0f2c51a 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -61,6 +61,13 @@ static inline void disable_acpi(void)
 	acpi_noirq = 1;
 }
 
+static inline void enable_acpi(void)
+{
+	acpi_disabled = 0;
+	acpi_pci_disabled = 0;
+	acpi_noirq = 0;
+}
+
 u32 pack_mpidr_into_32_bits(u64 mpidr);
 
 /*
@@ -99,6 +106,8 @@ static inline void arch_fix_phys_package_id(int num, u32 slot) { }
 extern int (*acpi_suspend_lowlevel)(void);
 #define acpi_wakeup_address 0
 
+#else
+static inline void disable_acpi(void) {}
 #endif /* CONFIG_ACPI */
 
 #endif /*_ASM_ACPI_H*/
diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 988fea2..585d08c 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -361,3 +361,20 @@ u32 pack_mpidr_into_32_bits(u64 mpidr)
  * TBD when ARM/ARM64 starts to support suspend...
  */
 int (*acpi_suspend_lowlevel)(void) = NULL;
+
+static int __init parse_acpi(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	/* "acpi=on" enables both ACPI table parsing and interpreter */
+	if (strcmp(arg, "on") == 0) {
+		enable_acpi();
+	} else {
+		/* Core will printk when we return error */
+		return -EINVAL;
+	}
+
+	return 0;
+}
+early_param("acpi", parse_acpi);
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index dfc4e4f3..056e2e1 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -59,6 +59,7 @@
 #include <asm/memblock.h>
 #include <asm/psci.h>
 #include <asm/efi.h>
+#include <asm/acpi.h>
 
 unsigned int processor_id;
 EXPORT_SYMBOL(processor_id);
@@ -380,6 +381,8 @@ void __init setup_arch(char **cmdline_p)
 	*cmdline_p = boot_command_line;
 
 	early_ioremap_init();
+	
+	disable_acpi();
 
 	parse_early_param();
 
-- 
1.7.9.5

