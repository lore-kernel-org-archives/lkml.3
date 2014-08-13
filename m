Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaHMKEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:04:12 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47889 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaHMKEK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:04:10 -0400
Message-ID: <53EB381D.7080604@arm.com>
Date: Wed, 13 Aug 2014 11:04:13 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH] cpuidle/cpuidle-big_little: fix reading cpu id part number
References: <1407501757-15231-1-git-send-email-juri.lelli@arm.com> <20140808132105.GB30282@n2100.arm.linux.org.uk> <20140808164737.GB11623@e102568-lin.cambridge.arm.com>
In-Reply-To: <20140808164737.GB11623@e102568-lin.cambridge.arm.com>
X-OriginalArrivalTime: 13 Aug 2014 10:04:06.0323 (UTC) FILETIME=[EAF8B830:01CFB6DD]
X-MC-Unique: 114081311040710101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On 08/08/14 17:47, Lorenzo Pieralisi wrote:
> On Fri, Aug 08, 2014 at 02:21:05PM +0100, Russell King - ARM Linux wrote:
>> On Fri, Aug 08, 2014 at 01:42:37PM +0100, Juri Lelli wrote:
>>> Commit af040ffc9ba1 ("ARM: make it easier to check the CPU part number
>>> correctly") changed ARM_CPU_PART_X masks, and the way they are returned and
>>> checked against. Usage of read_cpuid_part_number() is now deprecated, and
>>> calling places updated accordingly. This actually broke cpuidle-big_little
>>> initialization, as bl_idle_driver_init() performs a check using and hardcoded
>>> mask on cpu_id.
>>>
>>> Update the check to reflect changes on ARM_CPU_PART_X masks. Also,
>>> make the check easier to understand.
>>
>> I don't like this "let's work out our own way to check the CPU type"
>> stuff which people seem to create.  Let's try and do the job better
>> and have some proper interfaces to do this kind of thing.
>>
>> Maybe we should have smp_cpuid_part(cpu) which returns the CPU vendor/
>> part identifier for the particular CPU in an efficient manner.

Thanks a lot for the comment. Does what below address it?

> 
> Ok, basically an inline function that either read and mask the cpuid
> stashed at boot in cpu_data or read the part number straight away on UP.
> 
> Should it belong in asm/smp_plat.h ?
> 

Ok, this is how it could look like.

>From 6dbaf6c2eb34b06966daf5e90d1f08a0202c86e2 Mon Sep 17 00:00:00 2001
From: Juri Lelli <juri.lelli@arm.com>
Date: Thu, 7 Aug 2014 17:26:54 +0100
Subject: [PATCH] cpuidle/cpuidle-big_little: fix reading cpu id part number

Commit af040ffc9ba1e079ee4c0748aff64fa3d4716fa5 by Russell King changed
ARM_CPU_PART_X masks, and the way they are returned and checked against.
Usage of read_cpuid_part_number() is now deprecated, and calling places
updated accordingly. This actually broke cpuidle-big_little initialization,
as bl_idle_driver_init() performs a check using and hardcoded mask on
cpu_id.

Create an interface to perform the check (that is now even easier to read).
Define also a proper mask (ARM_CPU_PART_MASK) that makes this kind of checks
cleaner and helps preventing bugs in the future. Update usage accordingly.

Signed-off-by: Juri Lelli <juri.lelli@arm.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
---
 arch/arm/include/asm/cputype.h       |  3 ++-
 arch/arm/include/asm/smp_plat.h      | 17 +++++++++++++++++
 drivers/cpuidle/cpuidle-big_little.c | 13 +++----------
 3 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/arch/arm/include/asm/cputype.h b/arch/arm/include/asm/cputype.h
index 963a251..819777d 100644
--- a/arch/arm/include/asm/cputype.h
+++ b/arch/arm/include/asm/cputype.h
@@ -74,6 +74,7 @@
 #define ARM_CPU_PART_CORTEX_A12		0x4100c0d0
 #define ARM_CPU_PART_CORTEX_A17		0x4100c0e0
 #define ARM_CPU_PART_CORTEX_A15		0x4100c0f0
+#define ARM_CPU_PART_MASK		0xff00fff0
 
 #define ARM_CPU_XSCALE_ARCH_MASK	0xe000
 #define ARM_CPU_XSCALE_ARCH_V1		0x2000
@@ -179,7 +180,7 @@ static inline unsigned int __attribute_const__ read_cpuid_implementor(void)
  */
 static inline unsigned int __attribute_const__ read_cpuid_part(void)
 {
-	return read_cpuid_id() & 0xff00fff0;
+	return read_cpuid_id() & ARM_CPU_PART_MASK;
 }
 
 static inline unsigned int __attribute_const__ __deprecated read_cpuid_part_number(void)
diff --git a/arch/arm/include/asm/smp_plat.h b/arch/arm/include/asm/smp_plat.h
index a252c0b..b84ee77 100644
--- a/arch/arm/include/asm/smp_plat.h
+++ b/arch/arm/include/asm/smp_plat.h
@@ -8,6 +8,7 @@
 #include <linux/cpumask.h>
 #include <linux/err.h>
 
+#include <asm/cpu.h>
 #include <asm/cputype.h>
 
 /*
@@ -25,6 +26,22 @@ static inline bool is_smp(void)
 #endif
 }
 
+/*
+ * smp_cpuid_part() - return part id for a given cpu
+ *
+ * @cpu: logical cpu id
+ *
+ * Return: part id of logical cpu passed as argument
+ *
+ */
+static inline unsigned int smp_cpuid_part(int cpu)
+{
+	struct cpuinfo_arm *cpu_info = &per_cpu(cpu_data, cpu);
+
+	return is_smp() ? (cpu_info->cpuid  & ARM_CPU_PART_MASK) :
+			  read_cpuid_part();
+}
+
 /* all SMP configurations have the extended CPUID registers */
 #ifndef CONFIG_MMU
 #define tlb_ops_need_broadcast()	0
diff --git a/drivers/cpuidle/cpuidle-big_little.c b/drivers/cpuidle/cpuidle-big_little.c
index 344d79fa..1703d32 100644
--- a/drivers/cpuidle/cpuidle-big_little.c
+++ b/drivers/cpuidle/cpuidle-big_little.c
@@ -138,25 +138,18 @@ static int bl_enter_powerdown(struct cpuidle_device *dev,
 	return idx;
 }
 
-static int __init bl_idle_driver_init(struct cpuidle_driver *drv, int cpu_id)
+static int __init bl_idle_driver_init(struct cpuidle_driver *drv, int match_id)
 {
-	struct cpuinfo_arm *cpu_info;
 	struct cpumask *cpumask;
-	unsigned long cpuid;
 	int cpu;
 
 	cpumask = kzalloc(cpumask_size(), GFP_KERNEL);
 	if (!cpumask)
 		return -ENOMEM;
 
-	for_each_possible_cpu(cpu) {
-		cpu_info = &per_cpu(cpu_data, cpu);
-		cpuid = is_smp() ? cpu_info->cpuid : read_cpuid_id();
-
-		/* read cpu id part number */
-		if ((cpuid & 0xFFF0) == cpu_id)
+	for_each_possible_cpu(cpu)
+		if (smp_cpuid_part(cpu) == match_id)
 			cpumask_set_cpu(cpu, cpumask);
-	}
 
 	drv->cpumask = cpumask;
 
-- 
2.0.4

