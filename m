Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab3FSNbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 09:31:09 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:36594 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566Ab3FSNbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 09:31:05 -0400
MIME-Version: 1.0
In-Reply-To: <20130619132417.GB5276@e102568-lin.cambridge.arm.com>
References: <1371569191-2364-1-git-send-email-t.figa@samsung.com>
	<51C0A01E.5020206@samsung.com>
	<CANuQgHEd3L=F20Nrp3zWh2+uXvRU9P_KVN=1xr3RXnoGBsaHLw@mail.gmail.com>
	<8974257.1Thh8U4Een@amdc1227>
	<20130619132417.GB5276@e102568-lin.cambridge.arm.com>
Date: Wed, 19 Jun 2013 19:01:02 +0530
Message-ID: <CANuQgHHV+1Pp6StaLvK-hnOvR=DvJ3g-V8LiJTMf4_4KqCPk5A@mail.gmail.com>
Subject: Re: [PATCH] ARM: EXYNOS: Fix incorrect usage of S5P_ARM_CORE1_* registers
From: Chander Kashyap <chander.kashyap@linaro.org>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Tomasz Figa <t.figa@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jingoo Han <jg1.han@samsung.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 June 2013 18:54, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com> wrote:
> On Wed, Jun 19, 2013 at 01:50:57PM +0100, Tomasz Figa wrote:
>> On Wednesday 19 of June 2013 17:39:21 Chander Kashyap wrote:
>> > On 18 June 2013 23:29, Kukjin Kim <kgene.kim@samsung.com> wrote:
>> > > On 06/19/13 02:45, Tomasz Figa wrote:
>> > >> Ccing Arnd and Olof, because I forgot to add them to git send-email...
>> > >>
>> > >> Sorry for the noise.
>> > >>
>> > >> On Tuesday 18 of June 2013 17:26:31 Tomasz Figa wrote:
>> > >>> S5P_ARM_CORE1_* registers affect only core 1. To control further
>> > >>> cores
>> > >>> properly another registers must be used.
>> > >>>
>> > >>> This patch replaces S5P_ARM_CORE1_* register definitions with
>> > >>> S5P_ARM_CORE_*(x) macro which return addresses of registers for
>> > >>> specified core.
>> > >>>
>> > >>> This fixes CPU hotplug on quad core Exynos SoCs on which currently
>> > >>> offlining CPUs 2 or 3 caused CPU 1 to be turned off.
>> > >>
>> > >> Obviously this doesn't happen currently because of the if (cpu == 1),
>> > >> but>
>> > > Yes, not happened...and just note exynos5440 doesn't support hotplug :)
>> > > so this is available on exynos4412 and added 5420.
>> > >
>> > >> if logical cpu1 turned out not to be physical cpu1, then it would
>> > >> crash.
>> > >>
>> > >> Best regards,
>> > >> Tomasz
>> > >>
>> > >>> In addition,
>> > >>> bring-up of CPU 2 and 3 is fixed on boards where bootloader powers
>> > >>> off
>> > >>> secondary cores by default.
>> > >
>> > > I need to test on board about above...
>> > >
>> > >>> Cc: stable@vger.kernel.org
>> > >>> Signed-off-by: Tomasz Figa<t.figa@samsung.com>
>> > >>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>> > >>> ---
>> > >>>
>> > >>>   arch/arm/mach-exynos/hotplug.c               |  9 +++++----
>> > >>>   arch/arm/mach-exynos/include/mach/regs-pmu.h | 10 +++++++---
>> > >>>   arch/arm/mach-exynos/platsmp.c               |  9 +++++----
>> > >>>   3 files changed, 17 insertions(+), 11 deletions(-)
>> > >>>
>> > >>> diff --git a/arch/arm/mach-exynos/hotplug.c
>> > >>> b/arch/arm/mach-exynos/hotplug.c index af90cfa..c089943 100644
>> > >>> --- a/arch/arm/mach-exynos/hotplug.c
>> > >>> +++ b/arch/arm/mach-exynos/hotplug.c
>> > >>> @@ -93,10 +93,11 @@ static inline void cpu_leave_lowpower(void)
>> > >>>
>> > >>>   static inline void platform_do_lowpower(unsigned int cpu, int
>> > >>>
>> > >>> *spurious) {
>> > >>>
>> > >>>         for (;;) {
>> > >>>
>> > >>> +               void __iomem *reg_base;
>> > >>> +               unsigned int phys_cpu = cpu_logical_map(cpu);
>> > >>>
>> > >>> -               /* make cpu1 to be turned off at next WFI command */
>> > >>> -               if (cpu == 1)
>> > >>> -                       __raw_writel(0, S5P_ARM_CORE1_CONFIGURATION);
>> > >>> +               reg_base = S5P_ARM_CORE_CONFIGURATION(phys_cpu);
>> >
>> > Tomasz,
>> > This will break for non-zero, MPIDR value.  Say if MPIDR is 1 then for
>> > cpu0 phys_cpu value will be 0x100,
>> > and address calculation will be   (S5P_ARM_CORE0_CONFIGURATION +
>> > ((0x101) * 0x80)), which is wrong.
>
> Honestly, I did not understand the reasoning above, please clarify.
Sorry not non-zero MPIDR but non-zero ClusterID.
All the power register addresses are at offset 0x80.
>
>>
>> Hmm, according to the code initializing __cpu_logical_map[] array this is
>> not true.
>>
>> Here's the code:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/arch/arm/kernel/setup.c?id=refs/tags/next-20130619#n468
>>
>> and for used macros and bitmasks:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/arch/arm/include/asm/cputype.h?id=refs/tags/next-20130619#n45
>>
>> Now the structure of the MPIDR register:
>>
>> http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0388e/CIHEBGFG.html
>>
>> As you can see, the value read from the register in
>> smp_setup_processor_id() is only the physical CPU ID, so I don't see any
>> problem here.
>
> Define "physical CPU ID" :-)
>
> There is a problem here: the MPIDR is not an index, and the cpu_logical_map is
> populated in arm_dt_init_cpu_maps in:
>
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/arch/arm/kernel/devtree.c?id=refs/tags/v3.10-rc6
>
> with all affinity levels.
>
> You need to perform a mapping between logical cpus and registers offset,
> you can't use the cpu_logical_map directly for that.
>
> Next accident waiting to happen is GIC code (CONFIG_GIC_NON_BANKED), where
> cpu_logical_map is used erroneously as an index.
>
> Lorenzo
>



--
with warm regards,
Chander Kashyap
