Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbaI2Uay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 16:30:54 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:56959 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaI2Uav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 16:30:51 -0400
MIME-Version: 1.0
In-Reply-To: <1412001499-19369-3-git-send-email-grygorii.strashko@ti.com>
References: <1412001499-19369-1-git-send-email-grygorii.strashko@ti.com>
	<1412001499-19369-3-git-send-email-grygorii.strashko@ti.com>
Date: Mon, 29 Sep 2014 22:30:49 +0200
X-Google-Sender-Auth: ovSKYxOk1oadPirT_PStAd4RiRc
Message-ID: <CAMuHMdVhu4-ZOK3QHQTzCViRvvoQ7H-pZLe4GkwGkzBBfJ8ayw@mail.gmail.com>
Subject: Re: [PATCH v1 2/4] ARM: keystone: pm: switch to use generic pm domains
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kevin Hilman <khilman@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grygorii,

On Mon, Sep 29, 2014 at 4:38 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> This patch switches Keystone 2 PM code to use Generic PM domains
> instead of PM clock domains because of the lack of DT support
> for the last.

Thanks, this looks interesting, as today I've been digging deeper into the
!CONFIG_PM_RUNTIME case for my patch series, and ended up with something
similar...

> --- a/arch/arm/mach-keystone/pm_domain.c
> +++ b/arch/arm/mach-keystone/pm_domain.c
> @@ -12,69 +12,110 @@
>   * version 2, as published by the Free Software Foundation.
>   */
>
> +#include <linux/clk.h>
>  #include <linux/init.h>
> -#include <linux/pm_runtime.h>
>  #include <linux/pm_clock.h>
> +#include <linux/pm_domain.h>
>  #include <linux/platform_device.h>
> -#include <linux/clk-provider.h>
>  #include <linux/of.h>
>
> -#ifdef CONFIG_PM_RUNTIME
> -static int keystone_pm_runtime_suspend(struct device *dev)
> +#ifdef CONFIG_PM_GENERIC_DOMAINS
> +
> +struct keystone_domain {
> +       struct generic_pm_domain base;
> +       struct device   *dev;
> +};
> +
> +void keystone_pm_domain_attach_dev(struct device *dev)
>  {
> +       struct clk *clk;
>         int ret;
> +       int i = 0;
>
>         dev_dbg(dev, "%s\n", __func__);
>
> -       ret = pm_generic_runtime_suspend(dev);
> -       if (ret)
> -               return ret;
> -
> -       ret = pm_clk_suspend(dev);
> +       ret = pm_clk_create(dev);
>         if (ret) {
> -               pm_generic_runtime_resume(dev);
> -               return ret;
> +               dev_err(dev, "pm_clk_create failed %d\n", ret);
> +               return;
> +       };
> +
> +       while ((clk = of_clk_get(dev->of_node, i++)) && !IS_ERR(clk)) {
> +               ret = pm_clk_add_clk(dev, clk);

This is an important difference compared to the non-DT pm_clk_notify()
version for !CONFIG_PM_RUNTIME.

You do call pm_clk_create() and pm_clk_add_clk(), while
pm_clk_notify() doesn't. Hence for the latter, the clocklist is always empty.

> +               if (ret) {
> +                       dev_err(dev, "pm_clk_add_clk failed %d\n", ret);
> +                       goto clk_err;
> +               };
>         }
>
> -       return 0;
> +       if (!IS_ENABLED(CONFIG_PM_RUNTIME)) {
> +               ret = pm_clk_resume(dev);

As a consequence of the above, calling pm_clk_resume() here just works,
and there's no need for the separate enable_clock()/disable_clock()
functions, like in drivers/base/power/clock_ops.c.

> +               if (ret) {
> +                       dev_err(dev, "pm_clk_resume failed %d\n", ret);
> +                       goto clk_err;
> +               };
> +       }
> +       return;
> +
> +clk_err:
> +       pm_clk_destroy(dev);
>  }
>
> -static int keystone_pm_runtime_resume(struct device *dev)
> +void keystone_pm_domain_detach_dev(struct device *dev)
>  {
>         dev_dbg(dev, "%s\n", __func__);
> -
> -       pm_clk_resume(dev);
> -
> -       return pm_generic_runtime_resume(dev);
> +       pm_clk_destroy(dev);
>  }
> -#endif
>
> -static struct dev_pm_domain keystone_pm_domain = {
> -       .ops = {
> -               SET_RUNTIME_PM_OPS(keystone_pm_runtime_suspend,
> -                                  keystone_pm_runtime_resume, NULL)
> -               USE_PLATFORM_PM_SLEEP_OPS
> +static const struct keystone_domain keystone_domain = {
> +       .base = {
> +               .name = "keystone",
> +               .attach_dev = keystone_pm_domain_attach_dev,
> +               .detach_dev = keystone_pm_domain_detach_dev,
> +               .dev_ops = {
> +                       .stop = pm_clk_suspend,
> +                       .start = pm_clk_resume,

Same here: the clocks will be disabled/enabled on system suspend/resume,
which is not the case for the non-DT case.

Rafael: shouldn't pm_clk_notify() in drivers/base/power/clock_ops.c
behave the same as above?
Or is there a good reason the non-PM runtime version doesn't call pm_clk_add()?

Then the two versions (CONFIG_PM_RUNTIME enabled vs. disabled) can become
more similar, and perhaps be merged.

> +               },
> +               .power_off_latency_ns = 25000,
> +               .power_on_latency_ns = 2000000,
>         },
>  };


Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
