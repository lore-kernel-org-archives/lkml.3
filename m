Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbbAUMoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:44:05 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52229 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbbAUMn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:43:27 -0500
From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: leo.yan@linaro.org, yexl@marvell.com, Will.Deacon@arm.com,
        Catalin.Marinas@arm.com, Mark.Rutland@arm.com,
        linux-kernel@vger.kernel.org,
        "Suzuki K. Poulose" <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 1/3] arm64: Track system support for mixed endian EL0
Date: Wed, 21 Jan 2015 12:43:09 +0000
Message-Id: <1421844191-9263-2-git-send-email-suzuki.poulose@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421844191-9263-1-git-send-email-suzuki.poulose@arm.com>
References: <1421844191-9263-1-git-send-email-suzuki.poulose@arm.com>
X-OriginalArrivalTime: 21 Jan 2015 12:43:24.0487 (UTC) FILETIME=[D8968D70:01D03577]
X-MC-Unique: 115012112432507401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id t0LCi9a6019676

From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>

This patch keeps track of the mixed endian EL0 support across
the system and provides helper functions to export it. The status
is a boolean indicating whether all the CPUs on the system supports
mixed endian at EL0.

Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/cpufeature.h |    2 ++
 arch/arm64/include/asm/cputype.h    |   14 ++++++++++++++
 arch/arm64/kernel/cpuinfo.c         |   22 ++++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 07547cc..b6c16d5 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -52,6 +52,8 @@ static inline void cpus_set_cap(unsigned int num)
 }
 
 void check_local_cpu_errata(void);
+bool cpu_supports_mixed_endian_el0(void);
+bool system_supports_mixed_endian_el0(void);
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 53d59b0..44e578d 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -73,6 +73,15 @@
 
 #define APM_CPU_PART_POTENZA	0x000
 
+#define ID_AA64MMFR0_BIGENDEL0_SHIFT	16
+#define ID_AA64MMFR0_BIGENDEL0_MASK	(0xf << ID_AA64MMFR0_BIGENDEL0_SHIFT)
+#define ID_AA64MMFR0_BIGENDEL0(mmfr0)	\
+	(((mmfr0) & ID_AA64MMFR0_BIGENDEL0_MASK) >> ID_AA64MMFR0_BIGENDEL0_SHIFT)
+#define ID_AA64MMFR0_BIGEND_SHIFT	8
+#define ID_AA64MMFR0_BIGEND_MASK	(0xf << ID_AA64MMFR0_BIGEND_SHIFT)
+#define ID_AA64MMFR0_BIGEND(mmfr0)	\
+	(((mmfr0) & ID_AA64MMFR0_BIGEND_MASK) >> ID_AA64MMFR0_BIGEND_SHIFT)
+
 #ifndef __ASSEMBLY__
 
 /*
@@ -105,6 +114,11 @@ static inline u32 __attribute_const__ read_cpuid_cachetype(void)
 	return read_cpuid(CTR_EL0);
 }
 
+static inline bool id_aa64mmfr0_mixed_endian_el0(u64 mmfr0)
+{
+	return (ID_AA64MMFR0_BIGEND(mmfr0) == 0x1) ||
+		(ID_AA64MMFR0_BIGENDEL0(mmfr0) == 0x1);
+}
 #endif /* __ASSEMBLY__ */
 
 #endif
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 07d435c..b6d1135 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -35,6 +35,7 @@
  */
 DEFINE_PER_CPU(struct cpuinfo_arm64, cpu_data);
 static struct cpuinfo_arm64 boot_cpu_data;
+static bool mixed_endian_el0 = true;
 
 static char *icache_policy_str[] = {
 	[ICACHE_POLICY_RESERVED] = "RESERVED/UNKNOWN",
@@ -68,6 +69,26 @@ static void cpuinfo_detect_icache_policy(struct cpuinfo_arm64 *info)
 	pr_info("Detected %s I-cache on CPU%d\n", icache_policy_str[l1ip], cpu);
 }
 
+bool cpu_supports_mixed_endian_el0(void)
+{
+	return id_aa64mmfr0_mixed_endian_el0(read_cpuid(ID_AA64MMFR0_EL1));
+}
+
+bool system_supports_mixed_endian_el0(void)
+{
+	return mixed_endian_el0;
+}
+
+static void update_mixed_endian_el0_support(struct cpuinfo_arm64 *info)
+{
+	mixed_endian_el0 &= id_aa64mmfr0_mixed_endian_el0(info->reg_id_aa64mmfr0);
+}
+
+static void update_cpu_features(struct cpuinfo_arm64 *info)
+{
+	update_mixed_endian_el0_support(info);
+}
+
 static int check_reg_mask(char *name, u64 mask, u64 boot, u64 cur, int cpu)
 {
 	if ((boot & mask) == (cur & mask))
@@ -215,6 +236,7 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
 	cpuinfo_detect_icache_policy(info);
 
 	check_local_cpu_errata();
+	update_cpu_features(info);
 }
 
 void cpuinfo_store_cpu(void)
-- 
1.7.9.5


