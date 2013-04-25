Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906Ab3DYRbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:31:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56839 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932761Ab3DYR3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:29:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Rob Herring <robherring2@gmail.com>
Subject: [PATCH 02/21] ARM: default machine descriptor for multiplatform
Date: Thu, 25 Apr 2013 19:28:45 +0200
Message-Id: <1366910944-3033663-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:XeTGW37q8F0fndftBlJpmCo6mWFkoGRXrUewMnaHcdt
 A2C5lR7YUlnlv0kkebbiRcnhSmXj00npe8IDR/ty8OCXRbspzx
 X5dt4gQ1y2McEorYndtmrc8nyDYcdnRE05ukyfAulIqbybxggi
 qa116e1mPaXPBH4ditvVzQ6nF6AUwdu49Kr7JrF1YfS96rAjDw
 53cJqAjPJp/ngwD7i5BQoqiQlc392X6op4LoSTFF0mqkCmxr0Y
 dr2qrL1VgOWPzoNo2CY3lC7gj+VBhFsVDVj0S7+lMX0Wp6CGEJ
 vu74LgELHFtaSclZb4O31IHbLirDCd9Gsq7AOKBdlLtWh/9wH7
 t+7BR9RjOC9F23DGOJY+H7d44JVLcykdOpcMiTle6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we now have default implementations for init_time and init_irq,
the init_machine callback is the only one that is not yet optional,
but since simple DT based platforms all have the same
of_platform_populate function call in there, we can consolidate them
as well, and then actually boot with a completely empty machine_desc.
Unofortunately we cannot just default to an empty init_machine: We
cannot call of_platform_populate before init_machine because that
does not work in case of auxdata, and we cannot call it after
init_machine either because the machine might need to run code
after adding the devices.

To take the final step, this adds support for booting without defining
any machine_desc whatsoever.

For the case that CONFIG_MULTIPLATFORM is enabled, it adds a
global machine descriptor that never matches any machine but is
used as a fallback if nothing else matches. We assume that without
CONFIG_MULTIPLATFORM, we only want to boot on the systems that the kernel
is built for, so we still retain the build-time warning for missing
machine descriptors and the run-time warning when the platform does not
match in that case.

In the case that we run on a multiplatform kernel and the machine
provides a fully populated device tree, we attempt to keep booting,
hoping that no machine specific callbacks are necessary.

Finally, this also removes the misguided "select ARCH_VEXPRESS" that
was only added to avoid a build error for allnoconfig kernels.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Nicolas Pitre <nico@linaro.org>
Acked-by: Olof Johansson <olof@lixom.net>
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Cc: Rob Herring <robherring2@gmail.com>
---
 arch/arm/Kconfig          |  1 -
 arch/arm/kernel/devtree.c |  7 +++++++
 arch/arm/kernel/setup.c   | 11 ++++++++++-
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a0d58a6..8c33760 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -890,7 +890,6 @@ config ARCH_MULTI_V7
 	bool "ARMv7 based platforms (Cortex-A, PJ4, Scorpion, Krait)"
 	default y
 	select ARCH_MULTI_V6_V7
-	select ARCH_VEXPRESS
 	select CPU_V7
 
 config ARCH_MULTI_V6_V7
diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index 70f1bde..5af04f6 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -180,6 +180,13 @@ struct machine_desc * __init setup_machine_fdt(unsigned int dt_phys)
 	unsigned long dt_root;
 	const char *model;
 
+#ifdef CONFIG_ARCH_MULTIPLATFORM
+	DT_MACHINE_START(GENERIC_DT, "Generic DT based system")
+	MACHINE_END
+
+	mdesc_best = (struct machine_desc *)&__mach_desc_GENERIC_DT;
+#endif
+
 	if (!dt_phys)
 		return NULL;
 
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 408f446..d039623 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -18,6 +18,7 @@
 #include <linux/bootmem.h>
 #include <linux/seq_file.h>
 #include <linux/screen_info.h>
+#include <linux/of_platform.h>
 #include <linux/init.h>
 #include <linux/kexec.h>
 #include <linux/of_fdt.h>
@@ -672,9 +673,17 @@ struct screen_info screen_info = {
 
 static int __init customize_machine(void)
 {
-	/* customizes platform devices, or adds new ones */
+	/*
+	 * customizes platform devices, or adds new ones
+	 * On DT based machines, we fall back to populating the
+	 * machine from the device tree, if no callback is provided,
+	 * otherwise we would always need an init_machine callback.
+	 */
 	if (machine_desc->init_machine)
 		machine_desc->init_machine();
+	else
+		of_platform_populate(NULL, of_default_bus_match_table,
+					NULL, NULL);
 	return 0;
 }
 arch_initcall(customize_machine);
-- 
1.8.1.2

