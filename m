Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab3AWI5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 03:57:25 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35519 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab3AWI5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 03:57:23 -0500
Message-ID: <50FFA620.50008@ti.com>
Date: Wed, 23 Jan 2013 14:28:08 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Stephen Warren <swarren@wwwdotorg.org>, Hiroshi Doyu <hdoyu@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [v3 2/2] ARM: tegra: Skip scu_enable(scu_base) if not Cortex
 A9
References: <1358833924-24535-1-git-send-email-hdoyu@nvidia.com> <1358833924-24535-2-git-send-email-hdoyu@nvidia.com> <50FE2CA8.20100@ti.com> <50FEC503.2080602@wwwdotorg.org> <CAOesGMgtaCkiv285TU_vbAokN5M2MrANQ9piDcyXu5YMmbQq3A@mail.gmail.com>
In-Reply-To: <CAOesGMgtaCkiv285TU_vbAokN5M2MrANQ9piDcyXu5YMmbQq3A@mail.gmail.com>
Content-Type: multipart/mixed;
	boundary="------------070908070100060708050206"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------070908070100060708050206
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

On Tuesday 22 January 2013 10:34 PM, Olof Johansson wrote:
> On Tue, Jan 22, 2013 at 8:57 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 01/21/2013 11:07 PM, Santosh Shilimkar wrote:
>>> On Tuesday 22 January 2013 11:22 AM, Hiroshi Doyu wrote:
>>>> Skip scu_enable(scu_base) if CPU is not Cortex A9 with SCU.
>>>>
>>>> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
>>>> ---
>>> Looks fine. I will also update OMAP code with the new
>>> interface. Thanks.
>>
>> OK, so patch 1/2 at least needs to get into a stable arm-soc branch
>> then. Unless there are violent objections, I'll forward patch 1/2 to
>> arm-soc and request it be added into a branch so that Tegra and OMAP can
>> both merge it into their branches as a dependency. I guess patch 2/2
>> could also be included; I don't think it has any complex dependencies
>> that'd prevent that, and would help to show how patch 1/2 gets used.
>>
>> Hiroshi, is this series the only dependency you need for your Tegra114
>> series? So, I could merge your Tegra114 series once this series is applied?
>
> For something like this, it might make more sense for us to just apply
> the patches for OMAP on top, i.e. we'll pull the short branch from
> you, and then we can just apply patches (with maintainer acks) on top,
> instead of doing a bunch of single-patch pulls.
>
In case you decide to apply patches, you can use patch in the end
of the email for OMAP. Attached the same in case mailer damages it.

Btw, I noticed the build error with patch 1/1. Since I wasn't using
the first interface in OMAP code, I just bypassed it for testing.
I might be missing some dependent patch which added
read_cpuid_part_number().

---------------
In file included from arch/arm/kernel/smp_scu.c:15:0:
linux-2.6/arch/arm/include/asm/smp_scu.h: In function 'scu_a9_has_base':
linux-2.6/arch/arm/include/asm/smp_scu.h:14:2: error: implicit 
declaration of function 'read_cpuid_part_number' 
[-Werror=implicit-function-declaration]
linux-2.6/arch/arm/include/asm/smp_scu.h:14:37: error: 
'ARM_CPU_PART_CORTEX_A9' undeclared (first use in this function)
linux-2.6/arch/arm/include/asm/smp_scu.h:14:37: note: each undeclared 
identifier is reported only once for each function it appears in
cc1: some warnings being treated as errors
make[1]: *** [arch/arm/kernel/smp_scu.o] Error 1
make: *** [arch/arm/kernel] Error 2
---------------------------------

Regards
Santosh

 From 9760cd0ed93b48ec22584e89979cd4a8ec65b938 Mon Sep 17 00:00:00 2001
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date: Wed, 23 Jan 2013 13:56:19 +0530
Subject: [PATCH] ARM: OMAP: Make use of available scu_a9_get_base() 
interface

Drop the define and make use of scu_a9_get_base() which reads
the physical address of SCU from CP15 register.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
  arch/arm/mach-omap2/omap-smp.c |    2 +-
  arch/arm/mach-omap2/omap44xx.h |    1 -
  2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/omap-smp.c b/arch/arm/mach-omap2/omap-smp.c
