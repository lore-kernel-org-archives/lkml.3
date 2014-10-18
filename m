Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbaJRXAc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 19:00:32 -0400
Received: from gloria.sntech.de ([95.129.55.99]:58612 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbaJRXAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 19:00:31 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: Kever Yang <kever.yang@rock-chips.com>,
        Douglas Anderson <dianders@chromium.org>,
        Addy Ke <addy.ke@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, han jiang <hj@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/6] ARM: rockchip: convert to regmap and use pmu syscon if available
Date: Sun, 19 Oct 2014 01:03:19 +0200
Message-ID: <1575510.y30n33AHoo@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <CAPz6YkWq4b0k1SWKZdxRKf-7VPvYDdNvbZKnq-Wfk1QxWOassA@mail.gmail.com>
References: <1413393785-26783-1-git-send-email-kever.yang@rock-chips.com> <1413393785-26783-2-git-send-email-kever.yang@rock-chips.com> <CAPz6YkWq4b0k1SWKZdxRKf-7VPvYDdNvbZKnq-Wfk1QxWOassA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 17. Oktober 2014, 21:30:52 schrieb Sonny Rao:
> On Wed, Oct 15, 2014 at 10:23 AM, Kever Yang <kever.yang@rock-chips.com> 
wrote:
> > From: Heiko Stuebner <heiko@sntech.de>
> > 
> > The pmu register space is - like the GRF - shared by quite some
> > peripherals. On the rk3188 and rk3288 even parts of the pinctrl are
> > living there. Therefore we normally shouldn't map it a second time when
> > the syscon does this already.
> > 
> > Therefore convert the cpu power-domain handling to access the pmu via a
> > regmap and at first try to get it via the syscon interface.
> > Getting this syscon will only fail if the pmu node does not have the
> > "syscon" compatible and thus does not get shared with other drivers.
> > 
> > In this case we map it like before and create the necessary regmap on
> > top of it.
> > 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> > Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> > ---
> > 
> > Changes in v5: None
> > Changes in v4: None
> > Changes in v3:
> > - add this patch in version 3
> > 
> > Changes in v2: None
> > 
> >  arch/arm/mach-rockchip/platsmp.c | 104
> >  +++++++++++++++++++++++++++++---------- 1 file changed, 78
> >  insertions(+), 26 deletions(-)
> > 
> > diff --git a/arch/arm/mach-rockchip/platsmp.c
> > b/arch/arm/mach-rockchip/platsmp.c index 189684f..4c36fbf 100644
> > --- a/arch/arm/mach-rockchip/platsmp.c
> > +++ b/arch/arm/mach-rockchip/platsmp.c
> > @@ -19,6 +19,8 @@
> > 
> >  #include <linux/io.h>
> >  #include <linux/of.h>
> >  #include <linux/of_address.h>
> > 
> > +#include <linux/regmap.h>
> > +#include <linux/mfd/syscon.h>
> > 
> >  #include <asm/cacheflush.h>
> >  #include <asm/cp15.h>
> > 
> > @@ -37,23 +39,42 @@ static int ncores;
> > 
> >  #define PMU_PWRDN_SCU          4
> > 
> > -static void __iomem *pmu_base_addr;
> > +static struct regmap *pmu;
> > 
> > -static inline bool pmu_power_domain_is_on(int pd)
> > +static int pmu_power_domain_is_on(int pd)
> > 
> >  {
> > 
> > -       return !(readl_relaxed(pmu_base_addr + PMU_PWRDN_ST) & BIT(pd));
> > +       u32 val;
> > +       int ret;
> > +
> > +       ret = regmap_read(pmu, PMU_PWRDN_ST, &val);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       return !(val & BIT(pd));
> > 
> >  }
> > 
> > -static void pmu_set_power_domain(int pd, bool on)
> > +static int pmu_set_power_domain(int pd, bool on)
> > 
> >  {
> > 
> > -       u32 val = readl_relaxed(pmu_base_addr + PMU_PWRDN_CON);
> > -       if (on)
> > -               val &= ~BIT(pd);
> > -       else
> > -               val |=  BIT(pd);
> > -       writel(val, pmu_base_addr + PMU_PWRDN_CON);
> > -
> > -       while (pmu_power_domain_is_on(pd) != on) { }
> > +       u32 val = (on) ? 0 : BIT(pd);
> > +       int ret;
> > +
> > +       ret = regmap_update_bits(pmu, PMU_PWRDN_CON, BIT(pd), val);
> > +       if (ret < 0) {
> > +               pr_err("%s: could not update power domain\n", __func__);
> > +               return ret;
> > +       }
> > +
> > +       ret = -1;
> > +       while (ret != on) {
> > +               ret = pmu_power_domain_is_on(pd);
> > +               if (ret < 0) {
> > +                       pr_err("%s: could not read power domain state\n",
> > +                                __func__);
> > +                       return ret;
> > +               }
> > +       }
> > +
> > +       return 0;
> > 
> >  }
> >  
> >  /*
> > 
> > @@ -63,7 +84,7 @@ static void pmu_set_power_domain(int pd, bool on)
> > 
> >  static int __cpuinit rockchip_boot_secondary(unsigned int cpu,
> >  
> >                                              struct task_struct *idle)
> >  
> >  {
> > 
> > -       if (!sram_base_addr || !pmu_base_addr) {
> > +       if (!sram_base_addr || !pmu) {
> > 
> >                 pr_err("%s: sram or pmu missing for cpu boot\n",
> >                 __func__);
> >                 return -ENXIO;
> >         
> >         }
> > 
> > @@ -75,9 +96,7 @@ static int __cpuinit rockchip_boot_secondary(unsigned
> > int cpu,> 
> >         }
> >         
> >         /* start the core */
> > 
> > -       pmu_set_power_domain(0 + cpu, true);
> > -
> > -       return 0;
> > +       return pmu_set_power_domain(0 + cpu, true);
> > 
> >  }
> >  
> >  /**
> > 
> > @@ -125,6 +144,48 @@ static int __init rockchip_smp_prepare_sram(struct
> > device_node *node)> 
> >         return 0;
> >  
> >  }
> > 
> > +static struct regmap_config rockchip_pmu_regmap_config = {
> > +       .reg_bits = 32,
> > +       .val_bits = 32,
> > +       .reg_stride = 4,
> > +};
> > +
> > +static int __init rockchip_smp_prepare_pmu(void)
> > +{
> > +       struct device_node *node;
> > +       void __iomem *pmu_base;
> > +
> > +       pmu = syscon_regmap_lookup_by_compatible("rockchip,rk3066-pmu");
> > +       if (!IS_ERR(pmu))
> > +               return 0;
> > +
> > +       /* fallback, create our own regmap for the pmu area */
> 
> I don't think you need this fallback, the syscon driver should take
> care of mapping and creating the regmap for you -- assuming that the
> pmu node has the "syscon" property.

