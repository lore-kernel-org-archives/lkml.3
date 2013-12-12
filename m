Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab3LLSBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:01:54 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:51377 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab3LLSBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:01:49 -0500
Date: Thu, 12 Dec 2013 12:01:07 -0600
From: Felipe Balbi <balbi@ti.com>
To: Andreas Larsson <andreas@gaisler.com>
CC: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <software@gaisler.com>
Subject: Re: [PATCH v3] usb: gadget: Add UDC driver for Aeroflex Gaisler
 GRUSBDC
Message-ID: <20131212180106.GF1939@saruman.home>
Reply-To: <balbi@ti.com>
References: <1386144838-16403-1-git-send-email-andreas@gaisler.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DO5DiztRLs659m5i"
Content-Disposition: inline
In-Reply-To: <1386144838-16403-1-git-send-email-andreas@gaisler.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DO5DiztRLs659m5i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Dec 04, 2013 at 09:13:58AM +0100, Andreas Larsson wrote:
> +static void gr_finish_request(struct gr_ep *ep, struct gr_request *req,
> +			      int status)
> +{
> +	struct gr_udc *dev;
> +
> +	list_del_init(&req->queue);
> +
> +	if (likely(req->req.status =3D=3D -EINPROGRESS))
> +		req->req.status =3D status;
> +	else
> +		status =3D req->req.status;
> +
> +	dev =3D ep->dev;
> +	usb_gadget_unmap_request(&dev->gadget, &req->req, ep->is_in);
> +	gr_free_dma_desc_chain(dev, req);
> +
> +	if (ep->is_in) /* For OUT, actual gets updated bit by bit */
> +		req->req.actual =3D req->req.length;
> +
> +	if (!status) {
> +		if (ep->is_in)
> +			gr_dbgprint_request("SENT", ep, req);
> +		else
> +			gr_dbgprint_request("RECV", ep, req);
> +	}
> +
> +	/* Prevent changes to ep->queue during callback */
> +	ep->callback =3D 1;
> +	if (req =3D=3D dev->ep0reqo && !status) {
> +		if (req->setup)
> +			gr_ep0_setup(dev, req);
> +		else
> +			dev_err(dev->dev,
> +				"Unexpected non setup packet on ep0in\n");
> +	} else if (req->req.complete) {
> +		unsigned long flags;
> +
> +		/*
> +		 * Complete should be called with interrupts disabled according
> +		 * to the contract of struct usb_request
> +		 */
> +		local_irq_save(flags);

sorry but this driver isn't ready for inclusion. local_irq_save() is a
pretty good hint that there's something wrong in the driver. Consider
the fact that local_irq_save() will disable preemption even when
CONFIG_PREEMPT_FULL is enabled and you have a bit a problem.

Also, the way you're using thread IRQs is quite wrong. I can't let that
pass and get merged upstream, sorry.

--=20
balbi

--DO5DiztRLs659m5i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSqfniAAoJEIaOsuA1yqREhYMP/2tSrdcWvYD5BQfise+UpJvE
Zjp5iavLDw0CbymNVzaulur0VzP96kMAZankI8IYzvrQZ1/Iq5Lr/cAOPX4PHmHv
yGPih9MddsvQ7Jw7ldpx0D8q0RG73409b2a8aTNsDbXwa49cN4v1jSn7YcD0oRV4
ak23w08K6FO6dyr9xXotysVFHxfFPLjYHq7cKaqSYSt2eUWhlEeCw2Hbr8xBbL+a
l2ly7LcngVKSzan5fKtxQT/FdzYlfuYL3QBY8orBzLSESp7jxqnq37ijAyomn2AC
d8zaQ2AqB73ZDxDoQSet2V4PNBG/YxoB3lhvmdFh4M27WGKQ5vqMMfmlv1MMOSov
lZl1+GWxSzKRUF1LdHgsckMF9NPadNCLcIA17tv4GhYGetYyleLGvg8DFaevbYN6
OWXd6csc47D9KokBUXqKOSSVxoJywq9wCAiKTzvjD2hGs4nI34arEcvAMILpAUO0
OqpBtd2sFJQItOxjd6r1rmHHGDdAstA350qWfFKG4bsTLbYcKcP9sYZfjep1jM+z
NNzQHLPpVVJhUhelUIrulA7+sQQCWRB6/Z3J9m9iSC3QnwrV3iZJ12yqttUXfLo4
LJIlEo4wCTx9mWr9YRl3RoycEj0fe9USVZfkx2JqMhv993Pk6TqMH3fj5qEyU7Yr
CHpgMO1wzJHXVh1yE4VZ
=5RmV
-----END PGP SIGNATURE-----

--DO5DiztRLs659m5i--
