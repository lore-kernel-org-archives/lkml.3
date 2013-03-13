Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab3CMBcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 21:32:08 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59897 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855Ab3CMBcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 21:32:04 -0400
X-IronPort-AV: E=Sophos;i="4.84,833,1355126400"; 
   d="scan'208";a="28951502"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 2/3] ARM: Detect support for SDIV/UDIV from ISAR0 register
Date: Tue, 12 Mar 2013 18:32:00 -0700
Message-Id: <1363138321-27849-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc2.4.g7799588
In-Reply-To: <1363138321-27849-1-git-send-email-sboyd@codeaurora.org>
References: <1363138321-27849-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ISAR0 register indicates support for the SDIV and UDIV
instructions in both the Thumb and ARM instruction set. Read the
register to detect the supported instructions and update the
elf_hwcap mask as appropriate. This is better than adding more
and more cpuid checks in proc-v7.S for each new cpu variant that
supports these instructions.

Cc: Will Deacon <will.deacon@arm.com>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/setup.c | 20 ++++++++++++++++++++
 arch/arm/mm/proc-v7.S   |  4 ++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index e2c8bbf..bd27a70 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -353,6 +353,23 @@ void __init early_print(const char *str, ...)
 	printk("%s", buf);
 }
 
+static void __init idiv_setup(void)
+{
+	unsigned int divide_instrs;
+
+	if (cpu_architecture() < CPU_ARCH_ARMv7)
+		return;
+
+	divide_instrs = (read_cpuid_ext(CPUID_EXT_ISAR0) & 0x0f000000) >> 24;
+
+	switch (divide_instrs) {
+	case 2:
+		elf_hwcap |= HWCAP_IDIVA;
+	case 1:
+		elf_hwcap |= HWCAP_IDIVT;
+	}
+}
+
 static void __init feat_v6_fixup(void)
 {
 	int id = read_cpuid_id();
@@ -483,6 +500,9 @@ static void __init setup_processor(void)
 	snprintf(elf_platform, ELF_PLATFORM_SIZE, "%s%c",
 		 list->elf_name, ENDIANNESS);
 	elf_hwcap = list->elf_hwcap;
+
+	idiv_setup();
+
 #ifndef CONFIG_ARM_THUMB
 	elf_hwcap &= ~(HWCAP_THUMB | HWCAP_IDIVT);
 #endif
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 3a3c015..bcd3d48 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -420,7 +420,7 @@ __v7_pj4b_proc_info:
 __v7_ca7mp_proc_info:
 	.long	0x410fc070
 	.long	0xff0ffff0
-	__v7_proc __v7_ca7mp_setup, hwcaps = HWCAP_IDIV
+	__v7_proc __v7_ca7mp_setup
 	.size	__v7_ca7mp_proc_info, . - __v7_ca7mp_proc_info
 
 	/*
@@ -430,7 +430,7 @@ __v7_ca7mp_proc_info:
 __v7_ca15mp_proc_info:
 	.long	0x410fc0f0
 	.long	0xff0ffff0
-	__v7_proc __v7_ca15mp_setup, hwcaps = HWCAP_IDIV
+	__v7_proc __v7_ca15mp_setup
 	.size	__v7_ca15mp_proc_info, . - __v7_ca15mp_proc_info
 
 	/*
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

