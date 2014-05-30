Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965021AbaE3OoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:44:00 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20308 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023AbaE3On6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:43:58 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7fac6d000006cfe-2f-5388992a2138
Content-transfer-encoding: 8BIT
Message-id: <1401461039.11651.6.camel@AMDC1943>
Subject: Re: [PATCH] ARM: exynos4212: hotplug: Fix CPU idle clock down after
 CPU1 off
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Date: Fri, 30 May 2014 16:43:59 +0200
In-reply-to: <53888008.5020108@gmail.com>
References: <1399990378-7023-1-git-send-email-k.kozlowski@samsung.com>
 <53887095.7090108@gmail.com> <1401453990.11651.2.camel@AMDC1943>
 <53888008.5020108@gmail.com>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t/xK7paMzuCDWZPkbPYOGM9q0Xvgqts
	Fmeb3rBbbHp8jdXi8q45bBYzzu9jsrh9mddi7ZG77BbrZ7xmsVi16w+jA5dHS3MPm8fOWXfZ
	PTYvqffo27KK0ePzJrkA1igum5TUnMyy1CJ9uwSujHct29gKzkhVvN3fx9TA2CfaxcjBISFg
	IvH4VFUXIyeQKSZx4d56ti5GLg4hgaWMErf+d7OBJHgFBCV+TL7HAlLPLCAvceRSNkiYWUBd
	YtK8RcwQ9Z8ZJa41LoSq15c4seoLO4gtLBAu8XbJTUYQm03AWGLz8iVgNSJAzd+m9LODNDML
	vGOSeDrpLQtIgkVAVWLnw0dgDZwCmhLz23uhNqxglOjd/4AV4lRliXn7jzFNYBSYheTAWQgH
	zkJy4AJG5lWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIeH/ZQfj4mNWhxgFOBiVeHgzXdqD
	hVgTy4orcw8xSnAwK4nwOvR2BAvxpiRWVqUW5ccXleakFh9iZOLglGpgLFF90PYvLf/NlnvL
	/m//oue9/9p1Z9tjCy/bvahYGfFsp5CF1M2Gjq9Zm8yac7+ueLJtlvu9Er9f6lYXc3IinXYH
	S6+2tte7tJj5opzpj03LVQODsz/PFhKutezfMCst+cekAHOTvUHvHwEjd90s11c/q1dtNe3/
	+l0k4YZnv820hv0PrhqXK7EUZyQaajEXFScCAHA/ArJdAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-05-30 at 14:56 +0200, Tomasz Figa wrote:
> On 30.05.2014 14:46, Krzysztof Kozlowski wrote:
> > On pią, 2014-05-30 at 13:50 +0200, Tomasz Figa wrote:
> >> Hi Krzysztof,
> >>
> >> On 13.05.2014 16:12, Krzysztof Kozlowski wrote:
> >>> On Exynos4212 USE_DELAYED_RESET_ASSERTION must be set in
> >>> ARM_CORE1_OPTION register during CPU power down. This is the proper way
> >>> of powering down CPU. Additionally without this the CPU clock down won't
> >>> work after powering down CPU1 and CPU will work at full frequency chosen
> >>> by CPUfreq governor.
> >>>
> >>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> >>> ---
> >>>  arch/arm/mach-exynos/hotplug.c  | 28 +++++++++++++++++++++++++---
> >>>  arch/arm/mach-exynos/regs-pmu.h |  2 ++
> >>>  2 files changed, 27 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
> >>> index 5eead530c6f8..59b813e74558 100644
> >>> --- a/arch/arm/mach-exynos/hotplug.c
> >>> +++ b/arch/arm/mach-exynos/hotplug.c
> >>> @@ -74,7 +74,7 @@ static inline void cpu_enter_lowpower_a15(void)
> >>>  	dsb();
> >>>  }
> >>>  
> >>> -static inline void cpu_leave_lowpower(void)
> >>> +static inline void cpu_leave_lowpower(unsigned int cpu)
> >>>  {
> >>>  	unsigned int v;
> >>>  
> >>> @@ -88,6 +88,14 @@ static inline void cpu_leave_lowpower(void)
> >>>  	  : "=&r" (v)
> >>>  	  : "Ir" (CR_C), "Ir" (0x40)
> >>>  	  : "cc");
> >>> +
> >>> +	if (cpu == 1 && soc_is_exynos4212()) {
> >>
> >> AFAIK this is needed not only on Exynos4x12, but at least also on 4412.
> >> Also I don't think the (cpu == 1) condition is necessary. See below.
> > 
> > I'll test it on Exynos4412.
> > 
> >>
> >>> +		unsigned int tmp;
> >>> +
> >>> +		tmp = __raw_readl(S5P_ARM_CORE1_OPTION);
> >>> +		tmp &= ~(S5P_USE_DELAYED_RESET_ASSERTION);
> >>> +		__raw_writel(tmp, S5P_ARM_CORE1_OPTION);
> >>> +	}
> >>>  }
> >>>  
> >>>  static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
> >>> @@ -95,8 +103,22 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
> >>>  	for (;;) {
> >>>  
> >>>  		/* make cpu1 to be turned off at next WFI command */
> >>> -		if (cpu == 1)
> >>> +		if (cpu == 1) {
> >>
> >> I think this patch should be rebased on top of my "[PATCH] ARM: EXYNOS:
> >> Fix core ID used by platsmp and hotplug code". Then instead of if (cpu
> >> == 1) you would just use EXYNOS_ARM_CORE_OPTION(core_id).
> >>
> >> Also same comment as above, I believe this is also needed on Exynos4412.
> > 
> > Probably your patch needs rebasing too. I couldn't apply (cleanly) on
> > current Linus' tree and on Kukjin's for-next. What are the requirements
> > for it?
> 
> Hmm, I based it on Kukjin's for-next from the day I sent the patch,
> 23.05 if I remember correctly. AFAICT everything needed by this patch is
> already merged in Kukjin's tree (and I believe already was when I sent
> that patch).
> 
> To make sure, I'm talking about this patch:
> http://www.spinics.net/lists/linux-samsung-soc/msg31604.html

Yep, that's the patch but still it does not apply cleanly :). Anyway
I'll send next version of my patch reflecting your comments:
1. Limit to all Exynos4 SoCs.
2. Rebase on your patch to utilize EXYNOS_ARM_CORE_OPTION(core_id).

Best regards,
Krzysztof


