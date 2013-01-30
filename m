Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3A3Gkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 01:40:40 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:32866 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab3A3Gki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 01:40:38 -0500
Date: Wed, 30 Jan 2013 01:41:04 -0500
From: Matt Porter <mporter@ti.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v5 03/14] ARM: edma: add AM33XX support to the private
 EDMA API
Message-ID: <20130130064104.GN5256@beef>
References: <1358281974-8411-1-git-send-email-mporter@ti.com>
 <1358281974-8411-4-git-send-email-mporter@ti.com>
 <CAHp75VeFZ19CCL-4huLNWbsXT-8sGrcvtxN=Dm0s+ojNA3w-3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VeFZ19CCL-4huLNWbsXT-8sGrcvtxN=Dm0s+ojNA3w-3g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 09:27:24PM +0200, Andy Shevchenko wrote:
> On Tue, Jan 15, 2013 at 10:32 PM, Matt Porter <mporter@ti.com> wrote:
> > Adds support for parsing the TI EDMA DT data into the required
> > EDMA private API platform data. Enables runtime PM support to
> > initialize the EDMA hwmod. Adds AM33XX EMDA crossbar event mux
> > support.
> >
> > Signed-off-by: Matt Porter <mporter@ti.com>
> > ---
> >  arch/arm/common/edma.c             |  314 ++++++++++++++++++++++++++++++++++--
> >  include/linux/platform_data/edma.h |    1 +
> >  2 files changed, 306 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
> > index 2dce245..beeb1d2 100644
> > --- a/arch/arm/common/edma.c
> > +++ b/arch/arm/common/edma.c
> > @@ -24,6 +24,13 @@
> >  #include <linux/platform_device.h>
> >  #include <linux/io.h>
> >  #include <linux/slab.h>
> > +#include <linux/edma.h>
> > +#include <linux/err.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_device.h>
> > +#include <linux/of_dma.h>
> > +#include <linux/of_irq.h>
> > +#include <linux/pm_runtime.h>
> >
> >  #include <linux/platform_data/edma.h>
> >
> > @@ -723,6 +730,9 @@ EXPORT_SYMBOL(edma_free_channel);
> >   */
> >  int edma_alloc_slot(unsigned ctlr, int slot)
> >  {
> > +       if (!edma_cc[ctlr])
> > +               return -EINVAL;
> > +
> >         if (slot >= 0)
> >                 slot = EDMA_CHAN_SLOT(slot);
> >
> > @@ -1366,31 +1376,291 @@ void edma_clear_event(unsigned channel)
> >  EXPORT_SYMBOL(edma_clear_event);
> >
> >  /*-----------------------------------------------------------------------*/
> > +static int edma_of_read_u32_to_s8_array(const struct device_node *np,
> > +                                        const char *propname, s8 *out_values,
> > +                                        size_t sz)
> 
> I'm sorry I didn't get why you couldn't use of_property_read_u8_array() ?
> The similar comment to u16 and so on.

There's some manipulation of the legacy Davinci platform data
structures going on here. The driving reason was to not change any of
the davinci platforms pdata which uses s8/s16 tables of mapping values
with signed values as terminators. These versions below add the
convert to the signed value and terminate the array as needed by the
existing driver. This will all go away when the driver is rewritten and
merged into drivers/dma/edma.c. At that point I want to throwaway all
these legacy data structures. First, there's some more drivers to
convert to dmaengine api.

-Matt
> 
> > +{
> > +       struct property *prop = of_find_property(np, propname, NULL);
> > +       const __be32 *val;
> > +
> > +       if (!prop)
> > +               return -EINVAL;
> > +       if (!prop->value)
> > +               return -ENODATA;
> > +       if ((sz * sizeof(u32)) > prop->length)
> > +               return -EOVERFLOW;
> > +
> > +       val = prop->value;
> > +
> > +       while (sz--)
> > +               *out_values++ = (s8)(be32_to_cpup(val++) & 0xff);
> > +
> > +       /* Terminate it */
> > +       *out_values++ = -1;
> > +       *out_values++ = -1;
> > +
> > +       return 0;
> > +}
> > +
> > +static int edma_of_read_u32_to_s16_array(const struct device_node *np,
> > +                                        const char *propname, s16 *out_values,
> > +                                        size_t sz)
> > +{
> > +       struct property *prop = of_find_property(np, propname, NULL);
> > +       const __be32 *val;
> > +
> > +       if (!prop)
> > +               return -EINVAL;
> > +       if (!prop->value)
> > +               return -ENODATA;
> > +       if ((sz * sizeof(u32)) > prop->length)
> > +               return -EOVERFLOW;
> > +
> > +       val = prop->value;
> > +
> > +       while (sz--)
> > +               *out_values++ = (s16)(be32_to_cpup(val++) & 0xffff);
> > +
> > +       /* Terminate it */
> > +       *out_values++ = -1;
> > +       *out_values++ = -1;
> > +
> > +       return 0;
> > +}
> > +
> > +static int edma_xbar_event_map(struct device *dev,
> > +                              struct device_node *node,
> > +                              struct edma_soc_info *pdata, int len)
> > +{
> > +       int ret = 0;
> > +       int i;
> > +       struct resource res;
> > +       void *xbar;
> > +       const s16 (*xbar_chans)[2];
> > +       u32 shift, offset, mux;
> > +
> > +       xbar_chans = devm_kzalloc(dev,
> > +                                 len/sizeof(s16) + 2*sizeof(s16),
> > +                                 GFP_KERNEL);
> > +       if (!xbar_chans)
> > +               return -ENOMEM;
> > +
> > +       ret = of_address_to_resource(node, 1, &res);
> > +       if (IS_ERR_VALUE(ret))
> > +               return -EIO;
> > +
> > +       xbar = devm_ioremap(dev, res.start, resource_size(&res));
> > +       if (!xbar)
> > +               return -ENOMEM;
> > +
> > +       ret = edma_of_read_u32_to_s16_array(node,
> > +                                           "ti,edma-xbar-event-map",
> > +                                           (s16 *)xbar_chans,
> > +                                           len/sizeof(u32));
> > +       if (IS_ERR_VALUE(ret))
> > +               return -EIO;
> > +
> > +       for (i = 0; xbar_chans[i][0] != -1; i++) {
> > +               shift = (xbar_chans[i][1] % 4) * 8;
> > +               offset = xbar_chans[i][1] >> 2;
> > +               offset <<= 2;
> > +               mux = readl((void *)((u32)xbar + offset));
> > +               mux &= ~(0xff << shift);
> > +               mux |= xbar_chans[i][0] << shift;
> > +               writel(mux, (void *)((u32)xbar + offset));
> > +       }
> > +
> > +       pdata->xbar_chans = xbar_chans;
> > +
> > +       return 0;
> > +}
> > +
> > +static int edma_of_parse_dt(struct device *dev,
> > +                           struct device_node *node,
> > +                           struct edma_soc_info *pdata)
> > +{
> > +       int ret = 0;
> > +       u32 value;
> > +       struct property *prop;
> > +       size_t sz;
> > +       struct edma_rsv_info *rsv_info;
> > +       const s16 (*rsv_chans)[2], (*rsv_slots)[2];
> > +       const s8 (*queue_tc_map)[2], (*queue_priority_map)[2];
> > +
> > +       memset(pdata, 0, sizeof(struct edma_soc_info));
> > +
> > +       ret = of_property_read_u32(node, "dma-channels", &value);
> > +       if (ret < 0)
> > +               return ret;
> > +       pdata->n_channel = value;
> > +
> > +       ret = of_property_read_u32(node, "ti,edma-regions", &value);
> > +       if (ret < 0)
> > +               return ret;
> > +       pdata->n_region = value;
> > +
> > +       ret = of_property_read_u32(node, "ti,edma-slots", &value);
> > +       if (ret < 0)
> > +               return ret;
> > +       pdata->n_slot = value;
> > +
> > +       pdata->n_cc = 1;
> > +       pdata->n_tc = 3;
> > +
> > +       rsv_info =
> > +               devm_kzalloc(dev, sizeof(struct edma_rsv_info), GFP_KERNEL);
> > +       if (!rsv_info)
> > +               return -ENOMEM;
> > +       pdata->rsv = rsv_info;
> > +
> > +       /* Build the reserved channel/slots arrays */
> > +       prop = of_find_property(node, "ti,edma-reserved-channels", &sz);
> > +       if (prop) {
> > +               rsv_chans = devm_kzalloc(dev,
> > +                                        sz/sizeof(s16) + 2*sizeof(s16),
> > +                                        GFP_KERNEL);
> > +               if (!rsv_chans)
> > +                       return -ENOMEM;
> > +               pdata->rsv->rsv_chans = rsv_chans;
> > +
> > +               ret = edma_of_read_u32_to_s16_array(node,
> > +                                                   "ti,edma-reserved-channels",
> > +                                                   (s16 *)rsv_chans,
> > +                                                   sz/sizeof(u32));
> > +               if (ret < 0)
> > +                       return ret;
> > +       }
> > +
> > +       prop = of_find_property(node, "ti,edma-reserved-slots", &sz);
> > +       if (prop) {
> > +               rsv_slots = devm_kzalloc(dev,
> > +                                        sz/sizeof(s16) + 2*sizeof(s16),
> > +                                        GFP_KERNEL);
> > +               if (!rsv_slots)
> > +                       return -ENOMEM;
> > +               pdata->rsv->rsv_slots = rsv_slots;
> > +
> > +               ret = edma_of_read_u32_to_s16_array(node,
> > +                                                   "ti,edma-reserved-slots",
> > +                                                   (s16 *)rsv_slots,
> > +                                                   sz/sizeof(u32));
> > +               if (ret < 0)
> > +                       return ret;
> > +       }
> > +
> > +       prop = of_find_property(node, "ti,edma-queue-tc-map", &sz);
> > +       if (!prop)
> > +               return -EINVAL;
> > +
> > +       queue_tc_map = devm_kzalloc(dev,
> > +                                   sz/sizeof(s8) + 2*sizeof(s8),
> > +                                   GFP_KERNEL);
> > +       if (!queue_tc_map)
> > +               return -ENOMEM;
> > +       pdata->queue_tc_mapping = queue_tc_map;
> > +
> > +       ret = edma_of_read_u32_to_s8_array(node,
> > +                                          "ti,edma-queue-tc-map",
> > +                                          (s8 *)queue_tc_map,
> > +                                          sz/sizeof(u32));
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       prop = of_find_property(node, "ti,edma-queue-priority-map", &sz);
> > +       if (!prop)
> > +               return -EINVAL;
> > +
> > +       queue_priority_map = devm_kzalloc(dev,
> > +                                         sz/sizeof(s8) + 2*sizeof(s8),
> > +                                         GFP_KERNEL);
> > +       if (!queue_priority_map)
> > +               return -ENOMEM;
> > +       pdata->queue_priority_mapping = queue_priority_map;
> > +
> > +       ret = edma_of_read_u32_to_s8_array(node,
> > +                                          "ti,edma-queue-tc-map",
> > +                                          (s8 *)queue_priority_map,
> > +                                          sz/sizeof(u32));
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       ret = of_property_read_u32(node, "ti,edma-default-queue", &value);
> > +       if (ret < 0)
> > +               return ret;
> > +       pdata->default_queue = value;
> > +
> > +       prop = of_find_property(node, "ti,edma-xbar-event-map", &sz);
> > +       if (prop)
> > +               ret = edma_xbar_event_map(dev, node, pdata, sz);
> > +
> > +       return ret;
> > +}
> > +
> > +static struct of_dma_filter_info edma_filter_info = {
> > +       .filter_fn = edma_filter_fn,
> > +};
> >
> >  static int edma_probe(struct platform_device *pdev)
> >  {
> >         struct edma_soc_info    **info = pdev->dev.platform_data;
> > +       struct edma_soc_info    *ninfo[EDMA_MAX_CC] = {NULL, NULL};
> > +       struct edma_soc_info    tmpinfo;
> >         const s8                (*queue_priority_mapping)[2];
> >         const s8                (*queue_tc_mapping)[2];
> >         int                     i, j, off, ln, found = 0;
> >         int                     status = -1;
> >         const s16               (*rsv_chans)[2];
> >         const s16               (*rsv_slots)[2];
> > +       const s16               (*xbar_chans)[2];
> >         int                     irq[EDMA_MAX_CC] = {0, 0};
> >         int                     err_irq[EDMA_MAX_CC] = {0, 0};
> > -       struct resource         *r[EDMA_MAX_CC] = {NULL};
> > +       struct resource         *r[EDMA_MAX_CC] = {NULL, NULL};
> > +       struct resource         res[EDMA_MAX_CC];
> >         resource_size_t         len[EDMA_MAX_CC];
> >         char                    res_name[10];
> >         char                    irq_name[10];
> > +       struct device_node      *node = pdev->dev.of_node;
> > +       struct device           *dev = &pdev->dev;
> > +       int                     ret;
> > +
> > +       if (node) {
> > +               info = ninfo;
> > +               edma_of_parse_dt(dev, node, &tmpinfo);
> > +               info[0] = &tmpinfo;
> > +
> > +               dma_cap_set(DMA_SLAVE, edma_filter_info.dma_cap);
> > +               of_dma_controller_register(dev->of_node,
> > +                                          of_dma_simple_xlate,
> > +                                          &edma_filter_info);
> > +       }
> >
> >         if (!info)
> >                 return -ENODEV;
> >
> > +       pm_runtime_enable(dev);
> > +       ret = pm_runtime_get_sync(dev);
> > +       if (IS_ERR_VALUE(ret)) {
> > +               dev_err(dev, "pm_runtime_get_sync() failed\n");
> > +               return ret;
> > +       }
> > +
> >         for (j = 0; j < EDMA_MAX_CC; j++) {
> > -               sprintf(res_name, "edma_cc%d", j);
> > -               r[j] = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> > +               if (!info[j]) {
> > +                       if (!found)
> > +                               return -ENODEV;
> > +                       break;
> > +               }
> > +               if (node) {
> > +                       ret = of_address_to_resource(node, j, &res[j]);
> > +                       if (!IS_ERR_VALUE(ret))
> > +                               r[j] = &res[j];
> > +               } else {
> > +                       sprintf(res_name, "edma_cc%d", j);
> > +                       r[j] = platform_get_resource_byname(pdev,
> > +                                               IORESOURCE_MEM,
> >                                                 res_name);
> > -               if (!r[j] || !info[j]) {
> > +               }
> > +               if (!r[j]) {
> >                         if (found)
> >                                 break;
> >                         else
> > @@ -1465,8 +1735,22 @@ static int edma_probe(struct platform_device *pdev)
> >                         }
> >                 }
> >
> > -               sprintf(irq_name, "edma%d", j);
> > -               irq[j] = platform_get_irq_byname(pdev, irq_name);
> > +               /* Clear the xbar mapped channels in unused list */
> > +               xbar_chans = info[j]->xbar_chans;
> > +               if (xbar_chans) {
> > +                       for (i = 0; xbar_chans[i][1] != -1; i++) {
> > +                               off = xbar_chans[i][1];
> > +                               clear_bits(off, 1,
> > +                                       edma_cc[j]->edma_unused);
> > +                       }
> > +               }
> > +
> > +               if (node)
> > +                       irq[j] = irq_of_parse_and_map(node, 0);
> > +               else {
> > +                       sprintf(irq_name, "edma%d", j);
> > +                       irq[j] = platform_get_irq_byname(pdev, irq_name);
> > +               }
> >                 edma_cc[j]->irq_res_start = irq[j];
> >                 status = request_irq(irq[j], dma_irq_handler, 0, "edma",
> >                                         &pdev->dev);
> > @@ -1476,8 +1760,12 @@ static int edma_probe(struct platform_device *pdev)
> >                         goto fail;
> >                 }
> >
> > -               sprintf(irq_name, "edma%d_err", j);
> > -               err_irq[j] = platform_get_irq_byname(pdev, irq_name);
> > +               if (node)
> > +                       err_irq[j] = irq_of_parse_and_map(node, 2);
> > +               else {
> > +                       sprintf(irq_name, "edma%d_err", j);
> > +                       err_irq[j] = platform_get_irq_byname(pdev, irq_name);
> > +               }
> >                 edma_cc[j]->irq_res_end = err_irq[j];
> >                 status = request_irq(err_irq[j], dma_ccerr_handler, 0,
> >                                         "edma_error", &pdev->dev);
> > @@ -1538,9 +1826,17 @@ fail1:
> >         return status;
> >  }
> >
> > +static const struct of_device_id edma_of_ids[] = {
> > +       { .compatible = "ti,edma3", },
> > +       {}
> > +};
> >
> >  static struct platform_driver edma_driver = {
> > -       .driver.name    = "edma",
> > +       .driver = {
> > +               .name   = "edma",
> > +               .of_match_table = edma_of_ids,
> > +       },
> > +       .probe = edma_probe,
> >  };
> >
> >  static int __init edma_init(void)
> > diff --git a/include/linux/platform_data/edma.h b/include/linux/platform_data/edma.h
> > index 2344ea2..ffc1fb2 100644
> > --- a/include/linux/platform_data/edma.h
> > +++ b/include/linux/platform_data/edma.h
> > @@ -177,6 +177,7 @@ struct edma_soc_info {
> >
> >         const s8        (*queue_tc_mapping)[2];
> >         const s8        (*queue_priority_mapping)[2];
> > +       const s16       (*xbar_chans)[2];
> >  };
> >
> >  #endif
> > --
> > 1.7.9.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
> -- 
> With Best Regards,
> Andy Shevchenko
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
