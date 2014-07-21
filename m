Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbaGUGSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 02:18:44 -0400
Received: from goedel.dlitz.net ([64.5.53.201]:47113 "EHLO goedel.dlitz.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbaGUGSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 02:18:42 -0400
Date: Sun, 20 Jul 2014 23:18:39 -0700
From: Dwayne Litzenberger <dlitz@dlitz.net>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-abi@vger.kernel.org,
        linux-crypto@vger.kernel.org, beck@openbsd.org
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Message-ID: <20140721061839.GA19200@rivest.lan>
References: <1405588695-12014-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <1405588695-12014-1-git-send-email-tytso@mit.edu>
X-Homepage: https://www.dlitz.net/
X-OpenPGP: url=https://www.dlitz.net/go/gpgkey/;
 id=19E11FE8B3CFF273ED174A24928CEC1339C25CF7; preference=signencrypt
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2014 at 05:18:15AM -0400, Theodore Ts'o wrote:
>SYNOPSIS
>	#include <linux/random.h>
>
>	int getrandom(void *buf, size_t buflen, unsigned int flags);
>
>DESCRIPTION
>
>	The system call getrandom() fills the buffer pointed to by buf
>	with up to buflen random bytes which can be used to seed user
>	space random number generators (i.e., DRBG's) or for other
>	cryptographic processes.  It should not be used Monte Carlo
>	simulations or for other probabilistic sampling applications.

Aside from poor performance for the offending application, will anything
actually break if an application ignores this warning and makes heavy
use of getrandom(2)?  It would be helpful if the documentation made this
clearer, rather than just saying, "don't do that".

As the developer of a userspace crypto library, I can't always prevent
downstream developers from doing silly things, and many developers
simply don't understand different "kinds" of random numbers, so I prefer
to tell them to just use the kernel CSPRNG by default, and to ask for
help once they run into performance problems.  It's not ideal, but it's
safer than the alternative.[1]

>	If the GRND_RANDOM flags bit is set, then draw from the
>	/dev/random pool instead of /dev/urandom pool.  The /dev/random
>	pool is limited based on the entropy that can be obtained from
>	environmental noise, so if there is insufficient entropy, the
>	requested number of bytes may not be returned.  If there is no
>	entropy available at all, getrandom(2) will either return an
>	error with errno set to EAGAIN, or block if the GRND_BLOCK flags
>	bit is set.
>
>	If the GRND_RANDOM flags bit is not set, then the /dev/raundom
>	pool will be used.  Unlike reading from the /dev/urandom, if
>	the urandom pool has not been sufficiently initialized,
>	getrandom(2) will either return an error with errno set to
>	EGAIN, or block if the GRND_BLOCK flags bit is set.
>
>RETURN VALUE
>       On success, the number of bytes that was returned is returned.
>
>       On error, -1 is returned, and errno is set appropriately

Hm.  Is it correct that, in blocking mode, the call is guaranteed either
to return -EINVAL immediately, or to block until the buffer is
*completely* populated with buflen bytes?  If so, I think a few small
changes could make this a really nice interface to work with:

* Use blocking mode by default.

* Add a new flag called GRND_PARTIAL (replacing GRND_BLOCK), which
  indicates that the caller is prepared to handle a partial/incomplete
  result.

* On success with GRND_PARTIAL, return the number of bytes that were
  written into buf.  (Or -EAGAIN, as is currently done.)

* If GRND_PARTIAL is *not* set, just return 0 on success.  (This avoids
  all signed-unsigned confusion when buflen > INT_MAX.)

With those changes, it would be trivial for a userspace library to
implement a reliable RNG interface as recommended in [2] or [3]:

/*
 * memzap(3)
 *
 * Fills the buffer pointed to by buf with exactly buflen random bytes
 * suitable for cryptographic purposes.  Nothing is returned.
 *
 * This function is thread-safe, and is safe to call from inside a
 * signal handler.
 *
 * It blocks if the kernel random number generator is not yet fully
 * initialized (e.g. early in the boot process), and it may trigger
 * abort(3) if invoked on an old kernel version that does not support
 * the getrandom(2) system call.
 */
void memzap(void *buf, size_t buflen)
{
        int     ret;

        ret =3D getrandom(buf, buflen, 0);
        if (ret !=3D 0) {
                perror("getrandom(2) failed");
                abort();
        }
}

Best,
- Dwayne

P.S.  If I had my way, I would also drop GRND_RANDOM.  Most software
won't use it, there's no legacy installed base, and no developer who
still wants that behavior can legitimately claim to care about RNG
availability guarantees, IMHO.  Anyone who really wants the old
/dev/random behavior can always just continue to use the existing
character device.  I don't really care enough to put up a fight about
it, though, as long as it doesn't affect the quality of the
non-GRND_RANDOM interface.


[1] On more than one occasion, I've seen developers use Python's
    standard "random" module to generate IVs.  I mean, why not?  IVs are
    public, right?
[2] http://cr.yp.to/highspeed/coolnacl-20120725.pdf
[3] https://groups.google.com/forum/#!msg/randomness-generation/4opmDHA6_3w=
/__TyKhbnNWsJ

--=20
Dwayne C. Litzenberger <dlitz@dlitz.net>
 OpenPGP: 19E1 1FE8 B3CF F273 ED17  4A24 928C EC13 39C2 5CF7

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iFYEAREKAAYFAlPMsL8ACgkQm4qoyix3/7CyzQDbBEwr2ZIjtJCKX1gXI3evDAx2
fs4tOr0sMV2iJgDfba0TIs7If1OUmHRbcH3HhqvCn+eOMZrCu+LyqQ==
=gXvl
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
