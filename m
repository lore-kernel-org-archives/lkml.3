Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbaJHVa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 17:30:29 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58673 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbaJHVaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 17:30:25 -0400
Date: Wed, 8 Oct 2014 16:29:38 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>, <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, <josh@joshtriplett.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: RCU bug with v3.17-rc3 ?
Message-ID: <20141008212938.GP22688@saruman>
Reply-To: <balbi@ti.com>
References: <20140904184021.GA13421@saruman.home>
 <20140904191642.GJ5001@linux.vnet.ibm.com>
 <20140904192535.GJ13421@saruman.home>
 <20140904200403.GL13421@saruman.home>
 <20140905213216.GD5001@linux.vnet.ibm.com>
 <20141008171322.GH22688@saruman>
 <20141008175707.GI22688@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yEbVe0JFHWhrOjGA"
Content-Disposition: inline
In-Reply-To: <20141008175707.GI22688@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--yEbVe0JFHWhrOjGA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 08, 2014 at 12:57:07PM -0500, Felipe Balbi wrote:

[ snip ]

> > > > It seems to be a difficult-to-reproduce race though. On a second bo=
ot it
> > > > didn't die during boot, but died with my USB test case. Unfortunate=
ly,
> > > > the platform I'm using is pretty new and only goes as far back as v=
3.16
> > > > (which I had to backport 11 patches to get it to boot good enough f=
or
> > > > this test).
> > > >=20
> > > > I wonder if a corrupt file system could cause such problems... I ke=
ep
> > > > seeing EXT4 errors every now and again; considering that this dies =
in a
> > > > path through VFS, I wonder...
> > >=20
> > > I recall hearing of similar things in the past, but must defer to the
> > > FS/VFS experts on this one.
> >=20
> > resurrecting this thread. I'm facing the same issues with a brand new
> > filesystem mounted through NFS. The way to reproduce is the same though:
> > using g_mass_storage with either tmpfs or mmc as backing store.
> >=20
> > However it seems to die much more frequently than before. I can
> > reproduce all the time. It's definitely not a problem with my board as I
> > have two boards with different SoCs (ARM Cortex A8 and ARM Cortex A9)
> > with two different USB peripheral controllers (MUSB and DWC3), using the
> > same rootfs and they die the exact same way no matter if I use tmpfs or
> > MMC as backing store.
> >=20
> > Adding a few more folks here.
>=20
> alright, first stable kernel with Cortex A8 was v3.14. All other kernel
> versions die starting with v3.15 to today's Linus. I'll start bisecting
> now.

Finally bisected it down to commit 139e561660fe11e0fc35e142a800df3dd7d03e9d
(lib: radix_tree: tree node interface). Here's full bisect log:

