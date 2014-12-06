Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaLFDvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 22:51:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbaLFDvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 22:51:46 -0500
Date: Sat, 6 Dec 2014 11:51:16 +0800
From: Amos Kong <akong@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        herbert@gondor.apana.org.au, m@bues.ch, mpm@selenic.com,
        amit.shah@redhat.com, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 4/6] hw_random: fix unregister race.
Message-ID: <20141206035116.GA1995@air.redhat.com>
References: <1415030186-18303-1-git-send-email-akong@redhat.com>
 <1415030186-18303-5-git-send-email-akong@redhat.com>
 <87y4rhm5fv.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
In-Reply-To: <87y4rhm5fv.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2014 at 02:33:00PM +1030, Rusty Russell wrote:
> Amos Kong <akong@redhat.com> writes:
> > From: Rusty Russell <rusty@rustcorp.com.au>
> >
> > The previous patch added one potential problem: we can still be
> > reading from a hwrng when it's unregistered.  Add a wait for zero
> > in the hwrng_unregister path.
> >
> > v4: add cleanup_done flag to insure that cleanup is done
>=20
> That's a bit weird.  The usual pattern would be to hold a reference
> until we're actually finished, but this reference is a bit weird.
>=20
> We hold the mutex across cleanup, so we could grab that but we have to
> take care sleeping inside wait_event, otherwise Peter will have to fix
> my code again :)
>=20
> AFAICT the wake_woken() stuff isn't merged yet, so your patch will
> have to do for now.
>=20
> > @@ -98,6 +99,8 @@ static inline void cleanup_rng(struct kref *kref)
> > =20
> >  	if (rng->cleanup)
> >  		rng->cleanup(rng);
> > +	rng->cleanup_done =3D true;
> > +	wake_up_all(&rng_done);
> >  }
> > =20
> >  static void set_current_rng(struct hwrng *rng)
> > @@ -536,6 +539,11 @@ void hwrng_unregister(struct hwrng *rng)
> >  			kthread_stop(hwrng_fill);
> >  	} else
> >  		mutex_unlock(&rng_mutex);
> > +
> > +	/* Just in case rng is reading right now, wait. */
> > +	wait_event(rng_done, rng->cleanup_done &&
> > +		   atomic_read(&rng->ref.refcount) =3D=3D 0);
> > +
>=20
> The atomic_read() isn't necessary here.

At least, we need it to convert refcount from atomic_t to int.
Otherwise, we will touch this error:

  error: invalid operands to binary =3D=3D (have 'atomic_t' and 'int')
=20
> However, you should probably init cleanup_done in hwrng_register().
> (Probably noone does unregister then register, but let's be clear).
>=20
> Thanks,
> Rusty.

--=20
			Amos.

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUgn00AAoJELxSv6I5vP9jWKAP/3D6eUg4/SpT7C72Djj8Sp8D
igLKYw1x9KwYyxh8k2Uh4fGYWHTEwotCQYKmBPsVA7N+K3qG6z1+RSJAvkMEBrwq
/42wL+CWGS9fH6vXT5rnVxTKCw7n+KA7gaODc+lDIsjXqIBOvYo+RYWlwM4xZni5
6kDt1zNtKLLi8M+cSS1P5k0y1oST5uUHYDbFzYHuXbHxPv6lW3k2gTMFB/Bj7fZR
dVWDjvOgEzcR6nJV6ReMxfM5EWuKfVCZwahhMNLDp41L5pWKYKtkKEtdULulK2AO
XqQktp5lm4X54LvE4AId5apDrjPX4tpV4xGy1vOS4gmfBKQKe0YYzeNWxrLeBulq
8/WIDQrLEWpKbAEv0IooQeZ7asxgqHhk/9nIRGxfEoiMzlQOq+4yVyMkfHkGhMts
wdZoKv5gGs8JryN4LLEeovtDvpgegbw0j7xdkDHI+k1yWxqEGJE+pBwbpn8IcHeO
dvD/mESXgiyiJK9anJZgCMAj0pTM8rVctfUin+IDR4proPDBePStsrbfI9eAkbSw
wBzYL4INUTauG0Q83OP/CNJQR28zjQ4LZbyi909dFAYxnBXwZh45dlFENcFGhkdy
b7eI8YJ4C7ToUngbMFNhRYouDzcSeG/TZJYd79jntyMIKCv1YtS6+cBd4MgBMnLe
W8Ekjz2rMjPUqskiTO9/
=zx2f
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
