Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504AbaDQPD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:03:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55608 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbaDQPD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:03:28 -0400
Date: Thu, 17 Apr 2014 10:01:10 -0500
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
Subject: Re: [PATCH v2 2/2] usb: gadget: Add xilinx axi usb2 device support
Message-ID: <20140417150110.GB20889@saruman.home>
Reply-To: <balbi@ti.com>
References: <1396510519-8555-1-git-send-email-sbhatta@xilinx.com>
 <113d0620-4003-417d-806b-0b79ae692829@VA3EHSMHS023.ehs.local>
 <20140403145853.GD14162@saruman.home>
 <CALHRZuoCtEz5-CmU17dUpVS_MjSDdYVLMSvgXq_RwxLj_KJMDA@mail.gmail.com>
 <20140416180228.GK28035@saruman.home>
 <CALHRZuq6=TMryHtbjTw7rYoGwbu2w0BTdxiOA95HYS3_CG6vwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8GpibOaaTibBMecb"
Content-Disposition: inline
In-Reply-To: <CALHRZuq6=TMryHtbjTw7rYoGwbu2w0BTdxiOA95HYS3_CG6vwQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8GpibOaaTibBMecb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 17, 2014 at 03:01:37PM +0530, sundeep subbaraya wrote:
> Hi Felipe,
>=20
> On Wed, Apr 16, 2014 at 11:32 PM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Wed, Apr 16, 2014 at 04:09:28PM +0530, sundeep subbaraya wrote:
> >> Hi Felipe,
> >>
> >> On Thu, Apr 3, 2014 at 8:28 PM, Felipe Balbi <balbi@ti.com> wrote:
> >>
> >> >> +static int start_dma(struct xusb_ep *ep, u32 src, u32 dst, u32 len=
gth)
> >> >
> >> > please prepend this with xudc_, it makes tracing a lot easier.
> >> >
> >> >> +{
> >> >> +     struct xusb_udc *udc;
> >> >> +     int rc =3D 0;
> >> >> +     unsigned long timeout;
> >> >> +
> >> >> +     udc =3D ep->udc;
> >> >> +     /*
> >> >> +      * Set the addresses in the DMA source and
> >> >> +      * destination registers and then set the length
> >> >> +      * into the DMA length register.
> >> >> +      */
> >> >> +     udc->write_fn(udc->base_address, XUSB_DMA_DSAR_ADDR_OFFSET, s=
rc);
> >> >> +     udc->write_fn(udc->base_address, XUSB_DMA_DDAR_ADDR_OFFSET, d=
st);
> >> >> +     udc->write_fn(udc->base_address, XUSB_DMA_LENGTH_OFFSET, leng=
th);
> >> >> +
> >> >> +     /*
> >> >> +      * Wait till DMA transaction is complete and
> >> >> +      * check whether the DMA transaction was
> >> >> +      * successful.
> >> >> +     */
> >> >> +     while ((udc->read_fn(ep->udc->base_address + XUSB_DMA_STATUS_=
OFFSET) &
> >> >> +                     XUSB_DMA_DMASR_BUSY) =3D=3D XUSB_DMA_DMASR_BU=
SY) {
> >> >> +             timeout =3D jiffies + 10000;
> >> >> +
> >> >> +             if (time_after(jiffies, timeout)) {
> >> >> +                     rc =3D -ETIMEDOUT;
> >> >> +                     goto clean;
> >> >> +             }
> >> >> +     }
> >> >
> >> > don't you get an IRQ for DMA completion ? If you do, you could be us=
ing
> >> > wait_for_completion()
> >>
> >> This function is called in interrupt context when buffer is ready or
> >> free. It initiates DMA to transfer data from IP buffer to memory.
> >> Hence it waits in busy loop till DMA completes
> >
> > wait, so you start_dma() before your gadget driver asks you to ?
>=20
> in ep_queue driver starts dma transfer from/to IP buffer to/from req->buf.
> If transfer is completed then request is not added to ep request queue
> and returns from ep_queue.
> If transfer is not completed (actual < length) then request is added
> to queue and returns from ep_queue.

This is wrong. Why wouldn't you give gadget driver the chance to decide
if it needs to queue the request again or not ?

> when buffer processed interrupt occurs, handler starts dma if there is
> request in queue and calls complete call back (when actual =3D=3D length)
> Hence answer is Yes for some transfers (start dma called from
> interrupt handler not from ep_queue).

this also seems wrong(-ish).

1) as Paul pointed out, you can't rely on jiffies if you're calling this
with IRQs disabled.

2) you don't really need to wait until DMA finishes its transaction
before returning from start_dma(), just use the DMA completion IRQ,

3) I don't see anywhere any sanitizing of arguments, can your DMA really
handle any alignment/unaligned addresses or should you make sure you're
getting good arguments?

You need to work on this a little bit, I guess.

--=20
balbi

--8GpibOaaTibBMecb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTT+y2AAoJEIaOsuA1yqRE5eIP/RxrSDqj4f1ki8KLcDaf4urD
9+sTXmxg4WfFjZry+LuoTHn9Aar5KyEjUv53/jO/Lreww1iAN7QrdzidzegwTenl
M6JS6UEnw5hUyotIKMuU20p43CBdFsd+AC/sQz0UNQbJY8hQ2MCo+kUJLbF50PdP
llhVzPwbej7JJ/GtR9XkbH0EoNDh6lWw95YX/q2tqXcW2evZ1e6TGBn7T1TJOexZ
xBjjkPOQgqgNhF30ISMJ5UOn47P2qRhPgYKjCEY5JihZz9WLFneMtoUWug/FFlqR
rdcLQ2glHi1YMrCtsVlgUUeMygdiUvDnXi+x6V/d7UzTFcCH+KpdEvsuzQShfSSM
L690ch2KXnRq3y/EFH35IkK039woNc3IB5hfZtb4SlEwsvOGbgQBqTVxsIyqvjZa
0/PEr7F72R7xIB1YmtFvsCcmAwZ3OcnhmbBb9V4oSbwF2ww6TCaGKr/zNajFDrm8
Mqgiwjfzk1UIxJYJvwIO+RwTelut8osoxmej/SOdjSfC7wAWPMnUOIKsGfrcK07J
xZSgM2TOk3fga65mYqjFy3IBoorbmBasOjNih5gyhyD5HikC+iey6ILhxk1EIgkL
Kr0eqT33nefdo9vWGQcXlI80AAMEvT5m6o3W4qrdrwXqBavb/V/qNeGiPtycfO0W
BS1BzkbNM8o+61GtRIN4
=nqwc
-----END PGP SIGNATURE-----

--8GpibOaaTibBMecb--
