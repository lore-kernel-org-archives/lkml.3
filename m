Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbaCIA11 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 19:27:27 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49047 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896AbaCIA1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 19:27:25 -0500
Message-ID: <1394324841.2861.56.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH RT 2/5] a few open coded completions
From: Ben Hutchings <ben@decadent.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, Corey Minyard <cminyard@mvista.com>
Date: Sun, 09 Mar 2014 00:27:21 +0000
In-Reply-To: <20131211144946.27d82a78@gandalf.local.home>
References: <20131211003732.351606520@goodmis.org>
	 <20131211003801.836995968@goodmis.org>
	 <20131211144946.27d82a78@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-AQxkwQnpp0rqhfMLtmS+"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.245
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AQxkwQnpp0rqhfMLtmS+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-12-11 at 14:49 -0500, Steven Rostedt wrote:
> Here's the new patch:

Doesn't add #includes and doesn't change any types, so of course it
doesn't compile.  WTF?

Ben.

> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Date: Mon, 28 Oct 2013 11:50:06 +0100
> Subject: [PATCH] swait: Add a few more users
>=20
> The wait-simple queue is lighter weight and more efficient than the full
> wait queue, and may be used in atomic context on PREEMPT_RT.
>=20
> Fix up some places that needed to call the swait_*() functions instead
> of the wait_*() functions.
>=20
> Cc: stable-rt@vger.kernel.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  drivers/net/wireless/orinoco/orinoco_usb.c | 2 +-
>  drivers/usb/gadget/f_fs.c                  | 2 +-
>  drivers/usb/gadget/inode.c                 | 4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wir=
eless/orinoco/orinoco_usb.c
> index 1f9cb55..a28f298 100644
> --- a/drivers/net/wireless/orinoco/orinoco_usb.c
> +++ b/drivers/net/wireless/orinoco/orinoco_usb.c
> @@ -714,7 +714,7 @@ static void ezusb_req_ctx_wait(struct ezusb_priv *upr=
iv,
>  			while (!ctx->done.done && msecs--)
>  				udelay(1000);
>  		} else {
> -			wait_event_interruptible(ctx->done.wait,
> +			swait_event_interruptible(ctx->done.wait,
>  						 ctx->done.done);
>  		}
>  		break;
> diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
> index b6e9d91..35d9c53 100644
> --- a/drivers/usb/gadget/f_fs.c
> +++ b/drivers/usb/gadget/f_fs.c
> @@ -1282,7 +1282,7 @@ static void ffs_data_put(struct ffs_data *ffs)
>  		pr_info("%s(): freeing\n", __func__);
>  		ffs_data_clear(ffs);
>  		BUG_ON(waitqueue_active(&ffs->ev.waitq) ||
> -		       waitqueue_active(&ffs->ep0req_completion.wait));
> +		       swaitqueue_active(&ffs->ep0req_completion.wait));
>  		kfree(ffs->dev_name);
>  		kfree(ffs);
>  	}
> diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
> index 570c005..c60233d 100644
> --- a/drivers/usb/gadget/inode.c
> +++ b/drivers/usb/gadget/inode.c
> @@ -340,7 +340,7 @@ ep_io (struct ep_data *epdata, void *buf, unsigned le=
n)
>  	spin_unlock_irq (&epdata->dev->lock);
> =20
>  	if (likely (value =3D=3D 0)) {
> -		value =3D wait_event_interruptible (done.wait, done.done);
> +		value =3D swait_event_interruptible (done.wait, done.done);
>  		if (value !=3D 0) {
>  			spin_lock_irq (&epdata->dev->lock);
>  			if (likely (epdata->ep !=3D NULL)) {
> @@ -349,7 +349,7 @@ ep_io (struct ep_data *epdata, void *buf, unsigned le=
n)
>  				usb_ep_dequeue (epdata->ep, epdata->req);
>  				spin_unlock_irq (&epdata->dev->lock);
> =20
> -				wait_event (done.wait, done.done);
> +				swait_event (done.wait, done.done);
>  				if (epdata->status =3D=3D -ECONNRESET)
>  					epdata->status =3D -EINTR;
>  			} else {

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-AQxkwQnpp0rqhfMLtmS+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUxu1aee/yOyVhhEJAQoEMhAAmKese8QJW1GhSuI8sGsWf1j+0KTA6Y21
Ms+oBTw9YJ0cKYxDzutkpxU1LeJBjv8TpDxyeFQueG+qLvr442Rn1uekcRNFvb58
0ydOrNgisRzwCOVBo85iDqVgyZzu1sJxaIJRjyGOmUVHUPj4zq7KjtyiEPB3EBNs
z5hLLAXpUFnDmB44aRxu4gxPuOa7sskcDYKOlMOQrMnTSqbBDMRJ91pJJXbjAKt/
bJLRJbINUJ2TM1e1VUWQAjBaYyEYyh+9d4ZYQ5hcn431EK1XGfJgn080vDXZt73h
zf8m/PtFqKVuxILVq030QlLxPrdqxNPAivVHPd+AE2g4IrQ1h37VP4f5xHhKqTDp
OxER9uy61/inxvGddffgIsPUY4zgdSMWElYeQholtLqgpBaEgTou5AGUmChHfVby
okHyIgcpBIbqvLjjOfwcpJY+rqE9QraSq0uM+nNOnd9xbS10+gVvymzvV4HdQLve
pw2vd8uNWG2It1KjEMEhrzMhhLr75q7EmTl/GXmQfrOFaPxx4v7Rxaz5LEr+UQEf
p9lIHvcVg4xOrEZH7dgZZ92bMUcf4Ka56JZHGRQkQ9pEIgaKYyatGlLs+BPMwEk5
v32MTbaHUICHqYbgiRcJpQipW5X91qL2pnpdhlXMBdujH1uEePJlvUS9MY0NK9uZ
Okspt0vXkxI=
=pzQ5
-----END PGP SIGNATURE-----

--=-AQxkwQnpp0rqhfMLtmS+--
