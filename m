Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaAZJJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 04:09:27 -0500
Received: from gerolde.archlinux.org ([66.211.214.132]:38543 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbaAZJI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 04:08:28 -0500
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Jan 2014 04:08:28 EST
Message-ID: <52E4CF03.8030208@archlinux.org>
Date: Sun, 26 Jan 2014 10:01:55 +0100
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, tpowa@archlinux.org
Subject: 3.13: <module> disagrees about version of symbol <symbol>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="HpI8WnRTbA9DqsfAJ6D4fTeGdkufCMWS2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HpI8WnRTbA9DqsfAJ6D4fTeGdkufCMWS2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Good morning,

I am trying to build Linux 3.13 on i686 with CONFIG_MODVERSIONS enabled
(for configuration, see [2]). Upon booting it in a VM, I discovered that
I was unable to load several kernel modules, like ext4:

ext4: disagrees about version of symbol d_tmpfile
ext4: Unknown symbol d_tmpfile (err -22)
ext4: disagrees about version of symbol iov_shorten
ext4: Unknown symbol iov_shorten (err -22)
ext4: disagrees about version of symbol in_group_p
ext4: Unknown symbol in_group_p (err -22)
ext4: disagrees about version of symbol do_sync_read
ext4: Unknown symbol do_sync_read (err -22)
ext4: disagrees about version of symbol current_fs_time
ext4: Unknown symbol current_fs_time (err -22)
ext4: disagrees about version of symbol generic_write_sync
ext4: Unknown symbol generic_write_sync (err -22)
ext4: disagrees about version of symbol generic_getxattr
ext4: Unknown symbol generic_getxattr (err -22)

This looks exactly like the problem experienced by Tetsuo Handa in [1].
However, for me, his solution, i.e. setting
 CONFIG_PHYSICAL_ALIGN=3D0x1000000
instead of
 CONFIG_PHYSICAL_ALIGN=3D0x100000
doesn't help and the symptoms stay the same (and, according to the
documentation and to Kbuild, both are valid values on i686).

The affected symbols seem to be exactly those that do not get a CRC
during build:

$ grep 0x000000 Module.symvers
0x00000000      task_nice       vmlinux EXPORT_SYMBOL
0x00000000      alloc_pages_current     vmlinux EXPORT_SYMBOL
0x00000000      iov_shorten     vmlinux EXPORT_SYMBOL
0x00000000      filp_close      vmlinux EXPORT_SYMBOL
0x00000000      perf_event_create_kernel_counter        vmlinux
EXPORT_SYMBOL_GPL
0x00000000      do_sync_read    vmlinux EXPORT_SYMBOL
0x00000000      finish_open     vmlinux EXPORT_SYMBOL
0x00000000      vfs_fsync_range vmlinux EXPORT_SYMBOL
0x00000000      path_is_under   vmlinux EXPORT_SYMBOL
0x00000000      kern_mount_data vmlinux EXPORT_SYMBOL_GPL
0x00000000      mnt_set_expiry  vmlinux EXPORT_SYMBOL
0x00000000      in_group_p      vmlinux EXPORT_SYMBOL
0x00000000      sys_close       vmlinux EXPORT_SYMBOL
0x00000000      generic_getxattr        vmlinux EXPORT_SYMBOL
0x00000000      sigset_from_compat      vmlinux EXPORT_SYMBOL_GPL
0x00000000      vm_brk  vmlinux EXPORT_SYMBOL
0x00000000      iterate_fd      vmlinux EXPORT_SYMBOL
0x00000000      __page_file_mapping     vmlinux EXPORT_SYMBOL_GPL
0x00000000      get_unmapped_area       vmlinux EXPORT_SYMBOL
0x00000000      ns_capable      vmlinux EXPORT_SYMBOL
0x00000000      compat_alloc_user_space vmlinux EXPORT_SYMBOL_GPL
0x00000000      current_fs_time vmlinux EXPORT_SYMBOL
0x00000000      vfs_test_lock   vmlinux EXPORT_SYMBOL_GPL
0x00000000      schedule_timeout        vmlinux EXPORT_SYMBOL
0x00000000      register_exec_domain    vmlinux EXPORT_SYMBOL
0x00000000      generic_write_sync      vmlinux EXPORT_SYMBOL
0x00000000      inode_add_bytes vmlinux EXPORT_SYMBOL
0x00000000      softirq_work_list       vmlinux EXPORT_SYMBOL
0x00000000      __symbol_put    vmlinux EXPORT_SYMBOL
0x00000000      sock_register   vmlinux EXPORT_SYMBOL
0x00000000      d_tmpfile       vmlinux EXPORT_SYMBOL

Bisecting the problem leads me to the exact same commit that Tetsuo
identified in September, namely

commit 83460ec8dcac14142e7860a01fa59c267ac4657c
Author: Andi Kleen <ak@linux.intel.com>
Date:   Tue Nov 12 15:08:36 2013 -0800

    syscalls.h: use gcc alias instead of assembler aliases for syscalls

In fact, reverting this commit gives me a kernel that boots just fine
and loads all modules.

The CRC being 0x0 should not cause a mismatch, after all, it is 0x0 in
both the kernel and the module - so there is another problem on i686
(Tetsuo talks about this in his emails).

However, the 0x0 CRCs are incorrect as well.

As it stands, there is no way to run a modular 3.13 kernel on i686.
What's the correct solution here?

[1] http://www.serverphorums.com/read.php?12,770337
[2]
https://projects.archlinux.org/svntogit/packages.git/tree/trunk/config?h=3D=
packages/linux


--HpI8WnRTbA9DqsfAJ6D4fTeGdkufCMWS2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS5M8FAAoJEChPw0yOSxolx0oQAJCFbNRA9eqZmcEK6b175vcq
gMHY3Blski0nNgIrmfoWsTOh9zyiPYs9XgNlduKXvQzM+rBeU9FYVgzoMTqLiayO
uQxxzFey3Iy0DjZoK5k05D5yxH2VFYXQpHVBD/qC0RMbiXW6fkIWFH/MopufY6nQ
hsrUq8CJxf4gNVLgKYxNZ1UgDfx3pCyzssB1NkpnXSMYVFRXvBCoa71S/xQB2UHe
9bD+z54D+zllC4q8ETQVr/SJiNpi++pWFTu+6/mmydfUrbITMAew+b5NwDm6ZuCB
phjffsZmgdE5M2urYLcbfnb1COsceex+gDDanQwf3j9LFT4SSTpT3aa0rzGUlfz/
B36ZiQchzHX5wBvueR0Unrc4nIMGld5tLXYfMp56z6K8ZuFwJA9ab6rgxyOh+Zil
VorQyIjPaJ4RpDqkD33IybO6dcZ1Soykf3CSuW5jLdZumO/PyCTzkvbL/jGsUwTt
ElGDoqkL4WKPoUYVcjttxJgOpdYAQJoIpoJK75cl5QkKHzMotUy1ZcY2qUdyCowx
r6gIelvYLfm1aG2nqHI6ackKJDsyT1YsG9Q5WAm57YJ7cJdnLhRuBDzK3F9IzyyY
QvAz6CjZF0kSGQwhh4VUufDJ7IFpoSCO79B2ir/Zv/dfqHj9FWhqWkZi23qQUilK
EL0LMqSoB3ch8GF6JEcL
=rcJU
-----END PGP SIGNATURE-----

--HpI8WnRTbA9DqsfAJ6D4fTeGdkufCMWS2--
