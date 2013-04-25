Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab3DYJGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:06:21 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:48985 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab3DYJGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:06:19 -0400
Date: Thu, 25 Apr 2013 10:06:12 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 04/32] dmaengine: ste_dma40: Amalgamate DMA source and
 destination channel numbers
Message-ID: <20130425090612.GC4623@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-5-git-send-email-lee.jones@linaro.org>
 <CACRpkdaauDYTdoBHGG9FO4kKqvCYyCrjY8EGWs5gAQWErGW6_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaauDYTdoBHGG9FO4kKqvCYyCrjY8EGWs5gAQWErGW6_A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Devices which utilise DMA tend to use the same channel numbers for
> > transmitting and receiving. For this reason and the fact that it'll
> > decrease the burden of platform data passed to each device, we're
> > amalgamating source and destination device types.
> 
> I don't think this explains what the patch is actually doing.
> 
> Instead describe this:
> 
> > @@ -56,8 +54,7 @@ static struct stedma40_chan_cfg msp1_dma_rx = {
> >         .high_priority = true,
> >         .dir = STEDMA40_PERIPH_TO_MEM,
> >
> > -       .src_dev_type = DB8500_DMA_DEV30_MSP3_RX,
> > -       .dst_dev_type = STEDMA40_DEV_DST_MEMORY,
> > +       .dev_type = DB8500_DMA_DEV30_MSP3,
> (...)
> 
> What the message should say is that we're encoding pairs of
> information for sources and destinations. Since every such
> entry contains a .dir entry stating the direction of the transfer
> it is implicit whether the channel is for RX or TX and this is what
> you're exploiting in this patch.
> 
> So channel numbers (as mentioned in the commit) is not
> the key issue here.

Channel numbers should really be device types in the commit
message. I'll expand using your explanation too though.

> Now we should ask ourselves why it was done like this from
> the beginning. The reason is that DMA40 supports device-to-device
> DMA, so if you encoded one device in .src_dev_type and another
> device in .dst_dev_type and set .dir to
> STEDMA40_PERIPH_TO_PERIPH (which as you can see is
> defined in <linux/platform_data/dma-ste-dma40.h>) you get a
> device to device transfer.
> 
> Are we now sacrificing that ability on the altar of simplification?
>
> I actually think not, but that we should do periph-to-periph transfers
> in some other way, and that the .dir attribute should go away from
> the struct stedma40_chan_cfg as well but I'm not entirely sure.
> Someone else?

Although the DMA40 device supports device-to-device transfers, Linux
does not, so this subject is moot AFAICT.

> (...)
> > +++ b/arch/arm/mach-ux500/cpu-db8500.c
> > @@ -167,25 +167,25 @@ static void __init db8500_add_gpios(struct device *parent)
> >  }
> >
> >  static int usb_db8500_rx_dma_cfg[] = {
> > -       DB8500_DMA_DEV38_USB_OTG_IEP_1_9,
> > -       DB8500_DMA_DEV37_USB_OTG_IEP_2_10,
> > -       DB8500_DMA_DEV36_USB_OTG_IEP_3_11,
> > -       DB8500_DMA_DEV19_USB_OTG_IEP_4_12,
> > -       DB8500_DMA_DEV18_USB_OTG_IEP_5_13,
> > -       DB8500_DMA_DEV17_USB_OTG_IEP_6_14,
> > -       DB8500_DMA_DEV16_USB_OTG_IEP_7_15,
> > -       DB8500_DMA_DEV39_USB_OTG_IEP_8
> > +       DB8500_DMA_DEV38_USB_OTG_IEP_AND_OEP_1_9,
> > +       DB8500_DMA_DEV37_USB_OTG_IEP_AND_OEP_2_10,
> > +       DB8500_DMA_DEV36_USB_OTG_IEP_AND_OEP_3_11,
> > +       DB8500_DMA_DEV19_USB_OTG_IEP_AND_OEP_4_12,
> > +       DB8500_DMA_DEV18_USB_OTG_IEP_AND_OEP_5_13,
> > +       DB8500_DMA_DEV17_USB_OTG_IEP_AND_OEP_6_14,
> > +       DB8500_DMA_DEV16_USB_OTG_IEP_AND_OEP_7_15,
> > +       DB8500_DMA_DEV39_USB_OTG_IEP_AND_OEP_8
> >  };
> >
> >  static int usb_db8500_tx_dma_cfg[] = {
> > -       DB8500_DMA_DEV38_USB_OTG_OEP_1_9,
> > -       DB8500_DMA_DEV37_USB_OTG_OEP_2_10,
> > -       DB8500_DMA_DEV36_USB_OTG_OEP_3_11,
> > -       DB8500_DMA_DEV19_USB_OTG_OEP_4_12,
> > -       DB8500_DMA_DEV18_USB_OTG_OEP_5_13,
> > -       DB8500_DMA_DEV17_USB_OTG_OEP_6_14,
> > -       DB8500_DMA_DEV16_USB_OTG_OEP_7_15,
> > -       DB8500_DMA_DEV39_USB_OTG_OEP_8
> > +       DB8500_DMA_DEV38_USB_OTG_IEP_AND_OEP_1_9,
> > +       DB8500_DMA_DEV37_USB_OTG_IEP_AND_OEP_2_10,
> > +       DB8500_DMA_DEV36_USB_OTG_IEP_AND_OEP_3_11,
> > +       DB8500_DMA_DEV19_USB_OTG_IEP_AND_OEP_4_12,
> > +       DB8500_DMA_DEV18_USB_OTG_IEP_AND_OEP_5_13,
> > +       DB8500_DMA_DEV17_USB_OTG_IEP_AND_OEP_6_14,
> > +       DB8500_DMA_DEV16_USB_OTG_IEP_AND_OEP_7_15,
> > +       DB8500_DMA_DEV39_USB_OTG_IEP_AND_OEP_8
> >  };
> 
> 
> If you're doing this change, and after this RX and TX has no semantical
> meaning for these lists, join these two config lists
> into one.

