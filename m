Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934496Ab3CUQnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:43:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41986 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934262Ab3CUQnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:43:01 -0400
Date: Thu, 21 Mar 2013 18:42:04 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kent Overstreet <koverstreet@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-aio@kvack.org>,
        <akpm@linux-foundation.org>, Zach Brown <zab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 03/33] gadget: remove only user of aio retry
Message-ID: <20130321164203.GC15740@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
 <1363883754-27966-4-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vEao7xgI/oilGqZ+"
Content-Disposition: inline
In-Reply-To: <1363883754-27966-4-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vEao7xgI/oilGqZ+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Mar 21, 2013 at 09:35:24AM -0700, Kent Overstreet wrote:
> From: Zach Brown <zab@redhat.com>
>=20
> This removes the only in-tree user of aio retry.  This will let us remove
> the retry code from the aio core.
>=20
> Removing retry is relatively easy as the USB gadget wasn't using it to
> retry IOs at all.  It always fully submitted the IO in the context of the
> initial io_submit() call.  It only used the AIO retry facility to get the
> submitter's mm context for copying the result of a read back to user
> space.  This is easy to implement with use_mm() and a work struct, much
> like kvm does with async_pf_execute() for get_user_pages().
>=20
> Signed-off-by: Zach Brown <zab@redhat.com>
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Asai Thambi S P <asamymuthupa@micron.com>
> Cc: Selvan Mani <smani@micron.com>
> Cc: Sam Bradshaw <sbradshaw@micron.com>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Benjamin LaHaise <bcrl@kvack.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

I don't have any objections with the approach. Let's see if anyone from
linux-usb has anything to say, though

