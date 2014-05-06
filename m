Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934288AbaEFHZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 03:25:19 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:65467 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934110AbaEFHZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 03:25:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux@arm.linux.org.uk, t.figa@samsung.com,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com
Subject: Re: [PATCH 0/4] Introducing Exynos ChipId driver
Date: Tue, 06 May 2014 09:24:42 +0200
Message-ID: <20694329.WZS2oIXA4v@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <536887D4.90808@samsung.com>
References: <1399097500-4052-1-git-send-email-pankaj.dubey@samsung.com> <4239261.HFHm7SU1iH@wuerfel> <536887D4.90808@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Mm8QMjZYktbHjfr2M0Fo6g8ewY+32pMYIgIPDqsQnh9
 GFlJu555alKbMbBU+/Dy9MC1La5TXcAt965SvN+9oNAywnu5pG
 uMsKYEtBUGpKaQi757YhJ5s/AidCPXkSoX+xFHpIV8pcVEwKfr
 dmgsyo1S1igWHgyIP+JuJr1iLf8Lpgf8Rrl3jBBwuC9P0YrUFv
 /gM7aavQqpMXsWo2f22fLlzGpox3ULlZ95I6+FR74EY8Tl2nnz
 5Nhr++xUnXCiRnRGsopnJ/gW3MfhDe3yU4MJKjvlS09tXyGIu3
 UDclC5OAH+177l3sv1ufwNl//jzrWT8Bn+gvtRSmrG2ma4DhmJ
 ggQ2PlZQkjTwGnFmSrQg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 May 2014 15:57:24 Pankaj Dubey wrote:
> On 05/05/2014 11:58 PM, Arnd Bergmann wrote:
> > On Monday 05 May 2014 18:23:55 Pankaj Dubey wrote:
> >> On 05/04/2014 12:02 AM, Arnd Bergmann wrote:
> >>> Ideally this should be done by slightly restructuring the DT
> >>> source to make all on-chip devices appear below the soc node.
> >> Currently I can't see soc nodes in exynos4 and exynos5 DT files.
> >> So isn't it should be a separate patch first to modify all exynos4
> >> exynos5 DT files to move all devices under soc node?
> >> In that case existing chipid node will be also moved under soc node.
> > Yes, that would be good. In fact the soc node could be identical
> > to the chipid node, effectively moving everything under chipid.
> 
> OK, in that case I would like to keep this as separate patch once
> I do all other modifications.

Yes, makes sense. Let's see if we can convince Rob first though, he
has some reservations.

> >> Also even if we get some way to preserve existing compatibility, I afraid
> >> in chipid driver that implementation will not look good, at least I am not
> >> able to think of any good way. Any suggestions?
> > The compatibility I mean is to ensure everything keeps working if
> > the node is not present.
> >
> >>> Regarding patch 4, this is not what I meant when I asked for
> >>> removing the soc_is_exynos* macros. You basically do a 1:1 replacement
> >>> using a different interface, but you still have code that does
> >>> things differently based on a global identification.
> >> I agree with what you are trying to say. But if you see recently we had some
> >> patches (cpu_idle.c: [2], pmu.c: [3])  to remove usage of such macros from
> >> exynos machine files. So only leftover files using these macros are exynos.c
> >> platsmp.c and pm.c.
> >>
> >> For exynos.c I have tried to remove soc_is_exynos4/exynos5 by matching with
> >> compatible string in patch 1 of this series. Please let me know if that is OK?
> > I've taken a closer look at that file now. My preferred solution
> > would be to go back to having two machine descriptors as it
> > was before Sachin Kamat's "ARM: EXYNOS: Consolidate exynos4 and
> > exynos5 machine files", but keep it all in one file and consolidated
> > as much as possible, e.g.
> 
> Yes, that case I do not need to add another function to compare compatible 
> strings.
> So if there is no issues in having two separate machine descriptor I will 
> do this
> modification in next version of patch.

ok.

> > static void __init exynos_dt_machine_init(void)
> > {
> >         exynos_cpuidle_init();
> >         exynos_cpufreq_init();
> >
> >         of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> > }
> >
> > static void __init exynos5_dt_machine_init(void)
> > {
> >         /*
> >          * Exynos5's legacy i2c controller and new high speed i2c
> >          * controller have muxed interrupt sources. By default the
> >          * interrupts for 4-channel HS-I2C controller are enabled.
> >          * If node for first four channels of legacy i2c controller
> >          * are available then re-configure the interrupts via the
> >          * system register.
> >          */
> >         struct device_node *i2c_np;
> >         const char *i2c_compat = "samsung,s3c2440-i2c";
> >         unsigned int tmp;
> >         int id;
> >
> >         for_each_compatible_node(i2c_np, NULL, i2c_compat) {
> >                if (of_device_is_available(i2c_np)) {
> >                          id = of_alias_get_id(i2c_np, "i2c");
> >                          if (id < 4) {
> >                                    tmp = readl(EXYNOS5_SYS_I2C_CFG);
> >                                    writel(tmp & ~(0x1 << id),  EXYNOS5_SYS_I2C_CFG);
> >                          }
> >                 }
> >         }
> >
> >         exynos_dt_machine_init();
> > }
> >
> > This way you can avoid having another check of the compatible node.
> > In the long run, all of the this code should go away: The cpuidle
> > and cpufreq drivers should become normal platform drivers that
> > get probed when the devices are present (just like it's required
> > for arm64 anyway), and the EXYNOS5_SYS_I2C_CFG register should
> > get set up by an appropriate driver, e.g. the i2c driver through
> > syscon, or a pinmux driver that changes the mux between the
> > sources based on DT information, whatever fits best.
> 
> OK, will move this in i2c driver and will use sysreg as syscon phandle.

Ok, cool.

> >> Also for platsmp.c and pm.c I can think of following approaches
> >> 1: Keep these macros till we get generic solution?
> >> 2: Allow chipid driver to expose APIs to check SoC id and SoC revisions
> >> till we get
> >> generic solution. So that at least we can remove #ifdef  based macros
> >> as soc_is_exynosXYZ.
> >> 3: Use of "of_flat_dt_is_compatible" or similar APIs in these machine files
> >> till we get
> >> generic solution. For some cases where we want to know SoC revision let us
> >> map chipid register and get revision there itself.
> >>
> >> Please let me know what approach you think will be good?
> > I think 1 or 2 would be better than 3. Between those two, I'm undecided,
> > but I think either way the SoC specific values would be better kept in the
> > mach-samsung directory than in plat/cpu.h or linux/exynos-chipid.h.
> 
> OK, let me introduce this driver via "drivers/soc" in second revision,
> there also if we think it's not proper to expose such APIs or variable
> outside of the driver, I will be think to move it in under machine 
> directory itself.

Ok.

	Arnd
