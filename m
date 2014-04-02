Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030227AbaDBTdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:33:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51252 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932666AbaDBTdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:33:41 -0400
Date: Wed, 2 Apr 2014 14:31:38 -0500
From: Felipe Balbi <balbi@ti.com>
To: Rabin Vincent <rabin@rab.in>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: musb: turn phy on
Message-ID: <20140402193138.GM8504@saruman.home>
Reply-To: <balbi@ti.com>
References: <1396466787-19093-1-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3rMDlCEgcaHQQFB+"
Content-Disposition: inline
In-Reply-To: <1396466787-19093-1-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3rMDlCEgcaHQQFB+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 02, 2014 at 09:26:27PM +0200, Rabin Vincent wrote:
> 30a70b026b4cde4 ("usb: musb: fix obex in g_nokia.ko causing kernel
> panic") broke USB gadget support on Pandaboard because it simply deletes
> the call to phy_power_on() and the PHY is therefore never turned on.
>=20
> Fix it by actually turning the phy on.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  drivers/usb/musb/musb_gadget.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadge=
t.c
> index d4aa779..09d5883 100644
> --- a/drivers/usb/musb/musb_gadget.c
> +++ b/drivers/usb/musb/musb_gadget.c
> @@ -1850,6 +1850,7 @@ static int musb_gadget_start(struct usb_gadget *g,
>  	}
> =20
>  	pm_runtime_get_sync(musb->controller);
> +	phy_power_on(musb->phy);
> =20
>  	dev_dbg(musb->controller, "registering driver %s\n", driver->function);
> =20
> @@ -1963,6 +1964,7 @@ static int musb_gadget_stop(struct usb_gadget *g,
>  	 * that currently misbehaves.
>  	 */
> =20
> +	phy_power_off(musb->phy);

hmmm... not the best place, I have been waiting for -rc1 to be out to
send this version:

commit e8fbe7b90021960907e885e0b7a9b52d378b0202
Author: Felipe Balbi <balbi@ti.com>
Date:   Fri Mar 28 14:31:47 2014 -0500

    usb: musb: fix PHY power on/off
   =20
    commi 30a70b0 (usb: musb: fix obex in g_nokia.ko
    causing kernel panic) removed phy_power_on()
    and phy_power_off() calls from runtime PM callbacks
    but it failed to note that the driver depended
    on pm_runtime_get_sync() calls to power up the PHY,
    thus leaving some platforms without any means to
    have a working PHY.
   =20
    Fix that by enabling the phy during omap2430_musb_init()
    and killing it in omap2430_musb_exit().
   =20
    Fixes: 30a70b0 (usb: musb: fix obex in g_nokia.ko causing kernel panic)
    Cc: <stable@vger.kernel.org> # v3.14
    Cc: Pali Roh=E1r <pali.rohar@gmail.com>
    Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
    Reported-by: Michael Scott <hashcode0f@gmail.com>
    Tested-by: Michael Scott <hashcode0f@gmail.com>
    Reported-by: Rabin Vincent <rabin@rab.in>
    Signed-off-by: Felipe Balbi <balbi@ti.com>

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index d341c14..819a7cd 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -416,6 +416,7 @@ static int omap2430_musb_init(struct musb *musb)
 		omap_musb_set_mailbox(glue);
=20
 	phy_init(musb->phy);
+	phy_power_on(musb->phy);
=20
 	pm_runtime_put_noidle(musb->controller);
 	return 0;
@@ -478,6 +479,7 @@ static int omap2430_musb_exit(struct musb *musb)
 	del_timer_sync(&musb_idle_timer);
=20
 	omap2430_low_level_exit(musb);
+	phy_power_off(musb->phy);
 	phy_exit(musb->phy);
=20
 	return 0;

and I'm much more inclined to send this one instead since it has been
tested by other folks already. I was even going to Cc you, as you can
see on that Reported-by tag.

cheers

--=20
balbi

--3rMDlCEgcaHQQFB+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTPGWaAAoJEIaOsuA1yqREWZEP+wc3pfbAV1mYJk3i7+ELCK/j
8RfrTNfxNYerv5EsJwdvve5Yle9xk/SUKd7JaAv/lVcNBdR7IfQjbB/r4O4WCMsz
/iYtjkos5upNgFyxEjtKjMMJ6GcFPmcNIYXJ08g0nHxIBK2zFZtvkHlUDvF0di7L
Xl1YB5my6A6R7hE2+RQk5NgFupYJyMKdhK+yJD7z6uBw9zPVI3AVusw1ZRl2apwS
wS1M3UH9rOqtIUCOgoYNjvRqAdWguoLBOrxxHRSzt//5uZfsU5z0vQumS7I9ooOC
8l+E+wIpAcj6wOLpXO8Zk3+03/92K9WZMDqlKyyhiaN46gdu7+p7UR0fxTYGoqDN
WDPCR474cbw0pM6+mtk+UBHUD7ELx9uN0+Wq57cUUKNrXUiWQjX1fKny7El4TgaC
ITZ/BwjoAICwu04t98NYkXowb3tePoqyPfDzYFE5Oi0ZJ0labGJ2RSDM67dn312W
oHCxGPGRNBCU5cEMQoqU0Gms363KW9B7F95qkTuw4OcCmnjNSWfS1aoUdamn1tcS
3fVDNgLShayk/wg8sRFcYfOvbQ3qpHMMFVBoDk6RXWs1DH+rS71RJre/wf1ahPwe
jlAbZMt4ZCcKuo2zSs4mCnUrjRG6LVmrWBVYpoG28z18IH5buOfGA2VZ7kKIy1Z6
dtNCvIrm7PZlpaoqB2as
=IhcH
-----END PGP SIGNATURE-----

--3rMDlCEgcaHQQFB+--