index cd42d92..e683d0d 100644
--- a/arch/arm/mach-omap2/omap-smp.c
+++ b/arch/arm/mach-omap2/omap-smp.c
@@ -215,7 +215,7 @@ static void __init omap4_smp_init_cpus(void)
  		 * Currently we can't call ioremap here because
  		 * SoC detection won't work until after init_early.
  		 */
-		scu_base =  OMAP2_L4_IO_ADDRESS(OMAP44XX_SCU_BASE);
+		scu_base =  OMAP2_L4_IO_ADDRESS(scu_a9_get_base());
  		BUG_ON(!scu_base);
  		ncores = scu_get_core_count(scu_base);
  	} else if (cpu_id == CPU_CORTEX_A15) {
diff --git a/arch/arm/mach-omap2/omap44xx.h b/arch/arm/mach-omap2/omap44xx.h
index 43b927b..8a515bb 100644
--- a/arch/arm/mach-omap2/omap44xx.h
+++ b/arch/arm/mach-omap2/omap44xx.h
@@ -40,7 +40,6 @@
  #define OMAP44XX_GIC_DIST_BASE		0x48241000
  #define OMAP44XX_GIC_CPU_BASE		0x48240100
  #define OMAP44XX_IRQ_GIC_START		32
-#define OMAP44XX_SCU_BASE		0x48240000
  #define OMAP44XX_LOCAL_TWD_BASE		0x48240600
  #define OMAP44XX_L2CACHE_BASE		0x48242000
  #define OMAP44XX_WKUPGEN_BASE		0x48281000
-- 
1.7.9.5



--------------070908070100060708050206
Content-Type: text/x-patch;
	name="0001-ARM-OMAP-Make-use-of-available-scu_a9_get_base-inter.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-ARM-OMAP-Make-use-of-available-scu_a9_get_base-inter.pa";
	filename*1="tch"

>From 9760cd0ed93b48ec22584e89979cd4a8ec65b938 Mon Sep 17 00:00:00 2001
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date: Wed, 23 Jan 2013 13:56:19 +0530
Subject: [PATCH] ARM: OMAP: Make use of available scu_a9_get_base() interface

Drop the define and make use of scu_a9_get_base() which reads
the physical address of SCU from CP15 register.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/mach-omap2/omap-smp.c |    2 +-
 arch/arm/mach-omap2/omap44xx.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/omap-smp.c b/arch/arm/mach-omap2/omap-smp.c
index cd42d92..e683d0d 100644
--- a/arch/arm/mach-omap2/omap-smp.c
+++ b/arch/arm/mach-omap2/omap-smp.c
@@ -215,7 +215,7 @@ static void __init omap4_smp_init_cpus(void)
 		 * Currently we can't call ioremap here because
 		 * SoC detection won't work until after init_early.
 		 */
-		scu_base =  OMAP2_L4_IO_ADDRESS(OMAP44XX_SCU_BASE);
+		scu_base =  OMAP2_L4_IO_ADDRESS(scu_a9_get_base());
 		BUG_ON(!scu_base);
 		ncores = scu_get_core_count(scu_base);
 	} else if (cpu_id == CPU_CORTEX_A15) {
diff --git a/arch/arm/mach-omap2/omap44xx.h b/arch/arm/mach-omap2/omap44xx.h
index 43b927b..8a515bb 100644
--- a/arch/arm/mach-omap2/omap44xx.h
+++ b/arch/arm/mach-omap2/omap44xx.h
@@ -40,7 +40,6 @@
 #define OMAP44XX_GIC_DIST_BASE		0x48241000
 #define OMAP44XX_GIC_CPU_BASE		0x48240100
 #define OMAP44XX_IRQ_GIC_START		32
-#define OMAP44XX_SCU_BASE		0x48240000
 #define OMAP44XX_LOCAL_TWD_BASE		0x48240600
 #define OMAP44XX_L2CACHE_BASE		0x48242000
 #define OMAP44XX_WKUPGEN_BASE		0x48281000
-- 
1.7.9.5


--------------070908070100060708050206--
