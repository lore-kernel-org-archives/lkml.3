Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab3DYIGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 04:06:11 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:45040 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab3DYIGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 04:06:06 -0400
MIME-Version: 1.0
In-Reply-To: <1366279934-30761-5-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-5-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 10:06:05 +0200
Message-ID: <CACRpkdaauDYTdoBHGG9FO4kKqvCYyCrjY8EGWs5gAQWErGW6_A@mail.gmail.com>
Subject: Re: [PATCH 04/32] dmaengine: ste_dma40: Amalgamate DMA source and
 destination channel numbers
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 12:11 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Devices which utilise DMA tend to use the same channel numbers for
> transmitting and receiving. For this reason and the fact that it'll
> decrease the burden of platform data passed to each device, we're
> amalgamating source and destination device types.

I don't think this explains what the patch is actually doing.

Instead describe this:

> @@ -56,8 +54,7 @@ static struct stedma40_chan_cfg msp1_dma_rx = {
>         .high_priority = true,
>         .dir = STEDMA40_PERIPH_TO_MEM,
>
> -       .src_dev_type = DB8500_DMA_DEV30_MSP3_RX,
> -       .dst_dev_type = STEDMA40_DEV_DST_MEMORY,
> +       .dev_type = DB8500_DMA_DEV30_MSP3,
(...)

What the message should say is that we're encoding pairs of
information for sources and destinations. Since every such
entry contains a .dir entry stating the direction of the transfer
it is implicit whether the channel is for RX or TX and this is what
you're exploiting in this patch.

So channel numbers (as mentioned in the commit) is not
the key issue here.

Now we should ask ourselves why it was done like this from
the beginning. The reason is that DMA40 supports device-to-device
DMA, so if you encoded one device in .src_dev_type and another
device in .dst_dev_type and set .dir to
STEDMA40_PERIPH_TO_PERIPH (which as you can see is
defined in <linux/platform_data/dma-ste-dma40.h>) you get a
device to device transfer.

Are we now sacrificing that ability on the altar of simplification?

I actually think not, but that we should do periph-to-periph transfers
in some other way, and that the .dir attribute should go away from
the struct stedma40_chan_cfg as well but I'm not entirely sure.
Someone else?

(...)
> +++ b/arch/arm/mach-ux500/cpu-db8500.c
> @@ -167,25 +167,25 @@ static void __init db8500_add_gpios(struct device *parent)
>  }
>
>  static int usb_db8500_rx_dma_cfg[] = {
> -       DB8500_DMA_DEV38_USB_OTG_IEP_1_9,
> -       DB8500_DMA_DEV37_USB_OTG_IEP_2_10,
> -       DB8500_DMA_DEV36_USB_OTG_IEP_3_11,
> -       DB8500_DMA_DEV19_USB_OTG_IEP_4_12,
> -       DB8500_DMA_DEV18_USB_OTG_IEP_5_13,
> -       DB8500_DMA_DEV17_USB_OTG_IEP_6_14,
> -       DB8500_DMA_DEV16_USB_OTG_IEP_7_15,
> -       DB8500_DMA_DEV39_USB_OTG_IEP_8
> +       DB8500_DMA_DEV38_USB_OTG_IEP_AND_OEP_1_9,
> +       DB8500_DMA_DEV37_USB_OTG_IEP_AND_OEP_2_10,
> +       DB8500_DMA_DEV36_USB_OTG_IEP_AND_OEP_3_11,
> +       DB8500_DMA_DEV19_USB_OTG_IEP_AND_OEP_4_12,
> +       DB8500_DMA_DEV18_USB_OTG_IEP_AND_OEP_5_13,
> +       DB8500_DMA_DEV17_USB_OTG_IEP_AND_OEP_6_14,
> +       DB8500_DMA_DEV16_USB_OTG_IEP_AND_OEP_7_15,
> +       DB8500_DMA_DEV39_USB_OTG_IEP_AND_OEP_8
>  };
>
>  static int usb_db8500_tx_dma_cfg[] = {
> -       DB8500_DMA_DEV38_USB_OTG_OEP_1_9,
> -       DB8500_DMA_DEV37_USB_OTG_OEP_2_10,
> -       DB8500_DMA_DEV36_USB_OTG_OEP_3_11,
> -       DB8500_DMA_DEV19_USB_OTG_OEP_4_12,
> -       DB8500_DMA_DEV18_USB_OTG_OEP_5_13,
> -       DB8500_DMA_DEV17_USB_OTG_OEP_6_14,
> -       DB8500_DMA_DEV16_USB_OTG_OEP_7_15,
> -       DB8500_DMA_DEV39_USB_OTG_OEP_8
> +       DB8500_DMA_DEV38_USB_OTG_IEP_AND_OEP_1_9,
> +       DB8500_DMA_DEV37_USB_OTG_IEP_AND_OEP_2_10,
> +       DB8500_DMA_DEV36_USB_OTG_IEP_AND_OEP_3_11,
> +       DB8500_DMA_DEV19_USB_OTG_IEP_AND_OEP_4_12,
> +       DB8500_DMA_DEV18_USB_OTG_IEP_AND_OEP_5_13,
> +       DB8500_DMA_DEV17_USB_OTG_IEP_AND_OEP_6_14,
> +       DB8500_DMA_DEV16_USB_OTG_IEP_AND_OEP_7_15,
> +       DB8500_DMA_DEV39_USB_OTG_IEP_AND_OEP_8
>  };