git bisect start
# good: [455c6fdbd219161bd09b1165f11699d6d73de11c] Linux 3.14
git bisect good 455c6fdbd219161bd09b1165f11699d6d73de11c
# bad: [1860e379875dfe7271c649058aeddffe5afd9d0d] Linux 3.15
git bisect bad 1860e379875dfe7271c649058aeddffe5afd9d0d
# bad: [74a475acea49459721ae4b062d3da68c74259009] SubmittingPatches: add st=
yle recommendation to use imperative descriptions
git bisect bad 74a475acea49459721ae4b062d3da68c74259009
# good: [c12e69c6aaf785fd307d05cb6f36ca0e7577ead7] Merge tag 'staging-3.15-=
rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
git bisect good c12e69c6aaf785fd307d05cb6f36ca0e7577ead7
# good: [0fc31966035d7a540c011b6c967ce8eae1db121b] Merge branch 'for-davem'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next
git bisect good 0fc31966035d7a540c011b6c967ce8eae1db121b
# good: [bdfc7cbdeef8cadba0e5793079ac0130b8e2220c] Merge branch 'mips-for-l=
inux-next' of git://git.linux-mips.org/pub/scm/ralf/upstream-sfr
git bisect good bdfc7cbdeef8cadba0e5793079ac0130b8e2220c
# good: [0f1b1e6d73cb989ce2c071edc57deade3b084dfe] Merge branch 'for-linus'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid
git bisect good 0f1b1e6d73cb989ce2c071edc57deade3b084dfe
# good: [181e7d5d7bd7747e882e3ca89ecbf0fc3e72d0da] ixgbe: remove redundant =
if clause from PTP work
git bisect good 181e7d5d7bd7747e882e3ca89ecbf0fc3e72d0da
# good: [59ecc26004e77e100c700b1d0da7502b0fdadb46] Merge git://git.kernel.o=
rg/pub/scm/linux/kernel/git/herbert/crypto-2.6
git bisect good 59ecc26004e77e100c700b1d0da7502b0fdadb46
# good: [2b665e276c15ba7d9fc8cdd16931883a51ed13e4] fs/direct-io.c: remove r=
edundant comparison
git bisect good 2b665e276c15ba7d9fc8cdd16931883a51ed13e4
# bad: [f412c97abef71026d8192ca8efca231f1e3906b3] mm, hugetlb: mark some bo=
otstrap functions as __init
git bisect bad f412c97abef71026d8192ca8efca231f1e3906b3
# good: [4e35f483850ba46b838adfd312b3052416e15204] mm, hugetlb: use vma_res=
v_map() map types
git bisect good 4e35f483850ba46b838adfd312b3052416e15204
# good: [6dbaf22ce1f1dfba33313198eb5bd989ae76dd87] mm: shmem: save one radi=
x tree lookup when truncating swapped pages
git bisect good 6dbaf22ce1f1dfba33313198eb5bd989ae76dd87
# good: [91b0abe36a7b2b3b02d7500925a5f8455334f0e5] mm + fs: store shadow en=
tries in page cache
git bisect good 91b0abe36a7b2b3b02d7500925a5f8455334f0e5
# bad: [139e561660fe11e0fc35e142a800df3dd7d03e9d] lib: radix_tree: tree nod=
e interface
git bisect bad 139e561660fe11e0fc35e142a800df3dd7d03e9d
# good: [a528910e12ec7ee203095eb1711468a66b9b60b0] mm: thrash detection-bas=
ed file cache sizing
git bisect good a528910e12ec7ee203095eb1711468a66b9b60b0
# first bad commit: [139e561660fe11e0fc35e142a800df3dd7d03e9d] lib: radix_t=
ree: tree node interface

I tried reverting that commit on v3.15 but it's non-trivial; I'll leave
that for tomorrow. Meanwhile, adding folks involved with that commit to
Cc list and another backtrace for reference:

