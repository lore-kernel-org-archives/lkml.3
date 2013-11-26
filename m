Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab3KZXEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 18:04:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46131 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756538Ab3KZXEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 18:04:45 -0500
Date: Wed, 27 Nov 2013 10:04:30 +1100
From: NeilBrown <neilb@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vitaly Mayatskikh <v.mayatskih@gmail.com>,
        "Murty, Ravi" <ravi.murty@intel.com>
Subject: Re: copy_from_user_*() and buffer zeroing
Message-ID: <20131127100430.0486a001@notabene.brown>
In-Reply-To: <529520AB.2020407@zytor.com>
References: <52950D7B.304@zytor.com>
	<20131126135454.b5e9597a998509f1ab43cee4@linux-foundation.org>
	<529520AB.2020407@zytor.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3RTKswm=WoBv3_b.=/YAD1e"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/3RTKswm=WoBv3_b.=/YAD1e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 26 Nov 2013 14:28:59 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:

> On 11/26/2013 01:54 PM, Andrew Morton wrote:
> >=20
> > Nine years ago:
> >=20
> > commit 7079f897164cb14f616c785d3d01629fd6a97719
> > Author: mingo <mingo>
> > Date:   Fri Aug 27 17:33:18 2004 +0000
> >=20
> >     [PATCH] Add a few might_sleep() checks
> >    =20
> >     Add a whole bunch more might_sleep() checks.  We also enable might_=
sleep()
> >     checking in copy_*_user().  This was non-trivial because of the "co=
py_*_user()
> >     in atomic regions" trick would generate false positives.  Fix that =
up by
> >     adding a new __copy_*_user_inatomic(), which avoids the might_sleep=
() check.
> >    =20
> >     Only i386 is supported in this patch.
> >=20
> >=20
> > I can't think of any reason why __copy_from_user_inatomic() should be
> > non-zeroing.  But maybe I'm missing something - this would pretty
> > easily permit uninitialised data to appear in pagecache and someone
> > surely would have noticed..
> >=20
>=20
> Yes, and the might_sleep() check is indeed bypassed.
>=20
> However, the non-zeroing bit is currently motivated by the following
> comment:
>=20
> /**
>  * __copy_from_user: - Copy a block of data from user space, with less
> checking.
>  * @to:   Destination address, in kernel space.
>  * @from: Source address, in user space.
>  * @n:    Number of bytes to copy.
>  *
>  * Context: User context only.  This function may sleep.
>  *
>  * Copy data from user space to kernel space.  Caller must check
>  * the specified block with access_ok() before calling this function.
>  *
>  * Returns number of bytes that could not be copied.
>  * On success, this will be zero.
>  *
>  * If some data could not be copied, this function will pad the copied
>  * data to the requested size using zero bytes.
>  *
>  * An alternate version - __copy_from_user_inatomic() - may be called from
>  * atomic context and will fail rather than sleep.  In this case the
>  * uncopied bytes will *NOT* be padded with zeros.  See fs/filemap.h
>  * for explanation of why this is needed.
>  */
>=20
> This comment is only present in the 32-bit code.  fs/filemap.h of course
> no longer exists, however, the original commit seems to be
> 01408c4939479ec46c15aa7ef6e2406be50eeeca which puts a comment in the
> (now defunct mm/filemap.h).
>=20
> I have to say I don't follow the explanation in that patch.  It seems
> like if you're concurrently reading a buffer being written you should
> expect to get any kind of mismash...
>=20
> Neil, is this still an issue?
>=20

I can't be certain if this is "still" and issue as many things could have
changed and I haven't been following them.
I can try to explain the original issue though.

If a process tries to read a file while another process is writing to the
same page of the same file, then it is quite reasonable for the reader to s=
ee
almost any combination of the old and the new data.  However it is wrong for
it so see something else.  In particular if the file actually contains no
nuls, and the writer doesn't write any nuls, then the read should not see a=
ny
nuls.

At the time of this patch, that could happen.
If the page contains valid data it will not be locked, and a read can succe=
ed
at any time without further locking.
When writing to a page, filemap_copy_from_user would first try an atomic co=
py
and if that failed, it could write zeros into the page, which would then be
over-written by a subsequent non-atomic copy.
This leaves a small window where zeros can be seen in the page by a read (or
a memory-mapping).

A quick look at the code history shows that Nick Piggin removed the comment
from mm/filemap.h in commit  4a9e5ef1f4f15205e477817a5 and it looks like the
code was changed so it doesn't "try one way, then try another".  So it could
well be that the failure mode that caused the problem before is no longer a
possible failure mode.
And if that failure mode is no longer possible, then maybe copy_from_user
will never fail and so never has a need to fill with zeros??

The reason only i386 was changed it that it was the only arch were
copy_from_user_atomic might ever zero a tail.  Most arch just used memcpy or
similar.  powerpc is the only other arch that defined a non-trivial
copy_from_user_atomic and I confirmed at the time that it would never (need
to) zero a tail.

NeilBrown

--Sig_/3RTKswm=WoBv3_b.=/YAD1e
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUpUo/jnsnt1WYoG5AQIHzhAAohZHNW4fdTj1SFQPyzc5WTcnSDd0/PgU
QPHhMi8glfJlPNH3kMdpP+ov+szR3RTQ+ttPC3z6nlqXRRtrbKdCsttumwHtk4Yn
4KbGJLUUjRPA2AbrWrWGVKUmPMQXX81fj1WMSNHMXKVDn8T7k1YSwfMXzzL8ffSx
LAfCNCcdGTEi9ok6L0PAq76FB4Ye3ti7hrz0zxI+jKHaYtnMg8Okwe2AapSOKxqu
tFtPoN0SQORoR9us8BIpMaveSDcBNl0jh1m6IZgqOMHh0mvS3I+TjEzohpsjXZrt
Rlmi4FkUyL6jDyxQfYLhDRDYDO3/J02pbOSNAjlHk5vxGuM7azcP0tGF3Lf889za
xTDYdBzvrlrIxAE28fXSAK5uKYPXkkqonV2u5CIEqwE/9c0e0xOETzWsIJ5mtMY0
PHEdyT7pcwHNbT+fLAs0tGuGec1sdpLTWKBCMloJGFGFdeLRafCbPiX7p/uCEwIc
bcsgrOmQ2c+6m3kVgcYbfwbHIqvPGTJ3zbLS53OFPKgu/pEWnacFZkyPnCPIjGz3
gAKkkmWfpOf7hRNT/od8SxmVfEmJmP3D4gSOfrq5xFxOBbZC+/nvXHeeO2sqTi1V
Nb3pfhAcYFwSSRl+prg2j4DVUXjgQJL96yvuo8SfuPrbxFg6aaHbNMxO6OzKK+zz
aYbrDcyCxDI=
=rQ+l
-----END PGP SIGNATURE-----

--Sig_/3RTKswm=WoBv3_b.=/YAD1e--
