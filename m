Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713Ab3CSDJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 23:09:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41584 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754097Ab3CSDJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 23:09:10 -0400
Message-ID: <1363662540.3937.366.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 45/82] USB: EHCI: dont check DMA values in QH overlays
From: Ben Hutchings <ben@decadent.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: stable@vger.kernel.org, akpm@linux-foundation.org,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 19 Mar 2013 03:09:00 +0000
In-Reply-To: <20130318042148.612442979@decadent.org.uk>
References: <20130318042148.612442979@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-MB5haGRQF5O9PJBQgUw2"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MB5haGRQF5O9PJBQgUw2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-03-18 at 04:22 +0000, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Alan Stern <stern@rowland.harvard.edu>
>=20
> commit feca7746d5d9e84b105a613b7f3b6ad00d327372 upstream.
>=20
> This patch (as1661) fixes a rather obscure bug in ehci-hcd.  In a
> couple of places, the driver compares the DMA address stored in a QH's
> overlay region with the address of a particular qTD, in order to see
> whether that qTD is the one currently being processed by the hardware.
> (If it is then the status in the QH's overlay region is more
> up-to-date than the status in the qTD, and if it isn't then the
> overlay's value needs to be adjusted when the QH is added back to the
> active schedule.)
>=20
> However, DMA address in the overlay region isn't always valid.  It
> sometimes will contain a stale value, which may happen by coincidence
> to be equal to a qTD's DMA address.  Instead of checking the DMA
> address, we should check whether the overlay region is active and
> valid.  The patch tests the ACTIVE bit in the overlay, and clears this
> bit when the overlay becomes invalid (which happens when the
> currently-executing URB is unlinked).
>=20
> This is the second part of a fix for the regression reported at:
>=20
> 	https://bugs.launchpad.net/bugs/1088733

Alan, the first part (commit 6402c796d3b4 aka as1660) didn't apply and I
couldn't see how to adapt it for 3.2.  Does this second part have any
value without the first?  Or, if you could provide a backport of the
first part, that would be very much appreciated.

Ben.

> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Reported-by: Joseph Salisbury <joseph.salisbury@canonical.com>
> Reported-and-tested-by: Stephen Thirlwall <sdt@dr.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/usb/host/ehci-q.c |   18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>=20
> --- a/drivers/usb/host/ehci-q.c
> +++ b/drivers/usb/host/ehci-q.c
> @@ -135,7 +135,7 @@ qh_refresh (struct ehci_hcd *ehci, struc
>  		 * qtd is updated in qh_completions(). Update the QH
>  		 * overlay here.
>  		 */
> -		if (cpu_to_hc32(ehci, qtd->qtd_dma) =3D=3D qh->hw->hw_current) {
> +		if (qh->hw->hw_token & ACTIVE_BIT(ehci)) {
>  			qh->hw->hw_qtd_next =3D qtd->hw_next;
>  			qtd =3D NULL;
>  		}
> @@ -444,11 +444,19 @@ qh_completions (struct ehci_hcd *ehci, s
>  			else if (last_status =3D=3D -EINPROGRESS && !urb->unlinked)
>  				continue;
> =20
> -			/* qh unlinked; token in overlay may be most current */
> -			if (state =3D=3D QH_STATE_IDLE
> -					&& cpu_to_hc32(ehci, qtd->qtd_dma)
> -						=3D=3D hw->hw_current) {
> +			/*
> +			 * If this was the active qtd when the qh was unlinked
> +			 * and the overlay's token is active, then the overlay
> +			 * hasn't been written back to the qtd yet so use its
> +			 * token instead of the qtd's.  After the qtd is
> +			 * processed and removed, the overlay won't be valid
> +			 * any more.
> +			 */
> +			if (state =3D=3D QH_STATE_IDLE &&
> +					qh->qtd_list.next =3D=3D &qtd->qtd_list &&
> +					(hw->hw_token & ACTIVE_BIT(ehci))) {
>  				token =3D hc32_to_cpu(ehci, hw->hw_token);
> +				hw->hw_token &=3D ~ACTIVE_BIT(ehci);
> =20
>  				/* An unlink may leave an incomplete
>  				 * async transaction in the TT buffer.
>=20


--=20
Ben Hutchings
When you say `I wrote a program that crashed Windows', people just stare ..=
.
and say `Hey, I got those with the system, *for free*'. - Linus Torvalds

--=-MB5haGRQF5O9PJBQgUw2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUfWzOe/yOyVhhEJAQpQTg/7BFK2wPoLQtu08qJQ2fenGTVNN4TOHZFK
jVIHJ8zRb1wenCwOXaQ5xGSi48aJcMqeGoncm4P/olEuHujuzFpSz/KutbrCBFek
6kCKjKV6DMIeB5/7+zWHtNj8IVcQJJnMhnMnYRTFf6cQMcHuqUOVqnfpoYD+X3uL
q5xynh17yGLS/WNqyhy3Pf8ckXk7gZNP1X/eScYml3WRfx6e/jMO3YOoypCNGZqt
0927DoqYe5bPaC3K3b+1DC6A49RRxxI1iabCLZXagqk7TLnS0kfzInvvYZaxeY7I
i4IG8WO1nrhfUUNNUDgG7+5qglRys2GrVwOPznH/RVKEZm5iSgrcboTlaTksUvXt
ZC4oPT2N5mUIllL2isq5X4XdT7l//oaTpfpdtwI1S8cdkxEyxS/ZQ/xdyi4+W77W
PcHSx7EXaNNwbOmmvCUff9NkldOjWQnzTRpDQcR7XlRZdigxGxP+6IbcoaS/wVmT
YwhRTIUtsnTz7KwvgeNg1Mxj/e7nzp6DGkNuXn7GwwbCDPc39+zVDTahZ+q3pnQM
QZskxMFHmCJhgeTHHOtzcd6RYFhZjSLtoFVlZQXtp1lrWGR1R9NT9drOxVZkD+/e
i/eQk2CMBHuMprAlF5dwyHqTtQ0zNCdqtv1nxp8kwZxC0qosnWyIOVQiu8mr6HTG
JlPZxIHFie8=
=F2jw
-----END PGP SIGNATURE-----

--=-MB5haGRQF5O9PJBQgUw2--
