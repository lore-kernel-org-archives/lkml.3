Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab3GRJ2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 05:28:24 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:58890 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758004Ab3GRJ2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 05:28:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130718084041.GE11251@arwen.pp.htv.fi>
References: <CA+k=oDzG+R-ei5WGxP8L1Od6VWTK9SgWcXHNjd89u6+b2bECkQ@mail.gmail.com>
	<20130715165209.GA6000@kroah.com>
	<CA+k=oDzZ5sf_wFMUvE_vkkqRQaOV0P3vWP99tDpoZkrwMN7Q+A@mail.gmail.com>
	<20130716063117.GA30320@kroah.com>
	<20130717075706.GC5291@arwen.pp.htv.fi>
	<CA+k=oDza-oN++KCYtVMD0V62xgkJ3ctUOmzNkaYYYhXuKtaWKQ@mail.gmail.com>
	<20130717132736.GA7614@arwen.pp.htv.fi>
	<CA+k=oDy=_CWMCfcGfy=wbhn0BDm45Y8wS=wpe6SviPcnetntTw@mail.gmail.com>
	<20130718084041.GE11251@arwen.pp.htv.fi>
Date: Thu, 18 Jul 2013 17:28:19 +0800
Message-ID: <CA+k=oDxbu09FoQdOVUQhK-Q4hKuPYyiYDS1akoE2kggN7echgA@mail.gmail.com>
Subject: Re: [PATCH] usb: udc: add gadget state kobject uevent
From: Rong Wang <wr011235813@gmail.com>
To: balbi@ti.com
Cc: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rong.Wang@csr.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

Thanks, I'll test the patch.

But sysfs_notify(&gadget->dev.kobj, NULL, "status"), status or state ?
I notice that DEVICE_ATTR(state, S_IRUGO, usb_gadget_state_show, NULL)