If you're doing this change, and after this RX and TX has no semantical
meaning for these lists, join these two config lists
into one.

(...)
> diff --git a/arch/arm/mach-ux500/usb.c b/arch/arm/mach-ux500/usb.c
>  static u32 d40_chan_has_events(struct d40_chan *d40c)
> @@ -1744,8 +1740,6 @@ static int d40_validate_conf(struct d40_chan *d40c,
>                              struct stedma40_chan_cfg *conf)
>  {
>         int res = 0;
> -       u32 dst_event_group = D40_TYPE_TO_GROUP(conf->dst_dev_type);
> -       u32 src_event_group = D40_TYPE_TO_GROUP(conf->src_dev_type);

Please explain why this is not important to check anymore, I'm not
following.

>         if (conf->dir == STEDMA40_MEM_TO_PERIPH &&
> -           dst_event_group == STEDMA40_DEV_DST_MEMORY) {
> -               chan_err(d40c, "Invalid dst\n");
> +           d40c->base->plat_data->dev_tx[conf->dev_type] == 0 &&
> +           d40c->runtime_addr == 0) {
> +               chan_err(d40c, "Invalid TX channel address (%d)\n",
> +                        conf->dev_type);

Like here. We are checking for inconsistency between group
and channel direction, why is it no longer important to check this?

>         if (conf->dir == STEDMA40_PERIPH_TO_MEM &&
> -           src_event_group == STEDMA40_DEV_SRC_MEMORY) {
> -               chan_err(d40c, "Invalid src\n");
> -               res = -EINVAL;
> -       }
> -
> -       if (src_event_group == STEDMA40_DEV_SRC_MEMORY &&
> -           dst_event_group == STEDMA40_DEV_DST_MEMORY && is_log) {
> -               chan_err(d40c, "No event line\n");
> -               res = -EINVAL;
> -       }
> -
> -       if (conf->dir == STEDMA40_PERIPH_TO_PERIPH &&
> -           (src_event_group != dst_event_group)) {
> -               chan_err(d40c, "Invalid event group\n");
> +           d40c->base->plat_data->dev_rx[conf->dev_type] == 0 &&
> +           d40c->runtime_addr == 0) {
> +               chan_err(d40c, "Invalid RX channel address (%d)\n",
> +                        conf->dev_type);

Same here.

(...)
> @@ -2062,7 +2035,7 @@ static int d40_free_dma(struct d40_chan *d40c)
>  {
>
>         int res = 0;
> -       u32 event;
> +       u32 event = D40_TYPE_TO_EVENT(d40c->dma_cfg.dev_type);
>         struct d40_phy_res *phy = d40c->phy_chan;
>         bool is_src;
>
> @@ -2081,13 +2054,11 @@ static int d40_free_dma(struct d40_chan *d40c)
>         }
>
>         if (d40c->dma_cfg.dir == STEDMA40_MEM_TO_PERIPH ||
> -           d40c->dma_cfg.dir == STEDMA40_MEM_TO_MEM) {
> -               event = D40_TYPE_TO_EVENT(d40c->dma_cfg.dst_dev_type);
> +           d40c->dma_cfg.dir == STEDMA40_MEM_TO_MEM)

Why did you just stop checking dma_cfg.dir for == STEDMA40_MEM_TO_MEM
above?

And why is dma_cfg.dir suddenly hardcoded to MEM_TO_MEM??

This seems like a totally unrelated change and should it be done
it need to be a separate patch with a separate explanation
AFAICT.

This seems to happen in some other places too, and I find it
very hard to follow the changes here ... can you please consider
splitting the changes to groups and types semantics into a separate
patch?

Yours,
Linus Walleij
