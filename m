Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbaDHV0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 17:26:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57148 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324AbaDHV0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 17:26:32 -0400
Date: Tue, 8 Apr 2014 16:24:21 -0500
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
Message-ID: <20140408212421.GA1431@saruman.home>
Reply-To: <balbi@ti.com>
References: <1396510519-8555-1-git-send-email-sbhatta@xilinx.com>
 <113d0620-4003-417d-806b-0b79ae692829@VA3EHSMHS023.ehs.local>
 <20140403145853.GD14162@saruman.home>
 <CALHRZupk2ywMNKjzAtCPgg=9-KsDqrVBAKFNoHOoSJOQ4FDJkA@mail.gmail.com>
 <CALHRZuqtEpK98vTS=RQ+f3yu-L_M1SnZSJOMTaBnDT8z+YqccQ@mail.gmail.com>
 <20140407163538.GD20228@saruman.home>
 <CALHRZuotnNf-sCaeQJQ_PnSVET=+GvZ_PmvF7E3oEg8bKZ8a2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <CALHRZuotnNf-sCaeQJQ_PnSVET=+GvZ_PmvF7E3oEg8bKZ8a2Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 08, 2014 at 09:31:29PM +0530, sundeep subbaraya wrote:
> >> >> +static const struct usb_gadget_ops xusb_udc_ops =3D {
> >> >> +     .get_frame =3D xudc_get_frame,
> >> >> +     .wakeup =3D xudc_wakeup,
> >> >> +     .udc_start =3D xudc_start,
> >> >> +     .udc_stop  =3D xudc_stop,
> >> >
> >> > no pullup ??? What gives ? This HW doesn't support it ? really ?
> >>
> >> Yes, there is no pull up. writing to control register to start udc is
> >> sufficient for this IP.
> >
> > right, but is there a bit inside control register which actually starts
> > the IP ? You might want to move that to ->pullup(), see how we did on
> > drivers/usb/dwc3/gadget.c::dwc3_gadget_pullup(); we're basically using
> > that to control RUN/STOP bit in DCTL register. That bit has two
> > functions: a) actually enable the ip; b) connect data pullups.
> >
> > You can actually see with a scope that the line goes high and low when
> > you mess with that bit.
> >
> > The reason I suggest this is because you don't want to let your host see
> > a connection until your gadget driver is registered and ready to go and
> > that's what the pullup method would guarantee.
>=20
> No.There are only two bits in Control register, one for Ready bit, anothe=
r for
> sending remote wakeup and remaining are reserved as zeroes. Until ready is
> set host do not see the gadget.

so this READY bit is what you want to toggle on pullup().

