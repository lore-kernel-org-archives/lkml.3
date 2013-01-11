Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab3AKO20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:28:26 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:46486 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab3AKO2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:28:24 -0500
MIME-Version: 1.0
In-Reply-To: <20130111135931.GE12715@arwen.pp.htv.fi>
References: <1356357513-8892-1-git-send-email-gautam.vivek@samsung.com>
	<20130110130238.GW28920@arwen.pp.htv.fi>
	<CAFp+6iHEJvCPHbSvqYhjuTjzvkKQVuKz8f8TupqFcZ9gdvpt-A@mail.gmail.com>
	<20130111135931.GE12715@arwen.pp.htv.fi>
Date: Fri, 11 Jan 2013 19:58:23 +0530
Message-ID: <CAFp+6iEvO2z=bWF7awN4vxN5W1YT0eXcpwarXoB8Mf_=BsQBpQ@mail.gmail.com>
Subject: Re: [PATCH RFC] usb: dwc3: Remove dwc3 dependency on gadget.
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: balbi@ti.com
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        gregkh@linuxfoundation.org, Doug Anderson <dianders@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Fri, Jan 11, 2013 at 7:29 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Fri, Jan 11, 2013 at 07:13:55PM +0530, Vivek Gautam wrote:
>> On Thu, Jan 10, 2013 at 6:32 PM, Felipe Balbi <balbi@ti.com> wrote:
>> > Hi,
>> >
>> > On Mon, Dec 24, 2012 at 07:28:33PM +0530, Vivek Gautam wrote:
>> >> DWC3 controller curretly depends on CONFIG_USB and CONFIG_USB_GADGET.
>> >> Some hardware may like to use only host feature on dwc3.
>> >> So, removing the dependency of USB_DWC3 on USB_GADGET
>> >> and further modulating the dwc3 core to enable gadget features
>> >> only with USB_GADGET.
>> >>
>> >> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> >> CC: Doug Anderson <dianders@chromium.org>
>> >
>> > right, right... Eventually we need to do it, but you're only making
>> > gadget side optional. Host side should be optional too, but then you
>> > need to make sure we don't build dwc3 without gadget and host.
>> >
>>
>> Yes, true we need to make host side also optional, build dwc3 only when
>> either of host or gadget are built.
>
> btw, make the default Dual-Role, if user/defconfig doesn't select
> anything we want to build with all features.
>

Yes we can try something like this ?

         if (USB || USB_GADGET)
         menuconfig USB_DWC3
                 tristate "DesignWare USB3 DRD Core Support"
          ...

          if USB_DWC3
          choice
          default USB_DWC3_DUAL_ROLE_MODE
          ...

          config USB_DWC3_HOST_MODE
          ...

          config USB_DWC3_DEVICE_MODE
          ...

          config USB_DWC3_DUAL_ROLE_MODE
          ...

         endchoice

         ..
         ..
         endif
         endif


>> > Maybe make a mode selection for Host-only, Peripheral-only, Dual-Role
>> > Device ??
>> >
>>
>> True this will be good idea to use modes: host only, gadget only or dual role.
>> May be the platform glue layers can use them later to put the controller
>> in a specific mode ?
>
> probably not as that's likely to change from board to board.
>
>> >>  int dwc3_gadget_init(struct dwc3 *dwc);
>> >>  void dwc3_gadget_exit(struct dwc3 *dwc);
>> >> +#else
>> >> +static inline int dwc3_gadget_init(struct dwc3 *dwc)
>> >> +{ return -EINVAL; }
>> >> +static inline void dwc3_gadget_exit(struct dwc3 *dwc)
>> >> +{ }
>> >> +#endif
>> >>
>> >>  #endif /* __DRIVERS_USB_DWC3_CORE_H */
>> >> diff --git a/drivers/usb/dwc3/debugfs.c b/drivers/usb/dwc3/debugfs.c
>> >> index d4a30f1..553bbaa 100644
>> >> --- a/drivers/usb/dwc3/debugfs.c
>> >> +++ b/drivers/usb/dwc3/debugfs.c
>> >> @@ -535,7 +535,8 @@ static ssize_t dwc3_testmode_write(struct file *file,
>> >>               testmode = 0;
>> >>
>> >>       spin_lock_irqsave(&dwc->lock, flags);
>> >> -     dwc3_gadget_set_test_mode(dwc, testmode);
>> >> +     if (dwc3_gadget_set_test_mode(dwc, testmode))
>> >> +             dev_dbg(dwc->dev, "host: Invalid request\n");
>> >>       spin_unlock_irqrestore(&dwc->lock, flags);
>> >>
>> >>       return count;
>> >
>> > wrong, if you don't have gadget mode, you just don't create this file.
>> >
>>
>> dwc3-core makes call to dwc3_debugfs_init() invariably depending on DEBUG_FS.
>> Will this not go ahead and create this file ?
>> I think i am missing here something.  :-(
>
> right, you can change dwc3_debugfs_init() to take into account the fact
> that you're a gadget/drd or host-only.
>
> In case of host only, you stil want regdump to be available :-)
>

So in dwc3_debugfs_init() we shall actually create just 'regdump' file
in case of host only mode, otherwise keep the dwc3_debugfs_init() happy
with creating other files too.
Right ?



-- 
Thanks & Regards
Vivek
