Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaEMRMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 13:12:55 -0400
Received: from service87.mimecast.com ([91.220.42.44]:57204 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbaEMRMq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 13:12:46 -0400
Date: Tue, 13 May 2014 18:14:52 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Chander Kashyap <chander.kashyap@linaro.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        Chander Kashyap <k.chander@samsung.com>
Subject: Re: [Patch v4 5/5] mcpm: exynos: populate suspend and powered_up
 callbacks
Message-ID: <20140513171452.GB10210@red-moon>
References: <1399278444-8312-3-git-send-email-chander.kashyap@linaro.org>
 <1399282040-8995-1-git-send-email-chander.kashyap@linaro.org>
 <1399282040-8995-6-git-send-email-chander.kashyap@linaro.org>
 <20140509153206.GB5040@e102568-lin.cambridge.arm.com>
 <CANuQgHG9tGzi2rSOwREAxVu4BQoprDg9om62AybgW5v31fpbTQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CANuQgHG9tGzi2rSOwREAxVu4BQoprDg9om62AybgW5v31fpbTQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 13 May 2014 17:12:52.0882 (UTC) FILETIME=[93311720:01CF6ECE]
X-MC-Unique: 114051318124401601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 12:43:31PM +0100, Chander Kashyap wrote:

[...]

> >> +static void exynos_suspend(u64 residency)
> >> +{
> >> +     unsigned int mpidr, cpunr;
> >> +
> >> +     mpidr = read_cpuid_mpidr();
> >> +     cpunr = exynos_pmu_cpunr(mpidr);
> >
> > If I were to be picky, I would compute these values only if they
> > are needed, ie move the computation after exynos_power_down().
> 
> Yes thats make sense. I will realign it.
> 
> >
> > There is another quite horrible issue here. We know this code works
> > because the processors A15/A7 hit the caches with C bit in SCTLR cleared.
> >
> > On processors where this is not true, this sequence would explode
> > if power down fails (in case core is gated but L2 is still powered on,
> > the stack is stuck in L2) since it is going to read stack data that is
> > in L2 but can't be read.
> >
> > It is not related to this sequence only, but it is an issue in general
> > and wanted to mention that on the lists for public awareness.
> >
> 
> Can you please elaborate. I didn't understand.

It is not related to this patch only. This function carries out writes to the
stack (which might end up in eg L2) and then disables the C bit in SCTLR
through MCPM.

A15 and A7 processors hit the cache with the C bit clear in the SCTLR
so the processor still "hits" the stack values if the power down fails.
On processors where caches are not hit with the C bit clear (eg A9) this code
would fail since the stack values that sit in the caches cannot be read with
the C bit clear in SCTLR until the SCTLR is restored, so it will have to
be implemented in assembly with no stack usage (or better, no cacheable data
usage).

So, all I am saying is, to avoid copy'n'paste havoc and to avoid running
this code on Exynos platforms where it must not be run as-is, please add
a comment along the line:

"This function requires the stack data to be visible through power down
and can only be executed on processors like A15 and A7 that hit the cache
with the C bit clear in the SCTLR register."

Please let me know if that's clear.

Lorenzo

> 
> > The gist of what I am saying is, please add a comment to that extent,
> > here and it should be added in exynos_power_down() too.
> >
> >> +     __raw_writel(virt_to_phys(mcpm_entry_point), ns_sram_base_addr + 0x1c);
> >
> > No magic numbers please (0x1c). You can add a macro/wrapper, as TC2 does.
> 
> Yes i will remove it.
> 
> >
> >> +     exynos_power_down();
> >> +
> >> +     /*
> >> +      * Execution reaches here only if cpu did not power down.
> >> +      * Hence roll back the changes done in exynos_power_down function.
> >> +     */
> >> +     exynos_cpu_powerup(cpunr);
> >
> > Please be aware that if this function returns MCPM will soft reboot, and
> > the CPUidle driver will have no way to detect a state entry failure.
> >
> > I am just flagging this up, since fixing this behaviour is not easy, and
> > honestly, since power down failure should be the exception not the rule,
> > the idle stats should not be affected much.
> >
> > I think this is the proper way of implementing the sequence but please
> > all keep in mind what I wrote above.
> >
> > Lorenzo
> >
> >> +}
> >> +
> >>  static const struct mcpm_platform_ops exynos_power_ops = {
> >>       .power_up               = exynos_power_up,
> >>       .power_down             = exynos_power_down,
> >>       .power_down_finish      = exynos_power_down_finish,
> >> +     .suspend                = exynos_suspend,
> >> +     .powered_up             = exynos_powered_up,
> >>  };
> >>
> >>  static void __init exynos_mcpm_usage_count_init(void)
> >> --
> >> 1.7.9.5
> >>
> >>
> >
> 
> 
> 
> -- 
> with warm regards,
> Chander Kashyap
> 

