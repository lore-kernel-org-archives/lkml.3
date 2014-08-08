Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbaHHLUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 07:20:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37074 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaHHLUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 07:20:38 -0400
Message-ID: <53E4B281.5050302@canonical.com>
Date: Fri, 08 Aug 2014 13:20:33 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Kees Cook <keescook@chromium.org>, David Vrabel <david.vrabel@citrix.com>
Subject: Xen PV domain regression with KASLR enabled (kernel 3.16)
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="qPbMRIjwqkuoVtU0rIgXTH1exhJeiMUqS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qPbMRIjwqkuoVtU0rIgXTH1exhJeiMUqS
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Unfortunately I have not yet figured out why this happens, but can confir=
m by
compiling with or without CONFIG_RANDOMIZE_BASE being set that without KA=
SLR all
is ok, but with it enabled there are issues (actually a dom0 does not eve=
n boot
as a follow up error).

Details can be seen in [1] but basically this is always some portion of a=

vmalloc allocation failing after hitting a freshly allocated PTE space no=
t being
PTE_NONE (usually from a module load triggered by systemd-udevd). In the
non-dom0 case this repeats many times but ends in a guest that allows log=
in. In
the dom0 case there is a more fatal error at some point causing a crash.

I have not tried this for a normal PV guest but for dom0 it also does not=
 help
to add "nokaslr" to the kernel command-line.

-Stefan

19:35:02 [ 2.547049] ------------[ cut here ]------------
19:35:02 [ 2.547065] WARNING: CPU: 0 PID: 97 at
/build/buildd/linux-3.16.0/mm/vmalloc.c:128 vmap_page_range_noflush+0x2d1=
/0x370()
19:35:02 [ 2.547069] Modules linked in:
19:35:02 [ 2.547073] CPU: 0 PID: 97 Comm: systemd-udevd Not tainted
3.16.0-6-generic #11-Ubuntu
19:35:02 [ 2.547077] 0000000000000009 ffff880002defb98 ffffffff81755538
0000000000000000
19:35:02 [ 2.547082] ffff880002defbd0 ffffffff8106bb0d ffff88000400ec88
0000000000000001
19:35:02 [ 2.547086] ffff880002fcfb00 ffffffffc0391000 0000000000000000
ffff880002defbe0
19:35:02 [ 2.547090] Call Trace:
19:35:02 [ 2.547096] [<ffffffff81755538>] dump_stack+0x45/0x56
19:35:02 [ 2.547101] [<ffffffff8106bb0d>] warn_slowpath_common+0x7d/0xa0
19:35:02 [ 2.547104] [<ffffffff8106bbea>] warn_slowpath_null+0x1a/0x20
19:35:02 [ 2.547108] [<ffffffff81197c31>] vmap_page_range_noflush+0x2d1/0=
x370
19:35:02 [ 2.547112] [<ffffffff81197cfe>] map_vm_area+0x2e/0x40
19:35:02 [ 2.547115] [<ffffffff8119a058>] __vmalloc_node_range+0x188/0x28=
0
19:35:02 [ 2.547120] [<ffffffff810e92b4>] ? module_alloc_update_bounds+0x=
14/0x70
19:35:02 [ 2.547124] [<ffffffff810e92b4>] ? module_alloc_update_bounds+0x=
14/0x70
19:35:02 [ 2.547129] [<ffffffff8104f294>] module_alloc+0x74/0xd0
19:35:02 [ 2.547132] [<ffffffff810e92b4>] ? module_alloc_update_bounds+0x=
14/0x70
19:35:02 [ 2.547135] [<ffffffff810e92b4>] module_alloc_update_bounds+0x14=
/0x70
19:35:02 [ 2.547146] [<ffffffff810e9a6c>] layout_and_allocate+0x74c/0xc70=

19:35:02 [ 2.547149] [<ffffffff810ea063>] load_module+0xd3/0x1b70
19:35:02 [ 2.547154] [<ffffffff811cfeb1>] ? vfs_read+0xf1/0x170
19:35:02 [ 2.547157] [<ffffffff810e7aa1>] ? copy_module_from_fd.isra.46+0=
x121/0x180
19:35:02 [ 2.547161] [<ffffffff810ebc76>] SyS_finit_module+0x86/0xb0
19:35:02 [ 2.547167] [<ffffffff8175de7f>] tracesys+0xe1/0xe6
19:35:02 [ 2.547169] ---[ end trace 8a5de7fc66e75fe4 ]---
19:35:02 [ 2.547172] vmalloc: allocation failure, allocated 20480 of 2457=
6 bytes
19:35:02 [ 2.547175] systemd-udevd: page allocation failure: order:0, mod=
e:0xd2


[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1350522


--qPbMRIjwqkuoVtU0rIgXTH1exhJeiMUqS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJT5LKBAAoJEOhnXe7L7s6jAhEP/j9W8Lkw1DguCs4Ojpl+GZrC
rrpC4U3hxZP/sJmZb/xzIDVI6U6lh0JBMRGE6tijij/8vpAEKib3y6QUUU9LSL6G
s+jlZE6KmwHDI7hCQ5DDGZG8o9IsJPtAfhTKaXHaG0OG1XMDVcmTqJlD9+Mmws8F
dYnETEUiI9rmRGf4Xc81L5IwxYe0gK2s3ZA+BqtFR5Kfd42ggkcPj7N7/XUYxEwE
wXBIAd6pHVJ5PzvTimBADvpmjsLzq1cuNxlnAYDgrzoeJ1Oc4KVuvKYP/DIEz4o3
g+OXCVvAC+ntjkKmNfYAmYa7/6ch2yRRsnUHQs6kv3soxfHYhgse2vzN/1UtUxtw
s4p1kZJKXFruh8VGF1MvJOnUWRNNsanO4/5cyq7QxhFYKsOSH7qeY2Lj5g7ZIZwt
VjZVqR8GfQJrREBilHDxqw9HPxoTlAkttz1O11DFj97AS6D770CS8SZPXqR3j0bA
z3wGWQN5sJwdti3tA6XdoYejGL9nykgMHZ9xA7NuCWz/FRB7x0zY51fRlnISSjo+
JUIjiHA+Sp+XaB94bPLFBsxBHZLzNefyplMgKm7ZFRCiIbb0P5ssMNUMCR4K2Pfi
Jm66DjrzY9afnr2j98iu+6y/fCDqAny+bZhnxQjv/SGwPIO2YOtGii2sBjVNhfFT
qzQwft5ZV9P1kMlEYLuK
=PEUc
-----END PGP SIGNATURE-----

--qPbMRIjwqkuoVtU0rIgXTH1exhJeiMUqS--
