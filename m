Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934594AbaLKKJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 05:09:37 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43979 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964989AbaLKKI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 05:08:57 -0500
Message-ID: <1418292513.3188.4.camel@pengutronix.de>
Subject: Re: [PATCH 2/2] misc: sram: switch to ioremap_wc from ioremap
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Abhilash Kesavan <a.kesavan@samsung.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, catalin.marinas@arm.com,
        Will.Deacon@arm.com, heiko@sntech.de, Li.Xiubo@freescale.com,
        shc_work@mail.ru, nicoleotsuka@gmail.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, robh+dt@kernel.org,
        grant.likely@linaro.org, linux-kernel@vger.kernel.org, corbet@lwn.net,
        padma.v@samsung.com, alsa-devel@alsa-project.org,
        shawn.guo@freescale.com, bcousson@baylibre.com, tony@atomide.com,
        kernel@pengutronix.de, kgene@kernel.org, kesavan.abhilash@gmail.com,
        pawel.moll@arm.com
Date: Thu, 11 Dec 2014 11:08:33 +0100
In-Reply-To: <1418266726-12004-2-git-send-email-a.kesavan@samsung.com>
References: <1418266726-12004-1-git-send-email-a.kesavan@samsung.com>
	 <1418266726-12004-2-git-send-email-a.kesavan@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Abhilash,

Am Donnerstag, den 11.12.2014, 08:28 +0530 schrieb Abhilash Kesavan:
> Currently, the SRAM allocator returns device memory via ioremap.
> This causes issues on ARM64 when the internal SoC SRAM allocated by
> the generic sram driver is used for audio playback. The destination
> buffer address (which is ioremapped SRAM) is not 64-bit aligned for
> certain streams (e.g. 44.1k sampling rate). In such cases we get
> unhandled alignment faults. Use ioremap_wc in place of ioremap which
> gives us normal non-cacheable memory instead of device memory.

Could this break the omap_bus_sync() implementation in
arch/arm/mach-omap2/omap4-common.c?

    void omap_bus_sync(void)
    {
            if (dram_sync && sram_sync) {
                    writel_relaxed(readl_relaxed(dram_sync), dram_sync);
                    writel_relaxed(readl_relaxed(sram_sync), sram_sync);
                    isb();
            }
    }

It is used in wmb() and omap_do_wfi() to drain interconnect write
buffers on omap4/5. If sram_sync is mapped with write-combining, could
the last write to sram_sync stay stuck in the write-combining buffer
until after the function returns?

regards
Philipp

> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> ---
> This is based on the discussion about the crash here:
> http://www.spinics.net/lists/arm-kernel/msg384647.html
> 
>  drivers/misc/sram.c |   17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/misc/sram.c b/drivers/misc/sram.c
> index 21181fa..15b4d4e 100644
> --- a/drivers/misc/sram.c
> +++ b/drivers/misc/sram.c
> @@ -69,12 +69,23 @@ static int sram_probe(struct platform_device *pdev)
>  	INIT_LIST_HEAD(&reserve_list);
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	virt_base = devm_ioremap_resource(&pdev->dev, res);
> -	if (IS_ERR(virt_base))
> -		return PTR_ERR(virt_base);
> +	if (!res) {
> +		dev_err(&pdev->dev, "found no memory resource\n");
> +		return -EINVAL;
> +	}
>  
>  	size = resource_size(res);
>  
> +	if (!devm_request_mem_region(&pdev->dev,
> +			res->start, size, pdev->name)) {
> +		dev_err(&pdev->dev, "could not request region for resource\n");
> +		return -EBUSY;
> +	}
> +
> +	virt_base = devm_ioremap_wc(&pdev->dev, res->start, size);
> +	if (IS_ERR(virt_base))
> +		return PTR_ERR(virt_base);
> +
>  	sram = devm_kzalloc(&pdev->dev, sizeof(*sram), GFP_KERNEL);
>  	if (!sram)
>  		return -ENOMEM;


