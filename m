Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbaIZIpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 04:45:55 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:60089 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbaIZIpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 04:45:51 -0400
MIME-Version: 1.0
In-Reply-To: <1411662520-22795-8-git-send-email-geert+renesas@glider.be>
References: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
	<1411662520-22795-8-git-send-email-geert+renesas@glider.be>
Date: Fri, 26 Sep 2014 10:45:50 +0200
Message-ID: <CAPDyKFrWKOENKxF1JBrtwYfQNTVjsQPqws3UTfGXy_4Uqog+pg@mail.gmail.com>
Subject: Re: [PATCH v3 07/13] ARM: shmobile: R-Mobile: Use generic_pm_domain.attach_dev()
 for pm_clk setup
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 September 2014 18:28, Geert Uytterhoeven <geert+renesas@glider.be> wrote:
> Use the just introduced genpd attach/detach callbacks to register the
> devices' module clocks, instead of doing it directly, to make it
> DT-proof.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

> ---
> v3:
>   - Update for callback signature changes,
> v2:
>   - New
>
>  arch/arm/mach-shmobile/pm-rmobile.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-shmobile/pm-rmobile.c b/arch/arm/mach-shmobile/pm-rmobile.c
> index 717e6413d29cb998..ae846dfcd69293f7 100644
> --- a/arch/arm/mach-shmobile/pm-rmobile.c
> +++ b/arch/arm/mach-shmobile/pm-rmobile.c
> @@ -101,6 +101,17 @@ static bool rmobile_pd_active_wakeup(struct device *dev)
>         return true;
>  }
>
> +static void rmobile_pd_attach_dev(struct device *dev)
> +{
> +       if (pm_clk_no_clocks(dev))
> +               pm_clk_add(dev, NULL);
> +}
> +
> +static void rmobile_pd_detach_dev(struct device *dev)
> +{
> +       pm_clk_remove(dev, NULL);
> +}
> +
>  static void rmobile_init_pm_domain(struct rmobile_pm_domain *rmobile_pd)
>  {
>         struct generic_pm_domain *genpd = &rmobile_pd->genpd;
> @@ -112,6 +123,8 @@ static void rmobile_init_pm_domain(struct rmobile_pm_domain *rmobile_pd)
>         genpd->dev_ops.active_wakeup    = rmobile_pd_active_wakeup;
>         genpd->power_off                = rmobile_pd_power_down;
>         genpd->power_on                 = rmobile_pd_power_up;
> +       genpd->attach_dev               = rmobile_pd_attach_dev;
> +       genpd->detach_dev               = rmobile_pd_detach_dev;
>         __rmobile_pd_power_up(rmobile_pd, false);
>  }
>
> @@ -130,8 +143,6 @@ void rmobile_add_device_to_domain_td(const char *domain_name,
>         struct device *dev = &pdev->dev;
>
>         __pm_genpd_name_add_device(domain_name, dev, td);
> -       if (pm_clk_no_clocks(dev))
> -               pm_clk_add(dev, NULL);
>  }
>
>  void rmobile_add_devices_to_domains(struct pm_domain_device data[],
> --
> 1.9.1
>
