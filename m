Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab3COTyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:54:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27896 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359Ab3COTv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:51:26 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=GfYQo16ec8oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=uGPwiYSE3TUA:10 a=VwQbUJbxAAAA:8 a=k5FiPARZpzFLQR7o2d8A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=8FXVZGi3qsC3N9340mUA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130315195124.731069893@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 15:39:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, <stable@vger.kernel.org>
Subject: [for-next][PATCH 14/20] tracing: Use stack of calling function for stack tracer
References: <20130315193935.359219613@goodmis.org>
Content-Disposition: inline; filename=0014-tracing-Use-stack-of-calling-function-for-stack-trac.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Use the stack of stack_trace_call() instead of check_stack() as
the test pointer for max stack size. It makes it a bit cleaner
and a little more accurate.

Adding stable, as a later fix depends on this patch.

Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_stack.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 42ca822..dc02e29 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -39,20 +39,21 @@ static DEFINE_MUTEX(stack_sysctl_mutex);
 int stack_tracer_enabled;
 static int last_stack_tracer_enabled;
=20
-static inline void check_stack(void)
+static inline void
+check_stack(unsigned long *stack)
 {
 	unsigned long this_size, flags;
 	unsigned long *p, *top, *start;
 	int i;
=20
-	this_size =3D ((unsigned long)&this_size) & (THREAD_SIZE-1);
+	this_size =3D ((unsigned long)stack) & (THREAD_SIZE-1);
 	this_size =3D THREAD_SIZE - this_size;
=20
 	if (this_size <=3D max_stack_size)
 		return;
=20
 	/* we do not handle interrupt stacks yet */
-	if (!object_is_on_stack(&this_size))
+	if (!object_is_on_stack(stack))
 		return;
=20
 	local_irq_save(flags);
@@ -73,7 +74,7 @@ static inline void check_stack(void)
 	 * Now find where in the stack these are.
 	 */
 	i =3D 0;
-	start =3D &this_size;
+	start =3D stack;
 	top =3D (unsigned long *)
 		(((unsigned long)start & ~(THREAD_SIZE-1)) + THREAD_SIZE);
=20
@@ -113,6 +114,7 @@ static void
 stack_trace_call(unsigned long ip, unsigned long parent_ip,
 		 struct ftrace_ops *op, struct pt_regs *pt_regs)
 {
+	unsigned long stack;
 	int cpu;
=20
 	preempt_disable_notrace();
@@ -122,7 +124,7 @@ stack_trace_call(unsigned long ip, unsigned long parent=
_ip,
 	if (per_cpu(trace_active, cpu)++ !=3D 0)
 		goto out;
=20
-	check_stack();
+	check_stack(&stack);
=20
  out:
 	per_cpu(trace_active, cpu)--;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ3u8AAoJEOdOSU1xswtMmacH+wSeDZqrhiAXpDBRfn6D8v0L
dgzzFxAjICV+KEDo/LxqHxwCl/xY3AC7WAHAq/RdABL2+TeGz5Qa1XMoqfhxU7b+
Ie5jiTT7Tvuwhgaxe0ZXXcmV3LEfS2gMbJVHoxDeYUQV8jU9lLTiip1D31UD3x/Q
9CQHr52ejSO6Om+ustWoxssLkTcSVXl6WRZUOAsEnlX18+c3MlfN9+wvQVHxzmdD
8voGuKUY/bEnF++DEaixR208w+RScnVKbp+3KC41N+HF6kqJADlMqazfycFUgE5X
6nRe8htq/VQ1QWXU6hsR5A8AT/YQwwEciT0M7isHr4RyaP7QCBXp80CKhLFq3w4=
=Vu8f
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
