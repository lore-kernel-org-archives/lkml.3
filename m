Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbaAFJII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:08:08 -0500
Received: from ozlabs.org ([203.10.76.45]:53156 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792AbaAFJIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:08:05 -0500
Date: Mon, 6 Jan 2014 20:07:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Rob Herring <rob.herring@calxeda.com>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-Id: <20140106200758.a76bbd94508614b4decabdcd@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__6_Jan_2014_20_07_58_+1100_K29zxq2R9r3JjJ9l"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Jan_2014_20_07_58_+1100_K29zxq2R9r3JjJ9l
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

arch/arm/mm/init.c:199:13: error: conflicting types for 'arm_dma_zone_size'
include/linux/bootmem.h:259:11: note: previous declaration of 'arm_dma_zone=
_size' was here

Caused by commit a3ae9362fafe ("mm/memblock: add memblock memory
allocation apis").

For this build, BOOTMEM_LOW_LIMIT is defined as __pa(MAX_DMA_ADDRESS) and
MAX_DMA_ADDRESS is defined as:

#define MAX_DMA_ADDRESS ({ \
        extern unsigned long arm_dma_zone_size; \
        arm_dma_zone_size ? \
                (PAGE_OFFSET + arm_dma_zone_size) : 0xffffffffUL; })

and in arch/arm/mm/init.c, arm_dma_zone_size is declared as:

phys_addr_t arm_dma_zone_size __read_mostly;

Urk!  :-(

OK, so commit 364230b995214 ("ARM: use phys_addr_t for DMA zone sizes")
changed the definition of arm_dma_zone_size except it missed the one in
arch/arm/include/asm/dma.h.

I have applied this merge fix patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 6 Jan 2014 20:02:05 +1100
Subject: [PATCH] ARM: change further appearance of arm_dma_zone_size to phy=
s_addr_t

The definition was chaned in commit 364230b995214 ("ARM: use phys_addr_t
for DMA zone sizes").

Fixes this build error:

arch/arm/mm/init.c:199:13: error: conflicting types for 'arm_dma_zone_size'
include/linux/bootmem.h:259:11: note: previous declaration of 'arm_dma_zone=
_size' was here

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/arm/include/asm/dma.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/dma.h b/arch/arm/include/asm/dma.h
index 58b8c6a0ab1f..1439b80b3a98 100644
--- a/arch/arm/include/asm/dma.h
+++ b/arch/arm/include/asm/dma.h
@@ -8,7 +8,7 @@
 #define MAX_DMA_ADDRESS	0xffffffffUL
 #else
 #define MAX_DMA_ADDRESS	({ \
-	extern unsigned long arm_dma_zone_size; \
+	extern phys_addr_t arm_dma_zone_size; \
 	arm_dma_zone_size ? \
 		(PAGE_OFFSET + arm_dma_zone_size) : 0xffffffffUL; })
 #endif
--=20
1.8.5.2

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__6_Jan_2014_20_07_58_+1100_K29zxq2R9r3JjJ9l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSynJyAAoJEMDTa8Ir7ZwV4y4P/0ZyIQtJUs99Vi8CrcUOJM7z
/n36xpYzjtXFBLw4e3u4gEpFsu4JeTh+2evgz7se8GZ5WmhIvq54fKGy71f74c9J
vMw6s+6rznhARm05Sd5iJnFPCqX+ps2b/YGvxanIokc9hrgjDLoi3VKKObtibHBY
48BY0mssHHrXw/BqGkpL8KFgymjkjFzdeuP2P61lIm4oIvXMtOkx3YkZzg8YExCT
ZtOvr1+/JQSiymUSI9RyBubPo9lQm6cfTxeIame5gPg5LVWH5s5oCFjZGue9dt2P
fO6L1WXjbbIoNsHtwdWHM3/D8GOjjPfBgsKTZSWlYUPRdKoYW3XOG0aX+kTaLKZP
0QcgLR0UbJpO22Zzm5X1rjxIV3Bzxpu4pTIOaRAxQlFaTXCHf1ZwddeJvFkguEmc
pe1W+VSrn3i0AIft94pvPqoCOdZTHKfu0IF7MbEtuMhg02OdkLgXivQc4FbecQtw
5lvS2mf3RRvNH1dkBA+s/0iwBDqwTSi4t0zH9d/AHUCtYMpJtWszR1ijQzi/jhvd
YcTzcnedwN8BarB/JLc6HgcNhZEFaAD8iXHYtw/r/76MiN1/ewed/Muzhb61Zpwg
yOD1W5okKeLhmSiVK1TRpsLLVJJ+kYezV3cD3aQtm5l/DXFkOg4mGhNRUASkkui8
zbQ/kzDTOiuhgadA0mym
=LGpA
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Jan_2014_20_07_58_+1100_K29zxq2R9r3JjJ9l--
