Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaIYErt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 00:47:49 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:41557 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaIYErs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 00:47:48 -0400
Message-ID: <54239E69.4050803@klondike.es>
Date: Thu, 25 Sep 2014 06:47:37 +0200
From: klondike <klondike@xiscosoft.sinip.es>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: P J P <ppandit@redhat.com>, Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] initramfs: allow again choice of the embedded compression
 algorithm
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="86aBjk8Q9XswLRbSXhJsceaPU2NNCqDKm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--86aBjk8Q9XswLRbSXhJsceaPU2NNCqDKm
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Choosing the appropriate option (for example on my tests, choosing
CONFIG_INITRAMFS_COMPRESSION_NONE when compressing the using XZ) results =
in
up to 500KiB differences (9MiB to 8.5MiB) in the kernel size as the
dictionary
will not get polluted with uncomprensible data and may reuse kernel data
too.

Despite embedding an uncompressed initramfs, a user may want to allow for=
 a
compressed extra initramfs to be passed using the rd system, for example =
to
boot a recovery system. Commit 9ba4bcb645898d562498ea66a0df958ef0e7a68c
("initramfs: read CONFIG_RD_ variables for initramfs compression") broke
that behavior by making the choice based on CONFIG_RD_* instead of adding=

CONFIG_INITRAMFS_COMPRESSION_LZ4. Saddly, CONFIG_RD_* is also used to
choose the supported RD compression algorithms by the kernel and a user m=
ay
want to suppport more than one.

