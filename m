Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbaANExq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 23:53:46 -0500
Received: from ozlabs.org ([203.10.76.45]:51381 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbaANExn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 23:53:43 -0500
Date: Tue, 14 Jan 2014 15:53:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: linux-next: manual merge of the akpm-current tree with the tip tree
Message-Id: <20140114155331.88d170d3c991b9465c23a537@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__14_Jan_2014_15_53_31_+1100_=mmZWMzklz_Q+c57"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Jan_2014_15_53_31_+1100_=mmZWMzklz_Q+c57
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
kernel/futex.c between commit a52b89ebb6d4 ("futexes: Increase hash table
size for better performance") from the tip tree and commit 61beee6c76e5
("futex: switch to USER_DS for futex test") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/futex.c
index 3666aa0017ed,66d23727c6ab..000000000000
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@@ -63,7 -63,7 +63,8 @@@
  #include <linux/sched/rt.h>
  #include <linux/hugetlb.h>
  #include <linux/freezer.h>
 +#include <linux/bootmem.h>
+ #include <linux/uaccess.h>
 =20
  #include <asm/futex.h>
 =20
@@@ -2845,19 -2734,9 +2846,20 @@@ SYSCALL_DEFINE6(futex, u32 __user *, ua
 =20
  static int __init futex_init(void)
  {
+ 	mm_segment_t fs;
  	u32 curval;
 -	int i;
 +	unsigned long i;
 +
 +#if CONFIG_BASE_SMALL
 +	futex_hashsize =3D 16;
 +#else
 +	futex_hashsize =3D roundup_pow_of_two(256 * num_possible_cpus());
 +#endif
 +
 +	futex_queues =3D alloc_large_system_hash("futex", sizeof(*futex_queues),
 +					       futex_hashsize, 0,
 +					       futex_hashsize < 256 ? HASH_SMALL : 0,
 +					       NULL, NULL, futex_hashsize, futex_hashsize);
 =20
  	/*
  	 * This will fail and we want it. Some arch implementations do
@@@ -2869,10 -2748,13 +2871,13 @@@
  	 * implementation, the non-functional ones will return
  	 * -ENOSYS.
  	 */
+ 	fs =3D get_fs();
+ 	set_fs(USER_DS);
  	if (cmpxchg_futex_value_locked(&curval, NULL, 0, 0) =3D=3D -EFAULT)
  		futex_cmpxchg_enabled =3D 1;
+ 	set_fs(fs);
 =20
 -	for (i =3D 0; i < ARRAY_SIZE(futex_queues); i++) {
 +	for (i =3D 0; i < futex_hashsize; i++) {
  		plist_head_init(&futex_queues[i].chain);
  		spin_lock_init(&futex_queues[i].lock);
  	}

--Signature=_Tue__14_Jan_2014_15_53_31_+1100_=mmZWMzklz_Q+c57
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS1MLQAAoJEMDTa8Ir7ZwV1gkP/3A9A2rlQbVdBsD+MHKseHff
0SUNblxJfz+cHDJZn/SHmlVPihfIVolDS+3yUm7w0oO5OSoBUZhpXMcdS2trM92a
gOHdwUdjuApUYzuHj/Nl9rnCTe64E1Ya7cOlS3Hp4iVRItyi3x2TES6kaByjvfAG
T8hWHA5mFnTFR7rhnQsSYZsOBifKCsq58yRHc/qMT/M7DIlwWcbNUjq+zcxmEqGA
cWB6Q3Qy+NThgJG9mAmTmYoJYzLJ3o/4stWCH9P2u7+G7SBKrGiCcG2VEG8F4fNh
RCvafl1EMW3YZYMTFMg0e4dZBwMv4MMBTcVUzpsitlLzqfLISlIo3RnaIzpx07rj
WmKYFHDDXh/SR1bzBHb/j/Ymrxk+SGUa2/32XZdfMwvClJeMLEoQ69xfeFPjNdq9
Q+APrmLZlTpCaW4Lb1n4cYJUPpZyXCPLoPLjcUSy5SbFFlKugXZZ00ZCM73diyV0
wGt76WSweRP1erLRDYPs+LuCW6KDSvTp7gBpdKNehSWK/dHYXWkD0rIsAiDcW+LC
ja3c9cboSc5DtzB93QLEev+/soaMPBdErDy0vEHS8/loQtJ28xOdj2iXYrdOdQDv
UqRk0qk2/mW3epjBvUKjOFamFQi3gFqvns7UlTTtbdLo5MknJpTWwX4F46uwj+F+
vmIip/z8EIkIaCElauHL
=p2Q7
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Jan_2014_15_53_31_+1100_=mmZWMzklz_Q+c57--
