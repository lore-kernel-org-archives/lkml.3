Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab3LaTV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 14:21:26 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:36526 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756343Ab3LaTVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 14:21:24 -0500
Message-ID: <52C31927.40304@gentoo.org>
Date: Tue, 31 Dec 2013 14:21:11 -0500
From: Richard Yao <ryao@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>
CC: linux-fsdevel@vger.kernel.org,
        "v9fs-developer@lists.sourceforge.net" 
	<v9fs-developer@lists.sourceforge.net>,
        "kernel@gentoo.org" <kernel@gentoo.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: v9fs does not honor open file handles on anonymous files
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="BBdWTWEPj4B4tu2t5HqqWnGl99VwrUxXP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BBdWTWEPj4B4tu2t5HqqWnGl99VwrUxXP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I have a small shell script:

#!/bin/bash
cat <<-EOF
EOF

Running this causes bash to fork via clone(), set fd=3D0 to point to an
empty file in /tmp, unlink it and then execve cat. Specifically,
something like this;

[pid  3699] open("/tmp/sh-thd-1388524249",
O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) =3D 3
[pid  3699] open("/tmp/sh-thd-1388524249", O_RDONLY) =3D 4
[pid  3699] close(3)                    =3D 0
[pid  3699] unlink("/tmp/sh-thd-1388524249") =3D 0
[pid  3699] dup2(4, 0)                  =3D 0
[pid  3699] close(4)                    =3D 0
[pid  3699] execve("/bin/cat", ["cat"], [/* 22 vars */]) =3D 0

One of the first things that cat does is fstat fd=3D0. This informs cat
that the file is empty and it will quit. If /tmp is on other
filesystems, cat will fstat fd=3D0, receive a return code of 0 from fstat=
,
print nothing and then quit normally. If /tmp is on 9pfs, cat will fstat
fd=3D0, receive ENOENT from fstat, print `cat: -: No such file or
directory` to stderr and die.

It seems that v9fs_vfs_unlink() is killing the file while we still have
open file handles. I have confirmed that this behavior occurs on Linux
3.13.0-rc6. This breaks several things when Gentoo is on a 9p rootfs
(e.g. gcc-config, any emerge command that involves a C compiler,
etcetera) inside QEMU. I have placed /tmp and /var/tmp/portage on a
tmpfs as a hack-fix, but it would be better to get this fixed.

I doubt that I will write a patch to fix this. I am sending the details
to the list so the 9p maintainers or any other interested individual can
fix it.


--BBdWTWEPj4B4tu2t5HqqWnGl99VwrUxXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSwxkrAAoJECDuEZm+6ExkBV8P/RmixO0bReOTy51PW/u3Q8GR
iHs2o5tKyYlJpeafUn5U2ydoiIYkv/rLEDDDjgiHPdLlnPc61pqH42IE1EY9KU0G
2CbuvwESvrgZhryTgxNkBbjHKxD0qBPKCW+oGPBephVz0bQ0zt4nM9oaYcOyVIaz
NUArpgUfRfSOytN7DCnhoJMu70mUsV/2BScAO+LoxRUn7MJSABfGbhXvlOu0bWmk
QQwKApGWm8aoG3CMOpTjHeaFCOEj9Wl0TBlXmhoF71ETjQtCOVFVfwTO76hOg/Ck
UFE4J85BoMRJ755T1gvACiSK1v8CgusXeRqf7+JMAAcT9viVjt6vvVr7S6zOR085
uLnfR6cio5+elSLISskyQ1AAS+ceeETQY3T0h5ZvF5P/H1iSNaYt+iut0EPx4hWS
lWgOC59Hl0COEoH45ygNhyeKl/A7vhShhofD5oZz5R93FhOigBbwfoOEjink1yL1
6gtFxGKo+mSyJxhSRj9ZcJnphTxRf5tNIGoYWSD6t9MkUVHmyAck/X/GHOBxNIvO
4H3C3NBRwhh0PKaWVvCVUGHEcI9DeIao1LY1neMB+uujOMN8YcSxiro23c5pHtcK
HPyBLwt9L1orecib1r1PFAbFT49CHHwDAUbTwyZVMT+3Peqg+E6jT0tmjCQstXrA
jRxDgLmR+Ty8so4tyJE4
=oP0x
-----END PGP SIGNATURE-----

--BBdWTWEPj4B4tu2t5HqqWnGl99VwrUxXP--
