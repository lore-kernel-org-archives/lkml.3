Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab3COTxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:53:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21975 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab3COTv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:51:27 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=BRV1MMiLyRcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=_DyCmw44UswA:10 a=VwQbUJbxAAAA:8 a=lovj1sxnkMUORCeWAFwA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=eC4tpAxUevF3uSev:21 a=K8I1YNCabqzuXedR:21 a=AD_TEC0H4u0k7bLoA4kA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130315195125.143863964@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 15:39:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, <stable@vger.kernel.org>
Subject: [for-next][PATCH 16/20] tracing: Remove most or all of stack tracer stack size from
 stack_max_size
References: <20130315193935.359219613@goodmis.org>
Content-Disposition: inline; filename=0016-tracing-Remove-most-or-all-of-stack-tracer-stack-siz.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Currently, the depth reported in the stack tracer stack_trace file
does not match the stack_max_size file. This is because the stack_max_size
includes the overhead of stack tracer itself while the depth does not.

The first time a max is triggered, a calculation is not performed that
figures out the overhead of the stack tracer and subtracts it from
the stack_max_size variable. The overhead is stored and is subtracted
from the reported stack size for comparing for a new max.

Now the stack_max_size corresponds to the reported depth:

 # cat stack_max_size
4640

 # cat stack_trace
        Depth    Size   Location    (48 entries)
        -----    ----   --------
  0)     4640      32   _raw_spin_lock+0x18/0x24
  1)     4608     112   ____cache_alloc+0xb7/0x22d
  2)     4496      80   kmem_cache_alloc+0x63/0x12f
  3)     4416      16   mempool_alloc_slab+0x15/0x17
[...]

While testing against and older gcc on x86 that uses mcount instead
of fentry, I found that pasing in ip + MCOUNT_INSN_SIZE let the
stack trace show one more function deep which was missing before.

Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_stack.c |   75 +++++++++++++++++++++++++++++++---------=
----
 1 file changed, 54 insertions(+), 21 deletions(-)

diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index ea28e4b..aab277b 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -20,27 +20,24 @@
=20
 #define STACK_TRACE_ENTRIES 500
=20
-/*
- * If fentry is used, then the function being traced will
- * jump to fentry directly before it sets up its stack frame.
- * We need to ignore that one and record the parent. Since
- * the stack frame for the traced function wasn't set up yet,
- * the stack_trace wont see the parent. That needs to be added
- * manually to stack_dump_trace[] as the first element.
- */
 #ifdef CC_USING_FENTRY
-# define add_func	1
+# define fentry		1
 #else
-# define add_func	0
+# define fentry		0
 #endif
=20
 static unsigned long stack_dump_trace[STACK_TRACE_ENTRIES+1] =3D
 	 { [0 ... (STACK_TRACE_ENTRIES)] =3D ULONG_MAX };
 static unsigned stack_dump_index[STACK_TRACE_ENTRIES];
=20
+/*
+ * Reserve one entry for the passed in ip. This will allow
+ * us to remove most or all of the stack size overhead
+ * added by the stack tracer itself.
+ */
 static struct stack_trace max_stack_trace =3D {
-	.max_entries		=3D STACK_TRACE_ENTRIES - add_func,
-	.entries		=3D &stack_dump_trace[add_func],
+	.max_entries		=3D STACK_TRACE_ENTRIES - 1,
+	.entries		=3D &stack_dump_trace[1],
 };
=20
 static unsigned long max_stack_size;
