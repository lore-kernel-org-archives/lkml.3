Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab3EMDyb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 23:54:31 -0400
Received: from static-173-79-223-29.washdc.fios.verizon.net ([173.79.223.29]:59414
	"EHLO mail.marc.info" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751708Ab3EMDya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 23:54:30 -0400
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 May 2013 23:54:30 EDT
Date: Sun, 12 May 2013 23:48:35 -0400
From: Hank Leininger <hlein@marc.info>
To: linux-kernel@vger.kernel.org
Subject: BUG: spinlock lockup, async_umap_flush_lock in 3.4, 3.7, 3.8
Message-ID: <20130513034835.GA1130@marklar.spinoli.org>
Reply-To: Hank Leininger <hlein@marc.info>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I've got several systems with similar hardware which crash with BUG:
spinlock errors on async_umap_flush_lock such as:

BUG: spinlock lockup suspected on CPU#0, sh/1166
 lock: async_umap_flush_lock+0x0/0x20, .magic: dead4ead, .owner: swapper/23=
/0, .owner_cpu: 23
BUG: spinlock lockup suspected on CPU#19, scsi_eh_0/1408
 lock: async_umap_flush_lock+0x0/0x20, .magic: dead4ead, .owner: swapper/23=
/0, .owner_cpu: 23

(More examples below.)

In general these happen very rarely--but a specific userland workload
(lots of mongodb + sqlite reads & writes, while other CPUs are running
compute-heavy tasks) seems to trigger it within a few minutes to hours.
After 1-3 "spinlock lockup suspected" errors, the system locks up, no
response to alt+sysrq.

I've gotten the crash on one system in the last couple of days with
3.7.1-gentoo, 3.8.11-gentoo, 3.8.11 vanilla, and 3.4.4 vanilla.  When
I looked further back, over the past year another system crashed with
similar errors (under similar workload) running 3.7.0-gentoo and
3.8.4-gentoo.  Further back than that there are 2-3 crashes on those
and other similar systems using 2.6.x and 3.0.x, but their errors are
different enough that they may not be related.

These systems each have:

Supermicro X8DTU-F motherboard
2x Xeon E5645 (6 cores each + hyperthreading)
24 GB ECC RAM
Adaptec 51645 RAID controller w/bbu
12x 2TB SAS disks

They are using hw raid, 11 disks in a RAID6 with 1 hot-spare; main
partition is 16 TB.

They all use loop-aes v3.6g as a replacement loop.ko module to encrypt
their / filesystem (using the aes-ni instruction set).

3.8.11 .config pastebin: http://pastebin.com/u3BDPTvP

3.4.44 .config pastebin: http://pastebin.com/1Rpk9RVf

Generally speaking, 3.8.x and 3.4.44 kernels were compiled with GCC 4.7;
the older 3.7.x kernels were compiled with GCC 4.6.

Error messages, captured by serial consoles, newest crashes first:

Host1:

3.4.44
BUG: spinlock lockup on CPU#0, john/21637
 lock: ffffffff816558d0, .magic: dead4ead, .owner: mongod/27646, .owner_cpu=
: 8
BUG: spinlock lockup on CPU#6, mongod/3256
 lock: ffff880621867860, .magic: dead4ead, .owner: mongod/3251, .owner_cpu:=
 18
BUG: spinlock lockup on CPU#20, khugepaged/735
 lock: ffff880621867860, .magic: dead4ead, .owner: mongod/3251, .owner_cpu:=
 18

3.8.11
BUG: spinlock lockup suspected on CPU#0, sh/1166
 lock: async_umap_flush_lock+0x0/0x20, .magic: dead4ead, .owner: swapper/23=
/0, .owner_cpu: 23
BUG: spinlock lockup suspected on CPU#19, scsi_eh_0/1408
 lock: async_umap_flush_lock+0x0/0x20, .magic: dead4ead, .owner: swapper/23=
/0, .owner_cpu: 23

3.8.11-gentoo
BUG: spinlock lockup suspected on CPU#0, swapper/0/0
 lock: async_umap_flush_lock+0x0/0x20, .magic: dead4ead, .owner: mongod/367=
8, .owner_cpu: 4
BUG: spinlock lockup suspected on CPU#16, mongod/3115
 lock: 0xffff880620ab47a8, .magic: dead4ead, .owner: flush-7:4/1915, .owner=
_cpu: 5
BUG: spinlock lockup suspected on CPU#6, khugepaged/744
 lock: 0xffff880620ab47a8, .magic: dead4ead, .owner: flush-7:4/1915, .owner=
_cpu: 5

3.7.1-gentoo
BUG: spinlock lockup suspected on CPU#0, john/32030
 lock: async_umap_flush_lock+0x0/0x20, .magic: dead4ead, .owner: swapper/13=
/0, .owner_cpu: 13
BUG: spinlock lockup suspected on CPU#19, mongod/18985
 lock: 0xffff8806221f7860, .magic: dead4ead, .owner: mongod/18975, .owner_c=
pu: 2
BUG: spinlock lockup suspected on CPU#3, scsi_eh_0/1407
 lock: async_umap_flush_lock+0x0/0x20, .magic: dead4ead, .owner: swapper/13=
/0, .owner_cpu: 13
BUG: spinlock lockup suspected on CPU#9, khugepaged/741
 lock: 0xffff8806221f7860, .magic: dead4ead, .owner: mongod/18975, .owner_c=
pu: 2

Host2:

3.8.4-gentoo
BUG: spinlock lockup suspected on CPU#0, swapper/0/0
 lock: async_umap_flush_lock+0x0/0x20, .magic: dead4ead, .owner: mongod/223=
77, .owner_cpu: 9
BUG: spinlock lockup suspected on CPU#4, mongod/3377
 lock: 0xffff880621d00f68, .magic: dead4ead, .owner: kswapd0/689, .owner_cp=
u: 14
BUG: spinlock lockup suspected on CPU#21, mongod/3375
 lock: 0xffff880621d00f68, .magic: dead4ead, .owner: kswapd0/689, .owner_cp=
u: 14

3.7.0-gentoo
BUG: spinlock lockup suspected on CPU#0, swapper/0/0
 lock: async_umap_flush_lock+0x0/0x20, .magic: dead4ead, .owner: mongo/1656=
1, .owner_cpu: 3

(The repeated crashes on Host2 lead to irreperable ext4 corruption.)

I can provide System.map files if they are interesting.  I'd be happy
to try a specific kernel, add patches to harvest more information in
the event of a crash, etc.

Thanks,

--=20

Hank Leininger <hlein@marc.info>
3C2A 4EEE ED36 D136 18F2  1B30 47A8 D14B E13E 9C6A

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQEVAwUBUZBik0eo0UvhPpxqAQhBMwf+OAX0UQpBdqbls4yqQ7dZnwX2F4zLIOVd
NEkxC0/UveWV4WJRqX2tyaUg7BUV8Ut2KktTxxcQQr5QFBNtJHffmB+8/U2K601y
W5fpY74KvVw3ogoHST3HaPbBnnpjtXuhPzALRcEyQg2wlkOwRfCFEZhRyhavfa0O
jT29FqER0x4lJzDaZjpnVNE5mZ0Z5CuOuIJ1u6F0HxYZfsnnF6Ogj88uCWLQ1IqI
E52MX1ZlvwyDGR1JeDm3CtVbOQVqCsiLsie7fID7J2lm9k6lktydPdijG3EYRFlP
cfOPicIJnqTktgX5+UCYTaBPxuu4tCt0L+b+Rcg1EBeijIUHjJCxjg==
=h2y4
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
