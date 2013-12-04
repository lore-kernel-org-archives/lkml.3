Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab3LDMrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 07:47:31 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:34639 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317Ab3LDMr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:47:29 -0500
Message-ID: <529F2463.8080907@cogentembedded.com>
Date: Wed, 04 Dec 2013 16:47:31 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: oliver@schinagl.nl, tj@kernel.org, grant.likely@linaro.org,
        ob.herring@calxeda.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        dev@linux-sunxi.org
CC: maxime.ripard@free-electrons.com, ijc@hellion.org.uk, hdegoede@redhat.com,
        oliver+list@schinagl.nl
Subject: Re: [PATCH 1/3] RFC: AHCI: libahci is missing DMA
References: <1386159055-10264-1-git-send-email-oliver@schinagl.nl> <1386159055-10264-2-git-send-email-oliver@schinagl.nl>
In-Reply-To: <1386159055-10264-2-git-send-email-oliver@schinagl.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 04-12-2013 16:10, oliver@schinagl.nl wrote:

> From: Oliver Schinagl <oliver@schinagl.nl>

> The Allwinner sunxi platforms have patched in the following to enable
> DMA. This patch enables DMA controllers for the SUNXI Architecture.

> Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
> ---
>   drivers/ata/ahci.h    | 6 ++++++
>   drivers/ata/libahci.c | 8 ++++++++
>   2 files changed, 14 insertions(+)

> diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
> index 2289efdf..2bf2423 100644
> --- a/drivers/ata/ahci.h
> +++ b/drivers/ata/ahci.h
[...]
> @@ -209,6 +210,11 @@ enum {
>   	PORT_DEVSLP_DSP		= (1 << 1),       /* DevSlp present */
>   	PORT_DEVSLP_ADSE	= (1 << 0),       /* Aggressive DevSlp enable */
>
> +	/* PORT_DMA bits */
> +	PORT_DMA_SETUP_OFFSET	= 8, /* dma setup offset */
> +	PORT_DMA_SETUP_MASK	= (0xff << PORT_DMA_SETUP_OFFSET),/* dma mask */
> +	PORT_DMA_SETUP_INIT	= (0x44 << 0),

    Why not shift it right by PORT_DMA_SETUP_OFFSET if you do it in the next 
file anyway?

[...]
> diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
> index c482f8c..d697a74 100644
> --- a/drivers/ata/libahci.c
> +++ b/drivers/ata/libahci.c
> @@ -570,6 +570,14 @@ void ahci_start_engine(struct ata_port *ap)
>   	void __iomem *port_mmio = ahci_port_base(ap);
>   	u32 tmp;
>
> +#ifdef CONFIG_ARCH_SUNXI
> +	/* Setup DMA before DMA start */
> +	tmp = readl(port_mmio + PORT_DMA);
> +	tmp &= ~PORT_DMA_SETUP_MASK;
> +	tmp |= PORT_DMA_SETUP_INIT << PORT_DMA_SETUP_OFFSET;
> +	writel(tmp, port_mmio + PORT_DMA);
> +#endif
> +

    I don't think #ifdef is appropriate here.

WBR, Sergei

