Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbaEIJQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:16:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:48142 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbaEIJQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:16:49 -0400
Date: Fri, 9 May 2014 11:16:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 11/20] arch,m68k: Fold atomic_ops
Message-ID: <20140509091646.GO30445@twins.programming.kicks-ass.net>
References: <20140508135840.956784204@infradead.org>
 <20140508135852.387473090@infradead.org>
 <CAMuHMdUrG6pR0_6VhL8P_=HDmVBQxa9kinRm=AFxddyHQFBNeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ht9V8wKec6a3w1Ef"
Content-Disposition: inline
In-Reply-To: <CAMuHMdUrG6pR0_6VhL8P_=HDmVBQxa9kinRm=AFxddyHQFBNeQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ht9V8wKec6a3w1Ef
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 09, 2014 at 11:08:37AM +0200, Geert Uytterhoeven wrote:
> These two chunks are identical, so please move them out of the #ifdef.

More lines saved!

---
Subject: arch,m68k: Fold atomic_ops
=46rom: Peter Zijlstra <peterz@infradead.org>
Date: Sun Mar 23 19:06:34 CET 2014

Many of the atomic op implementations are the same except for one
instruction; fold the lot into a few CPP macros and reduce LoC.

This also prepares for easy addition of new ops.

Requires asm_op due to eor.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/m68k/include/asm/atomic.h |  113 +++++++++++++++++-------------------=
-----
 1 file changed, 49 insertions(+), 64 deletions(-)

--- a/arch/m68k/include/asm/atomic.h
+++ b/arch/m68k/include/asm/atomic.h
@@ -30,15 +30,56 @@
 #define	ASM_DI	"di"
 #endif
=20
-static inline void atomic_add(int i, atomic_t *v)
-{
-	__asm__ __volatile__("addl %1,%0" : "+m" (*v) : ASM_DI (i));
-}
+#define ATOMIC_OP(op, c_op, asm_op)					\
+static inline void atomic_##op(int i, atomic_t *v)			\
+{									\
+	__asm__ __volatile__(#asm_op "l %1,%0" : "+m" (*v) : ASM_DI (i));\
+}									\
=20
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	__asm__ __volatile__("subl %1,%0" : "+m" (*v) : ASM_DI (i));
-}
+#ifdef CONFIG_RMW_INSNS
+
+#define ATOMIC_OP_RETURN(op, c_op, asm_op)				\
+static inline int atomic_##op##_return(int i, atomic_t *v)		\
+{									\
+	int t, tmp;							\
+									\
+	__asm__ __volatile__(						\
+			"1:	movel %2,%1\n"				\
+			"	" #asm_op "l %3,%1\n"			\
+			"	casl %2,%1,%0\n"			\
+			"	jne 1b"					\
+			: "+m" (*v), "=3D&d" (t), "=3D&d" (tmp)		\
+			: "g" (i), "2" (atomic_read(v)));		\
+	return t;							\
+}
+
+#else
+
+#define ATOMIC_OP_RETURN(op, c_op, asm_op)				\
+static inline int atomic_##op##_return(int i, atomic_t * v)		\
+{									\
+	unsigned long flags;						\
+	int t;								\
+									\
+	local_irq_save(flags);						\
+	t =3D (v->counter c_op i);					\
+	local_irq_restore(flags);					\
+									\
+	return t;							\
+}
+
+#endif /* CONFIG_RMW_INSNS */
+
+#define ATOMIC_OPS(op, c_op, asm_op)					\
+	ATOMIC_OP(op, c_op, asm_op)					\
+	ATOMIC_OP_RETURN(op, c_op, asm_op)
+
+ATOMIC_OPS(add, +=3D, add)
+ATOMIC_OPS(sub, -=3D, sub)
+
+#undef ATOMIC_OPS
+#undef ATOMIC_OP_RETURN
+#undef ATOMIC_OP
=20
 static inline void atomic_inc(atomic_t *v)
 {
@@ -76,67 +117,11 @@ static inline int atomic_inc_and_test(at
=20
 #ifdef CONFIG_RMW_INSNS
=20
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	int t, tmp;
-
-	__asm__ __volatile__(
-			"1:	movel %2,%1\n"
-			"	addl %3,%1\n"
-			"	casl %2,%1,%0\n"
-			"	jne 1b"
-			: "+m" (*v), "=3D&d" (t), "=3D&d" (tmp)
-			: "g" (i), "2" (atomic_read(v)));
-	return t;
-}
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	int t, tmp;
-
-	__asm__ __volatile__(
-			"1:	movel %2,%1\n"
-			"	subl %3,%1\n"
-			"	casl %2,%1,%0\n"
-			"	jne 1b"
-			: "+m" (*v), "=3D&d" (t), "=3D&d" (tmp)
-			: "g" (i), "2" (atomic_read(v)));
-	return t;
-}
-
 #define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
=20
 #else /* !CONFIG_RMW_INSNS */
=20
-static inline int atomic_add_return(int i, atomic_t * v)
-{
-	unsigned long flags;
-	int t;
-
-	local_irq_save(flags);
-	t =3D atomic_read(v);
-	t +=3D i;
-	atomic_set(v, t);
-	local_irq_restore(flags);
-
-	return t;
-}
-
-static inline int atomic_sub_return(int i, atomic_t * v)
-{
-	unsigned long flags;
-	int t;
-
-	local_irq_save(flags);
-	t =3D atomic_read(v);
-	t -=3D i;
-	atomic_set(v, t);
-	local_irq_restore(flags);
-
-	return t;
-}
-
 static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 {
 	unsigned long flags;

--ht9V8wKec6a3w1Ef
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbJz+AAoJEHZH4aRLwOS6EgYP/iXrKiEGA/TC/z3hGkOtMceI
hLRsNXBhrBYwiXzO6UDe8JHgXtyvU/Od/Lz1jeWzQu53bBMh0Z8n2nhhPUJqnjvN
QLNO4CBL114JY1NKs7kSxB0LjiLEO/cSOJH6+sYi67VVDXAo0uxaaUdXlCTfDwRe
xbcgy/KceuRu1AIRMhBl17B+5ieOqfWF+dQ0ES7OsoXZYQJ9yE0x7XADOVMbIdiH
I+c5n2N83GUitgPW5iT4HHNLLXZmg8skYac3rVQNwm3hXn0YbOR9cjzSA+Pp+5l/
XoKHtd2QEYJGwNLSuyWAqPwZdXeiQP7s0IOaJlyTz9fEGwL+OCzMWEcuW2G7iQwM
maB+W0+MzGZ8CPMI4ipMgthtA8ZQr3xCcxxmOlmP6t1l6CpLgHz24jNuJvr2r2Vt
Gr6ad4RcaP4HH/QJmmSNK9oDnVaXeH0IKHwZcinO71NM3mLWWqG/vc4FmuNH4fhG
sBTm8OTIh+fEnsUnTVqdLEi1+/EOB4qvQtrLAg5sQPsxn7W59UF0Pc4tyESvwbcQ
oRkZSavMdptd6Jz/AIEYbRj8YFxw68tNLHzU0K1tLXaF4/d+GfnRI4zG9Ay5Ipnx
Y2v4Nru59FPIF4Z6BLZQtcv5Yj/fIRu6g7CjfuGb3rLoqQ3Do68gcJLGDhllKaC1
g3Sl0kruXUQUNJ84QSlW
=/DB2
-----END PGP SIGNATURE-----

--ht9V8wKec6a3w1Ef--
