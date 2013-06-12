Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab3FLGtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 02:49:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49467 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab3FLGtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 02:49:10 -0400
Date: Wed, 12 Jun 2013 16:48:48 +1000
From: NeilBrown <neilb@suse.de>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Dhaval Giani <dgiani@mozilla.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 5/8] vrange: Add new vrange(2) system call
Message-ID: <20130612164848.10b93db2@notabene.brown>
In-Reply-To: <1371010971-15647-6-git-send-email-john.stultz@linaro.org>
References: <1371010971-15647-1-git-send-email-john.stultz@linaro.org>
	<1371010971-15647-6-git-send-email-john.stultz@linaro.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/b0nI1FvxbWRiAuqajT_wD97"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/b0nI1FvxbWRiAuqajT_wD97
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Jun 2013 21:22:48 -0700 John Stultz <john.stultz@linaro.org> wro=
te:

> From: Minchan Kim <minchan@kernel.org>
>=20
> This patch adds new system call sys_vrange.
>=20
> NAME
> 	vrange - Mark or unmark range of memory as volatile
>=20
> SYNOPSIS
> 	int vrange(unsigned_long start, size_t length, int mode,
> 			 int *purged);
>=20
...
>=20
> 	purged: Pointer to an integer which will return 1 if
> 	mode =3D=3D VRANGE_NONVOLATILE and any page in the affected range
> 	was purged. If purged returns zero during a mode =3D=3D
> 	VRANGE_NONVOLATILE call, it means all of the pages in the range
> 	are intact.

This seems a bit ambiguous.
It is clear that the pointed-to location will be set to '1' if any part of
the range was purged, but it is not clear what will happen if it wasn't
purged.
The mention of 'returns zero' seems to suggest that it might set the locati=
on
to '0' in that case, but that isn't obvious to me.  The code appear to alwa=
ys
set it - that should be explicit.

Also, should the location be a fixed number of bytes to reduce possible
issues with N-bit userspace on M-bit kernels?

May I suggest:

        purge:  If not NULL, a pointer to a 32bit location which will be set
        to 1 if mode =3D=3D VRANGE_NONVOLATILE and any page in the affected=
 range
        was purged, and will be set to 0 in all other cases (including
        if mode =3D=3D VRANGE_VOLATILE).


I don't think any further explanation is needed.


> +	if (purged) {
> +		/* Test pointer is valid before making any changes */
> +		if (put_user(p, purged))
> +			return -EFAULT;
> +	}
> +
> +	ret =3D do_vrange(mm, start, end - 1, mode, &p);
> +
> +	if (purged) {
> +		if (put_user(p, purged)) {
> +			/*
> +			 * This would be bad, since we've modified volatilty
> +			 * and the change in purged state would be lost.
> +			 */
> +			BUG();
> +		}
> +	}

I agree that would be bad, but I don't think a BUG() is called for.  Maybe a
WARN, and certainly a "return -EFAULT;"

--Sig_/b0nI1FvxbWRiAuqajT_wD97
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUbgZ0Dnsnt1WYoG5AQJqbw//Zb5KkmJeLkSWquGmN5sLd0KuV+qm/xub
KnE5Ti8LHDvLkYW+DYmt0fhOZV7Q/V25dQ53oO+y5ia4b392kyJ+0PVaOaPX/SHG
8vuN9oBNaGKzYR7e5mOHqixJOnQcbZlP8H6TIld5R4VEsjvtQS6Q9/3dirdXdB4/
LhNSjJmplfQNMZbTQXvcorRdCxNHtosRGQarbsI9YM9Hvy1386FPG5JdHA3rDXrD
yA82BrH5A6V6IA++Sl4tuaFUPWY3a96ErsS7CIqLOT22uBe85N/WEbKOz0y9tP5H
ILlquYUuSHayi2i5zkY08VIZii3wdMWiw2cfNIGdVpSpI9QPEiX5tXrmBbveN6Hf
MyD8SLJ4r45kD09vvehBsi0ZJhiXeJCTCscyc4O0Oz9hoeymAXGPltWLVfz5SkTa
Lq6WLMMZN+YlEhX+RlVwk6LBda2iMRvf1FWhnSH+ANjkNQ/tfGBvCxhwq2JAYtG+
2qv48i+pz8AGlxZ6AsCgrdpGE3c5hfJ1bPUGAzNRpk3PjWzL0Dt5PWdFqReU5zs/
tR90isndAoHIZoWJWM1YcHf+v7MClbGm9vH5L845JNB+/Zjy7KkyPOOYIUWo5RzZ
f4nagLWmg1TO74l8zfmx/14RnvMLfhZRG9aaHTMNt+Qi5m/O+f/Q5ls3cDfIlFjx
IqbaGNLzzzc=
=AQM0
-----END PGP SIGNATURE-----

--Sig_/b0nI1FvxbWRiAuqajT_wD97--