@@ -58,10 +55,14 @@ check_stack(unsigned long ip, unsigned long *stack)
 {
 	unsigned long this_size, flags;
 	unsigned long *p, *top, *start;
+	static int tracer_frame;
+	int frame_size =3D ACCESS_ONCE(tracer_frame);
 	int i;
=20
 	this_size =3D ((unsigned long)stack) & (THREAD_SIZE-1);
 	this_size =3D THREAD_SIZE - this_size;
+	/* Remove the frame of the tracer */
+	this_size -=3D frame_size;
=20
 	if (this_size <=3D max_stack_size)
 		return;
@@ -73,6 +74,10 @@ check_stack(unsigned long ip, unsigned long *stack)
 	local_irq_save(flags);
 	arch_spin_lock(&max_stack_lock);
=20
+	/* In case another CPU set the tracer_frame on us */
+	if (unlikely(!frame_size))
+		this_size -=3D tracer_frame;
+
 	/* a race could have already updated it */
 	if (this_size <=3D max_stack_size)
 		goto out;
@@ -85,15 +90,12 @@ check_stack(unsigned long ip, unsigned long *stack)
 	save_stack_trace(&max_stack_trace);
=20
 	/*
-	 * When fentry is used, the traced function does not get
-	 * its stack frame set up, and we lose the parent.
-	 * Add that one in manally. We set up save_stack_trace()
-	 * to not touch the first element in this case.
+	 * Add the passed in ip from the function tracer.
+	 * Searching for this on the stack will skip over
+	 * most of the overhead from the stack tracer itself.
 	 */
-	if (add_func) {
-		stack_dump_trace[0] =3D ip;
-		max_stack_trace.nr_entries++;
-	}
+	stack_dump_trace[0] =3D ip;
+	max_stack_trace.nr_entries++;
=20
 	/*
 	 * Now find where in the stack these are.
@@ -123,6 +125,18 @@ check_stack(unsigned long ip, unsigned long *stack)
 				found =3D 1;
 				/* Start the search from here */
 				start =3D p + 1;
+				/*
+				 * We do not want to show the overhead
+				 * of the stack tracer stack in the
+				 * max stack. If we haven't figured
+				 * out what that is, then figure it out
+				 * now.
+				 */
+				if (unlikely(!tracer_frame) && i =3D=3D 1) {
+					tracer_frame =3D (p - stack) *
+						sizeof(unsigned long);
+					max_stack_size -=3D tracer_frame;
+				}
 			}
 		}
=20
@@ -149,7 +163,26 @@ stack_trace_call(unsigned long ip, unsigned long paren=
t_ip,
 	if (per_cpu(trace_active, cpu)++ !=3D 0)
 		goto out;
=20
-	check_stack(parent_ip, &stack);
+	/*
+	 * When fentry is used, the traced function does not get
+	 * its stack frame set up, and we lose the parent.
+	 * The ip is pretty useless because the function tracer
+	 * was called before that function set up its stack frame.
+	 * In this case, we use the parent ip.
+	 *
+	 * By adding the return address of either the parent ip
+	 * or the current ip we can disregard most of the stack usage
+	 * caused by the stack tracer itself.
+	 *
+	 * The function tracer always reports the address of where the
+	 * mcount call was, but the stack will hold the return address.
+	 */
+	if (fentry)
+		ip =3D parent_ip;
+	else
+		ip +=3D MCOUNT_INSN_SIZE;
+
+	check_stack(ip, &stack);
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

iQEcBAABAgAGBQJRQ3u9AAoJEOdOSU1xswtMlCUIAL1GEMwdZ/zgGB/3t1vD5Pl8
RzhkHIzhYE+re4s5PGSIhkoWrEoH/mV7lpTUT+aDi4N+F7icRDZ3B3rbmrAuhCq9
mEspHv5WoXuu87+RWdxWwuv7J0L0KhPQrDYUIiIh3f2djgf1e02WTSRX4aKrPXWZ
9SOLjv+LSh/oiVeEuL1N/zUI5HIqNA9Ub+GnP4+3STY58q+iqVu1ie4OhaVRcYuY
qMZBjvWWGoNjit41U5EPfM2SAqXSFmpiKph0QA5rF6L9h+IhhYgh5rIM9cF8Bq+/
kAZGpKkfu7MpRDwCb5VQlQrM1LcTRo7vzj9KIQD5lCwDGYYZ5m9ibFxBxThqNbo=
=/OBj
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
