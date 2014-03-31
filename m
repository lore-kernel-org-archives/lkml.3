Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaCaXiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 19:38:17 -0400
Received: from gerolde.archlinux.org ([66.211.214.132]:54734 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaCaXiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 19:38:14 -0400
Message-ID: <5339FC62.8060207@archlinux.org>
Date: Tue, 01 Apr 2014 01:38:10 +0200
From: =?ISO-8859-1?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, tpowa@archlinux.org
Subject: Re: 3.13: <module> disagrees about version of symbol <symbol>
References: <52E4CF03.8030208@archlinux.org> <5339F739.2060207@archlinux.org> <20140331233450.GI32556@tassilo.jf.intel.com>
In-Reply-To: <20140331233450.GI32556@tassilo.jf.intel.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="3qBnB0hSao81OPJtc64IrF5AD7vK5aWvx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3qBnB0hSao81OPJtc64IrF5AD7vK5aWvx
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 01.04.2014 01:34, schrieb Andi Kleen:
>> This problem persists in v3.14, i.e. I still have to revert
>> 83460ec8dcac14142e7860a01fa59c267ac4657c in order to get a working
>> kernel on i686. I would really appreciate if someone would actually re=
ad
>> my original mail from about 3 months ago and write an answer.
>=20
> Can you resend it please?

It's available here: https://lkml.org/lkml/2014/1/26/22

For convenience, here is a copy-and-paste of the full text:

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


--3qBnB0hSao81OPJtc64IrF5AD7vK5aWvx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTOfxiAAoJEChPw0yOSxolaZgP/3Y9qYMtJBkGJYdQFV3cZErX
Irf1aSGG8Cw098Wr3j9UBzJvokZ9+3YA+NEzsKNblhiCFC/eZzZElTV+KWHJCghV
kKLnWbP9/IHUnx9qFCAIhy/2VM4iObg/MWDnvuMSEbTYDc95CDTPYTmt/kFPGcEC
XF4+YL8J1+S27CPbp+xbxN/0ytuSvbppNFFczf+gbFIEpzlPeFdsGpyAucdjspOp
EqqwG/dMduxwyH7AC639ZKYwxP8IjeflvfJ5AwYNubwZ5wUNFpqhxCjwNsbZEwJG
+OUYW63wj4dnUdW0JzyWGFpnICssAOvNNHAAN0aOrn/yRIRzzVS/r/KwliBOCmYI
QQWZ2JaRnm+14clW65XZfpUTO/61WTiJcaJQyUKn/thBLWB2BsVw0OzlczQ/Q8d4
8bv9/xNOCo7M/sOnCvvZBGDffCugEQX92wIMsvifnf64jmJ7/DIPDIVUCl+4SMsX
AhkL+d5aJ83hfzZzif1qtGNZyrH40yWzO8BHVdk6VM7+f9rnutnmE6wza51LHY3M
nQHGQyk0OIoYgzG9s5ntoIRNfegXiGTDfcW12bb1Uz7qWhALsABfOqr2OIcogYmo
hc40/AY7NdHLZwbE7A7wIbw6kM0yQEXw+ZP36dkS+TIOUKIJY0z+BOKcDPNrSf3B
Av5/KuEvfXIgCNhGQ4Xd
=TJfh
-----END PGP SIGNATURE-----

--3qBnB0hSao81OPJtc64IrF5AD7vK5aWvx--
