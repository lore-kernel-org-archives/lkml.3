Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160AbaEEO6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:58:22 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:61335 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932887AbaEEO6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:58:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, t.figa@samsung.com,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 0/4] Introducing Exynos ChipId driver
Date: Mon, 05 May 2014 16:58:14 +0200
Message-ID: <4239261.HFHm7SU1iH@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <536758AB.2060503@samsung.com>
References: <1399097500-4052-1-git-send-email-pankaj.dubey@samsung.com> <13946837.RfnRDPQdge@wuerfel> <536758AB.2060503@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:1nozxlos9Gy3gB1ZU4QQD4K0/TwwZB3SXE0/tYRoJSf
 vzlJoFIbloD43gko0/86FDGMdOP7gY0SlXqp9gC88lQi3umfwA
 t2esiXes883NTCklxLzZCYrlbWP9+tRaFBCttottM+ei1Yl44M
 5f0TMbCZiK9HhvVJzpFwpn9Ap0DK9nzP1l5Tt21G8/9wk/eW9R
 /YCfFyWm131kZW2k6oNNxAQK/XWVpxbFZuUer0YgePFBR4xZAe
 lVmf8h3OKJhmozFRqwqlPuQTTOf5mwy4F19eT8AQCj1KZp/mkU
 CUpPees3n2HWiuTTyOc3EDJgZ6tpShH9N8cFsIGuzDKDJrzKs3
 baD7OwvDdO89j23sIiU8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 May 2014 18:23:55 Pankaj Dubey wrote:
> On 05/04/2014 12:02 AM, Arnd Bergmann wrote:
> > Ideally this should be done by slightly restructuring the DT
> > source to make all on-chip devices appear below the soc node.
> 
> Currently I can't see soc nodes in exynos4 and exynos5 DT files.
> So isn't it should be a separate patch first to modify all exynos4
> exynos5 DT files to move all devices under soc node?
> In that case existing chipid node will be also moved under soc node.

Yes, that would be good. In fact the soc node could be identical
to the chipid node, effectively moving everything under chipid.

> > We'd have to think a bit about how to best do this while
> > preserving compatibility with existing dts files.
> 
> Is it necessary in this case?
> As I have mentioned there is difference in bit-mask among exynos4
> and exynos5's chipid. So is this reason not sufficient to keep separate
> compatible for both?

Having two "compatible" values for exynos4 and exynos5 is not a problem,
and it absolutely makes sense to have more specific values in there
as well:

compatible = "samsung,exynos4210-chipid", "samsung,exynos4-chipid";

> Also even if we get some way to preserve existing compatibility, I afraid
> in chipid driver that implementation will not look good, at least I am not
> able to think of any good way. Any suggestions?

The compatibility I mean is to ensure everything keeps working if
the node is not present.

> > Regarding patch 4, this is not what I meant when I asked for
> > removing the soc_is_exynos* macros. You basically do a 1:1 replacement
> > using a different interface, but you still have code that does
> > things differently based on a global identification.
> I agree with what you are trying to say. But if you see recently we had some
> patches (cpu_idle.c: [2], pmu.c: [3])  to remove usage of such macros from
> exynos machine files. So only leftover files using these macros are exynos.c
> platsmp.c and pm.c.
> 
> For exynos.c I have tried to remove soc_is_exynos4/exynos5 by matching with
> compatible string in patch 1 of this series. Please let me know if that is OK?

I've taken a closer look at that file now. My preferred solution
would be to go back to having two machine descriptors as it
was before Sachin Kamat's "ARM: EXYNOS: Consolidate exynos4 and
exynos5 machine files", but keep it all in one file and consolidated
as much as possible, e.g.

static void __init exynos_dt_machine_init(void)
{
       exynos_cpuidle_init();
       exynos_cpufreq_init();

       of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
}

static void __init exynos5_dt_machine_init(void)
{
       /*
        * Exynos5's legacy i2c controller and new high speed i2c
        * controller have muxed interrupt sources. By default the
        * interrupts for 4-channel HS-I2C controller are enabled.
        * If node for first four channels of legacy i2c controller
        * are available then re-configure the interrupts via the
        * system register.
        */
       struct device_node *i2c_np;
       const char *i2c_compat = "samsung,s3c2440-i2c";
       unsigned int tmp;
       int id;

       for_each_compatible_node(i2c_np, NULL, i2c_compat) {
              if (of_device_is_available(i2c_np)) {
                        id = of_alias_get_id(i2c_np, "i2c");
                        if (id < 4) {
                                  tmp = readl(EXYNOS5_SYS_I2C_CFG);
                                  writel(tmp & ~(0x1 << id),  EXYNOS5_SYS_I2C_CFG);
                        }
               }
       }

       exynos_dt_machine_init();
}

This way you can avoid having another check of the compatible node.
In the long run, all of the this code should go away: The cpuidle
and cpufreq drivers should become normal platform drivers that
get probed when the devices are present (just like it's required
for arm64 anyway), and the EXYNOS5_SYS_I2C_CFG register should
get set up by an appropriate driver, e.g. the i2c driver through
syscon, or a pinmux driver that changes the mux between the
sources based on DT information, whatever fits best.

Similarly for exynos_map_io(), with the sysram out of the picture,
it can be 

void __init exynos4_init_io(void)
{
        debug_ll_io_init();
	iotable_init(exynos4_iodesc, ARRAY_SIZE(exynos4_iodesc));
}

void __init exynos5_init_io(void)
{
        debug_ll_io_init();
	iotable_init(exynos5_iodesc, ARRAY_SIZE(exynos4_iodesc));
}

but in the long run, it would be nicer to completely eliminate
exynos4_iodesc and exynos5_iodesc as well, and remove the init_io
functions. Note that debug_ll_io_init() is already called when
you have a NULL .map_io callback.

> Also for platsmp.c and pm.c I can think of following approaches
> 1: Keep these macros till we get generic solution?
> 2: Allow chipid driver to expose APIs to check SoC id and SoC revisions 
> till we get
> generic solution. So that at least we can remove #ifdef  based macros
> as soc_is_exynosXYZ.
> 3: Use of "of_flat_dt_is_compatible" or similar APIs in these machine files 
> till we get
> generic solution. For some cases where we want to know SoC revision let us
> map chipid register and get revision there itself.
> 
> Please let me know what approach you think will be good?

I think 1 or 2 would be better than 3. Between those two, I'm undecided,
but I think either way the SoC specific values would be better kept in the
mach-samsung directory than in plat/cpu.h or linux/exynos-chipid.h.

	Arnd
