Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaLDDpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 22:45:25 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:52131 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaLDDpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 22:45:23 -0500
MIME-Version: 1.0
In-Reply-To: <1417610024-29748-1-git-send-email-m.szyprowski@samsung.com>
References: <1416814256-24288-3-git-send-email-a.hajda@samsung.com>
	<1417610024-29748-1-git-send-email-m.szyprowski@samsung.com>
Date: Thu, 4 Dec 2014 09:15:21 +0530
X-Google-Sender-Auth: 0HLgjeDigVSMreAmO_ulU-ty-U4
Message-ID: <CADGdYn5N-hw7P0+0Z4hZk33NeV30UR+h8joHfC1qSo_mRfzofg@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] ARM: Exynos: add support for sub-power domains
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene@kernel.org>, Inki Dae <inki.dae@samsung.com>,
        Tobias Jakobi <Liquid.Acid@gmx.net>, Daniel Drake <drake@endlessm.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 6:03 PM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> This patch adds support for making one power domain a sub-domain of
> other domain. This is useful for modeling power dependences for devices
> like TV Mixer or Camera ISP, which needs to have more than one power
> domain enabled to be operational.
>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  Documentation/devicetree/bindings/arm/exynos/power_domain.txt |  2 ++
>  arch/arm/mach-exynos/pm_domains.c                             | 11 ++++++++++-
>  2 files changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
> index abde1ea8a119..b884358ebb1a 100644
> --- a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
> +++ b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
> @@ -22,6 +22,8 @@ Optional Properties:
>         - pclkN, clkN: Pairs of parent of input clock and input clock to the
>                 devices in this power domain. Maximum of 4 pairs (N = 0 to 3)
>                 are supported currently.
> +- samsung,power-domain: phandle to a master power domain that the given domain
> +                      is a part of
>
>  Node of a device using power domains must have a samsung,power-domain property
>  defined with a phandle to respective power domain.
> diff --git a/arch/arm/mach-exynos/pm_domains.c b/arch/arm/mach-exynos/pm_domains.c
> index 20f267121b3e..fa9a47ddad81 100644
> --- a/arch/arm/mach-exynos/pm_domains.c
> +++ b/arch/arm/mach-exynos/pm_domains.c
> @@ -108,7 +108,7 @@ static int exynos_pd_power_off(struct generic_pm_domain *domain)
>  static __init int exynos4_pm_init_power_domain(void)
>  {
>         struct platform_device *pdev;
> -       struct device_node *np;
> +       struct device_node *np, *master_np;
>
>         for_each_compatible_node(np, NULL, "samsung,exynos4210-pd") {
>                 struct exynos_pm_domain *pd;
> @@ -159,6 +159,15 @@ no_clk:
>
>                 pm_genpd_init(&pd->pd, NULL, !on);
>                 of_genpd_add_provider_simple(np, &pd->pd);
> +
> +               /* make master and slave hierarchy */
> +               master_np = of_parse_phandle(np, "samsung,power-domain", 0);
> +               if (!master_np)
> +                       master_np = of_parse_phandle(np, "power-domains", 0);
> +               if (master_np) {
> +                       pm_genpd_add_subdomain_names(master_np->name, np->name);
> +                       of_node_put(master_np);
> +               }
>         }
Hi Marek,

In the my patch series posted earlier i added this feature in a
slightly different way. (https://lkml.org/lkml/2014/11/24/320)
Parent PD's are not added in the same loop but in the second loop.
This will make sure that the parents PD are registered before the
child PD's and we can get away from the assumption of child/parent
PD's position in the Device Tree. This is a still a work in progress.
Also posted a patch earlier regarding this,
http://www.spinics.net/lists/linux-samsung-soc/msg39836.html.

Regards,
Amit



>
>         return 0;
> --
> 1.9.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
