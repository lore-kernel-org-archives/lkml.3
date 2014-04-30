Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933829AbaD3QzC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:55:02 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34294 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbaD3Qy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:54:59 -0400
Date: Wed, 30 Apr 2014 11:54:37 -0500
From: Felipe Balbi <balbi@ti.com>
To: sundeep subbaraya <sundeep.lkml@gmail.com>
CC: "balbi@ti.com" <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michals@xilinx.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Subject: Re: [PATCH v2 2/2] usb: gadget: Add xilinx axi usb2 device support
Message-ID: <20140430165437.GO23679@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140421160802.GA22794@saruman.home>
 <Pine.LNX.4.44L0.1404211228190.1201-100000@iolanthe.rowland.org>
 <CALHRZur7+MaYXbWOfbvjggPN7_eYAE+th5VNbcLP=ehvm0HGsA@mail.gmail.com>
 <20140422144944.GF5524@saruman.home>
 <CALHRZuoq32qoh70hbb2LtVJNgkwB1j6bvzmYONmxcn3mBnGONQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5PFZVUeDPxlnBcQp"
Content-Disposition: inline
In-Reply-To: <CALHRZuoq32qoh70hbb2LtVJNgkwB1j6bvzmYONmxcn3mBnGONQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5PFZVUeDPxlnBcQp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 23, 2014 at 09:57:52AM +0530, sundeep subbaraya wrote:
> >> > I get the impression that the two of you are arguing past each other.
> >> > It appears that Sundeep is talking about transferring data from the
> >> > gadget driver's buffer to an internal buffer in the UDC hardware, but
> >> > Felipe is talking about transferring data from the UDC to the host.
> >> >
> >> > As I understand it, Sundeep said that when the gadget driver queues a
> >> > data-IN request, the UDC driver copies as much of the data buffer as
> >> > possible into a hardware FIFO.  If it succeeds in copying all the da=
ta
> >> > into the FIFO then the request's completion routine gets called
> >> > immediately, even though the data doesn't get sent from the FIFO to =
the
> >> > host until the host asks for it.
> >> >
> >> > If only part of the data can be copied into the FIFO then the request
> >> > is added to the ep's request queue before the usb_ep_queue() call
> >> > returns.  When space becomes available in the FIFO, the data will be
> >> > copied and eventually sent to the host.  When all the data has been
> >> > copied to the FIFO, the request's completion routine will be called.
> >
> > there seems to be a slight problem with this approach: how will the IP
> > know that even though you copied X bytes into the FIFO, it should wait
> > for another Y bytes before shifting data to the wire ? How will it know
> > that it shouldn't generate CRC yet because there's still data to be
> > added ?
>=20
> No. IP does/need not know that it has to wait for Y bytes.We just
> write X bytes into
> HW buffer and count as X in buffer count register. IP generates CRC
> for bytes based
> on Count register and sends data to Host. Let us consider this
> scenario of bulk IN transfer:
> req.length =3D 5120 and   wMaxPacketSize =3D 512, ep_queue is called once
> and is returned with
> status 0. In ep_queue this code snippet,
>                if (xudc_write_fifo(ep, req) =3D=3D 1)
>                         req =3D NULL;
>                if(req !=3D NULL)
>                          list_add_tail(&req->queue, &ep->queue);
>=20
> xudc_write_fifo does the following if HW buffers not busy:
>      copies 512 bytes to HW buffer
>      set count and ready registers so that IP can start data transfer to =
host
>      changes req.actual to 512 and returns 0(if req.length >
> wMaxPacketSize) and 1(if req.length < wMaxPacketSize).

you should return a proper error code, not 1.

> Since return is zero this request is added to queue. When data
> transfer to host is completed IP generates
> an interrupt. In the interrupt handler we again call write_fifo if
> request list is not empty.
>        if (list_empty(&ep->queue))
>                 req =3D NULL;
>         else
>                 req =3D list_entry(ep->queue.next, struct xusb_req, queue=
);
>         if (!req)
>                 return;

okay, this can be improved a bit though:

	if (list_empty(&ep->queue))
		return;

	req =3D list_first_entry(&ep->queue, struct xusb_req, queue);

>         if (ep->is_in)
>                 xudc_write_fifo(ep, req);
>         else
>                 xudc_read_fifo(ep, req);
>=20
> This happens 10 times(since length 5120) and completion is called.

ok.

> > If there's no space in the FIFO yet, why copy data at all ?
>=20
> If HW buffers are busy(IP is still transferring previous data to Host
> from buffer) then xudc_write_fifo returns 0 without changing
> req.actual. When previous data transfer completes then Interrupt then
> again write_fifo from handler.

ok, sounds good to me.

> >> > Thus there never is any need for the gadget driver to queue the requ=
est
> >> > again.
>=20
> Yes
>=20
> >> >An incomplete transfer means the FIFO didn't have enough room
> >> > when the request was submitted; it doesn't mean that the data didn't
> >> > eventually get sent to the host.
> >>
> >> Exactly Alan,this is what I was trying to say. Probably I was not
> >> clear in explaining. I didnt see any harm this way and even this
> >> implementation is same like at91_udc.c. I have been reading
> >> mas_storage to understand when does gadget driver tries to enqueue a
> >> request again. Since different gadget drivers might have different
> >> requirements (agree with Felipe), wanted to know criteria for queuing
> >> a same request again.
> >>
> >> I will change this implementation as per Felipe comments and test with
> >> some of the gadgets.
> >
> > Let's see, please help me understand the questions above.
>=20
> Hope this helps.

it does, but please sort out the small comments I had above.

cheers

--=20
balbi

--5PFZVUeDPxlnBcQp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYSrNAAoJEIaOsuA1yqREkF4P/RZSzrk6ZZO0+zhw8fAcM7Ot
Q0beJ0VuMONNZ2IXKMovd1WDvIAMGn7orBySUFqvP1FzLxGP05NagbRr7X+8mFGl
ulRtXkuLcmGqkzXvP8BsNwE0vTad4ND1eWOyReSuskY1HmSjkyl0c/zE0+As2IBm
PuR2u7bgZzsoNPd0nYRdkPkYJ1f/7ezmqsbw0B6webk+LBpe3a3bHX+xpYf7oupO
8A+hmN2QFVzZOx13erefAapJQJ7y5fs/xjGQhWnzfCn8QVWL/CD+/aipiFvbZLfz
TuXHqGBHI1lY1d5gP5/QxUZb6CUr+evrvASHTveNmrxS5BPXMTY97WBKO2vElhj7
md6nu5sNOm5e68QSVcELgANV2OQcgk4N1PLc2Nap7wCGo9zc2EGR6toU7M6GLVH6
/5v+V8bUM/0GdHQ5b06VclFMNgWscbkNQdt37Y7wh93NxdEz8ZkWikcU7Vir3NUP
Of7GR2YPn79uqJs6HPc/Yq3yZba1sota3YkElT5hMEHRXqZ2Fa3mjO5CDtJQrRok
a8thvXHZ2vqkqwwwJItuCq+Jbxx7ZmkyzKZwhL/StwJT5zTDUb6BfOHnrJgy3GgJ
Pk1EwZYHF3/tbLLdUOB2KiBXP39cDcJRosvhXyeRcXc6lr5DFxzAxT28UpUPNyMu
mdUKzJoLNeFk9GRZrDYW
=9bo9
-----END PGP SIGNATURE-----

--5PFZVUeDPxlnBcQp--
