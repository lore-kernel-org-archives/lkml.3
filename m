Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab3KZRoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 12:44:38 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56027 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab3KZRog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 12:44:36 -0500
Date: Tue, 26 Nov 2013 11:43:42 -0600
From: Felipe Balbi <balbi@ti.com>
To: Andreas Larsson <andreas@gaisler.com>
CC: <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <software@gaisler.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] usb: gadget: Add UDC driver for Aeroflex Gaisler GRUSBDC
Message-ID: <20131126174342.GT24310@saruman.home>
Reply-To: <balbi@ti.com>
References: <1376316310-27989-1-git-send-email-andreas@gaisler.com>
 <20130918171506.GQ21559@radagast>
 <524A8927.6090500@gaisler.com>
 <20131001141958.GQ1476@radagast>
 <526E5F96.9090904@gaisler.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+OVWeTxrbAwQuiek"
Content-Disposition: inline
In-Reply-To: <526E5F96.9090904@gaisler.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+OVWeTxrbAwQuiek
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 28, 2013 at 01:59:02PM +0100, Andreas Larsson wrote:
> On 2013-10-01 16:19, Felipe Balbi wrote:
> >>>>+static void gr_finish_request(struct gr_ep *ep, struct gr_request *r=
eq,
> >>>>+			      int status)
> >>>>+{
> >>>>+	struct gr_udc *dev;
> >>>>+
> >>>>+	list_del_init(&req->queue);
> >>>>+
> >>>>+	if (likely(req->req.status =3D=3D -EINPROGRESS))
> >>>>+		req->req.status =3D status;
> >>>>+	else
> >>>>+		status =3D req->req.status;
> >>>>+
> >>>>+	dev =3D ep->dev;
> >>>>+	usb_gadget_unmap_request(&dev->gadget, &req->req, ep->is_in);
> >>>>+	gr_free_dma_desc_chain(dev, req);
> >>>>+
> >>>>+	if (ep->is_in) /* For OUT, actual gets updated by the work handler =
*/
> >>>>+		req->req.actual =3D req->req.length;
> >>>>+
> >>>>+	if (!status) {
> >>>>+		if (ep->is_in)
> >>>>+			gr_dbgprint_request("SENT", ep, req);
> >>>>+		else
> >>>>+			gr_dbgprint_request("RECV", ep, req);
> >>>>+	}
> >>>>+
> >>>>+	/* Prevent changes to ep->queue during callback */
> >>>>+	ep->callback =3D 1;
> >>>>+	if (req =3D=3D dev->ep0reqo && !status) {
> >>>>+		if (req->setup)
> >>>>+			gr_ep0_setup(dev, req);
> >>>>+		else
> >>>>+			dev_err(dev->dev,
> >>>>+				"Unexpected non setup packet on ep0in\n");
> >>>>+	} else if (req->req.complete) {
> >>>>+		unsigned long flags;
> >>>>+
> >>>>+		/* Complete should be called with irqs disabled */
> >>>>+		local_irq_save(flags);
> >>>
> >>>I guess it'd be better if you called this with spin_lock_irqsave()
> >>>called before, then you can remove local_irq_save from here.
> >>
> >>That would increase the amount of time interrupts are disabled quite a
> >>lot, so I would prefer not to.
> >
> >that's what every other UDC driver is doing. I don't think you need to
> >worry about that. Can you run some benchmarks with both constructs just
> >so I can have peace of mind ?
>=20
> Hi!
>=20
> My benchmark shows 20%+ performance loss both for mass storage running
> on this driver and for concurrent ethernet traffic and cpu bound tasks
> running with this change. In addition the code becomes messier as some
> spin locks disables interrupts and some do not depending on wich paths
> might lead to a call to complete. So I'll stick to not disabling
> interrupts until disabled interrupts are actually needed.
>=20
> >>>>+static irqreturn_t gr_irq(int irq, void *_dev)
> >>>>+{
> >>>>+	struct gr_udc *dev =3D _dev;
> >>>>+
> >>>>+	if (!dev->irq_enabled)
> >>>>+		return IRQ_NONE;
> >>>>+
> >>>>+	schedule_work(&dev->work);
> >>>
> >>>why do you need this ? We have threaded IRQ handlers. Why a workqueue ?
> >>
> >>As mentioned above, to to be able to schedule work after pausing
> >>endpoint handling during a completion callback call or during an
> >>endpoint halt.
> >
> >doesn't look like you need that work_struct at all. Handle your IRQ
> >directly and for the pieces you need to do after ClearHalt, re-factor
> >that to a separate function which you call conditionally on
> >->set_halt().
>=20
> For some reason, the performance suffers massively when switching to
> using threaded interrupts instead of the current solution using the work
> queue. The times to complete large file transfers to the mass_storage
> gadget running on top of the udc are regularly around seven times longer
> using threaded interrupts complared to using the work queue
> solution. Unless you have any ideas here, I hope you can let the driver
> keep the work queue solution.

sorry for the long delay. That would point to a bug in threaded IRQ
handling and I believe Sebastian has looked over that in past,
Sebastian ? To answer your question, sorry, we don't want unnecessary
workqueues to be added :-s

cheers

--=20
balbi

--+OVWeTxrbAwQuiek
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSlN3OAAoJEIaOsuA1yqRE1BUP/iIKWB7GTfDjiJyKoWixCr5U
LYL3Hoqk7dm7lBmcoNL03sCCZN5j8PgfSoC3WLhrODcHd9Yfg7pP0A9BzqmYjQ+U
gSDPi+mZBvfLoiddXd4fhyXuX+KuGhooktmiUcra6zFgnnBr0We1PpBzemUj+ZyC
drxyv+nI4HHr00x1MKow8BqWdeHczAbsLQ6iBNuDEZi/C3W4BZmdZW8diKU3Qp7k
D6rmv3sz+kFPvBxmqHKWXKJffUjLO6/j0fYqNCd8C9zoi1LFFUBnFWS2rERu2cTC
kUnIpprW05o6i73EsaT0ODIx4lONG8dd2Su3Kc4Yn+3Sz/iKaqYZ8lvdrW/LJi8p
npmfU3unzakoXe0wl6k353ZsGBUNJlMC7n96MyjW07soY8ZFIYDmWanU5qWD7nBH
jk2Zux6S3HVigRMpoAaiCAGEqgrjOqfPanM6znfHBg4stUD8Yt0qeBSbCJhPrEft
K9KIjChd2c2gvElEihmUXe2uzolYvd8MrDEjHt4hjSqNMmF6gfDHxmwOUu40yJCh
A9sDzi4S0N+mHKLsDUSMqtTLv8zUHV4v/b4AEvVt87niq0Tu64dx8OlCcEKpaeEt
XixX0qTKwKvUUkzwOcQmLwJ3SrhmL39jtygShHPVrRq9bXl91XQSPh0kAWG/jvNp
Wftgw+iELLwHT5sztXeV
=rkCB
-----END PGP SIGNATURE-----

--+OVWeTxrbAwQuiek--