On Thu, Jul 18, 2013 at 4:40 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Thu, Jul 18, 2013 at 04:33:43PM +0800, Rong Wang wrote:
>> On Wed, Jul 17, 2013 at 9:27 PM, Felipe Balbi <balbi@ti.com> wrote:
>> > On Wed, Jul 17, 2013 at 09:04:54PM +0800, Rong Wang wrote:
>> >> Hi Felipe,
>> >>
>> >> On Wed, Jul 17, 2013 at 3:57 PM, Felipe Balbi <balbi@ti.com> wrote:
>> >> > Hi,
>> >> >
>> >> > On Mon, Jul 15, 2013 at 11:31:17PM -0700, Greg KH wrote:
>> >> >> > The question is since we default GADGET, so the g_mass_storage.ko is
>> >> >> > installed early but connecting to a host PC
>> >> >> > is randomly, But the udev has no idea when a host PC connects our device.
>> >> >> >
>> >> >> > So we consider it's reasonable to let the udev know the GADGET device state.
>> >> >> > Is there any alternative to our question?
>> >> >>
>> >> >> I thought we already export events for gadget device states, have you
>> >> >> looked for them?  I can't dig through the code at the moment, but this
>> >> >> seems like a pretty common issue...
>> >> >>
>> >> >> Felipe, any ideas?
>> >> >
>> >> > we already expose that in sysfs. IIRC udev can act on sysfs changes,
>> >> > no ?
>> >>
>> >> I do not know if udev can polling sysfs file content change. I'll study this.
>> >>
>> >> But the change is triggered by calling usb_gadget_set_state, and I find
>> >> composite framework do not call this. Then we should do this common work
>> >> in every udc driver?
>> >
>> > yes. Only the UDC driver knows when the controller is moving among those
>> > states.
>>
>> OK. I got that.
>>
>> But I think it may be more reasonable for the udc driver to maintain a
>> work queue
>> to handle the state change since this operation mostly happen in ISR ?
>
> And that's the patch I want to test. Adding a workqueue to every single
> UDC will be too much, so I tried to hide it in udc-core.c. I agree with
> you we need to pass the sysfs_notification to a separate workqueue
> though. If you can test the patch below, that would be great.
>
> commit d32521bd775d48b600e67f23d363d70f71597ffd
> Author: Felipe Balbi <balbi@ti.com>
> Date:   Wed Jul 17 11:09:49 2013 +0300
>
>     usb: gadget: udc-core: move sysfs_notify() to a workqueue
>
>     usb_gadget_set_state() will call sysfs_notify()
>     which might sleep. Some users might want to call
>     usb_gadget_set_state() from the very IRQ handler
>     which actually changes the gadget state.
>
>     Instead of having every UDC driver add their own
>     workqueue for such a simple notification, we're
>     adding it generically to our struct usb_gadget,
>     so the details are hidden from all UDC drivers.
>
>     Signed-off-by: Felipe Balbi <balbi@ti.com>
>
> diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-core.c
> index ffd8fa5..b0d91b1 100644
> --- a/drivers/usb/gadget/udc-core.c
> +++ b/drivers/usb/gadget/udc-core.c
> @@ -23,6 +23,7 @@
>  #include <linux/list.h>
>  #include <linux/err.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/workqueue.h>
>
>  #include <linux/usb/ch9.h>
>  #include <linux/usb/gadget.h>
> @@ -101,11 +102,18 @@ EXPORT_SYMBOL_GPL(usb_gadget_unmap_request);
>
>  /* ------------------------------------------------------------------------- */
>
> +static void usb_gadget_state_work(struct work_struct *work)
> +{
> +       struct usb_gadget       *gadget = work_to_gadget(work);
> +
> +       sysfs_notify(&gadget->dev.kobj, NULL, "status");
> +}
> +
>  void usb_gadget_set_state(struct usb_gadget *gadget,
>                 enum usb_device_state state)
>  {
>         gadget->state = state;
> -       sysfs_notify(&gadget->dev.kobj, NULL, "status");
> +       schedule_work(&gadget->work);
>  }
>  EXPORT_SYMBOL_GPL(usb_gadget_set_state);
>
> @@ -192,6 +200,7 @@ int usb_add_gadget_udc_release(struct device *parent, struct usb_gadget *gadget,
>                 goto err1;
>
>         dev_set_name(&gadget->dev, "gadget");
> +       INIT_WORK(&gadget->work, usb_gadget_state_work);
>         gadget->dev.parent = parent;
>
>         dma_set_coherent_mask(&gadget->dev, parent->coherent_dma_mask);
> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
> index f1b0dca..942ef5e 100644
> --- a/include/linux/usb/gadget.h
> +++ b/include/linux/usb/gadget.h
> @@ -22,6 +22,7 @@
>  #include <linux/slab.h>
>  #include <linux/scatterlist.h>
>  #include <linux/types.h>
> +#include <linux/workqueue.h>
>  #include <linux/usb/ch9.h>
>
>  struct usb_ep;
> @@ -475,6 +476,7 @@ struct usb_gadget_ops {
>
>  /**
>   * struct usb_gadget - represents a usb slave device
> + * @work: (internal use) Workqueue to be used for sysfs_notify()
>   * @ops: Function pointers used to access hardware-specific operations.
>   * @ep0: Endpoint zero, used when reading or writing responses to
>   *     driver setup() requests
> @@ -520,6 +522,7 @@ struct usb_gadget_ops {
>   * device is acting as a B-Peripheral (so is_a_peripheral is false).
>   */
>  struct usb_gadget {
> +       struct work_struct              work;
>         /* readonly to gadget driver */
>         const struct usb_gadget_ops     *ops;
>         struct usb_ep                   *ep0;
> @@ -538,6 +541,7 @@ struct usb_gadget {
>         unsigned                        out_epnum;
>         unsigned                        in_epnum;
>  };
> +#define work_to_gadget(w)      (container_of((w), struct usb_gadget, work))
>
>  static inline void set_gadget_data(struct usb_gadget *gadget, void *data)
>         { dev_set_drvdata(&gadget->dev, data); }
>
> --
> balbi
