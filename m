Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbaDGQhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 12:37:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52436 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637AbaDGQhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 12:37:45 -0400
Date: Mon, 7 Apr 2014 11:35:38 -0500
From: Felipe Balbi <balbi@ti.com>
To: sundeep subbaraya <sundeep.lkml@gmail.com>
CC: <balbi@ti.com>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michals@xilinx.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Subject: Re: Fwd: [PATCH v2 2/2] usb: gadget: Add xilinx axi usb2 device
 support
Message-ID: <20140407163538.GD20228@saruman.home>
Reply-To: <balbi@ti.com>
References: <1396510519-8555-1-git-send-email-sbhatta@xilinx.com>
 <113d0620-4003-417d-806b-0b79ae692829@VA3EHSMHS023.ehs.local>
 <20140403145853.GD14162@saruman.home>
 <CALHRZupk2ywMNKjzAtCPgg=9-KsDqrVBAKFNoHOoSJOQ4FDJkA@mail.gmail.com>
 <CALHRZuqtEpK98vTS=RQ+f3yu-L_M1SnZSJOMTaBnDT8z+YqccQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3Gf/FFewwPeBMqCJ"
Content-Disposition: inline
In-Reply-To: <CALHRZuqtEpK98vTS=RQ+f3yu-L_M1SnZSJOMTaBnDT8z+YqccQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3Gf/FFewwPeBMqCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Apr 07, 2014 at 02:36:13PM +0530, sundeep subbaraya wrote:
> >> +/**
> >> + * xudc_wrstatus - Sets up the usb device status stages.
> >> + * @udc: pointer to the usb device controller structure.
> >> + */
> >> +static void xudc_wrstatus(struct xusb_udc *udc)
> >> +{
> >> +     u32 epcfgreg;
> >> +
> >> +     epcfgreg =3D udc->read_fn(udc->base_address +
> >> +                             udc->ep[XUSB_EP_NUMBER_ZERO].offset)|
> >> +                             XUSB_EP_CFG_DATA_TOGGLE_MASK;
> >
> > are you really trying to mask here ? If you're trying to mask you should
> > be using a bitwise and.
>=20
> This is used for making DATA1 packet for status stage during control tran=
sfers.
> IP has internally a weak check for alternating between DATA0 and DATA1
> packets using
> this bit. Firmware can set this bit to send a DATA1 packet. As we
> always need to send DATA1
> for status stage, we force IP to send DATA1 packet whatever maybe in this
> bit because of alternating behavior. Is this is confusing for the name
> *_TOGGLE_MASK ?

yeah, I guess it was the suffix _MASK, nevermind then ;-)

