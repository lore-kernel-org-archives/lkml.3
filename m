Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbaHGDO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 23:14:27 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:36170 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046AbaHGDOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 23:14:25 -0400
Message-ID: <53E2EF0D.8090302@gmail.com>
Date: Wed, 06 Aug 2014 22:14:21 -0500
From: Dinh Nguyen <dinh.linux@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Doug Anderson <dianders@chromium.org>,
        Kever Yang <kever.yang@rock-chips.com>
CC: Heiko Stuebner <heiko@sntech.de>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        wulf <wulf@rock-chips.com>, lyz <lyz@rock-chips.com>,
        Jingoo Han <jg1.han@samsung.com>, han jiang <hj@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: Re: [PATCH v4 2/2] usb: dwc2: add 'mode' which based on Kconfig select
 or dts setting
References: <1407286910-30906-1-git-send-email-kever.yang@rock-chips.com>	<1407286910-30906-3-git-send-email-kever.yang@rock-chips.com> <CAD=FV=V7TuqcVouC3KfPyebLqbVOJNhu-4HAVx0=+9_ny1RrOA@mail.gmail.com> <A2CA0424C0A6F04399FB9E1CD98E0304844C4A45@US01WEMBX2.internal.synopsys.com>
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844C4A45@US01WEMBX2.internal.synopsys.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 8/6/14, 5:57 PM, Paul Zimmerman wrote:
>> From: dianders@google.com [mailto:dianders@google.com] On Behalf Of Doug Anderson
>> Sent: Wednesday, August 06, 2014 3:25 PM
>>
>> On Tue, Aug 5, 2014 at 6:01 PM, Kever Yang <kever.yang@rock-chips.com> wrote:
>>> According to the "dr_mode", the otg controller can work as
>>> device role and host role. Some boards always want to use host mode
>>> and some other boards want to use gadget mode. We use the dts setting
>>> to set dwc2's mode, rather than fixing it to whatever hardware says.
>>>
>>> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
>>> Acked-by: Paul Zimmerman <paulz@synopsys.com>
>>> ---
>>>
>>> Changes in v4:
>>> - From Doug's suggestion:
>>>  -- remove dr_mode init from Kconfig code
>>>  -- change the commit meesage
>>>
>>> Changes in v3:
>>> - fix the odd spacing in dwc2_hsotg struct
>>> - From Jingoo's suggestion:
>>>     change the commit message
>>> - add dr_mode init from Kconfig
>>>
>>> Changes in v2:
>>> - put spaces around '+' operator
>>> - expand the comment for dr_mode
>>> - handle dr_mode is USB_DR_MODE_OTG
>>>
>>>  drivers/usb/dwc2/core.c     | 18 ++++++++++++++++++
>>>  drivers/usb/dwc2/core.h     |  5 +++++
>>>  drivers/usb/dwc2/platform.c |  4 ++++
>>>  3 files changed, 27 insertions(+)
>> I think this patch still makes sense even though we don't have a
>> combined driver yet.  Perhaps Paul or Dihn can confirm.
> Yes, it should be fine.
>
>> We could potentially do something based on KConfig (like you did in
>> patch set #3), but it wouldn't really make sense to do that until
>> after Dihn's work lands.
>>
>>
>>> diff --git a/drivers/usb/dwc2/core.c b/drivers/usb/dwc2/core.c
>>> index 27d2c9b..738bec2 100644
>>> --- a/drivers/usb/dwc2/core.c
>>> +++ b/drivers/usb/dwc2/core.c
>>> @@ -118,6 +118,7 @@ static int dwc2_core_reset(struct dwc2_hsotg *hsotg)
>>>  {
>>>         u32 greset;
>>>         int count = 0;
>>> +       u32 gusbcfg;
>>>
>>>         dev_vdbg(hsotg->dev, "%s()\n", __func__);
>>>
>>> @@ -148,6 +149,23 @@ static int dwc2_core_reset(struct dwc2_hsotg *hsotg)
>>>                 }
>>>         } while (greset & GRSTCTL_CSFTRST);
>>>
>>> +       if (hsotg->dr_mode == USB_DR_MODE_HOST) {
>>> +               gusbcfg = readl(hsotg->regs + GUSBCFG);
>>> +               gusbcfg &= ~GUSBCFG_FORCEDEVMODE;
>>> +               gusbcfg |= GUSBCFG_FORCEHOSTMODE;
>>> +               writel(gusbcfg, hsotg->regs + GUSBCFG);
>>> +       } else if (hsotg->dr_mode == USB_DR_MODE_PERIPHERAL) {
>>> +               gusbcfg = readl(hsotg->regs + GUSBCFG);
>>> +               gusbcfg &= ~GUSBCFG_FORCEHOSTMODE;
>>> +               gusbcfg |= GUSBCFG_FORCEDEVMODE;
>>> +               writel(gusbcfg, hsotg->regs + GUSBCFG);
>>> +       } else if (hsotg->dr_mode == USB_DR_MODE_OTG) {
>>> +               gusbcfg = readl(hsotg->regs + GUSBCFG);
>>> +               gusbcfg &= ~GUSBCFG_FORCEHOSTMODE;
>>> +               gusbcfg &= ~GUSBCFG_FORCEDEVMODE;
>>> +               writel(gusbcfg, hsotg->regs + GUSBCFG);
>> I think the third case here won't be too useful until the combined
>> driver, but it shouldn't hurt, right?
> Right. For the existing drivers, it shouldn't change anything, since
> nothing currently sets dr_mode. And with Kever's other patches, it
> forces host mode on the Rockchip platform, which is all that is required
> for now, if I understand correctly.
>
I managed to test this patch on the SOCFPGA platform. So

Tested-by: Dinh Nguyen <dinguyen@opensource.altera.com>

Thanks,
DInh

