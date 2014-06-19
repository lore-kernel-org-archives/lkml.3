Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336AbaFSPLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:11:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39106 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812AbaFSPLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:11:12 -0400
Date: Thu, 19 Jun 2014 10:10:57 -0500
From: Felipe Balbi <balbi@ti.com>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
CC: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <mingo@kernel.org>, <tglx@linutronix.de>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>
Subject: Re: [PATCH v2 RESEND] PREEMPT_RT: USB serial gadget: Fix locking
 issue
Message-ID: <20140619151057.GH23782@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140522140948.GB11707@saruman.home>
 <1400770651-30685-1-git-send-email-jjhiblot@traphandler.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFBW6CQlri5Qm8JQ"
Content-Disposition: inline
In-Reply-To: <1400770651-30685-1-git-send-email-jjhiblot@traphandler.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nFBW6CQlri5Qm8JQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2014 at 04:57:31PM +0200, Jean-Jacques Hiblot wrote:
> With CONFIG_PREEMPT_RT_FULL the tty_flip_buffer_push(..) actions are exec=
uted
> immeditely (same behaviour as if low_latency flag was set). We thus have =
to
> release port_lock before callng tty_flip_buffer_push().
>=20
> This issue resultst of commits:
> 44a0c019: USB: g_serial: don't set low_latency flag
> dc0cbd1b: serial: 8250: Call flush_to_ldisc when the irq is threaded
>=20
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> ---
> changes since v1:
>  - fix compilation problem: use port.tty instead of port->port_tty
>=20
>  drivers/usb/gadget/u_serial.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
> index b369292..3d4246d 100644
> --- a/drivers/usb/gadget/u_serial.c
> +++ b/drivers/usb/gadget/u_serial.c
> @@ -549,12 +549,25 @@ static void gs_rx_push(unsigned long _port)
>  		port->read_started--;
>  	}
>=20
> -	/* Push from tty to ldisc; without low_latency set this is handled by
> -	 * a workqueue, so we won't get callbacks and can hold port_lock
> -	 */
> -	if (do_push)
> +	/* Push from tty to ldisc */
> +	if (do_push) {
> +#ifndef CONFIG_PREEMPT_RT_FULL

can we drop the ifdef somehow ? Are there no better options here ?

> +		/* without low_latency set this is handled by a workqueue, so
> +		 * we won't get callbacks and can hold port_lock
> +		*/
>  		tty_flip_buffer_push(&port->port);
> -
> +#else
> +		/* CONFIG_PREEMPT_RT_FULL makes this a synchronous action. and
> +		 * it may trigger synchronous callbacks to this driver. We need
> +		 * to release the lock.
> +		*/
> +		spin_unlock_irq(&port->port_lock);
> +		tty_flip_buffer_push(&port->port);
> +		spin_lock_irq(&port->port_lock);
> +		/* tty may have been closed */
> +		tty =3D port->port.tty;
> +#endif
> +	}
>=20
>  	/* We want our data queue to become empty ASAP, keeping data
>  	 * in the tty and ldisc (not here).  If we couldn't push any
> --
> 1.9.2
>=20

--=20
balbi

--nFBW6CQlri5Qm8JQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTov2BAAoJEIaOsuA1yqREUiwP/1Ebt3CaWD+GfOVKxql4x5od
KjZ4m8+b37MirGK01SKLu+EUdSolQeUZuuCZY775B4Q41Im28Mg/UUfvBEIVRrlX
SXEXq1IWYriNh+VeR3go3I96rY1jrNxQfE9PtGr9VDR8oKDMyhfP/o/rtkL3YY5s
rIrFKrqfNAxXXpNxTmqO6cQ5xRCj+vzCg9NW7v893mKTpF7ZpQzNziwKrpPH8H9p
g+A0h4cUF0XJZnhWSTlM+zCOYIBByxoZieU0D3YDZJUp+9Xy+2+TVCQSyXCkvWbw
I8EqPbBlAWIMVaaaZHGxWcNlRBn92lv7c0+34u09bLB8Ef/ghlsXq6SxrhxFzlN3
MyFru7eRvAWzl/KPc3tufXI1ZfyjS/cOA/bsULgqZhym4ABMGeWzRiwTrDW/3SUa
Yy+b4z4/Jq9Bzgjxoy5W2xQVHn5DOXxDQXpnefgSNCB2OyXrRcH0Sigf1fnEqpnI
CXpcaG63CcvGBclrqc5Cu5U1d9zCXi3r6WSa3G2bnBhlx25azaocTkY0nDEBXLDC
9GUyJeawxIStRPxujBN3G6pUHmveSy5GRy2M+Gmp37irNtKHRNpxi4k6ANiI7N9e
UKWXYFMzsX7WhtRa4o+cT8b1ZBc8JDlI0RGlss+vT7oeqHC3a5+h+rzmKAwnmmxm
wcSsII2S+/SLJYmBVsKn
=H3qQ
-----END PGP SIGNATURE-----

--nFBW6CQlri5Qm8JQ--
