Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbaHEUIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 16:08:54 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:47887 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbaHEUIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 16:08:51 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Kever Yang <kever.yang@rock-chips.com>,
        Doug Anderson <dianders@chromium.org>
CC: Heiko Stuebner <heiko@sntech.de>, Addy Ke <addy.ke@rock-chips.com>,
        "Eddie Cai" <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        wulf <wulf@rock-chips.com>, lyz <lyz@rock-chips.com>,
        Jingoo Han <jg1.han@samsung.com>, han jiang <hj@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 2/2] usb: dwc2: add 'mode' which based on Kconfig
 select or dts setting
Thread-Topic: [PATCH v3 2/2] usb: dwc2: add 'mode' which based on Kconfig
 select or dts setting
Thread-Index: AQHPr+s0L5+LjPXnf0eieX1tPaIz9JvBGXAAgACZ9QCAALsJsA==
Date: Tue, 5 Aug 2014 20:08:48 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844C44CF@US01WEMBX2.internal.synopsys.com>
References: <1407159942-7063-1-git-send-email-kever.yang@rock-chips.com>
	<1407159942-7063-3-git-send-email-kever.yang@rock-chips.com>
 <CAD=FV=WO5TxzWEv3XwO7T6_F6ynyi0P0yF+Y=LD495dEOyWw_w@mail.gmail.com>
 <53E0373C.5090309@rock-chips.com>
In-Reply-To: <53E0373C.5090309@rock-chips.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s75K8xcY007234

> From: Kever Yang [mailto:kever.yang@rock-chips.com]
> Sent: Monday, August 04, 2014 6:46 PM
> 
> On 08/05/2014 12:34 AM, Doug Anderson wrote:
> 
> > Normally I'd say that you should have added Paul's "Acked-by" since
> > you fixed his nit and he told you to include his Acked-by when his nit
> > was fixed, but...
> There are some more changes than Paul's suggestion, so I'm not sure
> if Paul need more review to give me the "Acked-by", I get it now.

Yes, you did the right thing by leaving off my ack (although you should
have mentioned the additional changes in your email).

