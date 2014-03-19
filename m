Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaCSF4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 01:56:20 -0400
Received: from ozlabs.org ([203.10.76.45]:43415 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbaCSF4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 01:56:15 -0400
Date: Wed, 19 Mar 2014 16:56:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: linux-next: manual merge of the random tree with Linus' tree
Message-Id: <20140319165608.739527f179d25c63ebb583ea@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Mar_2014_16_56_08_+1100_SjfipRG2h5olfvbE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Mar_2014_16_56_08_+1100_SjfipRG2h5olfvbE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Theodore,

Today's linux-next merge of the random tree got a conflict in
arch/x86/include/asm/archrandom.h between commit 5bfce5ef55cb ("x86,
kaslr: Provide randomness functions") from Linus' tree and commits
e3be36e60bdc ("x86, random: Enable the RDSEED instruction") and
91a60dc7aa88 ("random: Add arch_has_random[_seed]()") from the random tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/include/asm/archrandom.h
index e6a92455740e,c7ed4a61e928..000000000000
--- a/arch/x86/include/asm/archrandom.h
+++ b/arch/x86/include/asm/archrandom.h
@@@ -39,20 -42,16 +42,30 @@@
 =20
  #ifdef CONFIG_ARCH_RANDOM
 =20
 +/* Instead of arch_get_random_long() when alternatives haven't run. */
 +static inline int rdrand_long(unsigned long *v)
 +{
 +	int ok;
 +	asm volatile("1: " RDRAND_LONG "\n\t"
 +		     "jc 2f\n\t"
 +		     "decl %0\n\t"
 +		     "jnz 1b\n\t"
 +		     "2:"
 +		     : "=3Dr" (ok), "=3Da" (*v)
 +		     : "0" (RDRAND_RETRY_LOOPS));
 +	return ok;
 +}
 +
+ /* A single attempt at RDSEED */
+ static inline bool rdseed_long(unsigned long *v)
+ {
+ 	unsigned char ok;
+ 	asm volatile(RDSEED_LONG "\n\t"
+ 		     "setc %0"
+ 		     : "=3Dqm" (ok), "=3Da" (*v));
+ 	return ok;
+ }
+=20
  #define GET_RANDOM(name, type, rdrand, nop)			\
  static inline int name(type *v)					\
  {								\
@@@ -80,15 -95,14 +109,21 @@@ GET_SEED(arch_get_random_seed_int, unsi
  GET_RANDOM(arch_get_random_long, unsigned long, RDRAND_LONG, ASM_NOP3);
  GET_RANDOM(arch_get_random_int, unsigned int, RDRAND_INT, ASM_NOP3);
 =20
+ GET_SEED(arch_get_random_seed_long, unsigned long, RDSEED_LONG, ASM_NOP4);
+ GET_SEED(arch_get_random_seed_int, unsigned int, RDSEED_INT, ASM_NOP4);
+=20
  #endif /* CONFIG_X86_64 */
 =20
+ #define arch_has_random()	static_cpu_has(X86_FEATURE_RDRAND)
+ #define arch_has_random_seed()	static_cpu_has(X86_FEATURE_RDSEED)
+=20
 +#else
 +
 +static inline int rdrand_long(unsigned long *v)
 +{
 +	return 0;
 +}
 +
  #endif  /* CONFIG_ARCH_RANDOM */
 =20
  extern void x86_init_rdrand(struct cpuinfo_x86 *c);

--Signature=_Wed__19_Mar_2014_16_56_08_+1100_SjfipRG2h5olfvbE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTKTF9AAoJEMDTa8Ir7ZwV+tAQAIJaMQhrs5uTkfxmhPLd6rzX
OFElO6hsHd4IyJFNAEoQRj3v6vVImiEk9+3dY304v1aXIthFGg4g5FNRUXheJLvF
quYz9fsE8g2713Bq9Hu7OCQio07ePzIUaGNKpHY3AU+rHbSnaxZh4FcenBIlU1th
AO3PHATnfxgxHlC9jbfASgiDNRZC4qgIHt5Lg7u64MZx45nStWSruOKFOX24Y6xn
r3/DzEU27jXzy5PE3bcsciNL8k8cSiJcvknptz5n6DDKNzyC+2GrDSoZ9iaBLoKn
N9S1A0U7NZjxwjVi+QmcGK9gNsvF02huox2MtQsIQlNW9trDZOYoy9lV1uQSr/AP
b2DPjgzXwqYkvQN5SE1/hPcAi20Z+Wwh3G6Gdjv4KqcByVjcHBvRwjleibldDhkK
PGhvT0wLlxdfV4p3kNyIPY7Q6Yk8ORHPtchxBt6CqHs9DhfOiAfylSWQ6161iwja
ovnFfpLThMxc+nX+lFB2DNnCTTQMijz+xRS9EhWMo0auAYZgJ7JTzDefpI2gCh4Q
TFgW9ppraQddQhvyHwrU+IqrHdEKff7g1QKpulrdUCzpttM7knj1TtTUpRihYym8
0kwW0q2U5LM9BaoYps3hOs7KvjUOvjfQgaKKUOgbPTI3BUVBe6K4O/XtDoeCpcmR
a7KOg4bLX6vOkn0Iw7fD
=8sX9
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Mar_2014_16_56_08_+1100_SjfipRG2h5olfvbE--
