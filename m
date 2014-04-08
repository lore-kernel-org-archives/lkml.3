Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058AbaDHQBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:01:34 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:50689 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525AbaDHQBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:01:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140407163538.GD20228@saruman.home>
References: <1396510519-8555-1-git-send-email-sbhatta@xilinx.com>
	<113d0620-4003-417d-806b-0b79ae692829@VA3EHSMHS023.ehs.local>
	<20140403145853.GD14162@saruman.home>
	<CALHRZupk2ywMNKjzAtCPgg=9-KsDqrVBAKFNoHOoSJOQ4FDJkA@mail.gmail.com>
	<CALHRZuqtEpK98vTS=RQ+f3yu-L_M1SnZSJOMTaBnDT8z+YqccQ@mail.gmail.com>
	<20140407163538.GD20228@saruman.home>
Date: Tue, 8 Apr 2014 21:31:29 +0530
Message-ID: <CALHRZuotnNf-sCaeQJQ_PnSVET=+GvZ_PmvF7E3oEg8bKZ8a2Q@mail.gmail.com>
Subject: Re: Fwd: [PATCH v2 2/2] usb: gadget: Add xilinx axi usb2 device support
From: sundeep subbaraya <sundeep.lkml@gmail.com>
To: balbi@ti.com
Cc: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michals@xilinx.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2014 at 10:05 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Mon, Apr 07, 2014 at 02:36:13PM +0530, sundeep subbaraya wrote:
>> >> +/**
>> >> + * xudc_wrstatus - Sets up the usb device status stages.
>> >> + * @udc: pointer to the usb device controller structure.
>> >> + */
>> >> +static void xudc_wrstatus(struct xusb_udc *udc)
>> >> +{
>> >> +     u32 epcfgreg;
>> >> +
>> >> +     epcfgreg = udc->read_fn(udc->base_address +
>> >> +                             udc->ep[XUSB_EP_NUMBER_ZERO].offset)|
>> >> +                             XUSB_EP_CFG_DATA_TOGGLE_MASK;
>> >
>> > are you really trying to mask here ? If you're trying to mask you should
>> > be using a bitwise and.
>>
>> This is used for making DATA1 packet for status stage during control transfers.
>> IP has internally a weak check for alternating between DATA0 and DATA1
>> packets using
>> this bit. Firmware can set this bit to send a DATA1 packet. As we
>> always need to send DATA1
>> for status stage, we force IP to send DATA1 packet whatever maybe in this
>> bit because of alternating behavior. Is this is confusing for the name
>> *_TOGGLE_MASK ?
>
> yeah, I guess it was the suffix _MASK, nevermind then ;-)

OK :)

