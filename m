Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbaEMTtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:49:50 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:60643 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbaEMTt3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:49:29 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "Sebastian Hesselbarth" <sebastian.hesselbarth@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1399839881-29895-2-git-send-email-sebastian.hesselbarth@gmail.com>
Cc: "Grant Likely" <grant.likely@linaro.org>,
        "Rob Herring" <robh+dt@kernel.org>,
        "Alexandre Belloni" <alexandre.belloni@free-electrons.com>,
        "Antoine Tenart" <antoine.tenart@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1399839881-29895-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1399839881-29895-2-git-send-email-sebastian.hesselbarth@gmail.com>
Message-ID: <20140513194922.5943.40228@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 1/8] clk: add helper for unique DT clock names
Date: Tue, 13 May 2014 12:49:22 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sebastian Hesselbarth (2014-05-11 13:24:34)
> Currently, most DT clock drivers pick a unique node name to allow unique
> clock names. As ePAPR recommends node names to be generic, we therefore
> provide a helper to generate a unique clock name from the DT node name
> plus reg property or a magic number instead. This is basically the same
> we already do for proper devices and may vanish as soon as there is some
> (early) device support for clocks available.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Cc: Antoine Tenart <antoine.tenart@free-electrons.com>
> Cc: devicetree@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/clk/clk.c            | 29 +++++++++++++++++++++++++++++
>  include/linux/clk-provider.h |  5 +++++
>  2 files changed, 34 insertions(+)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index dff0373f53c1..b449a635dbfa 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -17,6 +17,7 @@
>  #include <linux/list.h>
>  #include <linux/slab.h>
>  #include <linux/of.h>
> +#include <linux/of_address.h>
>  #include <linux/device.h>
>  #include <linux/init.h>
>  #include <linux/sched.h>
> @@ -2543,6 +2544,34 @@ const char *of_clk_get_parent_name(struct device_node *np, int index)
>  }
>  EXPORT_SYMBOL_GPL(of_clk_get_parent_name);
>  
> +/**
> + * of_clk_create_name() - Allocate and create a unique clock name
> + * @np: Device node pointer of the clock node
> + *
> + * This will allocate and create a unique clock name based on the
> + * reg property value. As a last resort, it will use the node name
> + * followed by a unique number. The caller has to deallocate the
> + * buffer.
> + */
> +char *of_clk_create_name(struct device_node *np)
> +{
> +       static atomic_t clk_no_reg_magic;
> +       const __be32 *reg;
> +       u64 addr;
> +       int magic;
> +
> +       reg = of_get_property(np, "reg", NULL);
> +       if (reg) {
> +               addr = of_translate_address(np, reg);
> +               return kasprintf(GFP_KERNEL, "%llx.%s",
> +                                (unsigned long long)addr, np->name);
> +       }
> +
> +       magic = atomic_add_return(1, &clk_no_reg_magic);
> +       return kasprintf(GFP_KERNEL, "%s.%d", np->name, magic);

For the case where we the reg property is present we use reg.name, but
for the case were the reg property is missing we use name.magic. Is it
intentional to switch the string and integer pairs?

Doing so avoids the case where magic might collide with a simple bus
clock (e.g. 'clk@1'), but I wanted to double check that it was
intentional.

Regards,
Mike

> +}
> +EXPORT_SYMBOL_GPL(of_clk_create_name);
> +
>  struct clock_provider {
>         of_clk_init_cb_t clk_init_cb;
>         struct device_node *np;
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 511917416fb0..c6f3ca1cd81c 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -514,6 +514,7 @@ struct clk *of_clk_src_simple_get(struct of_phandle_args *clkspec,
>  struct clk *of_clk_src_onecell_get(struct of_phandle_args *clkspec, void *data);
>  int of_clk_get_parent_count(struct device_node *np);
>  const char *of_clk_get_parent_name(struct device_node *np, int index);
> +char *of_clk_create_name(struct device_node *np);
>  
>  void of_clk_init(const struct of_device_id *matches);
>  
> @@ -543,6 +544,10 @@ static inline const char *of_clk_get_parent_name(struct device_node *np,
>  {
>         return NULL;
>  }
> +static inline char *of_clk_create_name(struct device_node *np)
> +{
> +       return NULL;
> +}
>  #define of_clk_init(matches) \
>         { while (0); }
>  #endif /* CONFIG_OF */
> -- 
> 1.9.1
> 
