Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbaHEBpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 21:45:45 -0400
Received: from regular1.263xmail.com ([211.150.99.132]:58988 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaHEBpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:45:43 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: linux-kernel@vger.kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <dafdbf30249bbe70f287b2c13e55f984>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <53E0373C.5090309@rock-chips.com>
Date: Tue, 05 Aug 2014 09:45:32 +0800
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Paul Zimmerman <paulz@synopsys.com>, Heiko Stuebner <heiko@sntech.de>,
        Addy Ke <addy.ke@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, Olof Johansson <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>, wulf <wulf@rock-chips.com>,
        lyz <lyz@rock-chips.com>, Jingoo Han <jg1.han@samsung.com>,
        han jiang <hj@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] usb: dwc2: add 'mode' which based on Kconfig select
 or dts setting
References: <1407159942-7063-1-git-send-email-kever.yang@rock-chips.com>	<1407159942-7063-3-git-send-email-kever.yang@rock-chips.com> <CAD=FV=WO5TxzWEv3XwO7T6_F6ynyi0P0yF+Y=LD495dEOyWw_w@mail.gmail.com>
In-Reply-To: <CAD=FV=WO5TxzWEv3XwO7T6_F6ynyi0P0yF+Y=LD495dEOyWw_w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug,

On 08/05/2014 12:34 AM, Doug Anderson wrote:
> Kever,
>
> On Mon, Aug 4, 2014 at 6:45 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
>> According to the "dr_mode", the otg controller can work as
>> device role during firmware period, and work as host role in
>> the kernel, without use of usb_id pin. As the commit "usb: dwc3:
>> set 'mode' based on selected Kconfig choices".
> I don't think you need to mention firmware / kernel here.  Just say
> that on some boards we always want to use host mode and on other
> boards we want to use gadget mode.  ...and that we don't necessarily
> have the ID pin hooked up to make this automatic.
OK, I'll change this message again, I just don't know how to describe
to make everyone understand what I'm doing.
>
>
>> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> Normally I'd say that you should have added Paul's "Acked-by" since
> you fixed his nit and he told you to include his Acked-by when his nit
> was fixed, but...
There are some more changes than Paul's suggestion, so I'm not sure
if Paul need more review to give me the "Acked-by", I get it now.
>
>
>> ---
>>
>> Changes in v3:
>> - fix the odd spacing in dwc2_hsotg struct
>> - From Jingoo's suggestion:
>>      change the commit message
> You did more than just this.  You also added some (incorrect) Kconfig
> things.  See below.
>
>
>> Changes in v2:
>> - put spaces around '+' operator
>> - expand the comment for dr_mode
>> - handle dr_mode is USB_DR_MODE_OTG
>>
>>   drivers/usb/dwc2/core.c     | 18 ++++++++++++++++++
>>   drivers/usb/dwc2/core.h     |  5 +++++
>>   drivers/usb/dwc2/platform.c | 12 ++++++++++++
>>   3 files changed, 35 insertions(+)
>>
>> diff --git a/drivers/usb/dwc2/core.c b/drivers/usb/dwc2/core.c
>> index 27d2c9b..738bec2 100644
>> --- a/drivers/usb/dwc2/core.c
>> +++ b/drivers/usb/dwc2/core.c
>> @@ -118,6 +118,7 @@ static int dwc2_core_reset(struct dwc2_hsotg *hsotg)
>>   {
>>          u32 greset;
>>          int count = 0;
>> +       u32 gusbcfg;
>>
>>          dev_vdbg(hsotg->dev, "%s()\n", __func__);
>>
>> @@ -148,6 +149,23 @@ static int dwc2_core_reset(struct dwc2_hsotg *hsotg)
>>                  }
>>          } while (greset & GRSTCTL_CSFTRST);
>>
>> +       if (hsotg->dr_mode == USB_DR_MODE_HOST) {
>> +               gusbcfg = readl(hsotg->regs + GUSBCFG);
>> +               gusbcfg &= ~GUSBCFG_FORCEDEVMODE;
>> +               gusbcfg |= GUSBCFG_FORCEHOSTMODE;
>> +               writel(gusbcfg, hsotg->regs + GUSBCFG);
>> +       } else if (hsotg->dr_mode == USB_DR_MODE_PERIPHERAL) {
>> +               gusbcfg = readl(hsotg->regs + GUSBCFG);
>> +               gusbcfg &= ~GUSBCFG_FORCEHOSTMODE;
>> +               gusbcfg |= GUSBCFG_FORCEDEVMODE;
>> +               writel(gusbcfg, hsotg->regs + GUSBCFG);
>> +       } else if (hsotg->dr_mode == USB_DR_MODE_OTG) {
>> +               gusbcfg = readl(hsotg->regs + GUSBCFG);
>> +               gusbcfg &= ~GUSBCFG_FORCEHOSTMODE;
>> +               gusbcfg &= ~GUSBCFG_FORCEDEVMODE;
>> +               writel(gusbcfg, hsotg->regs + GUSBCFG);
>> +       }
>> +
>>          /*
>>           * NOTE: This long sleep is _very_ important, otherwise the core will
>>           * not stay in host mode after a connector ID change!
>> diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
>> index 1efd10c..52a4fd2 100644
>> --- a/drivers/usb/dwc2/core.h
>> +++ b/drivers/usb/dwc2/core.h
>> @@ -501,6 +501,10 @@ struct dwc2_hw_params {
>>    *                      a_peripheral and b_device=>b_host) this may not match
>>    *                      the core, but allows the software to determine
>>    *                      transitions
>> + * @dr_mode:            Requested mode of operation, one of following:
>> + *                      - USB_DR_MODE_PERIPHERAL
>> + *                      - USB_DR_MODE_HOST
>> + *                      - USB_DR_MODE_OTG
>>    * @queuing_high_bandwidth: True if multiple packets of a high-bandwidth
>>    *                      transfer are in process of being queued
>>    * @srp_success:        Stores status of SRP request in the case of a FS PHY
>> @@ -592,6 +596,7 @@ struct dwc2_hsotg {
>>          /** Params to actually use */
>>          struct dwc2_core_params *core_params;
>>          enum usb_otg_state op_state;
>> +       enum usb_dr_mode dr_mode;
>>
>>          unsigned int queuing_high_bandwidth:1;
>>          unsigned int srp_success:1;
>> diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
>> index a10e7a3..4d2c738 100644
>> --- a/drivers/usb/dwc2/platform.c
>> +++ b/drivers/usb/dwc2/platform.c
>> @@ -42,6 +42,8 @@
>>   #include <linux/of_device.h>
>>   #include <linux/platform_device.h>
>>
>> +#include <linux/usb/of.h>
>> +
>>   #include "core.h"
>>   #include "hcd.h"
>>
>> @@ -171,6 +173,16 @@ static int dwc2_driver_probe(struct platform_device *dev)
>>          dev_dbg(&dev->dev, "mapped PA %08lx to VA %p\n",
>>                  (unsigned long)res->start, hsotg->regs);
>>
>> +       hsotg->dr_mode = of_usb_get_dr_mode(dev->dev.of_node);
>> +
>> +       if (IS_ENABLED(CONFIG_USB_DWC2_HOST))
>> +               hsotg->dr_mode = USB_DR_MODE_HOST;
>> +       else if (IS_ENABLED(CONFIG_USB_DWC2_GADGET))
>> +               hsotg->dr_mode = USB_DR_MODE_PERIPHERAL;
>> +
>> +       if (hsotg->dr_mode == USB_DR_MODE_UNKNOWN)
>> +               hsotg->dr_mode = USB_DR_MODE_OTG;
>> +
> Please remove this whole chunk.  Specifically:
>
> * CONFIG_USB_DWC2_GADGET is not a config option and is nowhere in any
> KConfig files.
This should be USB_DWC2_PERIPHERAL, and I just copy it wrong from dwc3.
>
> * CONFIG_USB_DWC2_HOST claims in Kconfig that we'll be in "host only"
> mode, but I don't think that's right.  The only way you'll get any
> host functionality is if CONFIG_USB_DWC2_HOST is defined, so we'd need
> that defined even for OTG mode.
Yeap, I add the chunk above because I'm confused by "Host only mode" for
CONFIG_USB_DWC2_HOST in Kconfig. If it's the "Host only mode", I should
add the dr_mode for it to make sure the controller works in host mode.

Maybe dwc2 is refer to the Kconfig in dwc3 for there is a choice from
one of "Host only mode", "Gadget only mode" and "Dual Role mode",
which means the role is decided by the Kconfig.

In my opinion, there maybe more than one controller in a Soc, and for 
different
usage, the mode select should not be done in Kconfig, it's better to do that
in dts file.
I agree with you that the CONFIG_USB_DWC2_HOST should defined for host
functionality, not for role definition.

Paul: what do you think?
>
>
>


