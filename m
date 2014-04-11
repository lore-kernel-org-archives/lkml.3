Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750965AbaDKR27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 13:28:59 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:42196 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaDKR2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 13:28:54 -0400
MIME-Version: 1.0
In-Reply-To: <1395413185-29763-3-git-send-email-jjhiblot@traphandler.com>
References: <20140320161118.B7075C4067A@trevor.secretlab.ca>
	<1395413185-29763-1-git-send-email-jjhiblot@traphandler.com>
	<1395413185-29763-3-git-send-email-jjhiblot@traphandler.com>
Date: Fri, 11 Apr 2014 12:28:52 -0500
Message-ID: <CAL_Jsq+aU+rs28gV=Gesb_-Dy6Ht7zuKrRA6_hmqp94Uun23Yg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] dt: platform driver: Fill the resources before
 probe and defer if needed
From: Rob Herring <robherring2@gmail.com>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 9:46 AM, Jean-Jacques Hiblot
<jjhiblot@traphandler.com> wrote:
> The goal of this patch is to allow drivers to be probed even if at the time of
> the DT parsing some of their IRQ ressources are not available yet.
>
> In the current situation, the IRQ resources of a platform device are filled from
> the DT at the time the device is created (of_device_alloc()). The drawback of
> this is that a device sitting close to the top of the DT (ahb for example) but
> depending on ressources that are initialized later (IRQ domain dynamically
> created for example) will fail to probe because the ressources don't exist
> at this time.

s/ressources/resources/