This patch also reverses 3e4e0f0a8756dade3023d1f47d50fbced7749788
("initramfs:
remove "compression mode" choice") restoring back the "compression mode"
choice and includes the CONFIG_INITRAMFS_COMPRESSION_LZ4 option which was=

never added.

As a result the following options are added or readed affecting the embed=
ded
initramfs compression:
INITRAMFS_COMPRESSION_NONE Do no compression
INITRAMFS_COMPRESSION_GZIP Compress using gzip
INITRAMFS_COMPRESSION_BZIP2 Compress using bzip2
INITRAMFS_COMPRESSION_LZMA Compress using lzma
INITRAMFS_COMPRESSION_XZ Compress using xz
INITRAMFS_COMPRESSION_LZO Compress using lzo
INITRAMFS_COMPRESSION_LZ4 Compress using lz4

These depend on the corresponding CONFIG_RD_* option (except NONE which
has no
dependencies).


Signed-off-by: Francisco Blas Izquierdo Riera (klondike)
<klondike@klondike.es>
Cc: P J P <ppandit@redhat.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
---
This patch is applied against Torvald's linux tree

Note: scripts/checkpatch.pl complains about style:
"WARNING: please write a paragraph that describes the config symbol fully=
"
this seems to be a false positive.

 usr/Kconfig  | 85
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++++++++
 usr/Makefile | 13 +++++++------
 2 files changed, 92 insertions(+), 6 deletions(-)
diff --git a/usr/Kconfig b/usr/Kconfig
index 2d4c77e..09de7b9 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -98,3 +98,88 @@ config RD_LZ4
     help
       Support loading of a LZ4 encoded initial ramdisk or cpio buffer
       If unsure, say N.
+
+choice
+    prompt "Built-in initramfs compression mode" if INITRAMFS_SOURCE!=3D=
""
+    help
+      This option decides by which algorithm the builtin initramfs
+      will be compressed.  Several compression algorithms are
+      available, which differ in efficiency, compression and
+      decompression speed.  Compression speed is only relevant
+      when building a kernel.  Decompression speed is relevant at
+      each boot.
+
+      If you have any problems with bzip2 or LZMA compressed
+      initramfs, mail me (Alain Knaff) <alain@knaff.lu>.
+
+      High compression options are mostly useful for users who are
+      low on RAM, since it reduces the memory consumption during
+      boot.
+
+      If in doubt, select 'gzip'
+
+config INITRAMFS_COMPRESSION_NONE
+    bool "None"
+    help
+      Do not compress the built-in initramfs at all. This may
+      sound wasteful in space, but, you should be aware that the
+      built-in initramfs will be compressed at a later stage
+      anyways along with the rest of the kernel, on those
+      architectures that support this.
+      However, not compressing the initramfs may lead to slightly
+      higher memory consumption during a short time at boot, while
+      both the cpio image and the unpacked filesystem image will
+      be present in memory simultaneously
+
+config INITRAMFS_COMPRESSION_GZIP
+    bool "Gzip"
+    depends on RD_GZIP
+    help
+      The old and tried gzip compression. It provides a good balance
+      between compression ratio and decompression speed.
+
+config INITRAMFS_COMPRESSION_BZIP2
+    bool "Bzip2"
+    depends on RD_BZIP2
+    help
+      Its compression ratio and speed is intermediate.
+      Decompression speed is slowest among the choices.  The initramfs
+      size is about 10% smaller with bzip2, in comparison to gzip.
+      Bzip2 uses a large amount of memory. For modern kernels you
+      will need at least 8MB RAM or more for booting.
+
+config INITRAMFS_COMPRESSION_LZMA
+    bool "LZMA"
+    depends on RD_LZMA
+    help
+      This algorithm's compression ratio is best.
+      Decompression speed is between the other choices.
+      Compression is slowest. The initramfs size is about 33%
+      smaller with LZMA in comparison to gzip.
+
+config INITRAMFS_COMPRESSION_XZ
+    bool "XZ"
+    depends on RD_XZ
+    help
+      XZ uses the LZMA2 algorithm. The initramfs size is about 30%
+      smaller with XZ in comparison to gzip. Decompression speed
+      is better than that of bzip2 but worse than gzip and LZO.
+      Compression is slow.
+
+config INITRAMFS_COMPRESSION_LZO
+    bool "LZO"
+    depends on RD_LZO
+    help
+      Its compression ratio is the second poorest among the choices. The=

+      kernel size is about 10% bigger than gzip; however its decompressi=
on
+      speed is the second fastest.
+
+config INITRAMFS_COMPRESSION_LZ4
+    bool "LZ4"
+    depends on RD_LZ4
+    help
+      Its compression ratio is the poorest among the choices. The kernel=

+      size is about 15% bigger than gzip; however its decompression spee=
d
+      is the fastest.
+
+endchoice
diff --git a/usr/Makefile b/usr/Makefile
index e767f01..4031e23 100644
--- a/usr/Makefile
+++ b/usr/Makefile
@@ -5,24 +5,25 @@
 klibcdirs:;
 PHONY +=3D klibcdirs
=20
+#If unset it means we use CONFIG_INITRAMFS_COMPRESSION_NONE
=20
 # Bzip2
-suffix_$(CONFIG_RD_BZIP2)  =3D .bz2
+suffix_$(CONFIG_INITRAMFS_COMPRESSION_BZIP2)  =3D .bz2
=20
 # Lzma
-suffix_$(CONFIG_RD_LZMA)   =3D .lzma
+suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZMA)   =3D .lzma
=20
 # XZ
-suffix_$(CONFIG_RD_XZ)     =3D .xz
+suffix_$(CONFIG_INITRAMFS_COMPRESSION_XZ)     =3D .xz
=20
 # Lzo
-suffix_$(CONFIG_RD_LZO)    =3D .lzo
+suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZO)    =3D .lzo
=20
 # Lz4
-suffix_$(CONFIG_RD_LZ4)    =3D .lz4
+suffix_$(CONFIG_INITRAMFS_COMPRESSION_LZ4)    =3D .lz4
=20
 # Gzip
-suffix_$(CONFIG_RD_GZIP)   =3D .gz
+suffix_$(CONFIG_INITRAMFS_COMPRESSION_GZIP)   =3D .gz
=20
 AFLAGS_initramfs_data.o +=3D
-DINITRAMFS_IMAGE=3D"usr/initramfs_data.cpio$(suffix_y)"
=20



--86aBjk8Q9XswLRbSXhJsceaPU2NNCqDKm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlQjnm4ACgkQcfrM1mX4BmBUewCg31ZgyFdQuY0E6PwO1rHyZZ6L
QXoAnilHAdyCCe0b7K8fqtrSNxEOuJj5
=5cAA
-----END PGP SIGNATURE-----

--86aBjk8Q9XswLRbSXhJsceaPU2NNCqDKm--
