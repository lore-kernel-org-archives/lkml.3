Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab3BVQy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 11:54:59 -0500
Received: from mail4.gandi.net ([217.70.183.210]:42841 "EHLO mail4.gandi.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757516Ab3BVQyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 11:54:54 -0500
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Feb 2013 11:54:54 EST
Date: Fri, 22 Feb 2013 17:47:28 +0100
From: William Dauchy <william@gandi.net>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ian.campbell@citrix.com, david.vrabel@citrix.com,
        "Christopher S. Aker" <caker@theshore.net>
Subject: xen-netback fixes for stable 35876b5 3e55f8b
Message-ID: <20130222164728.GB27794@gandi.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ITEy4z2kE7rjCDPK"
Content-Disposition: inline
Reply_to: William Dauchy <william@gandi.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ITEy4z2kE7rjCDPK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I believe the two commits 35876b5 and 3e55f8b could be included in stable t=
ree.
35876b5 is related to 4885628 already in the stable tree and fixes a
possible oops.
3e55f8b is fixing another possible oops (see commit messages).

I tested them on top of a v3.4.33.
Could we consider adding these patches in stable tree at least for v3.4?

Tested-by: William Dauchy <william@gandi.net>
Cc: stable@vger.kernel.org



commit 35876b5ffc154c357476b2c3bdab10feaf4bd8f0
Author: David Vrabel <david.vrabel@citrix.com>
Date:   Thu Feb 14 03:18:57 2013 +0000

    xen-netback: correctly return errors from netbk_count_requests()
  =20
    netbk_count_requests() could detect an error, call
    netbk_fatal_tx_error() but return 0.  The vif may then be used
    afterwards (e.g., in a call to netbk_tx_error().
  =20
    Since netbk_fatal_tx_error() could set vif->refcnt to 1, the vif may
    be freed immediately after the call to netbk_fatal_tx_error() (e.g.,
    if the vif is also removed).
  =20
    Netback thread              Xenwatch thread
    -------------------------------------------
    netbk_fatal_tx_err()        netback_remove()
                                  xenvif_disconnect()
                                    ...
                                    free_netdev()
    netbk_tx_err() Oops!
  =20
    Signed-off-by: Wei Liu <wei.liu2@citrix.com>
    Signed-off-by: Jan Beulich <JBeulich@suse.com>
    Signed-off-by: David Vrabel <david.vrabel@citrix.com>
    Reported-by: Christopher S. Aker <caker@theshore.net>
    Acked-by: Ian Campbell <ian.campbell@citrix.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 3e55f8b306cf305832a4ac78aa82e1b40e818ece
Author: David Vrabel <david.vrabel@citrix.com>
Date:   Thu Feb 14 03:18:58 2013 +0000

    xen-netback: cancel the credit timer when taking the vif down
  =20
    If the credit timer is left armed after calling
    xen_netbk_remove_xenvif(), then it may fire and attempt to schedule
    the vif which will then oops as vif->netbk =3D=3D NULL.
  =20
    This may happen both in the fatal error path and during normal
    disconnection from the front end.
  =20
    The sequencing during shutdown is critical to ensure that: a)
    vif->netbk doesn't become unexpectedly NULL; and b) the net device/vif
    is not freed.
  =20
    1. Mark as unschedulable (netif_carrier_off()).
    2. Synchronously cancel the timer.
    3. Remove the vif from the schedule list.
    4. Remove it from it netback thread group.
    5. Wait for vif->refcnt to become 0.
  =20
    Signed-off-by: David Vrabel <david.vrabel@citrix.com>
    Acked-by: Ian Campbell <ian.campbell@citrix.com>
    Reported-by: Christopher S. Aker <caker@theshore.net>
    Signed-off-by: David S. Miller <davem@davemloft.net>


Regards,
--=20
William

--ITEy4z2kE7rjCDPK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlEnoSAACgkQ1I6eqOUidQEUsACgoixSadvxakgB2QiACg62KY8O
Bn4AmgO+UpS2f5GFv+HGo+VVUz0Ij1mO
=jdvI
-----END PGP SIGNATURE-----

--ITEy4z2kE7rjCDPK--