[  113.696647] Unable to handle kernel paging request at virtual address ff=
ffffff
[  113.704370] pgd =3D c0004000
[  113.707276] [ffffffff] *pgd=3D9fef6821, *pte=3D00000000, *ppte=3D00000000
[  113.713998] Internal error: Oops: 17 [#1] SMP ARM
[  113.718912] Modules linked in: g_mass_storage usb_f_mass_storage libcomp=
osite configfs musb_dsps musb_hdrc musb_am335x
[  113.730144] CPU: 0 PID: 1368 Comm: file-storage Not tainted 3.17.0-02899=
-g748eb79 #239
[  113.738410] task: de606e00 ti: dd0ba000 task.ti: dd0ba000
[  113.744060] PC is at find_get_entry+0x64/0x100
[  113.748700] LR is at 0xfffffffa
[  113.751978] pc : [<c01065b4>]    lr : [<fffffffa>]    psr: a00f0013
[  113.751978] sp : dd0bbba0  ip : 00000000  fp : dd0bbbd4
[  113.763962] r10: c0665100  r9 : 00001000  r8 : 0000001a
[  113.769415] r7 : dd0ee9b8  r6 : 00000001  r5 : 00000000  r4 : dd0ee880
[  113.776228] r3 : dd0bbb8c  r2 : 00000000  r1 : 0000001a  r0 : ffffffff
[  113.783044] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment=
 kernel
[  113.790674] Control: 10c5387d  Table: 9e210019  DAC: 00000015
[  113.796672] Process file-storage (pid: 1368, stack limit =3D 0xdd0ba248)
[  113.803486] Stack: (0xdd0bbba0 to 0xdd0bc000)
[  113.808038] bba0: 00000000 00000000 c0106550 00017508 00000002 dd0ee880 =
dd0ee9b4 0000001a
[  113.816578] bbc0: 00001000 00000000 dd0bbbf4 dd0bbbd8 c010716c c010655c =
00013ef0 dd0ee880
[  113.825118] bbe0: dd0bbda4 00000003 dd0bbc6c dd0bbbf8 c011df94 c0107150 =
dd0bbc2c c0106b9c
[  113.833657] bc00: c0089a3c c0089328 00000001 c0107080 00000002 dd0bbcc0 =
000000d0 00000000
[  113.842197] bc20: 0001a000 00000000 00000000 dd0ee9b4 0000001a c011e74c =
dd0bbc94 dd0bbc48
[  113.850736] bc40: c011beec 00001000 dd0bbda4 dd0ee9b4 00001000 00000000 =
00001000 c0665100
[  113.859276] bc60: dd0bbc94 dd0bbc70 c011e74c c011df08 000200da 00000000 =
00001000 dd0bbda4
[  113.867816] bc80: dd0ee9b4 00001000 dd0bbcf4 dd0bbc98 c0106b10 c011e700 =
00001000 00000001
[  113.876356] bca0: dd0bbcc0 dd0bbcc4 dd0ba000 00000001 de60ee40 00002000 =
0001a000 00000000
[  113.884896] bcc0: dfe71ac0 c00a3b60 54355ca1 00004000 de60ee40 00000000 =
dd0bbdb8 dd0ee9b4
[  113.893436] bce0: dd0ee880 ffffffff dd0bbd5c dd0bbcf8 c0108c6c c0106a68 =
dd0bbd5c dd0bbd08
[  113.901975] bd00: c064b790 c0089c48 00000001 dd0ba038 c0108f70 c0089328 =
00000001 c0108f7c
[  113.910515] bd20: dd0bbda4 de606e00 00018000 00000000 dd0bbd5c dd0bbdb8 =
dd0ee920 dd0bbda4
[  113.919055] bd40: de60ee40 de606e00 dd0e5000 de664a00 dd0bbd8c dd0bbd60 =
c0108f7c c0108a24
[  113.927595] bd60: c008c410 c0089fd0 00000001 00000000 00018000 00000000 =
dd0bbe80 de60ee40
[  113.936134] bd80: dd0bbe14 dd0bbd90 c014c920 c0108f40 00004000 00000001 =
00000001 de274000
[  113.944674] bda0: 00004000 00000003 00002000 00002000 dd0bbd9c 00000001 =
de60ee40 00000000
[  113.953214] bdc0: 00000000 00000000 de606e00 00000000 00000000 00000000 =
00018000 00000000
[  113.961753] bde0: 00004000 00000000 00000000 00000000 de274000 de60ee40 =
de274000 dd0bbe80
[  113.970293] be00: 00004000 de6ce9c0 dd0bbe44 dd0bbe18 c014d1c8 c014c888 =
00000002 de6ce9c0
[  113.978833] be20: 00004000 00000000 00000000 00008000 de6ce9c0 dd0e5000 =
dd0bbeb4 dd0bbe48
[  113.987373] be40: bf059cc4 c014d120 00000000 dd0bbe9c dd0bbe68 bf05a04c =
19000000 00000000
[  113.995912] be60: dd0ba000 00000000 00000000 6f48202c 00018000 00000000 =
00020000 00000000
[  114.004452] be80: 00018000 00000000 00000000 de664a00 de6ce9c0 00000000 =
de664a38 de664a00
[  114.012992] bea0: dd0ba038 de664a7c dd0bbf24 dd0bbeb8 bf05a938 bf059980 =
00000001 c00899dc
[  114.021531] bec0: a00f0013 de2e3bd4 00000000 00052000 00000000 dd0bbee0 =
c0089c50 c0089a70
[  114.030071] bee0: dd0bbf04 dd0bbef0 c064f3a4 de6ce840 00000000 de664a00 =
bf05a244 de6ce840
[  114.038611] bf00: 00000000 de664a00 bf05a244 00000000 00000000 00000000 =
dd0bbfac dd0bbf28
[  114.047151] bf20: c0065bdc bf05a250 c0089c50 00000000 dd0bbf54 de664a00 =
00000000 00000000
[  114.055690] bf40: dead4ead ffffffff ffffffff c0a8a238 00000000 00000000 =
c08070f8 dd0bbf5c
[  114.064230] bf60: dd0bbf5c 00000000 00000000 dead4ead ffffffff ffffffff =
c0a8a238 00000000
[  114.072770] bf80: 00000000 c08070f8 dd0bbf88 dd0bbf88 de6ce840 c0065af8 =
00000000 00000000
[  114.081310] bfa0: 00000000 dd0bbfb0 c000eea8 c0065b04 00000000 00000000 =
00000000 00000000
[  114.089850] bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 =
00000000 00000000
[  114.098389] bfe0: 00000000 00000000 00000000 00000000 00000013 00000000 =
0001086e 00001a02
[  114.106944] [<c01065b4>] (find_get_entry) from [<c010716c>] (find_lock_e=
ntry+0x28/0x7c)
[  114.115316] [<c010716c>] (find_lock_entry) from [<c011df94>] (shmem_getp=
age_gfp+0x98/0x7f8)
[  114.124042] [<c011df94>] (shmem_getpage_gfp) from [<c011e74c>] (shmem_wr=
ite_begin+0x58/0x94)
[  114.132856] [<c011e74c>] (shmem_write_begin) from [<c0106b10>] (generic_=
perform_write+0xb4/0x1c8)
[  114.142124] [<c0106b10>] (generic_perform_write) from [<c0108c6c>] (__ge=
neric_file_write_iter+0x254/0x51c)
[  114.152208] [<c0108c6c>] (__generic_file_write_iter) from [<c0108f7c>] (=
generic_file_write_iter+0x48/0xdc)
[  114.162298] [<c0108f7c>] (generic_file_write_iter) from [<c014c920>] (ne=
w_sync_write+0xa4/0xcc)
[  114.171386] [<c014c920>] (new_sync_write) from [<c014d1c8>] (vfs_write+0=
xb4/0x1c0)
[  114.179334] [<c014d1c8>] (vfs_write) from [<bf059cc4>] (do_write+0x350/0=
x4b8 [usb_f_mass_storage])
[  114.188719] [<bf059cc4>] (do_write [usb_f_mass_storage]) from [<bf05a938=
>] (fsg_main_thread+0x6f4/0x13f8 [usb_f_mass_storage])
[  114.200636] [<bf05a938>] (fsg_main_thread [usb_f_mass_storage]) from [<c=
0065bdc>] (kthread+0xe4/0x100)
[  114.210368] [<c0065bdc>] (kthread) from [<c000eea8>] (ret_from_fork+0x14=
/0x20)
[  114.217914] Code: e1a01008 eb08abbe e3500000 0a00001b (e5904000)=20
[  114.224529] ---[ end trace afb7e71d4b71be98 ]---

for those who are coming by late, the problem happens when I use
g_mass_storage with either Cortex A8 or Cortex A9 with two different USB
peripheral controllers using either tmpfs or mmc as backing store.

--=20
balbi

--yEbVe0JFHWhrOjGA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUNazBAAoJEIaOsuA1yqRETzYP/22AnKZaX1UW2uZTTROYyT53
9nC4HPJqcHzn7ITLn97k3OBg4gkJ4qUyxCe/VzZp7Kkv2r5M02i3fOIZDgRgRDGn
f5Jrx1Ji2/hP1jIoVIBXCqjbAb6E1KUnlQZrmdoB+MWG0H/gyL0J+KhGrhz7A6Au
OzPajELHVtAn3wNL9b1e/g1WGdqFK2+9fZsznHnOufVc52LktUtbpvrCNGAbv4ZB
vGuyC77otD8xnvuoEBuxUi4P7HtXozADK0JNiZgYhdia542KAMJBzhTXRJir53Uq
K7+5OFZ3i5/2rrKcK3bGlv9UjdeyBGc7b7elqx11b0qbnr/zEwK7jwnxYcytlNSY
TJSyzVvRX/aUpMFMChEJd1vtDqGkjzJ0HClNIn6q3PeXG+NcfwIOO6aAK07HmjkL
dF66Emfqr+lsqxWHzCwPzAhmMXqXfEHLBcEG1dAzrEk9MA5zFWGZ8xVYC+mbDNbk
50ohkQakUT0UHtf6bl+2zpEJCcuNJ3x0S/iAh/+4FrsZ7kRy/eSYXJNxVYMX0WZ/
pNhP4hZsMXZC2dTshIOiLHmuS9U9F4Wtl9cQmmX6xn1Eb+0YwWXstpuWdplnGjQ3
e+wsEJUcYVU9/6CAuNfKU2YuKSFdr5ZEKS1trx7HH7L8ueut/YWPAXHY8uBAnyhy
XhbDe77FhLW//3Zt7s1U
=bIk2
-----END PGP SIGNATURE-----

--yEbVe0JFHWhrOjGA--