>  drivers/usb/gadget/inode.c | 38 +++++++++++++++++++++++++++++---------
>  1 file changed, 29 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
> index e2b2e9c..a1aad43 100644
> --- a/drivers/usb/gadget/inode.c
> +++ b/drivers/usb/gadget/inode.c
> @@ -24,6 +24,7 @@
>  #include <linux/sched.h>
>  #include <linux/slab.h>
>  #include <linux/poll.h>
> +#include <linux/mmu_context.h>
> =20
>  #include <linux/device.h>
>  #include <linux/moduleparam.h>
> @@ -513,6 +514,9 @@ static long ep_ioctl(struct file *fd, unsigned code, =
unsigned long value)
>  struct kiocb_priv {
>  	struct usb_request	*req;
>  	struct ep_data		*epdata;
> +	struct kiocb 		*iocb;
> +	struct mm_struct 	*mm;
> +	struct work_struct	work;
>  	void			*buf;
>  	const struct iovec	*iv;
>  	unsigned long		nr_segs;
> @@ -540,15 +544,12 @@ static int ep_aio_cancel(struct kiocb *iocb, struct=
 io_event *e)
>  	return value;
>  }
> =20
> -static ssize_t ep_aio_read_retry(struct kiocb *iocb)
> +static ssize_t ep_copy_to_user(struct kiocb_priv *priv)
>  {
> -	struct kiocb_priv	*priv =3D iocb->private;
>  	ssize_t			len, total;
>  	void			*to_copy;
>  	int			i;
> =20
> -	/* we "retry" to get the right mm context for this: */
> -
>  	/* copy stuff into user buffers */
>  	total =3D priv->actual;
>  	len =3D 0;
> @@ -568,9 +569,26 @@ static ssize_t ep_aio_read_retry(struct kiocb *iocb)
>  		if (total =3D=3D 0)
>  			break;
>  	}
> +
> +	return len;
> +}
> +
> +static void ep_user_copy_worker(struct work_struct *work)
> +{
> +	struct kiocb_priv *priv =3D container_of(work, struct kiocb_priv, work);
> +	struct mm_struct *mm =3D priv->mm;
> +	struct kiocb *iocb =3D priv->iocb;
> +	size_t ret;
> +
> +	use_mm(mm);
> +	ret =3D ep_copy_to_user(priv);
> +	unuse_mm(mm);
> +
> +	/* completing the iocb can drop the ctx and mm, don't touch mm after */
> +	aio_complete(iocb, ret, ret);
> +
>  	kfree(priv->buf);
>  	kfree(priv);
> -	return len;
>  }
> =20
>  static void ep_aio_complete(struct usb_ep *ep, struct usb_request *req)
> @@ -596,14 +614,14 @@ static void ep_aio_complete(struct usb_ep *ep, stru=
ct usb_request *req)
>  		aio_complete(iocb, req->actual ? req->actual : req->status,
>  				req->status);
>  	} else {
> -		/* retry() won't report both; so we hide some faults */
> +		/* ep_copy_to_user() won't report both; we hide some faults */
>  		if (unlikely(0 !=3D req->status))
>  			DBG(epdata->dev, "%s fault %d len %d\n",
>  				ep->name, req->status, req->actual);
> =20
>  		priv->buf =3D req->buf;
>  		priv->actual =3D req->actual;
> -		kick_iocb(iocb);
> +		schedule_work(&priv->work);
>  	}
>  	spin_unlock(&epdata->dev->lock);
> =20
> @@ -633,8 +651,10 @@ fail:
>  		return value;
>  	}
>  	iocb->private =3D priv;
> +	priv->iocb =3D iocb;
>  	priv->iv =3D iv;
>  	priv->nr_segs =3D nr_segs;
> +	INIT_WORK(&priv->work, ep_user_copy_worker);
> =20
>  	value =3D get_ready_ep(iocb->ki_filp->f_flags, epdata);
>  	if (unlikely(value < 0)) {
> @@ -646,6 +666,7 @@ fail:
>  	get_ep(epdata);
>  	priv->epdata =3D epdata;
>  	priv->actual =3D 0;
> +	priv->mm =3D current->mm; /* mm teardown waits for iocbs in exit_aio() =
*/
> =20
>  	/* each kiocb is coupled to one usb_request, but we can't
>  	 * allocate or submit those if the host disconnected.
> @@ -674,7 +695,7 @@ fail:
>  		kfree(priv);
>  		put_ep(epdata);
>  	} else
> -		value =3D (iv ? -EIOCBRETRY : -EIOCBQUEUED);
> +		value =3D -EIOCBQUEUED;
>  	return value;
>  }
> =20
> @@ -692,7 +713,6 @@ ep_aio_read(struct kiocb *iocb, const struct iovec *i=
ov,
>  	if (unlikely(!buf))
>  		return -ENOMEM;
> =20
> -	iocb->ki_retry =3D ep_aio_read_retry;
>  	return ep_aio_rwtail(iocb, buf, iocb->ki_left, epdata, iov, nr_segs);
>  }
> =20
> --=20
> 1.8.1.3
>=20

--=20
balbi

--vEao7xgI/oilGqZ+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRSzhbAAoJEIaOsuA1yqRElPcP/1IDdcz44JYvfE8qQcmJE3lu
INwDi3x3aMmZsi5KKRg+aXCYi0aDqsySuEHcyS9IOCJdYKpqOZD9L+bpcBqg6hp+
g8V7+zeFu+5wIxUMV0RZ/bo+d2zKuaGjZbwXDcnREIc/27BqXHEr+R0IIjXffn7V
BGs47u4iAf/wjT9pz8uoY6zSKb2DzqRaM+y0/6/fgXe8bhln91ncvHXgUK7DAZLP
t5JSIOxrJ+Omy8r1qDAZCTeXxUJ0eqQ6vtCSjQP5OG80jIUqaIoKN72RLn03ltJw
Ojib9wo3Nfkhz+50lfupqPA6mAMwMDZ4Rs+TjCcH+yIh2szE9sTLYo2sHoNATbAT
11tV9MpILvhVC7i2CWJ055AKTedWi2CIDo+NTef3A7NW/ifJqLz5sqvV5Jiaa3+f
vqfyGQvuKCZSRuc4j4FqzHm+eZR41VfFic62evjJVHuwhCIwKObFWW+IlAxglpnh
4kE1pc9NDxx2YWguZ/N+ZvSH4kQ2lNkDHC4sNS/oaN1Y/BgDkXjmLCs5BBVCenge
4n1AY0Upt0q7sdkGkZ6vmmcu/kLSGDg3KgN3X2Yg5HH3Umv21r/2Occtb1N92Diy
Is9jAsTsJ1ssfxZERgpwaCkpjuPgYJLTr0ujzjDboUaPEoEOw2uxn/NtdC9dMJoW
jr0scp4j2q2a3J6j8mGi
=etWw
-----END PGP SIGNATURE-----

--vEao7xgI/oilGqZ+--
