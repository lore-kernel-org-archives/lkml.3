Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab3ILMlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:41:06 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:64363 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab3ILMlD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:41:03 -0400
MIME-Version: 1.0
Date: Thu, 12 Sep 2013 14:41:00 +0200
X-Google-Sender-Auth: 2zld1NsyykTlvoee5pU-s8NOkL8
Message-ID: <CAMuHMdVVjkZBZyJe2qnUxHeRVo+8WD_Vx1ZKin_pA7XLRCW8uw@mail.gmail.com>
Subject: Uninitialized rx_req/tx_req (was: Re: [PATCH v2 2/3] mmc: omap_hsmmc:
 Skip platform_get_resource_byname() for dt case)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Matt Porter <matt.porter@linaro.org>
Cc: Balaji T K <balajitk@ti.com>, Chris Ball <cjb@laptop.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Jon Hunter <jon-hunter@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 10:13 PM, Matt Porter <mporter@ti.com> wrote:
> From: Santosh Shilimkar <santosh.shilimkar@ti.com>
>
> MMC driver probe will abort for DT case because of failed
> platform_get_resource_byname() lookup. Fix it by skipping resource
> byname lookup for device tree build.
>
> Issue is hidden because hwmod popullates the IO resources which
> helps to succeed platform_get_resource_byname() and probe.
>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
>  drivers/mmc/host/omap_hsmmc.c |   28 +++++++++++++++-------------
>  1 file changed, 15 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index e79b12d..8ae1225 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -1896,21 +1896,23 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
>
>         omap_hsmmc_conf_bus_power(host);
>
> -       res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "tx");
> -       if (!res) {
> -               dev_err(mmc_dev(host->mmc), "cannot get DMA TX channel\n");
> -               ret = -ENXIO;
> -               goto err_irq;
> -       }
> -       tx_req = res->start;
> +       if (!pdev->dev.of_node) {
> +               res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "tx");
> +               if (!res) {
> +                       dev_err(mmc_dev(host->mmc), "cannot get DMA TX channel\n");
> +                       ret = -ENXIO;
> +                       goto err_irq;
> +               }
> +               tx_req = res->start;
>
> -       res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "rx");
> -       if (!res) {
> -               dev_err(mmc_dev(host->mmc), "cannot get DMA RX channel\n");
> -               ret = -ENXIO;
> -               goto err_irq;
> +               res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "rx");
> +               if (!res) {
> +                       dev_err(mmc_dev(host->mmc), "cannot get DMA RX channel\n");
> +                       ret = -ENXIO;
> +                       goto err_irq;
> +               }
> +               rx_req = res->start;
>         }
> -       rx_req = res->start;
>
>         dma_cap_zero(mask);
>         dma_cap_set(DMA_SLAVE, mask);

Now this is in mainline, I get (gcc 4.1.2):

drivers/mmc/host/omap_hsmmc.c: In function ‘omap_hsmmc_probe’:
drivers/mmc/host/omap_hsmmc.c:1779: warning: ‘rx_req’ may be used
uninitialized in this function
drivers/mmc/host/omap_hsmmc.c:1779: warning: ‘tx_req’ may be used
uninitialized in this function

Indeed, rx_req and tx_req are not initialized in the DT case.

Initializing them to zero is probably not the right fix. Where are the values
supposed to come from in the DT case?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
