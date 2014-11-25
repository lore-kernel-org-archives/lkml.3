Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaKYHoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 02:44:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbaKYHoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 02:44:22 -0500
Date: Tue, 25 Nov 2014 15:42:23 +0800
From: Amos Kong <akong@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        herbert@gondor.apana.org.au, m@bues.ch, mb@bu3sch.de, mpm@selenic.com,
        amit.shah@redhat.com, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 4/6] hw_random: fix unregister race.
Message-ID: <20141125074223.GA11690@air.redhat.com>
References: <1415030186-18303-1-git-send-email-akong@redhat.com>
 <1415030186-18303-5-git-send-email-akong@redhat.com>
 <87y4rhm5fv.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <87y4rhm5fv.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
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

The cleanup function is a callback function of kref_put(), we can't
use the same reference count inside cleanup function.
=20
> We hold the mutex across cleanup, so we could grab that but we have to
> take care sleeping inside wait_event, otherwise Peter will have to fix
> my code again :)

We didn't hold rng_mutex inside cleanup_rng(), am I missing something?
=20
> AFAICT the wake_woken() stuff isn't merged yet, so your patch will
> have to do for now.

Can you provide some patches/mail link here? I searched nothing about wake_=
woken.
=20
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
>=20
> However, you should probably init cleanup_done in hwrng_register().
> (Probably noone does unregister then register, but let's be clear).

Got it.
=20
> Thanks,
> Rusty.
>=20
> >  }
> >  EXPORT_SYMBOL_GPL(hwrng_unregister);
> > =20
> > diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
> > index c212e71..7832e50 100644
> > --- a/include/linux/hw_random.h
> > +++ b/include/linux/hw_random.h
> > @@ -46,6 +46,7 @@ struct hwrng {
> >  	/* internal. */
> >  	struct list_head list;
> >  	struct kref ref;
> > +	bool cleanup_done;
> >  };
> > =20
> >  /** Register a new Hardware Random Number Generator driver. */
> > --=20
> > 1.9.3

--=20
			Amos.

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUdDLfAAoJELxSv6I5vP9jW4gP/2glGE79f30avT494VYlJK64
jN9dzIzfpGe3a+rD+w9XCD0MBq2dSxPV0BKeW98Zy7AJ52gDDIlmZkeU5cFA4iDi
z9an+3t5mxcb4poIUqyykXXiEsAXSS7DV+w+DkKYYFaXA/BAiht3kuNKwXqOb+N1
mjM3j2pNpIdb36V3lPekAxFN6LE/Gct8gJA9Om++gUWH67w4LeaFtxfHRlycMOix
T769rVwIAUdJ0ZZpIXTFbYyWzVSBvK+/iSMViFykwWkv0poaC+WBjHebBwFhDETX
Rau8b6bnYCbpqIU3HlJh67ffScpMNI3Ym/Zb/tq5iVD97M3CTee5c0tJrj696KJi
MxwSAT3NvmO9GglY5P2UlXLnjRFL061RWzPwsEg4wLY6kxJFQU721aX06WRRY/EP
uZiiXUpuFhm2qqRD615nV8V+6J84mugMmoq+jdEIOh2FOCGmTJ4MhQ3MIIM6P0SM
MZy8DKDEHmd3pJMH73MBrexN76wD/tQwJdirMw7djhkrKQqmabE1bbPgFwfW4Rl4
hpcfQakq1y+9i0U/yYHSA/MYTgM73rZH1szgAuq8PO72TAoKkLFCJVTHMCcOjV4v
3u7r+MDXhKHDJWgEwkSxC8M8jqeIe1IcyDEPfLVNJJVjVpdkwcpfidsAV1NljZqr
MrA0Note0GomruthFm0W
=YUhK
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