> >> +static int xudc_get_frame(struct usb_gadget *gadget)
> >> +{
> >> +
> >> +     struct xusb_udc *udc =3D to_udc(gadget);
> >> +     unsigned long flags;
> >> +     int retval;
> >> +
> >> +     if (!gadget)
> >> +             return -ENODEV;
> >
> > oh boy... so you first deref gadget, then you check for it ?
>=20
> Yes i too had this doubt after looking at some of the functions (like
> ep_queue) of other controller drivers.

if there are other gadget drivers doing this, they're wrong and need to
be fixed.

> I tested sending a NULL to container_of macro I see no NULL exception.

yeah, container_of() will *always* return a valid pointer, even if it's
argument is NULL.

> Hence using container_of
> macro first and then checking for NULL input is fine. If you insist

no, it's not. You'd waste cpu cycles with pointer arithmetic for no
reason.

> this i need to change code at other
> places too.

yes.

> >> +static int xudc_wakeup(struct usb_gadget *gadget)
> >> +{
> >> +     struct xusb_udc *udc =3D to_udc(gadget);
> >> +     u32             crtlreg;
> >> +     int             status =3D -EINVAL;
> >> +     unsigned long   flags;
> >> +
> >> +     spin_lock_irqsave(&udc->lock, flags);
> >> +
> >> +     /* Remote wake up not enabled by host */
> >> +     if (!udc->remote_wkp)
> >> +             goto done;
> >> +
> >> +     crtlreg =3D udc->read_fn(udc->base_address + XUSB_CONTROL_OFFSET=
);
> >> +     /* set remote wake up bit */
> >> +     udc->write_fn(udc->base_address, XUSB_CONTROL_OFFSET, crtlreg |
> >> +                     XUSB_CONTROL_USB_RMTWAKE_MASK);
> >> +     /* wait for a while and reset remote wake up bit */
> >> +     mdelay(2);
> >
> > why 2 ms ? why not 5 ? why not 1 ? shouldn't you be polling a bit in a
> > register or something ?
>=20
> IP datasheet says writing Remote wake bit to this register will send
> remote wake up
> signalling to host immediately and this bit will not be cleared by
> hardware, firmware has
> to clear it. There is no bit for polling.

then you need a better comment stating this detail.

> >> +static const struct usb_gadget_ops xusb_udc_ops =3D {
> >> +     .get_frame =3D xudc_get_frame,
> >> +     .wakeup =3D xudc_wakeup,
> >> +     .udc_start =3D xudc_start,
> >> +     .udc_stop  =3D xudc_stop,
> >
> > no pullup ??? What gives ? This HW doesn't support it ? really ?
>=20
> Yes, there is no pull up. writing to control register to start udc is
> sufficient for this IP.

right, but is there a bit inside control register which actually starts
the IP ? You might want to move that to ->pullup(), see how we did on
drivers/usb/dwc3/gadget.c::dwc3_gadget_pullup(); we're basically using
that to control RUN/STOP bit in DCTL register. That bit has two
functions: a) actually enable the ip; b) connect data pullups.

You can actually see with a scope that the line goes high and low when
you mess with that bit.

The reason I suggest this is because you don't want to let your host see
a connection until your gadget driver is registered and ready to go and
that's what the pullup method would guarantee.

> >> +     }
> >> +     if (intrstatus & XUSB_STATUS_SUSPEND_MASK) {
> >> +
> >> +             DBG("Suspend\n");
> >> +
> >> +             /* Enable the reset and resume */
> >> +             intrreg =3D udc->read_fn(udc->base_address + XUSB_IER_OF=
FSET);
> >> +             intrreg |=3D XUSB_STATUS_RESET_MASK | XUSB_STATUS_RESUME=
_MASK;
> >> +             udc->write_fn(udc->base_address, XUSB_IER_OFFSET, intrre=
g);
> >> +             udc->usb_state =3D USB_STATE_SUSPENDED;
> >> +
> >> +             if (udc->driver->suspend)
> >> +                     udc->driver->suspend(&udc->gadget);
> >> +     }
> >
> > when are you going to call driver->resume() ??
>=20
> When an interrupt occurs we first check if udc->usb_state =3D
> USB_STATE_SUSPENDED,
> if yes driver->resume is called. Also if Resume bit is set then it is
> cleared too. Resume status bit is set
> when device is resumed by host after device sends Remote wakeup
> signalling to host.

<snip>