>
> This patch fills the resource structure only before the device is probed and
> will defer the probe if the IRQ resource is not yet available.
>
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> ---
>  drivers/base/platform.c     |   5 ++
>  drivers/of/platform.c       | 114 ++++++++++++++++++++++++++++++++++----------
>  include/linux/device.h      |   1 +
>  include/linux/of_platform.h |  10 ++++
>  4 files changed, 105 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index bc78848..cee9b8d 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -481,6 +481,10 @@ static int platform_drv_probe(struct device *_dev)
>         struct platform_device *dev = to_platform_device(_dev);
>         int ret;
>
> +       ret = of_platform_device_prepare(dev);
> +       if (ret)
> +               goto error;
> +
>         if (ACPI_HANDLE(_dev))
>                 acpi_dev_pm_attach(_dev, true);
>
> @@ -488,6 +492,7 @@ static int platform_drv_probe(struct device *_dev)
>         if (ret && ACPI_HANDLE(_dev))
>                 acpi_dev_pm_detach(_dev, true);
>
> +error:
>         if (drv->prevent_deferred_probe && ret == -EPROBE_DEFER) {
>                 dev_warn(_dev, "probe deferral not supported\n");
>                 ret = -ENXIO;
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 404d1da..ba6be4a 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -141,41 +141,17 @@ struct platform_device *of_device_alloc(struct device_node *np,
>                                   struct device *parent)
>  {
>         struct platform_device *dev;
> -       int rc, i, num_reg = 0, num_irq;
> -       struct resource *res, temp_res;
>
>         dev = platform_device_alloc("", -1);
>         if (!dev)
>                 return NULL;
>
> -       /* count the io and irq resources */
> -       if (of_can_translate_address(np))
> -               while (of_address_to_resource(np, num_reg, &temp_res) == 0)
> -                       num_reg++;
> -       num_irq = of_irq_count(np);
> -
> -       /* Populate the resource table */
> -       if (num_irq || num_reg) {
> -               res = kzalloc(sizeof(*res) * (num_irq + num_reg), GFP_KERNEL);
> -               if (!res) {
> -                       platform_device_put(dev);
> -                       return NULL;
> -               }
> -
> -               dev->num_resources = num_reg + num_irq;
> -               dev->resource = res;
> -               for (i = 0; i < num_reg; i++, res++) {
> -                       rc = of_address_to_resource(np, i, res);
> -                       WARN_ON(rc);
> -               }
> -               WARN_ON(of_irq_to_resource_table(np, res, num_irq) != num_irq);
> -       }
> -
>         dev->dev.of_node = of_node_get(np);
>  #if defined(CONFIG_MICROBLAZE)
>         dev->dev.dma_mask = &dev->archdata.dma_mask;
>  #endif
>         dev->dev.parent = parent;
> +       dev->dev.of_device = 1;
>
>         if (bus_id)
>                 dev_set_name(&dev->dev, "%s", bus_id);
> @@ -233,6 +209,94 @@ static struct platform_device *of_platform_device_create_pdata(
>         return dev;
>  }
>
> +static int of_reg_count(struct device_node *np)

This belongs in of/address.c. It can be more efficiently written as:

int of_reg_count(struct device_node *dev)
{
const __be32 *prop;
unsigned int psize;
struct device_node *parent;
struct of_bus *bus;
int na, ns;

/* Get parent & match bus type */
parent = of_get_parent(dev);
if (!parent)
  return 0;
bus = of_match_bus(parent);
bus->count_cells(dev, &na, &ns);
of_node_put(parent);
if (!OF_CHECK_COUNTS(na, ns))
  return 0;

/* Get "reg" or "assigned-addresses" property */
prop = of_get_property(dev, bus->addresses, &psize);
if (!prop)
  return 0;
psize /= 4;

return psize / (na + ns);
}


> +{
> +       int nreg = 0;
> +       if (of_can_translate_address(np)) {
> +               struct resource temp_res;
> +               while (of_address_to_resource(np, nreg, &temp_res) == 0)
> +                       nreg++;
> +       }
> +       return nreg;
> +}
> +
> +int of_platform_device_prepare(struct platform_device *dev)
> +{
> +       struct device_node *np;
> +       int i, irq_index;
> +       struct resource *res;
> +
> +       /*
> +        * This function applies only devices described in the DT and
> +        * created by of_device_alloc().
> +        * Other platform devices have their ressources already populated.
> +        */
> +       np = dev->dev.of_node;
> +       if (!np || !dev->dev.of_device)
> +               return 0;
> +
> +       /* Populate the resource table */
> +       if (!dev->resource) {
> +               int rc, nreg = 0, nirq;
> +               /* count the io and irq resources */
> +               nreg = of_reg_count(np);
> +               nirq = of_irq_count(np);

I think of_irq_count should be changed to return errors from
of_irq_parse_one. It's complicated by the fact you want to distinguish
checking the index is too big versus all other errors.

> +
> +               if (!nirq && !nreg)
> +                       return 0;
> +
> +               res = kzalloc(sizeof(*res) * (nirq + nreg), GFP_KERNEL);
> +               if (!res)
> +                       return -ENOMEM;
> +
> +               dev->resource = res;
> +               dev->num_resources = nreg + nirq;
> +
> +               for (i = 0; i < nreg; i++, res++) {
> +                       rc = of_address_to_resource(np, i, res);
> +                       if (WARN_ON(rc)) {
> +                               /* THIS IS BAD; don't try to defer probing */
> +                               dev->num_resources = 0;
> +                               dev->resource = NULL;
> +                               kfree(res);

You are incrementing res, so this kfree is wrong. Using "res + i"
instead would work, but...

> +                               return rc;
> +                       }
> +               }
> +
> +               if (!rc && of_irq_to_resource_table(np, res, nirq) != nirq)

...then res needs to change here.

Doesn't this give a rc may not be initialized warning? You don't need
to check rc. You need to check !nirq instead.

> +                       /*
> +                        * Not all irqs can be translated. redo the irq
> +                        * resources to check if the probe can be deferred
> +                        */
> +                       goto redo_irq_resources;
> +
> +               return 0;

But then, you don't really need any of this. You can just fall-thru
and the code below will work.

> +       }
> +
> +redo_irq_resources:
> +       /* See which IRQ resources need to be redone */
> +       irq_index = 0;
> +       for (i = 0, res = dev->resource; i < dev->num_resources; i++, res++) {
> +               if (!res->flags) {
> +                       int rc;
> +                       /*
> +                        * If the IRQ can't be translated to a resource, check
> +                        * if its IRQ domain exists.
> +                        */
> +                       rc = of_irq_to_resource(np, irq_index, res);
> +                       if (!rc) {
> +                               if (of_find_irq_domain(np, irq_index) == NULL)
> +                                       return -EPROBE_DEFER;
> +                               return rc;
> +                       }

I would move this check into of_irq_to_resource_table and also make it
skip entries with IORESOURCE_IRQ set. Then this can become:

for (i = 0, res = dev->resource; i < dev->num_resources; i++, res++) {
  if (resource_type(res) != IORESOURCE_MEM)
    break;
}
rc = of_irq_to_resource_table(np, res, dev->num_resources - i);
return (rc < 0) ? rc : 0;


Rob
