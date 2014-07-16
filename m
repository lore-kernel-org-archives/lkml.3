Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaGPUuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:50:17 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:46629 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbaGPUuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:50:05 -0400
MIME-Version: 1.0
In-Reply-To: <1405116252-53612-3-git-send-email-s-anna@ti.com>
References: <1405116252-53612-1-git-send-email-s-anna@ti.com>
	<1405116252-53612-3-git-send-email-s-anna@ti.com>
Date: Wed, 16 Jul 2014 13:50:03 -0700
Message-ID: <CAPdLdqmA5HkRe9xLOUybOQQzpkmqX8Ot4aH9ZA7B_s3Zp90tPw@mail.gmail.com>
Subject: Re: [PATCHv2 2/5] mailbox/omap: add support for parsing dt devices
From: Markus Mayer <markus.mayer@linaro.org>
To: Suman Anna <s-anna@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Jassi Brar <jaswinder.singh@linaro.org>,
        Dave Gerlach <d-gerlach@ti.com>, Pavel Machek <pavel@ucw.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org,
        Device Tree List <devicetree@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I may nit-pick here for a minute...

On 11 July 2014 15:04, Suman Anna <s-anna@ti.com> wrote:
> Logic has been added to the OMAP2+ mailbox code to parse the
> mailbox dt nodes and construct the different sub-mailboxes
> associated with the instance. The DT representation of the
> sub-mailbox devices is different from legacy platform data
> representation to allow flexibility of interrupt configuration
> between Tx and Rx fifos (to also possibly allow simplex devices
> in the future). The DT representation gathers similar information
> that was being passed previously through the platform data, except
> for the number of fifos, interrupts and interrupt type information,
> which are gathered through driver compatible match data.
>
> The non-DT support has to be maintained for now to not break
> OMAP3 legacy boot, and the legacy-style code will be cleaned
> up once OMAP3 is also converted to DT-boot only.
>
> Cc: Jassi Brar <jassisinghbrar@gmail.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Suman Anna <s-anna@ti.com>
> ---
>  drivers/mailbox/omap-mailbox.c | 156 ++++++++++++++++++++++++++++++++++-------
>  1 file changed, 132 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/mailbox/omap-mailbox.c b/drivers/mailbox/omap-mailbox.c

[...]

>  static int omap_mbox_probe(struct platform_device *pdev)
>  {
>         struct resource *mem;
>         int ret;
>         struct omap_mbox **list, *mbox, *mboxblk;
>         struct omap_mbox_pdata *pdata = pdev->dev.platform_data;
> -       struct omap_mbox_dev_info *info;
> +       struct omap_mbox_dev_info *info = NULL;
> +       struct omap_mbox_fifo_info *finfo, *finfoblk;
>         struct omap_mbox_device *mdev;
>         struct omap_mbox_fifo *fifo;
> -       u32 intr_type;
> +       struct device_node *node = pdev->dev.of_node;
> +       struct device_node *child;
> +       const struct of_device_id *match;
> +       u32 intr_type, info_count;
> +       u32 num_users, num_fifos;
> +       u32 tmp[3];
>         u32 l;
>         int i;
>
> -       if (!pdata || !pdata->info_cnt || !pdata->info) {
> +       if (!node && (!pdata || !pdata->info_cnt || !pdata->info)) {
>                 pr_err("%s: platform not supported\n", __func__);
>                 return -ENODEV;
>         }
>
> +       if (node) {

I noticed here you are using

    if (node)
        /* DT stuff goes here */
    else
        /* non-DT stuff goes here */

but below the logic is reversed.

> +               match = of_match_device(omap_mailbox_of_match, &pdev->dev);
> +               if (!match)
> +                       return -ENODEV;
> +               intr_type = (u32)match->data;
> +
> +               if (of_property_read_u32(node, "ti,mbox-num-users",
> +                                        &num_users))
> +                       return -ENODEV;
> +
> +               if (of_property_read_u32(node, "ti,mbox-num-fifos",
> +                                        &num_fifos))
> +                       return -ENODEV;
> +
> +               info_count = of_get_available_child_count(node);
> +               if (!info_count) {
> +                       dev_err(&pdev->dev, "no available mbox devices found\n");
> +                       return -ENODEV;
> +               }
> +       } else { /* non-DT device creation */
> +               info_count = pdata->info_cnt;
> +               info = pdata->info;
> +               intr_type = pdata->intr_type;
> +               num_users = pdata->num_users;
> +               num_fifos = pdata->num_fifos;
> +       }
> +
> +       finfoblk = devm_kzalloc(&pdev->dev, info_count * sizeof(*finfoblk),
> +                               GFP_KERNEL);
> +       if (!finfoblk)
> +               return -ENOMEM;
> +
> +       finfo = finfoblk;
> +       child = NULL;
> +       for (i = 0; i < info_count; i++, finfo++) {
> +               if (!node) {

Here it's
    if (!node)
        /* non-DT stuff */
    else
        /* DT stuff */

I think the "if (node) ..." version is a bit cleaner. Besides it's
nice if code is consistent. Do you mind changing the if statement here
so it matches the logic used above?

> +                       finfo->tx_id = info->tx_id;
> +                       finfo->rx_id = info->rx_id;
> +                       finfo->tx_usr = info->usr_id;
> +                       finfo->tx_irq = info->irq_id;
> +                       finfo->rx_usr = info->usr_id;
> +                       finfo->rx_irq = info->irq_id;
> +                       finfo->name = info->name;
> +                       info++;
> +               } else {
> +                       child = of_get_next_available_child(node, child);
> +                       ret = of_property_read_u32_array(child, "ti,mbox-tx",
> +                                                        tmp, ARRAY_SIZE(tmp));
> +                       if (ret)
> +                               return ret;
> +                       finfo->tx_id = tmp[0];
> +                       finfo->tx_irq = tmp[1];
> +                       finfo->tx_usr = tmp[2];
> +
> +                       ret = of_property_read_u32_array(child, "ti,mbox-rx",
> +                                                        tmp, ARRAY_SIZE(tmp));
> +                       if (ret)
> +                               return ret;
> +                       finfo->rx_id = tmp[0];
> +                       finfo->rx_irq = tmp[1];
> +                       finfo->rx_usr = tmp[2];
> +
> +                       finfo->name = child->name;
> +               }
> +               if (finfo->tx_id >= num_fifos || finfo->rx_id >= num_fifos ||
> +                   finfo->tx_usr >= num_users || finfo->rx_usr >= num_users)
> +                       return -EINVAL;
> +       }
> +
