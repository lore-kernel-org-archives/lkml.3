Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab3IVVI3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 17:08:29 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:58020 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3IVVI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 17:08:27 -0400
MIME-Version: 1.0
In-Reply-To: <1379510692-32435-8-git-send-email-treding@nvidia.com>
References: <1379510692-32435-1-git-send-email-treding@nvidia.com>
	<1379510692-32435-8-git-send-email-treding@nvidia.com>
Date: Sun, 22 Sep 2013 16:08:26 -0500
Message-ID: <CAL_JsqJ+4P26hRrJcrbBmwfNPDAS+1GhXj12B+UvqmZZGjqT0g@mail.gmail.com>
Subject: Re: [PATCH v2 07/10] of/irq: Propagate errors in of_irq_to_resource_table()
From: Rob Herring <robherring2@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mips@linux-mips.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        sparclinux@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 8:24 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> Now that all helpers return precise error codes, this function can
> propagate these errors to the caller properly.
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Changes in v2:
> - return 0 on success or a negative error code on failure
> - convert callers to new calling convention

[snip]

> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> index e4f38c0..6d7f824 100644
> --- a/drivers/of/irq.c
> +++ b/drivers/of/irq.c
> @@ -397,18 +397,20 @@ int of_irq_count(struct device_node *dev)
>   * @res: array of resources to fill in
>   * @nr_irqs: the number of IRQs (and upper bound for num of @res elements)

You are effectively changing this to require an exact match rather
than an upper bound. That seems to be okay since that is what all the
callers want, but the documentation should be updated.

>   *
> - * Returns the size of the filled in table (up to @nr_irqs).
> + * Returns 0 on success or a negative error code on failure.
>   */
>  int of_irq_to_resource_table(struct device_node *dev, struct resource *res,
>                 int nr_irqs)
>  {
> -       int i;
> +       int i, ret;
>
> -       for (i = 0; i < nr_irqs; i++, res++)
> -               if (!of_irq_to_resource(dev, i, res))

The error handling here needs to be updated in the previous patch.

> -                       break;
> +       for (i = 0; i < nr_irqs; i++, res++) {
> +               ret = of_irq_to_resource(dev, i, res);
> +               if (ret < 0)
> +                       return ret;
> +       }
>
> -       return i;
> +       return 0;
>  }
>  EXPORT_SYMBOL_GPL(of_irq_to_resource_table);
>