I agree. See patch: ARM: ux500: Strip out duplicate USB DMA configuration

> (...)
> > diff --git a/arch/arm/mach-ux500/usb.c b/arch/arm/mach-ux500/usb.c
> >  static u32 d40_chan_has_events(struct d40_chan *d40c)
> > @@ -1744,8 +1740,6 @@ static int d40_validate_conf(struct d40_chan *d40c,
> >                              struct stedma40_chan_cfg *conf)
> >  {
> >         int res = 0;
> > -       u32 dst_event_group = D40_TYPE_TO_GROUP(conf->dst_dev_type);
> > -       u32 src_event_group = D40_TYPE_TO_GROUP(conf->src_dev_type);
> 
> Please explain why this is not important to check anymore, I'm not
> following.
> 
> >         if (conf->dir == STEDMA40_MEM_TO_PERIPH &&
> > -           dst_event_group == STEDMA40_DEV_DST_MEMORY) {
> > -               chan_err(d40c, "Invalid dst\n");
> > +           d40c->base->plat_data->dev_tx[conf->dev_type] == 0 &&
> > +           d40c->runtime_addr == 0) {
> > +               chan_err(d40c, "Invalid TX channel address (%d)\n",
> > +                        conf->dev_type);
> 
> Like here. We are checking for inconsistency between group
> and channel direction, why is it no longer important to check this?

I'm not entirely sure how this ever worked:

  #define D40_TYPE_TO_GROUP(type) (type / 16)
  #define STEDMA40_DEV_DST_MEMORY (-1)

  (dev_type / 16) == -1

What number would dev_type have to be for this to be true? -16?

> >         if (conf->dir == STEDMA40_PERIPH_TO_MEM &&
> > -           src_event_group == STEDMA40_DEV_SRC_MEMORY) {
> > -               chan_err(d40c, "Invalid src\n");
> > -               res = -EINVAL;
> > -       }

As above.

> > -       if (src_event_group == STEDMA40_DEV_SRC_MEMORY &&
> > -           dst_event_group == STEDMA40_DEV_DST_MEMORY && is_log) {
> > -               chan_err(d40c, "No event line\n");
> > -               res = -EINVAL;
> > -       }

We still check for this.

> > -       if (conf->dir == STEDMA40_PERIPH_TO_PERIPH &&
> > -           (src_event_group != dst_event_group)) {
> > -               chan_err(d40c, "Invalid event group\n");
> > +           d40c->base->plat_data->dev_rx[conf->dev_type] == 0 &&
> > +           d40c->runtime_addr == 0) {
> > +               chan_err(d40c, "Invalid RX channel address (%d)\n",
> > +                        conf->dev_type);
> 
> Same here.

I stopped all 'dev_src/dev_dest' comparisons, as there is only 'dev' now.

> (...)
> > @@ -2062,7 +2035,7 @@ static int d40_free_dma(struct d40_chan *d40c)
> >  {
> >
> >         int res = 0;
> > -       u32 event;
> > +       u32 event = D40_TYPE_TO_EVENT(d40c->dma_cfg.dev_type);
> >         struct d40_phy_res *phy = d40c->phy_chan;
> >         bool is_src;
> >
> > @@ -2081,13 +2054,11 @@ static int d40_free_dma(struct d40_chan *d40c)
> >         }
> >
> >         if (d40c->dma_cfg.dir == STEDMA40_MEM_TO_PERIPH ||
> > -           d40c->dma_cfg.dir == STEDMA40_MEM_TO_MEM) {
> > -               event = D40_TYPE_TO_EVENT(d40c->dma_cfg.dst_dev_type);
> > +           d40c->dma_cfg.dir == STEDMA40_MEM_TO_MEM)
> 
> Why did you just stop checking dma_cfg.dir for == STEDMA40_MEM_TO_MEM
> above?

That's not what this is doing. STEDMA40_MEM_TO_MEM is still there.

This patch is doing this:

+       u32 event = D40_TYPE_TO_EVENT(d40c->dma_cfg.dev_type);
<snip>
-       event = D40_TYPE_TO_EVENT(d40c->dma_cfg.dst_dev_type);
-       event = D40_TYPE_TO_EVENT(d40c->dma_cfg.src_dev_type);

> And why is dma_cfg.dir suddenly hardcoded to MEM_TO_MEM??

It's not. Look again. :)

> This seems like a totally unrelated change and should it be done
> it need to be a separate patch with a separate explanation
> AFAICT.
> 
> This seems to happen in some other places too,

If you could point those out, I'll re-evaluate, or explain.

> and I find it
> very hard to follow the changes here ... can you please consider
> splitting the changes to groups and types semantics into a separate
> patch?

Can you read the patch again and reconsider please?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