>
>> >> +static int xudc_get_frame(struct usb_gadget *gadget)
>> >> +{
>> >> +
>> >> +     struct xusb_udc *udc = to_udc(gadget);
>> >> +     unsigned long flags;
>> >> +     int retval;
>> >> +
>> >> +     if (!gadget)
>> >> +             return -ENODEV;
>> >
>> > oh boy... so you first deref gadget, then you check for it ?
>>
>> Yes i too had this doubt after looking at some of the functions (like
>> ep_queue) of other controller drivers.
>
> if there are other gadget drivers doing this, they're wrong and need to
> be fixed.
>
>> I tested sending a NULL to container_of macro I see no NULL exception.
>
> yeah, container_of() will *always* return a valid pointer, even if it's
> argument is NULL.
>
>> Hence using container_of
>> macro first and then checking for NULL input is fine. If you insist
>
> no, it's not. You'd waste cpu cycles with pointer arithmetic for no
> reason.
>
>> this i need to change code at other
>> places too.
>
> yes.

ok will modify

>
>> >> +static int xudc_wakeup(struct usb_gadget *gadget)
>> >> +{
>> >> +     struct xusb_udc *udc = to_udc(gadget);
>> >> +     u32             crtlreg;
>> >> +     int             status = -EINVAL;
>> >> +     unsigned long   flags;
>> >> +
>> >> +     spin_lock_irqsave(&udc->lock, flags);
>> >> +
>> >> +     /* Remote wake up not enabled by host */
>> >> +     if (!udc->remote_wkp)
>> >> +             goto done;
>> >> +
>> >> +     crtlreg = udc->read_fn(udc->base_address + XUSB_CONTROL_OFFSET);
>> >> +     /* set remote wake up bit */
>> >> +     udc->write_fn(udc->base_address, XUSB_CONTROL_OFFSET, crtlreg |
>> >> +                     XUSB_CONTROL_USB_RMTWAKE_MASK);
>> >> +     /* wait for a while and reset remote wake up bit */
>> >> +     mdelay(2);
>> >
>> > why 2 ms ? why not 5 ? why not 1 ? shouldn't you be polling a bit in a
>> > register or something ?
>>
>> IP datasheet says writing Remote wake bit to this register will send
>> remote wake up
>> signalling to host immediately and this bit will not be cleared by
>> hardware, firmware has
>> to clear it. There is no bit for polling.
>
> then you need a better comment stating this detail.

sure

>
>> >> +static const struct usb_gadget_ops xusb_udc_ops = {
>> >> +     .get_frame = xudc_get_frame,
>> >> +     .wakeup = xudc_wakeup,
>> >> +     .udc_start = xudc_start,
>> >> +     .udc_stop  = xudc_stop,
>> >
>> > no pullup ??? What gives ? This HW doesn't support it ? really ?
>>
>> Yes, there is no pull up. writing to control register to start udc is
>> sufficient for this IP.
>
> right, but is there a bit inside control register which actually starts
> the IP ? You might want to move that to ->pullup(), see how we did on
> drivers/usb/dwc3/gadget.c::dwc3_gadget_pullup(); we're basically using
> that to control RUN/STOP bit in DCTL register. That bit has two
> functions: a) actually enable the ip; b) connect data pullups.
>
> You can actually see with a scope that the line goes high and low when
> you mess with that bit.
>
> The reason I suggest this is because you don't want to let your host see
> a connection until your gadget driver is registered and ready to go and
> that's what the pullup method would guarantee.

No.There are only two bits in Control register, one for Ready bit, another for
sending remote wakeup and remaining are reserved as zeroes. Until ready is
set host do not see the gadget.

>
>> >> +     }
>> >> +     if (intrstatus & XUSB_STATUS_SUSPEND_MASK) {
>> >> +
>> >> +             DBG("Suspend\n");
>> >> +
>> >> +             /* Enable the reset and resume */
>> >> +             intrreg = udc->read_fn(udc->base_address + XUSB_IER_OFFSET);
>> >> +             intrreg |= XUSB_STATUS_RESET_MASK | XUSB_STATUS_RESUME_MASK;
>> >> +             udc->write_fn(udc->base_address, XUSB_IER_OFFSET, intrreg);
>> >> +             udc->usb_state = USB_STATE_SUSPENDED;
>> >> +
>> >> +             if (udc->driver->suspend)
>> >> +                     udc->driver->suspend(&udc->gadget);
>> >> +     }
>> >
>> > when are you going to call driver->resume() ??
>>
>> When an interrupt occurs we first check if udc->usb_state =
>> USB_STATE_SUSPENDED,
>> if yes driver->resume is called. Also if Resume bit is set then it is
>> cleared too. Resume status bit is set
>> when device is resumed by host after device sends Remote wakeup
>> signalling to host.
>
> <snip>
>
>> >> +static irqreturn_t xudc_irq(int irq, void *_udc)
>> >> +{
>> >> +     struct xusb_udc *udc = _udc;
>> >> +     u32 intrstatus;
>> >> +     u32 intrreg;
>> >> +     u8 index;
>> >> +     u32 bufintr;
>> >> +
>> >> +     spin_lock(&(udc->lock));
>> >> +
>> >> +     intrreg = udc->read_fn(udc->base_address + XUSB_IER_OFFSET);
>> >> +     intrreg &= ~XUSB_STATUS_INTR_EVENT_MASK;
>> >> +     udc->write_fn(udc->base_address, XUSB_IER_OFFSET, intrreg);
>> >> +
>> >> +     /* Read the Interrupt Status Register.*/
>> >> +     intrstatus = udc->read_fn(udc->base_address + XUSB_STATUS_OFFSET);
>> >> +
>> >> +     if (udc->usb_state == USB_STATE_SUSPENDED) {
>> >> +
>> >> +             DBG("Resume\n");
>> >> +
>> >> +             if (intrstatus & XUSB_STATUS_RESUME_MASK) {
>> >> +                     /* Enable the reset and suspend */
>> >> +                     intrreg = udc->read_fn(udc->base_address +
>> >> +                                             XUSB_IER_OFFSET);
>> >> +                     intrreg |= XUSB_STATUS_RESET_MASK |
>> >> +                                     XUSB_STATUS_SUSPEND_MASK;
>> >> +                     udc->write_fn(udc->base_address, XUSB_IER_OFFSET,
>> >> +                                     intrreg);
>> >> +             }
>> >> +             udc->usb_state = 0;
>> >> +
>> >> +             if (udc->driver->resume)
>> >> +                     udc->driver->resume(&udc->gadget);
>
> this is wrong, note that you would call ->resume() *every time*
> usb_state == SUSPENDED and there's an interrupt. This means that if
> gadget is suspended and you remove the cable, then you first call
> ->resume() and then ->disconnect().
>
>> Here. calling driver->resume.
>
> Here's what I would do:
>
> if (intrstatus & XUSB_STATUS_RESUME_MASK) {
>         bool condition = udc->usb_state != USB_STATE_SUSPENDED;
>         dev_WARN_ONCE(dev, condition, "Resume IRQ while not suspended\n");
>
>         /* Enable the reset and suspend */
>         intrreg = udc->read_fn(udc->base_address + XUSB_IER_OFFSET);
>         intrreg |= XUSB_STATUS_RESET_MASK | XUSB_STATUS_SUSPEND_MASK;
>         udc->write_fn(udc->base_address, XUSB_IER_OFFSET, intrreg);
>
>         if (udc->driver->resume)
>                 udc->driver_resume(&udc->gadget);
> }

Resume Interrupt bit is set only when Resume happens by device sending
Remote wakeup.
I am assuming we need to call driver->resume for every
driver->suspend. Hence I implemented
like this. Please suggest me what needs to be done for this case.

>
>
>> >> +     udc->write_fn(udc->base_address, XUSB_TESTMODE_OFFSET, 0);
>> >> +
>> >> +     xudc_reinit(udc);
>> >> +
>> >> +     /* Set device address to 0.*/
>> >> +     udc->write_fn(udc->base_address, XUSB_ADDRESS_OFFSET, 0);
>> >> +
>> >> +     ret = usb_add_gadget_udc(&pdev->dev, &udc->gadget);
>> >> +     if (ret)
>> >> +             goto fail;
>> >> +
>> >> +     /* Enable the interrupts.*/
>> >> +     udc->write_fn(udc->base_address, XUSB_IER_OFFSET,
>> >> +                     XUSB_STATUS_GLOBAL_INTR_MASK | XUSB_STATUS_RESET_MASK |
>> >> +                     XUSB_STATUS_SUSPEND_MASK |
>> >> +                     XUSB_STATUS_RESUME_MASK |
>> >
>> > you're enabling resume IRQ but never handling it.
>>
>> it is handled in interrupt handler. Please take a look at xudc_irq.
>
> it's mishandled.
>
> --
> balbi

Thanks for the comments and I will work on next iteration.
Sundeep.B.S.
