Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbaBXPvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:51:38 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36210 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752711AbaBXPvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:51:35 -0500
Date: Mon, 24 Feb 2014 15:51:32 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Tony Lindgren <tony@atomide.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCHv1 5/6] HSI: Introduce OMAP SSI driver
Message-ID: <20140224155132.GK28555@e106331-lin.cambridge.arm.com>
References: <1393199401-27197-1-git-send-email-sre@debian.org>
 <1393199401-27197-6-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393199401-27197-6-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 23, 2014 at 11:50:00PM +0000, Sebastian Reichel wrote:
> Add OMAP SSI driver to the HSI subsystem.
> 
> The Synchronous Serial Interface (SSI) is a legacy version
> of HSI. As in the case of HSI, it is mainly used to connect
> Application engines (APE) with cellular modem engines (CMT)
> in cellular handsets.
> 
> It provides a multichannel, full-duplex, multi-core communication
> with no reference clock. The OMAP SSI block is capable of reaching
> speeds of 110 Mbit/s.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
>  drivers/hsi/Kconfig                     |    1 +
>  drivers/hsi/Makefile                    |    1 +
>  drivers/hsi/controllers/Kconfig         |   19 +
>  drivers/hsi/controllers/Makefile        |    6 +
>  drivers/hsi/controllers/omap_ssi.c      |  618 ++++++++++++++
>  drivers/hsi/controllers/omap_ssi.h      |  166 ++++
>  drivers/hsi/controllers/omap_ssi_port.c | 1401 +++++++++++++++++++++++++++++++
>  drivers/hsi/controllers/omap_ssi_regs.h |  171 ++++
>  8 files changed, 2383 insertions(+)
>  create mode 100644 drivers/hsi/controllers/Kconfig
>  create mode 100644 drivers/hsi/controllers/Makefile
>  create mode 100644 drivers/hsi/controllers/omap_ssi.c
>  create mode 100644 drivers/hsi/controllers/omap_ssi.h
>  create mode 100644 drivers/hsi/controllers/omap_ssi_port.c
>  create mode 100644 drivers/hsi/controllers/omap_ssi_regs.h

[...]

> +       irq = platform_get_resource_byname(pd, IORESOURCE_IRQ, "gdd_mpu");
> +       if (!irq) {
> +               dev_err(&pd->dev, "GDD IRQ resource missing\n");
> +               err = -ENXIO;
> +               goto out_err;
> +       }
> +       omap_ssi->gdd_irq = irq->start;

You can use platform_get_irq_byname here.

[...]

> +static inline int ssi_of_get_available_child_count(const struct device_node *np)
> +{
> +       struct device_node *child;
> +       int num = 0;
> +
> +       for_each_child_of_node(np, child)
> +               if (of_device_is_available(child))
> +                       num++;
> +
> +       return num;
> +}

You can find of_get_available_child_count in <linux/of.h>.

That said, this seems to be trying to count the numbero f ports, which
should all be compatible with "ti,omap3-ssi-port", no?

So maybe you should count all available child nodes compatible with
that.

> +
> +static int __init ssi_probe(struct platform_device *pd)
> +{
> +       struct device_node *np = pd->dev.of_node;
> +       struct hsi_controller *ssi;
> +       int err;
> +       int num_ports;
> +
> +       if (!np) {
> +               dev_err(&pd->dev, "missing device tree data\n");
> +               return -EINVAL;
> +       }
> +
> +       num_ports = ssi_of_get_available_child_count(np);
> +
> +       ssi = hsi_alloc_controller(num_ports, GFP_KERNEL);
> +       if (!ssi) {
> +               dev_err(&pd->dev, "No memory for controller\n");
> +               return -ENOMEM;
> +       }
> +
> +       platform_set_drvdata(pd, ssi);
> +
> +       err = ssi_add_controller(ssi, pd);
> +       if (err < 0)
> +               goto out1;
> +
> +       pm_runtime_irq_safe(&pd->dev);
> +       pm_runtime_enable(&pd->dev);
> +
> +       err = ssi_hw_init(ssi);
> +       if (err < 0)
> +               goto out2;
> +#ifdef CONFIG_DEBUG_FS
> +       err = ssi_debug_add_ctrl(ssi);
> +       if (err < 0)
> +               goto out2;
> +#endif
> +
> +       err = of_platform_populate(pd->dev.of_node, NULL, NULL, &pd->dev);

I'm not keen on doing this because it allows arbitrary devices which are
not ssi ports to be placed in the ssi host controller node that will be
probed, which is nonsensical and something I'd like to avoid by
construction.

Is there any reason the ports have to be platform devices at all?

If so, is there no way we can register them directly and skip any other
devices?

[...]

> +static int __exit ssi_remove(struct platform_device *pd)
> +{
> +       struct hsi_controller *ssi = platform_get_drvdata(pd);
> +
> +#ifdef CONFIG_DEBUG_FS
> +       ssi_debug_remove_ctrl(ssi);
> +#endif
> +       ssi_remove_controller(ssi);
> +       platform_set_drvdata(pd, NULL);
> +
> +       pm_runtime_disable(&pd->dev);
> +
> +       /* cleanup of of_platform_populate() call */
> +       device_for_each_child(&pd->dev, NULL, ssi_remove_ports);

This would certainly be broken for a non ssi port device.

[...]

> +static int omap_ssi_port_runtime_suspend(struct device *dev)
> +{
> +       struct hsi_port *port = dev_get_drvdata(dev);
> +       struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
> +       struct hsi_controller *ssi = to_hsi_controller(port->device.parent);
> +       struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
> +
> +       dev_dbg(dev, "port runtime suspend!\n");
> +
> +       ssi_set_port_mode(omap_port, SSI_MODE_SLEEP);
> +       if (omap_ssi->get_loss)
> +               omap_port->loss_count =
> +                               (*omap_ssi->get_loss)(ssi->device.parent);

You don't need to do (*struct->func)(args) when invoking a function
pointer. You can jsut have struct->func(args) as we do elsewhere. This
can be:

  omap_ssi->get_loss(ssi->device.parent)

This should be fixed up in the other sites too.

Cheers,
Mark.
