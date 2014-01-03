Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbaACWEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 17:04:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37355 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbaACWEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 17:04:48 -0500
Message-ID: <52C733F0.7070103@suse.com>
Date: Fri, 03 Jan 2014 17:04:32 -0500
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Knut Petersen <Knut_Petersen@t-online.de>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, reiserfs-devel@vger.kernel.org
Subject: Re: [BUG 3.13.0-rc6] reiserfs possible circular locking dependency
References: <52C70C75.4050502@t-online.de> <CA+55aFxVs_aGnMdcTck3C7AayFrjX=GrFSwmJwiC9q3-3wySgw@mail.gmail.com>
In-Reply-To: <CA+55aFxVs_aGnMdcTck3C7AayFrjX=GrFSwmJwiC9q3-3wySgw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="eeUIH98CBb73u1uh7q12sCTL8gKPH2csf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eeUIH98CBb73u1uh7q12sCTL8gKPH2csf
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 1/3/14, 2:46 PM, Linus Torvalds wrote:
> On Fri, Jan 3, 2014 at 11:16 AM, Knut Petersen
> <Knut_Petersen@t-online.de> wrote:
>> Rebooting after a power failure on an openSuSE 13.1 system
>> with kernel 3.13.0-rc6 triggered the attached lockdep warning.
>=20
> Hmm. It seems to be that the *normal* sequence should be:
>=20
>  - get i_mutex, call lookup, which gets sbi->lock (reiserfs_write_lock)=

>=20
> but in the mounting path, we have special circumstances.
>=20
> That finish_unfinished() function does
>=20
>  - reiserfs_write_lock_nested() .
>  - remove_save_link
>  - iput(inode) with the write lock held
>=20
> and that can apparently end up taking i_mutex in open_xa_dir (and then
> recursively the write lock, but that's an explicitly recursive lock,
> so that part should be ok).
>=20
> Now, I don't think this can *really* deadlock with the normal order of
> operations, because during mounting there is no other process that can
> take those in the reverse order (since the filesystem isn't live), but
> I do wonder if we should just release the reiserfs write lock over the
> iputs. We release it in other parts anyway (like for the quota off)
>=20
> Jeff, you already touched this exact case in commit d2d0395fd177
> ("reiserfs: locking, release lock around quota operations") except
> that was for those quota operation cases.
>=20
> Even if it's not a real problem, making lockdep happy sounds like a
> good idea. Of course, the trouble is that this code path almost never
> gets exercised (which is why this hasn't been noticed earlier), so
> testing...
>=20
> Jeff? Comments?

If someone ever invents a time machine, I'd go back to 2004 and tell
myself to fight harder to make a reiserfs v3.7 with real extended
attribute items. This code will haunt me to my death.

Anyway, yeah. The right thing here is to drop the lock for the iput.
More than that would be ok too. finish_unfinished happens when the file
system goes read-write and that includes the remount path. There can be
other users of the file system but it would be a recursive acquire so we
wouldn't actually deadlock there.

I'll work something up over the weekend or on Monday.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--eeUIH98CBb73u1uh7q12sCTL8gKPH2csf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)

iQIcBAEBAgAGBQJSxzPzAAoJEB57S2MheeWy6jMP/3R+pkIQjf7nVkbuKPVpu68q
KQGjNHmgdvfMJRfNKgRV9k5RSVcVGPfPB5UiY/3Q7ipPSDJV9dH4+TgaQF7SQq2K
Pq51aCRgYh24ur8qZQDOD0O9c2PbVAzL2DEzZZKE1vqYE+Paj5QRgeOBo3Lqa1x5
M/bJB9RCAecd7MQ0jUKt0UKKz4TNnBqbOi3i16zswLQNanBZ3xXbIo8q9fZy9a69
bpdcEQiivdtEPVV0yqsZPNIRqk7jPPVgWVAZ4CpssHGX6Mu8cwAdqITFiJqL7RrW
RB/uN4ANI9pEyAqw4MXnaA6RqrAdvUDx6+A4lVm+0pBkJJv78DNVklhBhgdzkSFm
leczIHl6JEt/lhs06larPKHViQ77k5fjQQ1n1FPqirckGZOCGQeIT/5Llq8kuVMN
R7nQ5CQHjq/kXPDJzhH2KlnwZOpSSiNQA1Q/6vkLho6VVk38ZoQ1ebkiaimVnay2
IDIv9hSZnOSt+dWLddaAeoATyX0WVuKFf2IzKAL76DUhK7A8gqij9kcy6N+pHJYu
OOadigIib0p4CVGWKHXPDQJIAK/3EsFfKI8Uq3pLX8yfAUYY2HrXt4Uj71gy8ILR
X5AL2e40/lsIte/7qVguQeB/7NRhrVFOzLQnbZ78Ac1GmsL+Pd0rTicl3xcXrPxR
VnyK61Y2arfR/ljymBq8
=KIP8
-----END PGP SIGNATURE-----

--eeUIH98CBb73u1uh7q12sCTL8gKPH2csf--
