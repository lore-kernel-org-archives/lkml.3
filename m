Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbaKQPWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 10:22:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbaKQPWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 10:22:14 -0500
Date: Mon, 17 Nov 2014 23:20:53 +0800
From: Amos Kong <akong@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        herbert@gondor.apana.org.au, m@bues.ch, mb@bu3sch.de, mpm@selenic.com,
        amit.shah@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/6] hw_random: use reference counts on each struct
 hwrng.
Message-ID: <20141117152053.GB12501@air.redhat.com>
References: <1415030186-18303-1-git-send-email-akong@redhat.com>
 <1415030186-18303-4-git-send-email-akong@redhat.com>
 <87zjbxm6fw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E39vaYmALEf/7YXx"
Content-Disposition: inline
In-Reply-To: <87zjbxm6fw.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E39vaYmALEf/7YXx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2014 at 02:11:23PM +1030, Rusty Russell wrote:
> Amos Kong <akong@redhat.com> writes:
> > From: Rusty Russell <rusty@rustcorp.com.au>
> >
> > current_rng holds one reference, and we bump it every time we want
> > to do a read from it.
> >
> > This means we only hold the rng_mutex to grab or drop a reference,
> > so accessing /sys/devices/virtual/misc/hw_random/rng_current doesn't
> > block on read of /dev/hwrng.
> >
> > Using a kref is overkill (we're always under the rng_mutex), but
> > a standard pattern.
> >
> > This also solves the problem that the hwrng_fillfn thread was
> > accessing current_rng without a lock, which could change (eg. to NULL)
> > underneath it.
> >
> > v4: decrease last reference for triggering the cleanup
>=20
> This doesn't make any sense:
>=20
> > +static void drop_current_rng(void)
> > +{
> > +	struct hwrng *rng =3D current_rng;
> > +
> > +	BUG_ON(!mutex_is_locked(&rng_mutex));
> > +	if (!current_rng)
> > +		return;
> > +
> > +	/* release current_rng reference */
> > +	kref_put(&current_rng->ref, cleanup_rng);
> > +	current_rng =3D NULL;
> > +
> > +	/* decrease last reference for triggering the cleanup */
> > +	kref_put(&rng->ref, cleanup_rng);
> > +}
>=20
> Why would it drop the refcount twice?  This doesn't make sense.
>=20
> Hmm, because you added kref_init, which initializes the reference count
> to 1, you created this bug.

I saw some kernel code uses kref_* helper functions, the reference
conter is initialized to 1. Some code didn't use the helper functions
to increase/decrease the reference counter. So I will drop kref_init()
and the second kref_put().
=20
> Leave out the kref_init, and let it naturally be 0 (until, and if, it
> becomes current_rng).  Add a comment if you want.

OK, thanks.
=20
> Thanks,
> Rusty.
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
			Amos.

--E39vaYmALEf/7YXx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUahJVAAoJELxSv6I5vP9jsyoP/2IxbrCRKcyQEFRKl/mfM7uu
0o/M5XSPKp6yaDhS8pA0e+uEAg/sLHe5dW8OB87iZjW8lbGSde7DW5bM6dbh6FOx
DV1qinwVIT5au8cRIzt4uV2U4yQalg6U0aNI/mhF058jcAGquhN0ItbpRRDn6SGP
SDCX4NtKG4NFtD1QaRfvNksYdjn+a/0zVAj7twTJtC9T0VgBYYDdTlsM207omtpo
b45If34dBmweU5CxK9YF4v3VP0AFdpT+pdk9/vKOp3+V7SZ1ZnOVekAhZtfPz2om
wr5V/fAzMJVQSq2jVq0+GA1P+yUj3+uhnSLTXlnZ00g6EB02pfrsOJJzoHIyTzUW
hJt1ed72nwmFtYLbxS7K5nhp71oIfZUqOjDivvxjML0/9jiO1ozwQ8stAsO9fS/6
gXVE2v5z4nxv4+WnhFew9tdwjQMTZ0U1I8z+CxmMhWTNB4DunPXlsfdjaa51W82R
ezW76FA1dqiDsERH9Mkc6g6UN9q4iNLd7afhNP5BTVX8GBsQ5xmLSMR9nHxfDxFF
PTMnzqeWjONPGQHT7txpMW7V30MdieeKk+hh3NlSbyXKi/8PV4w8r8gCECiZz0sV
cdzhzAfcJ2L7pil7vvDcHs6aHvfqc04cGY719EIF2eiPrT+1kHHZGfMH+jwXIYiC
iiPoiLJcq2Iwgb22fCFa
=DMq1
-----END PGP SIGNATURE-----

--E39vaYmALEf/7YXx--