> >> >> +     }
> >> >> +     if (intrstatus & XUSB_STATUS_SUSPEND_MASK) {
> >> >> +
> >> >> +             DBG("Suspend\n");
> >> >> +
> >> >> +             /* Enable the reset and resume */
> >> >> +             intrreg =3D udc->read_fn(udc->base_address + XUSB_IER=
_OFFSET);
> >> >> +             intrreg |=3D XUSB_STATUS_RESET_MASK | XUSB_STATUS_RES=
UME_MASK;
> >> >> +             udc->write_fn(udc->base_address, XUSB_IER_OFFSET, int=
rreg);
> >> >> +             udc->usb_state =3D USB_STATE_SUSPENDED;
> >> >> +
> >> >> +             if (udc->driver->suspend)
> >> >> +                     udc->driver->suspend(&udc->gadget);
> >> >> +     }
> >> >
> >> > when are you going to call driver->resume() ??
> >>
> >> When an interrupt occurs we first check if udc->usb_state =3D
> >> USB_STATE_SUSPENDED,
> >> if yes driver->resume is called. Also if Resume bit is set then it is
> >> cleared too. Resume status bit is set
> >> when device is resumed by host after device sends Remote wakeup
> >> signalling to host.
> >
> > <snip>
> >
> >> >> +static irqreturn_t xudc_irq(int irq, void *_udc)
> >> >> +{
> >> >> +     struct xusb_udc *udc =3D _udc;
> >> >> +     u32 intrstatus;
> >> >> +     u32 intrreg;
> >> >> +     u8 index;
> >> >> +     u32 bufintr;
> >> >> +
> >> >> +     spin_lock(&(udc->lock));
> >> >> +
> >> >> +     intrreg =3D udc->read_fn(udc->base_address + XUSB_IER_OFFSET);
> >> >> +     intrreg &=3D ~XUSB_STATUS_INTR_EVENT_MASK;
> >> >> +     udc->write_fn(udc->base_address, XUSB_IER_OFFSET, intrreg);
> >> >> +
> >> >> +     /* Read the Interrupt Status Register.*/
> >> >> +     intrstatus =3D udc->read_fn(udc->base_address + XUSB_STATUS_O=
FFSET);
> >> >> +
> >> >> +     if (udc->usb_state =3D=3D USB_STATE_SUSPENDED) {
> >> >> +
> >> >> +             DBG("Resume\n");
> >> >> +
> >> >> +             if (intrstatus & XUSB_STATUS_RESUME_MASK) {
> >> >> +                     /* Enable the reset and suspend */
> >> >> +                     intrreg =3D udc->read_fn(udc->base_address +
> >> >> +                                             XUSB_IER_OFFSET);
> >> >> +                     intrreg |=3D XUSB_STATUS_RESET_MASK |
> >> >> +                                     XUSB_STATUS_SUSPEND_MASK;
> >> >> +                     udc->write_fn(udc->base_address, XUSB_IER_OFF=
SET,
> >> >> +                                     intrreg);
> >> >> +             }
> >> >> +             udc->usb_state =3D 0;
> >> >> +
> >> >> +             if (udc->driver->resume)
> >> >> +                     udc->driver->resume(&udc->gadget);
> >
> > this is wrong, note that you would call ->resume() *every time*
> > usb_state =3D=3D SUSPENDED and there's an interrupt. This means that if
> > gadget is suspended and you remove the cable, then you first call
> > ->resume() and then ->disconnect().
> >
> >> Here. calling driver->resume.
> >
> > Here's what I would do:
> >
> > if (intrstatus & XUSB_STATUS_RESUME_MASK) {
> >         bool condition =3D udc->usb_state !=3D USB_STATE_SUSPENDED;
> >         dev_WARN_ONCE(dev, condition, "Resume IRQ while not suspended\n=
");
> >
> >         /* Enable the reset and suspend */
> >         intrreg =3D udc->read_fn(udc->base_address + XUSB_IER_OFFSET);
> >         intrreg |=3D XUSB_STATUS_RESET_MASK | XUSB_STATUS_SUSPEND_MASK;
> >         udc->write_fn(udc->base_address, XUSB_IER_OFFSET, intrreg);
> >
> >         if (udc->driver->resume)
> >                 udc->driver_resume(&udc->gadget);
> > }
>=20
> Resume Interrupt bit is set only when Resume happens by device sending
> Remote wakeup.

so if the host drives resume signalling there will be no interrupt ?
Well, this is wrong :-) The gadget driver needs to know about that too.
The host side can decide to wake you up.

> I am assuming we need to call driver->resume for every
> driver->suspend. Hence I implemented

no you don't, you need to let host wake you up or you drive remote
wakeup on the bus. The thing is: if the bus is suspended, there will be
*no* activity on the bus prior to host driving Resume signal or device
driving Remote Wakeup signal.

Enable RESUME IRQ on probe and never disable it, it'll be a lot easier
to implement it.

--=20
balbi

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTRGkEAAoJEIaOsuA1yqREihkP/j/g/Ckd7TZRahGge2T4LKuP
gm6rWwmh88h/jz0V9UKP2zf7SfhdDsiBmFLwn2C4i49ptAFzrzmDjYdpBMU9RmIp
SQDhHMO6z4zyrTeNKPnjwDHQYtNUpm68taud5IHbWBWpQQceYFk1qfmMlo0Cd3y+
TZ3V5GTBfL3NEI8w4VC5ZnYSqpF0SaaeFh+kVJPGadqLFenQMq8E9r7cUreMmYl9
JkxwlPlD4HQOyUXSNZ8BkA8CzuGeM2t4k6Gm5L+yl3XF9F13tGivK7+lMkSA3DzJ
NlLE8KVal+cOlBNJDP4Nusn+C8N2H3IuoWXCoPFKtbUDaQIDHuy8Z2DsbrHjWycO
LK2tqZFABJ2lOt0a++ArQHelqc/axxFe6ORt2oldzKinD4yAeYRjky/4ik1i5/yb
KjAkA0cNFrQMDE/TVFDr46ztZUiN2kskNRnwMm7G71Ir7Kgvc5TWkOG385pxHb9K
rhvVmzqEBCKFUuuVHaUcZkn26i+Dv+lhXf3F/t2uE5Rw+s8nBLWTlXDxdu96JRVB
p+rj+Vqtwk9CTFXKeML6vmsqfURti/3rxwruuB3tUi6AzEsR5W45Ui8T3cctyejB
lMlKp/kCSuL/zQ+Whj9h0CoSTRyooe/PFGRlws0YD80CPsnbgQ7yF3uBd6fJ3Tl2
h+XibIFBd3jQFmsC/odU
=JOis
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
