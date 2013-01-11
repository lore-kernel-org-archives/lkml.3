Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab3AKNn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:43:59 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:62732 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab3AKNn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:43:57 -0500
MIME-Version: 1.0
In-Reply-To: <20130110130238.GW28920@arwen.pp.htv.fi>
References: <1356357513-8892-1-git-send-email-gautam.vivek@samsung.com>
	<20130110130238.GW28920@arwen.pp.htv.fi>
Date: Fri, 11 Jan 2013 19:13:55 +0530
Message-ID: <CAFp+6iHEJvCPHbSvqYhjuTjzvkKQVuKz8f8TupqFcZ9gdvpt-A@mail.gmail.com>
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

Hi Felipe,


On Thu, Jan 10, 2013 at 6:32 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Mon, Dec 24, 2012 at 07:28:33PM +0530, Vivek Gautam wrote:
>> DWC3 controller curretly depends on CONFIG_USB and CONFIG_USB_GADGET.
>> Some hardware may like to use only host feature on dwc3.
>> So, removing the dependency of USB_DWC3 on USB_GADGET
>> and further modulating the dwc3 core to enable gadget features
>> only with USB_GADGET.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> CC: Doug Anderson <dianders@chromium.org>
>
> right, right... Eventually we need to do it, but you're only making
> gadget side optional. Host side should be optional too, but then you
> need to make sure we don't build dwc3 without gadget and host.
>

Yes, true we need to make host side also optional, build dwc3 only when
either of host or gadget are built.

> Maybe make a mode selection for Host-only, Peripheral-only, Dual-Role
> Device ??
>

True this will be good idea to use modes: host only, gadget only or dual role.
May be the platform glue layers can use them later to put the controller
in a specific mode ?

> More comments below...
>
>> diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
>> index f6a6e07..b70dcf1 100644
>> --- a/drivers/usb/dwc3/Kconfig
>> +++ b/drivers/usb/dwc3/Kconfig
>> @@ -1,7 +1,7 @@
>>  config USB_DWC3
>>       tristate "DesignWare USB3 DRD Core Support"
>> -     depends on (USB && USB_GADGET)
>> -     select USB_OTG_UTILS
>> +     depends on USB
>> +     select USB_OTG_UTILS if USB_GADGET
>
> we want USB_OTG_UTILS also on host-only builds because host side,
> eventually, will have to learn how to control its PHYs.
>

Ok.

>>       select USB_XHCI_PLATFORM if USB_SUPPORT && USB_XHCI_HCD
>>       help
>>         Say Y or M here if your system has a Dual Role SuperSpeed
>> diff --git a/drivers/usb/dwc3/Makefile b/drivers/usb/dwc3/Makefile
>> index 4502648..8f469cb 100644
>> --- a/drivers/usb/dwc3/Makefile
>> +++ b/drivers/usb/dwc3/Makefile
>> @@ -5,7 +5,7 @@ obj-$(CONFIG_USB_DWC3)                        += dwc3.o
>>
>>  dwc3-y                                       := core.o
>>  dwc3-y                                       += host.o
>> -dwc3-y                                       += gadget.o ep0.o
>> +obj-$(CONFIG_USB_GADGET)               += gadget.o ep0.o
>
> this is wrong. CONFIG_USB_GADGET is tristate, so this should be:
>
> ifneq($(CONFIG_USB_GADGET),)
>  dwc3-y += gadget.o ep0.o
> endif
>
> or something similar
>

True, missed taking into account that CONFIG_USB_GADGET is tristate :-(
Will amend this as suggested.

>> diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
>> index 4999563..4dc7ef2 100644
>> --- a/drivers/usb/dwc3/core.h
>> +++ b/drivers/usb/dwc3/core.h
>> @@ -865,7 +865,14 @@ int dwc3_gadget_resize_tx_fifos(struct dwc3 *dwc);
>>  int dwc3_host_init(struct dwc3 *dwc);
>>  void dwc3_host_exit(struct dwc3 *dwc);
>>
>> +#ifdef CONFIG_USB_GADGET
>
> not taking into account module builds.
>

ditto

>>  int dwc3_gadget_init(struct dwc3 *dwc);
>>  void dwc3_gadget_exit(struct dwc3 *dwc);
>> +#else
>> +static inline int dwc3_gadget_init(struct dwc3 *dwc)
>> +{ return -EINVAL; }
>> +static inline void dwc3_gadget_exit(struct dwc3 *dwc)
>> +{ }
>> +#endif
>>
>>  #endif /* __DRIVERS_USB_DWC3_CORE_H */
>> diff --git a/drivers/usb/dwc3/debugfs.c b/drivers/usb/dwc3/debugfs.c
>> index d4a30f1..553bbaa 100644
>> --- a/drivers/usb/dwc3/debugfs.c
>> +++ b/drivers/usb/dwc3/debugfs.c
>> @@ -535,7 +535,8 @@ static ssize_t dwc3_testmode_write(struct file *file,
>>               testmode = 0;
>>
>>       spin_lock_irqsave(&dwc->lock, flags);
>> -     dwc3_gadget_set_test_mode(dwc, testmode);
>> +     if (dwc3_gadget_set_test_mode(dwc, testmode))
>> +             dev_dbg(dwc->dev, "host: Invalid request\n");
>>       spin_unlock_irqrestore(&dwc->lock, flags);
>>
>>       return count;
>
> wrong, if you don't have gadget mode, you just don't create this file.
>

dwc3-core makes call to dwc3_debugfs_init() invariably depending on DEBUG_FS.
Will this not go ahead and create this file ?
I think i am missing here something.  :-(

>> @@ -638,7 +639,8 @@ static ssize_t dwc3_link_state_write(struct file *file,
>>               return -EINVAL;
>>
>>       spin_lock_irqsave(&dwc->lock, flags);
>> -     dwc3_gadget_set_link_state(dwc, state);
>> +     if (dwc3_gadget_set_link_state(dwc, state))
>> +             dev_dbg(dwc->dev, "host: Invalid request\n");
>
> likewise.
>
>>       spin_unlock_irqrestore(&dwc->lock, flags);
>>
>>       return count;
>> diff --git a/drivers/usb/dwc3/gadget.h b/drivers/usb/dwc3/gadget.h
>> index 99e6d72..28e82db 100644
>> --- a/drivers/usb/dwc3/gadget.h
>> +++ b/drivers/usb/dwc3/gadget.h
>> @@ -105,8 +105,16 @@ static inline void dwc3_gadget_move_request_queued(struct dwc3_request *req)
>>  void dwc3_gadget_giveback(struct dwc3_ep *dep, struct dwc3_request *req,
>>               int status);
>>
>> +#ifdef CONFIG_USB_GADGET
>
> not taking into account CONFIG_USB_GADGET=m
>
missed taking into account that CONFIG_USB_GADGET is tristate :-(

Will amend this patch accordingly.


-- 
Thanks & Regards
Vivek