The original binding for the pmu node 
(devicetree/bindings/arm/rockchip/pmu.txt) does not specify "syscon" as second 
compatible.

Therefore we need this fallback to stay compatible with this. If the syscon 
compatible is present syscon_regmap_lookup_by_compatible will already succeed. 
If not [legacy case and also what the code did until now] we would create it 
in the fallback.

Nevertheless we should update the pmu binding to contain the "syscon" 
compatible and deprecate the variant without.

Hopefully I'll have time to do this on sunday :-)


Heiko


> > +       pmu = NULL;
> > +       node = of_find_compatible_node(NULL, NULL, "rockchip,rk3066-pmu");
> > +       if (!node) {
> > +               pr_err("%s: could not find pmu dt node\n", __func__);
> > +               return -ENODEV;
> > +       }
> > +
> > +       pmu_base = of_iomap(node, 0);
> > +       if (!pmu_base) {
> > +               pr_err("%s: could not map pmu registers\n", __func__);
> > +               return -ENOMEM;
> > +       }
> > +
> > +       pmu = regmap_init_mmio(NULL, pmu_base,
> > &rockchip_pmu_regmap_config); +       if (IS_ERR(pmu)) {
> > +               int ret = PTR_ERR(pmu);
> > +
> > +               iounmap(pmu_base);
> > +               pmu = NULL;
> > +               pr_err("%s: regmap init failed\n", __func__);
> > +               return ret;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > 
> >  static void __init rockchip_smp_prepare_cpus(unsigned int max_cpus)
> >  {
> >  
> >         struct device_node *node;
> > 
> > @@ -151,17 +212,8 @@ static void __init rockchip_smp_prepare_cpus(unsigned
> > int max_cpus)> 
> >         if (rockchip_smp_prepare_sram(node))
> >         
> >                 return;
> > 
> > -       node = of_find_compatible_node(NULL, NULL, "rockchip,rk3066-pmu");
> > -       if (!node) {
> > -               pr_err("%s: could not find pmu dt node\n", __func__);
> > +       if (rockchip_smp_prepare_pmu())
> > 
> >                 return;
> > 
> > -       }
> > -
> > -       pmu_base_addr = of_iomap(node, 0);
> > -       if (!pmu_base_addr) {
> > -               pr_err("%s: could not map pmu registers\n", __func__);
> > -               return;
> > -       }
> > 
> >         /* enable the SCU power domain */
> >         pmu_set_power_domain(PMU_PWRDN_SCU, true);
> > 
> > --
> > 1.9.1