> >> +static irqreturn_t xudc_irq(int irq, void *_udc)
> >> +{
> >> +     struct xusb_udc *udc =3D _udc;
> >> +     u32 intrstatus;
> >> +     u32 intrreg;
> >> +     u8 index;
> >> +     u32 bufintr;
> >> +
> >> +     spin_lock(&(udc->lock));
> >> +
> >> +     intrreg =3D udc->read_fn(udc->base_address + XUSB_IER_OFFSET);
> >> +     intrreg &=3D ~XUSB_STATUS_INTR_EVENT_MASK;
> >> +     udc->write_fn(udc->base_address, XUSB_IER_OFFSET, intrreg);
> >> +
> >> +     /* Read the Interrupt Status Register.*/
> >> +     intrstatus =3D udc->read_fn(udc->base_address + XUSB_STATUS_OFFS=
ET);
> >> +
> >> +     if (udc->usb_state =3D=3D USB_STATE_SUSPENDED) {
> >> +
> >> +             DBG("Resume\n");
> >> +
> >> +             if (intrstatus & XUSB_STATUS_RESUME_MASK) {
> >> +                     /* Enable the reset and suspend */
> >> +                     intrreg =3D udc->read_fn(udc->base_address +
> >> +                                             XUSB_IER_OFFSET);
> >> +                     intrreg |=3D XUSB_STATUS_RESET_MASK |
> >> +                                     XUSB_STATUS_SUSPEND_MASK;
> >> +                     udc->write_fn(udc->base_address, XUSB_IER_OFFSET,
> >> +                                     intrreg);
> >> +             }
> >> +             udc->usb_state =3D 0;
> >> +
> >> +             if (udc->driver->resume)
> >> +                     udc->driver->resume(&udc->gadget);

this is wrong, note that you would call ->resume() *every time*
usb_state =3D=3D SUSPENDED and there's an interrupt. This means that if
gadget is suspended and you remove the cable, then you first call
->resume() and then ->disconnect().

> Here. calling driver->resume.

Here's what I would do:

if (intrstatus & XUSB_STATUS_RESUME_MASK) {
	bool condition =3D udc->usb_state !=3D USB_STATE_SUSPENDED;
	dev_WARN_ONCE(dev, condition, "Resume IRQ while not suspended\n");

	/* Enable the reset and suspend */
	intrreg =3D udc->read_fn(udc->base_address + XUSB_IER_OFFSET);
	intrreg |=3D XUSB_STATUS_RESET_MASK | XUSB_STATUS_SUSPEND_MASK;
	udc->write_fn(udc->base_address, XUSB_IER_OFFSET, intrreg);

	if (udc->driver->resume)
		udc->driver_resume(&udc->gadget);
}


> >> +     udc->write_fn(udc->base_address, XUSB_TESTMODE_OFFSET, 0);
> >> +
> >> +     xudc_reinit(udc);
> >> +
> >> +     /* Set device address to 0.*/
> >> +     udc->write_fn(udc->base_address, XUSB_ADDRESS_OFFSET, 0);
> >> +
> >> +     ret =3D usb_add_gadget_udc(&pdev->dev, &udc->gadget);
> >> +     if (ret)
> >> +             goto fail;
> >> +
> >> +     /* Enable the interrupts.*/
> >> +     udc->write_fn(udc->base_address, XUSB_IER_OFFSET,
> >> +                     XUSB_STATUS_GLOBAL_INTR_MASK | XUSB_STATUS_RESET=
_MASK |
> >> +                     XUSB_STATUS_SUSPEND_MASK |
> >> +                     XUSB_STATUS_RESUME_MASK |
> >
> > you're enabling resume IRQ but never handling it.
>=20
> it is handled in interrupt handler. Please take a look at xudc_irq.

it's mishandled.

--=20
balbi

--3Gf/FFewwPeBMqCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTQtPaAAoJEIaOsuA1yqRE6FMP/RVKeSgZ1oijvwWbXgnnzv/S
TqTR5j8xsFmYu9k6lAtQKUjCljvlYNxhXrTC9z55Ut1Hy9ug8pWPuzdwd6xjUYPd
nKlIfoGAbX/qWpvAwcBPWfY8eq15idFqt3M9xzE3Dk9q+XmklvC6aX0DckkoL4+G
6D2A92jH2SV1N7SwrWzIxKpHI7pfn/0igGnc9Ht4ggZz27iWMDaqbsJ3DaiW0Qvj
qC2iCVbKJ0gF9pP5aLZ/GMoLUB9two3uw2DzRm6zqsG/IXWXKIKtN4xW/Z+fr3lV
4s4HkTs1WafvY1eQQcfUmeklyYx0ORZIAmHAbMA60X8+1iumq80ANYeLp010FYy9
C+5Y0RR4XYBffF7wTRswSvdXyufF+LT4d0Btmdv2cXEzbjuMjKrl53lPXvXOu1WF
G+NgvTpP+M6Ex5ksttbx+DRdrtZau8/qIzWW/DT4BM08uNnLidmOOFC6IaIpSu7G
PR4DSP6DnKcoA2z7kBN+pUxGCyoO1vWb9EYsFr74B5P5VcvvQ7SaOZxBP9ovC+QE
KXdDFSqe+N9IFwUy1pYii2yXZRb087PA6GZR5ohD6c5rQ7Afuru8xgWE0U81o6k5
7qrdeBnqcegtb6v0xSXv4vNObG0o1tmbWibm6fe0AjdkKnHcXbsmisz4QBPG9ltL
eo+fzgVmc1p6voVJydPH
=ud8Z
-----END PGP SIGNATURE-----

--3Gf/FFewwPeBMqCJ--
