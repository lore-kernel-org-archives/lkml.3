Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab3IVVRf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 17:17:35 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:54633 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab3IVVRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 17:17:32 -0400
MIME-Version: 1.0
In-Reply-To: <1379510692-32435-3-git-send-email-treding@nvidia.com>
References: <1379510692-32435-1-git-send-email-treding@nvidia.com>
	<1379510692-32435-3-git-send-email-treding@nvidia.com>
Date: Sun, 22 Sep 2013 16:17:31 -0500
Message-ID: <CAL_JsqLdBxihDpoVzwrPYQ0VKgi08w4o96EDEmX1Ydb3OCU8DA@mail.gmail.com>
Subject: Re: [PATCH v2 02/10] of/irq: Use irq_of_parse_and_map()
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
> Replace some instances of of_irq_map_one()/irq_create_of_mapping() and
> of_irq_to_resource() by the simpler equivalent irq_of_parse_and_map().
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Acked-by: Rob Herring <rob.herring@calxeda.com>

> ---
>  arch/arm/mach-u300/timer.c                       |  9 ++++-----
>  arch/powerpc/platforms/cell/celleb_scc_pciex.c   |  8 +++-----
>  arch/powerpc/platforms/cell/spider-pic.c         |  7 ++-----
>  arch/powerpc/sysdev/fsl_gtm.c                    |  9 ++++-----
>  arch/powerpc/sysdev/mpic_msgr.c                  |  6 ++----
>  drivers/crypto/caam/ctrl.c                       |  2 +-
>  drivers/crypto/caam/jr.c                         |  2 +-
>  drivers/crypto/omap-sham.c                       |  2 +-
>  drivers/i2c/busses/i2c-cpm.c                     |  2 +-
>  drivers/input/serio/xilinx_ps2.c                 |  7 ++++---
>  drivers/net/ethernet/arc/emac_main.c             | 10 +++++-----
>  drivers/net/ethernet/freescale/fs_enet/mac-fcc.c |  2 +-
>  drivers/net/ethernet/freescale/fs_enet/mac-fec.c |  2 +-
>  drivers/net/ethernet/freescale/fs_enet/mac-scc.c |  2 +-
>  drivers/spi/spi-fsl-espi.c                       |  6 +++---
>  drivers/tty/serial/cpm_uart/cpm_uart_core.c      |  2 +-
>  16 files changed, 35 insertions(+), 43 deletions(-)
>
> diff --git a/arch/arm/mach-u300/timer.c b/arch/arm/mach-u300/timer.c
> index b5db207..9a5f9fb 100644
> --- a/arch/arm/mach-u300/timer.c
> +++ b/arch/arm/mach-u300/timer.c
> @@ -358,8 +358,7 @@ static struct delay_timer u300_delay_timer;
>   */
>  static void __init u300_timer_init_of(struct device_node *np)
>  {
> -       struct resource irq_res;
> -       int irq;
> +       unsigned int irq;
>         struct clk *clk;
>         unsigned long rate;
>
> @@ -368,11 +367,11 @@ static void __init u300_timer_init_of(struct device_node *np)
>                 panic("could not ioremap system timer\n");
>
>         /* Get the IRQ for the GP1 timer */
> -       irq = of_irq_to_resource(np, 2, &irq_res);
> -       if (irq <= 0)
> +       irq = irq_of_parse_and_map(np, 2);
> +       if (!irq)
>                 panic("no IRQ for system timer\n");
>
> -       pr_info("U300 GP1 timer @ base: %p, IRQ: %d\n", u300_timer_base, irq);
> +       pr_info("U300 GP1 timer @ base: %p, IRQ: %u\n", u300_timer_base, irq);
>
>         /* Clock the interrupt controller */
>         clk = of_clk_get(np, 0);
> diff --git a/arch/powerpc/platforms/cell/celleb_scc_pciex.c b/arch/powerpc/platforms/cell/celleb_scc_pciex.c
> index 14be2bd..856ad64 100644
> --- a/arch/powerpc/platforms/cell/celleb_scc_pciex.c
> +++ b/arch/powerpc/platforms/cell/celleb_scc_pciex.c
> @@ -486,8 +486,7 @@ static __init int celleb_setup_pciex(struct device_node *node,
>                                      struct pci_controller *phb)
>  {
>         struct resource r;
> -       struct of_irq oirq;
> -       int virq;
> +       unsigned int virq;
>
>         /* SMMIO registers; used inside this file */
>         if (of_address_to_resource(node, 0, &r)) {
> @@ -507,12 +506,11 @@ static __init int celleb_setup_pciex(struct device_node *node,
>         phb->ops = &scc_pciex_pci_ops;
>
>         /* internal interrupt handler */
> -       if (of_irq_map_one(node, 1, &oirq)) {
> +       virq = irq_of_parse_and_map(node, 1);
> +       if (!virq) {
>                 pr_err("PCIEXC:Failed to map irq\n");
>                 goto error;
>         }
> -       virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
> -                                    oirq.size);
>         if (request_irq(virq, pciex_handle_internal_irq,
>                         0, "pciex", (void *)phb)) {
>                 pr_err("PCIEXC:Failed to request irq\n");
> diff --git a/arch/powerpc/platforms/cell/spider-pic.c b/arch/powerpc/platforms/cell/spider-pic.c
> index 8e29944..1f72f4a 100644
> --- a/arch/powerpc/platforms/cell/spider-pic.c
> +++ b/arch/powerpc/platforms/cell/spider-pic.c
> @@ -235,12 +235,9 @@ static unsigned int __init spider_find_cascade_and_node(struct spider_pic *pic)
>         /* First, we check whether we have a real "interrupts" in the device
>          * tree in case the device-tree is ever fixed
>          */
> -       struct of_irq oirq;
> -       if (of_irq_map_one(pic->host->of_node, 0, &oirq) == 0) {
> -               virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
> -                                            oirq.size);
> +       virq = irq_of_parse_and_map(pic->host->of_node, 0);
> +       if (virq)
>                 return virq;
> -       }
>
>         /* Now do the horrible hacks */
>         tmp = of_get_property(pic->host->of_node, "#interrupt-cells", NULL);
> diff --git a/arch/powerpc/sysdev/fsl_gtm.c b/arch/powerpc/sysdev/fsl_gtm.c
> index 0eb871c..dd0d5be 100644
> --- a/arch/powerpc/sysdev/fsl_gtm.c
> +++ b/arch/powerpc/sysdev/fsl_gtm.c
> @@ -401,16 +401,15 @@ static int __init fsl_gtm_init(void)
>                 gtm->clock = *clock;
>
>                 for (i = 0; i < ARRAY_SIZE(gtm->timers); i++) {
> -                       int ret;
> -                       struct resource irq;
> +                       unsigned int irq;
>
> -                       ret = of_irq_to_resource(np, i, &irq);
> -                       if (ret == NO_IRQ) {
> +                       irq = irq_of_parse_and_map(np, i);
> +                       if (irq == NO_IRQ) {
>                                 pr_err("%s: not enough interrupts specified\n",
>                                        np->full_name);
>                                 goto err;
>                         }
> -                       gtm->timers[i].irq = irq.start;
> +                       gtm->timers[i].irq = irq;
>                         gtm->timers[i].gtm = gtm;
>                 }
>
> diff --git a/arch/powerpc/sysdev/mpic_msgr.c b/arch/powerpc/sysdev/mpic_msgr.c
> index c753258..2c9b52a 100644
> --- a/arch/powerpc/sysdev/mpic_msgr.c
> +++ b/arch/powerpc/sysdev/mpic_msgr.c
> @@ -237,15 +237,13 @@ static int mpic_msgr_probe(struct platform_device *dev)
>                 raw_spin_lock_init(&msgr->lock);
>
>                 if (receive_mask & (1 << i)) {
> -                       struct resource irq;
> -
> -                       if (of_irq_to_resource(np, irq_index, &irq) == NO_IRQ) {
> +                       msgr->irq = irq_of_parse_and_map(np, irq_index);
> +                       if (msgr->irq == NO_IRQ) {
>                                 dev_err(&dev->dev,
>                                                 "Missing interrupt specifier");
>                                 kfree(msgr);
>                                 return -EFAULT;
>                         }
> -                       msgr->irq = irq.start;
>                         irq_index += 1;
>                 } else {
>                         msgr->irq = NO_IRQ;
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> index 26438cd..c8224da 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -419,7 +419,7 @@ static int caam_probe(struct platform_device *pdev)
>         topregs = (struct caam_full __iomem *)ctrl;
>
>         /* Get the IRQ of the controller (for security violations only) */
> -       ctrlpriv->secvio_irq = of_irq_to_resource(nprop, 0, NULL);
> +       ctrlpriv->secvio_irq = irq_of_parse_and_map(nprop, 0);
>
>         /*
>          * Enable DECO watchdogs and, if this is a PHYS_ADDR_T_64BIT kernel,
> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
> index 105ba4d..517a16d 100644
> --- a/drivers/crypto/caam/jr.c
> +++ b/drivers/crypto/caam/jr.c
> @@ -403,7 +403,7 @@ int caam_jr_probe(struct platform_device *pdev, struct device_node *np,
>                 dma_set_mask(jrdev, DMA_BIT_MASK(32));
>
>         /* Identify the interrupt */
> -       jrpriv->irq = of_irq_to_resource(np, 0, NULL);
> +       jrpriv->irq = irq_of_parse_and_map(np, 0);
>
>         /* Now do the platform independent part */
>         error = caam_jr_init(jrdev); /* now turn on hardware */
> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
> index 8bdde57..e28104b 100644
> --- a/drivers/crypto/omap-sham.c
> +++ b/drivers/crypto/omap-sham.c
> @@ -1818,7 +1818,7 @@ static int omap_sham_get_res_of(struct omap_sham_dev *dd,
>                 goto err;
>         }
>
> -       dd->irq = of_irq_to_resource(node, 0, NULL);
> +       dd->irq = irq_of_parse_and_map(node, 0);
>         if (!dd->irq) {
>                 dev_err(dev, "can't translate OF irq value\n");
>                 err = -EINVAL;
> diff --git a/drivers/i2c/busses/i2c-cpm.c b/drivers/i2c/busses/i2c-cpm.c
> index b2b8aa9..3e5ea2c 100644
> --- a/drivers/i2c/busses/i2c-cpm.c
> +++ b/drivers/i2c/busses/i2c-cpm.c
> @@ -447,7 +447,7 @@ static int cpm_i2c_setup(struct cpm_i2c *cpm)
>
>         init_waitqueue_head(&cpm->i2c_wait);
>
> -       cpm->irq = of_irq_to_resource(ofdev->dev.of_node, 0, NULL);
> +       cpm->irq = irq_of_parse_and_map(ofdev->dev.of_node, 0);
>         if (!cpm->irq)
>                 return -EINVAL;
>
> diff --git a/drivers/input/serio/xilinx_ps2.c b/drivers/input/serio/xilinx_ps2.c
> index 4b7662a..36f7b95 100644
> --- a/drivers/input/serio/xilinx_ps2.c
> +++ b/drivers/input/serio/xilinx_ps2.c
> @@ -235,12 +235,12 @@ static void sxps2_close(struct serio *pserio)
>   */
>  static int xps2_of_probe(struct platform_device *ofdev)
>  {
> -       struct resource r_irq; /* Interrupt resources */
>         struct resource r_mem; /* IO mem resources */
>         struct xps2data *drvdata;
>         struct serio *serio;
>         struct device *dev = &ofdev->dev;
>         resource_size_t remap_size, phys_addr;
> +       unsigned int irq;
>         int error;
>
>         dev_info(dev, "Device Tree Probing \'%s\'\n",
> @@ -254,7 +254,8 @@ static int xps2_of_probe(struct platform_device *ofdev)
>         }
>
>         /* Get IRQ for the device */
> -       if (!of_irq_to_resource(ofdev->dev.of_node, 0, &r_irq)) {
> +       irq = irq_of_parse_and_map(ofdev->dev.of_node, 0);
> +       if (!irq) {
>                 dev_err(dev, "no IRQ found\n");
>                 return -ENODEV;
>         }
> @@ -267,7 +268,7 @@ static int xps2_of_probe(struct platform_device *ofdev)
>         }
>
>         spin_lock_init(&drvdata->lock);
> -       drvdata->irq = r_irq.start;
> +       drvdata->irq = irq;
>         drvdata->serio = serio;
>         drvdata->dev = dev;
>
> diff --git a/drivers/net/ethernet/arc/emac_main.c b/drivers/net/ethernet/arc/emac_main.c
> index 9e16014..d087852 100644
> --- a/drivers/net/ethernet/arc/emac_main.c
> +++ b/drivers/net/ethernet/arc/emac_main.c
> @@ -628,12 +628,12 @@ static const struct net_device_ops arc_emac_netdev_ops = {
>
>  static int arc_emac_probe(struct platform_device *pdev)
>  {
> -       struct resource res_regs, res_irq;
> +       struct resource res_regs;
>         struct device_node *phy_node;
>         struct arc_emac_priv *priv;
>         struct net_device *ndev;
>         const char *mac_addr;
> -       unsigned int id, clock_frequency;
> +       unsigned int id, clock_frequency, irq;
>         int err;
>
>         if (!pdev->dev.of_node)
> @@ -661,8 +661,8 @@ static int arc_emac_probe(struct platform_device *pdev)
>         }
>
>         /* Get IRQ from device tree */
> -       err = of_irq_to_resource(pdev->dev.of_node, 0, &res_irq);
> -       if (!err) {
> +       irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
> +       if (!irq) {
>                 dev_err(&pdev->dev, "failed to retrieve <irq> value from device tree\n");
>                 return -ENODEV;
>         }
> @@ -711,7 +711,7 @@ static int arc_emac_probe(struct platform_device *pdev)
>                 goto out;
>         }
>
> -       ndev->irq = res_irq.start;
> +       ndev->irq = irq;
>         dev_info(&pdev->dev, "IRQ is %d\n", ndev->irq);
>
>         /* Register interrupt handler for device */
> diff --git a/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c b/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c
> index 7583a95..10f781d 100644
> --- a/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c
> +++ b/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c
> @@ -88,7 +88,7 @@ static int do_pd_setup(struct fs_enet_private *fep)
>         struct fs_platform_info *fpi = fep->fpi;
>         int ret = -EINVAL;
>
> -       fep->interrupt = of_irq_to_resource(ofdev->dev.of_node, 0, NULL);
> +       fep->interrupt = irq_of_parse_and_map(ofdev->dev.of_node, 0);
>         if (fep->interrupt == NO_IRQ)
>                 goto out;
>
> diff --git a/drivers/net/ethernet/freescale/fs_enet/mac-fec.c b/drivers/net/ethernet/freescale/fs_enet/mac-fec.c
> index 9ae6cdb..53a0c23 100644
> --- a/drivers/net/ethernet/freescale/fs_enet/mac-fec.c
> +++ b/drivers/net/ethernet/freescale/fs_enet/mac-fec.c
> @@ -98,7 +98,7 @@ static int do_pd_setup(struct fs_enet_private *fep)
>  {
>         struct platform_device *ofdev = to_platform_device(fep->dev);
>
> -       fep->interrupt = of_irq_to_resource(ofdev->dev.of_node, 0, NULL);
> +       fep->interrupt = irq_of_parse_and_map(ofdev->dev.of_node, 0);
>         if (fep->interrupt == NO_IRQ)
>                 return -EINVAL;
>
> diff --git a/drivers/net/ethernet/freescale/fs_enet/mac-scc.c b/drivers/net/ethernet/freescale/fs_enet/mac-scc.c
> index 22a02a7..631f098 100644
> --- a/drivers/net/ethernet/freescale/fs_enet/mac-scc.c
> +++ b/drivers/net/ethernet/freescale/fs_enet/mac-scc.c
> @@ -98,7 +98,7 @@ static int do_pd_setup(struct fs_enet_private *fep)
>  {
>         struct platform_device *ofdev = to_platform_device(fep->dev);
>
> -       fep->interrupt = of_irq_to_resource(ofdev->dev.of_node, 0, NULL);
> +       fep->interrupt = irq_of_parse_and_map(ofdev->dev.of_node, 0);
>         if (fep->interrupt == NO_IRQ)
>                 return -EINVAL;
>
> diff --git a/drivers/spi/spi-fsl-espi.c b/drivers/spi/spi-fsl-espi.c
> index b8f1103..3197d55 100644
> --- a/drivers/spi/spi-fsl-espi.c
> +++ b/drivers/spi/spi-fsl-espi.c
> @@ -687,7 +687,7 @@ static int of_fsl_espi_probe(struct platform_device *ofdev)
>         struct device_node *np = ofdev->dev.of_node;
>         struct spi_master *master;
>         struct resource mem;
> -       struct resource irq;
> +       unsigned int irq;
>         int ret = -ENOMEM;
>
>         ret = of_mpc8xxx_spi_probe(ofdev);
> @@ -702,13 +702,13 @@ static int of_fsl_espi_probe(struct platform_device *ofdev)
>         if (ret)
>                 goto err;
>
> -       ret = of_irq_to_resource(np, 0, &irq);
> +       irq = irq_of_parse_and_map(np, 0);
>         if (!ret) {
>                 ret = -EINVAL;
>                 goto err;
>         }
>
> -       master = fsl_espi_probe(dev, &mem, irq.start);
> +       master = fsl_espi_probe(dev, &mem, irq);
>         if (IS_ERR(master)) {
>                 ret = PTR_ERR(master);
>                 goto err;
> diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_core.c b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
> index 1a535f7..6957f445 100644
> --- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
> +++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
> @@ -1207,7 +1207,7 @@ static int cpm_uart_init_port(struct device_node *np,
>         pinfo->port.fifosize = pinfo->tx_nrfifos * pinfo->tx_fifosize;
>         spin_lock_init(&pinfo->port.lock);
>
> -       pinfo->port.irq = of_irq_to_resource(np, 0, NULL);
> +       pinfo->port.irq = irq_of_parse_and_map(np, 0);
>         if (pinfo->port.irq == NO_IRQ) {
>                 ret = -EINVAL;
>                 goto out_pram;
> --
> 1.8.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