> >> diff --git a/drivers/usb/dwc2/core.c b/drivers/usb/dwc2/core.c
> >> index 27d2c9b..738bec2 100644
> >> --- a/drivers/usb/dwc2/core.c
> >> +++ b/drivers/usb/dwc2/core.c
> >> @@ -118,6 +118,7 @@ static int dwc2_core_reset(struct dwc2_hsotg *hsotg)
> >>   {
> >>          u32 greset;
> >>          int count = 0;
> >> +       u32 gusbcfg;
> >>
> >>          dev_vdbg(hsotg->dev, "%s()\n", __func__);
> >>
> >> @@ -148,6 +149,23 @@ static int dwc2_core_reset(struct dwc2_hsotg *hsotg)
> >>                  }
> >>          } while (greset & GRSTCTL_CSFTRST);
> >>
> >> +       if (hsotg->dr_mode == USB_DR_MODE_HOST) {
> >> +               gusbcfg = readl(hsotg->regs + GUSBCFG);
> >> +               gusbcfg &= ~GUSBCFG_FORCEDEVMODE;
> >> +               gusbcfg |= GUSBCFG_FORCEHOSTMODE;
> >> +               writel(gusbcfg, hsotg->regs + GUSBCFG);
> >> +       } else if (hsotg->dr_mode == USB_DR_MODE_PERIPHERAL) {
> >> +               gusbcfg = readl(hsotg->regs + GUSBCFG);
> >> +               gusbcfg &= ~GUSBCFG_FORCEHOSTMODE;
> >> +               gusbcfg |= GUSBCFG_FORCEDEVMODE;
> >> +               writel(gusbcfg, hsotg->regs + GUSBCFG);
> >> +       } else if (hsotg->dr_mode == USB_DR_MODE_OTG) {
> >> +               gusbcfg = readl(hsotg->regs + GUSBCFG);
> >> +               gusbcfg &= ~GUSBCFG_FORCEHOSTMODE;
> >> +               gusbcfg &= ~GUSBCFG_FORCEDEVMODE;
> >> +               writel(gusbcfg, hsotg->regs + GUSBCFG);
> >> +       }
> >> +
> >>          /*
> >>           * NOTE: This long sleep is _very_ important, otherwise the core will
> >>           * not stay in host mode after a connector ID change!
> >> diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
> >> index 1efd10c..52a4fd2 100644
> >> --- a/drivers/usb/dwc2/core.h
> >> +++ b/drivers/usb/dwc2/core.h
> >> @@ -501,6 +501,10 @@ struct dwc2_hw_params {
> >>    *                      a_peripheral and b_device=>b_host) this may not match
> >>    *                      the core, but allows the software to determine
> >>    *                      transitions
> >> + * @dr_mode:            Requested mode of operation, one of following:
> >> + *                      - USB_DR_MODE_PERIPHERAL
> >> + *                      - USB_DR_MODE_HOST
> >> + *                      - USB_DR_MODE_OTG
> >>    * @queuing_high_bandwidth: True if multiple packets of a high-bandwidth
> >>    *                      transfer are in process of being queued
> >>    * @srp_success:        Stores status of SRP request in the case of a FS PHY
> >> @@ -592,6 +596,7 @@ struct dwc2_hsotg {
> >>          /** Params to actually use */
> >>          struct dwc2_core_params *core_params;
> >>          enum usb_otg_state op_state;
> >> +       enum usb_dr_mode dr_mode;
> >>
> >>          unsigned int queuing_high_bandwidth:1;
> >>          unsigned int srp_success:1;
> >> diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
> >> index a10e7a3..4d2c738 100644
> >> --- a/drivers/usb/dwc2/platform.c
> >> +++ b/drivers/usb/dwc2/platform.c
> >> @@ -42,6 +42,8 @@
> >>   #include <linux/of_device.h>
> >>   #include <linux/platform_device.h>
> >>
> >> +#include <linux/usb/of.h>
> >> +
> >>   #include "core.h"
> >>   #include "hcd.h"
> >>
> >> @@ -171,6 +173,16 @@ static int dwc2_driver_probe(struct platform_device *dev)
> >>          dev_dbg(&dev->dev, "mapped PA %08lx to VA %p\n",
> >>                  (unsigned long)res->start, hsotg->regs);
> >>
> >> +       hsotg->dr_mode = of_usb_get_dr_mode(dev->dev.of_node);
> >> +
> >> +       if (IS_ENABLED(CONFIG_USB_DWC2_HOST))
> >> +               hsotg->dr_mode = USB_DR_MODE_HOST;
> >> +       else if (IS_ENABLED(CONFIG_USB_DWC2_GADGET))
> >> +               hsotg->dr_mode = USB_DR_MODE_PERIPHERAL;
> >> +
> >> +       if (hsotg->dr_mode == USB_DR_MODE_UNKNOWN)
> >> +               hsotg->dr_mode = USB_DR_MODE_OTG;
> >> +
> > Please remove this whole chunk.  Specifically:
> >
> > * CONFIG_USB_DWC2_GADGET is not a config option and is nowhere in any
> > KConfig files.
> This should be USB_DWC2_PERIPHERAL, and I just copy it wrong from dwc3.
> >
> > * CONFIG_USB_DWC2_HOST claims in Kconfig that we'll be in "host only"
> > mode, but I don't think that's right.  The only way you'll get any
> > host functionality is if CONFIG_USB_DWC2_HOST is defined, so we'd need
> > that defined even for OTG mode.
> Yeap, I add the chunk above because I'm confused by "Host only mode" for
> CONFIG_USB_DWC2_HOST in Kconfig. If it's the "Host only mode", I should
> add the dr_mode for it to make sure the controller works in host mode.
> 
> Maybe dwc2 is refer to the Kconfig in dwc3 for there is a choice from
> one of "Host only mode", "Gadget only mode" and "Dual Role mode",
> which means the role is decided by the Kconfig.
> 
> In my opinion, there maybe more than one controller in a Soc, and for
> different
> usage, the mode select should not be done in Kconfig, it's better to do that
> in dts file.
> I agree with you that the CONFIG_USB_DWC2_HOST should defined for host
> functionality, not for role definition.
> 
> Paul: what do you think?

I'm confused about how your dual-role mode implementation is supposed
to work. Right now, the host and peripheral modes are compiled as
separate drivers, and there is no dual-role mode in the Kconfig. So I
don't see how your code can work. Have you tested it?

Dinh Nguyen is working on a patch series to add dual-role support, I
think you have seen that, right? That adds the Kconfig options for all
three modes. Maybe you should build on top of that?

-- 
Paul

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
