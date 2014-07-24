Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236AbaGXNCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:02:35 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:58388 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759219AbaGXNCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:02:32 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi-private@linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH 09/19] ARM64 / ACPI: Move the initialization of cpu_logical_map(0) before acpi_boot_init()
Date: Thu, 24 Jul 2014 21:00:15 +0800
Message-Id: <1406206825-15590-10-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the initialization of cpu_logical_map(0) before acpi_boot_init()
to remove the duplicated initialization of cpu_logical_map(0).

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/arm64/kernel/acpi.c  |    3 ---
 arch/arm64/kernel/setup.c |    3 ++-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 801e268..ff0f6a0 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -244,9 +244,6 @@ int __init acpi_boot_init(void)
 	if (err)
 		pr_err("Can't find FADT\n");
 
-	/* Get the boot CPU's MPIDR before MADT parsing */
-	cpu_logical_map(0) = read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
-
 	err = acpi_parse_madt_gic_cpu_interface_entries();
 
 	return err;
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index e00d40c..17ab98e 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -394,13 +394,14 @@ void __init setup_arch(char **cmdline_p)
 
 	efi_idmap_init();
 
+	/* Get the boot CPU's MPIDR before cpu logical map is built */
+	cpu_logical_map(0) = read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
 	acpi_boot_init();
 
 	unflatten_device_tree();
 
 	psci_init();
 
-	cpu_logical_map(0) = read_cpuid_mpidr() & MPIDR_HWID_BITMASK;
 	cpu_read_bootcpu_ops();
 #ifdef CONFIG_SMP
 	smp_init_cpus();
-- 
1.7.9.5

