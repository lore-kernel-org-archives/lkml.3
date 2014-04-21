Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaDUQKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:10:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44478 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbaDUQKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:10:24 -0400
Date: Mon, 21 Apr 2014 11:08:02 -0500
From: Felipe Balbi <balbi@ti.com>
To: sundeep subbaraya <sundeep.lkml@gmail.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michals@xilinx.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Subject: Re: [PATCH v2 2/2] usb: gadget: Add xilinx axi usb2 device support
Message-ID: <20140421160802.GA22794@saruman.home>
Reply-To: <balbi@ti.com>
References: <1396510519-8555-1-git-send-email-sbhatta@xilinx.com>
 <113d0620-4003-417d-806b-0b79ae692829@VA3EHSMHS023.ehs.local>
 <20140403145853.GD14162@saruman.home>
 <CALHRZuoCtEz5-CmU17dUpVS_MjSDdYVLMSvgXq_RwxLj_KJMDA@mail.gmail.com>
 <20140416180228.GK28035@saruman.home>
 <CALHRZuq6=TMryHtbjTw7rYoGwbu2w0BTdxiOA95HYS3_CG6vwQ@mail.gmail.com>
 <20140417150110.GB20889@saruman.home>
 <CALHRZuqetzEANE=F4mit5sPG_Q-X8Vxsd9-N4k-MKW4_uzDFwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <CALHRZuqetzEANE=F4mit5sPG_Q-X8Vxsd9-N4k-MKW4_uzDFwg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Apr 18, 2014 at 07:34:08PM +0530, sundeep subbaraya wrote:

<snip>

> >> in ep_queue driver starts dma transfer from/to IP buffer to/from req->=
buf.
> >> If transfer is completed then request is not added to ep request queue
> >> and returns from ep_queue.
> >> If transfer is not completed (actual < length) then request is added
> >> to queue and returns from ep_queue.
> >
> > This is wrong. Why wouldn't you give gadget driver the chance to decide
> > if it needs to queue the request again or not ?
>=20
> When does gadget driver decides to queue the same request again?
> if -EBUSY is returned from ep_queue or req.status !=3D 0 in completion
> routine?

whenever it so decides. Different gadget drivers might have different
requirements. The code is open and sits under drivers/usb/gadget/ why
don't you have a read ?

> there are cases where ping-pong buffers both are busy. currently this dri=
ver
> adds request to queue only when buffers are busy. In normal cases request=
 is
> processed without adding to queue.

it shouldn't do that. You can't add requests by yourself. If you can't
initiate transfers right now, let the HW NAK or something.

> do i need to have another local queue for requests waiting since
> buffers are busy?

you should probably move the request to another queue, yes. Here's what
dwc3 does:

=2E gadget queues request
=2E dwc3 puts request in a 'queued' list
=2E HW sends XferNotReady event to notify it needs transfer requests
=2E dwc3 moves requests to 'pending' list
=2E dwc3 tells hw to consume 'pending' list

if gadget driver queues another request, we accept it into 'queued' list
and wait for another XferNotReady before moving it to 'pending' and
consuming it.

> Or dequeue the request ?

you could return -EAGAIN, if you wish. But don't add requests by
yourself, this could end up in hard-to-debug scenarios. Remember you
don't *own* the reqeusts, only gadget drivers do. You can keep the
request around until you have space in your FIFOs to start it, but then,
in that case, don't try to list_del() -> start() -> list_add().

> >> when buffer processed interrupt occurs, handler starts dma if there is
> >> request in queue and calls complete call back (when actual =3D=3D leng=
th)
> >> Hence answer is Yes for some transfers (start dma called from
> >> interrupt handler not from ep_queue).
> >
> > this also seems wrong(-ish).
> >
> > 1) as Paul pointed out, you can't rely on jiffies if you're calling this
> > with IRQs disabled.
> >
> > 2) you don't really need to wait until DMA finishes its transaction
> > before returning from start_dma(), just use the DMA completion IRQ,
> >
> > 3) I don't see anywhere any sanitizing of arguments, can your DMA really
> > handle any alignment/unaligned addresses or should you make sure you're
> > getting good arguments?
> >
> > You need to work on this a little bit, I guess.
>=20
> Yes am working on this and will be using seperate ep_ops for ep0  like
> drivers/usb/dwc3/gadget.c since ep0 has no dma and ping-pong buffers

ok

--=20
balbi

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTVUJiAAoJEIaOsuA1yqRE+GUP/1bVrAfH2apM0IwaHFW6+Wbn
rSbSUsYla0C8OLstyz3alq+pAjnO9DZDh3AQ0MLR/IlfeJ4PHLZSKjoy2Y5JrQ4H
XQIFtPvZkFIuNiHviiyxnb8otFeSODHLS/hUL1WuliaG/XKENOYTQZy5G+2iO7m3
XkCZ/QldKIn9bNrwgoS5qAV0BW+0U63/oOrkOCeJRQZd3dfWuMO5EGpT6KOzQmG5
XZRnxaLQeLZAd+t550vm48WRA49B+k+UDSPWkZCAHYRoB1xrwaaq82R6TDnrLzuN
cCa6PuWnJA7/RRHOZJk9Mm+hVqBou0tPsX7Rt4QwoZO+w6RogVy5X2vFXtPBEXhl
TQZCD++LfKN1M72L/Kc26ulIPJv11QOdBZhjbZM27PgwepmEI4ovw/cGAfwBZ7s1
HRqc1pmOV52sgr/bjqJIiM2fIDsDglHvz8FQ20y7voYnxbQ+yc7Klo/0FFGRfJvY
5D/Y5EQCRfmqrTOA6cTH4goHS69r2qVPGdPWfQjO+E9cEUnwCkGxgqn1okE0ofUs
E1Tc5F7VR9Ti6aD463vnwMoeltXJakmhLiVw9KmSyCbaXyCSAuQYaPBbU7dahr7u
/Rm1io+l7n5A9fEo+oCr86Mxe2QA/Bbo9r/gy8jCOvxCXDtQnEMWjuzwciNwpRDk
FFAB1Pl+PXSCh/tHn4hb
=YKdV
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
