Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab3COTxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:53:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22900 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab3COTv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:51:27 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=EfiBAIpdEIIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ozJkY-_bxT8A:10 a=VwQbUJbxAAAA:8 a=GtmIaYBfFRQAWf7-H48A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=BUsvTIOplOozriQ6ulcA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130315195124.960288283@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 15:39:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, <stable@vger.kernel.org>
Subject: [for-next][PATCH 15/20] tracing: Fix stack tracer with fentry use
References: <20130315193935.359219613@goodmis.org>
Content-Disposition: inline; filename=0015-tracing-Fix-stack-tracer-with-fentry-use.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When gcc 4.6 on x86 is used, the function tracer will use the new
option -mfentry which does a call to "fentry" at every function
instead of "mcount". The significance of this is that fentry is
called as the first operation of the function instead of the mcount
usage of being called after the stack.

This causes the stack tracer to show some bogus results for the size
of the last function traced, as well as showing "ftrace_call" instead
of the function. This is due to the stack frame not being set up
by the function that is about to be traced.

 # cat stack_trace
        Depth    Size   Location    (48 entries)
        -----    ----   --------
  0)     4824     216   ftrace_call+0x5/0x2f
  1)     4608     112   ____cache_alloc+0xb7/0x22d
  2)     4496      80   kmem_cache_alloc+0x63/0x12f

The 216 size for ftrace_call includes both the ftrace_call stack
(which includes the saving of registers it does), as well as the
stack size of the parent.

To fix this, if CC_USING_FENTRY is defined, then the stack_tracer
will reserve the first item in stack_dump_trace[] array when
calling save_stack_trace(), and it will fill it in with the parent ip.
Then the code will look for the parent pointer on the stack and
give the real size of the parent's stack pointer:

 # cat stack_trace
        Depth    Size   Location    (14 entries)
        -----    ----   --------
  0)     2640      48   update_group_power+0x26/0x187
  1)     2592     224   update_sd_lb_stats+0x2a5/0x4ac
  2)     2368     160   find_busiest_group+0x31/0x1f1
  3)     2208     256   load_balance+0xd9/0x662

I'm Cc'ing stable, although it's not urgent, as it only shows bogus
size for item #0, the rest of the trace is legit. It should still be
corrected in previous stable releases.

Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_stack.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index dc02e29..ea28e4b 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -20,13 +20,27 @@
=20
 #define STACK_TRACE_ENTRIES 500
=20
+/*
+ * If fentry is used, then the function being traced will
+ * jump to fentry directly before it sets up its stack frame.
+ * We need to ignore that one and record the parent. Since
+ * the stack frame for the traced function wasn't set up yet,
+ * the stack_trace wont see the parent. That needs to be added
+ * manually to stack_dump_trace[] as the first element.
+ */
+#ifdef CC_USING_FENTRY
+# define add_func	1
+#else
+# define add_func	0
+#endif
+
 static unsigned long stack_dump_trace[STACK_TRACE_ENTRIES+1] =3D
 	 { [0 ... (STACK_TRACE_ENTRIES)] =3D ULONG_MAX };
 static unsigned stack_dump_index[STACK_TRACE_ENTRIES];
=20
 static struct stack_trace max_stack_trace =3D {
-	.max_entries		=3D STACK_TRACE_ENTRIES,
-	.entries		=3D stack_dump_trace,
+	.max_entries		=3D STACK_TRACE_ENTRIES - add_func,
+	.entries		=3D &stack_dump_trace[add_func],
 };
=20
 static unsigned long max_stack_size;
@@ -40,7 +54,7 @@ int stack_tracer_enabled;
 static int last_stack_tracer_enabled;
=20
 static inline void
-check_stack(unsigned long *stack)
+check_stack(unsigned long ip, unsigned long *stack)
 {
 	unsigned long this_size, flags;
 	unsigned long *p, *top, *start;
@@ -71,6 +85,17 @@ check_stack(unsigned long *stack)
 	save_stack_trace(&max_stack_trace);
=20
 	/*
+	 * When fentry is used, the traced function does not get
+	 * its stack frame set up, and we lose the parent.
+	 * Add that one in manally. We set up save_stack_trace()
+	 * to not touch the first element in this case.
+	 */
+	if (add_func) {
+		stack_dump_trace[0] =3D ip;
+		max_stack_trace.nr_entries++;
+	}
+
+	/*
 	 * Now find where in the stack these are.
 	 */
 	i =3D 0;
@@ -124,7 +149,7 @@ stack_trace_call(unsigned long ip, unsigned long parent=
_ip,
 	if (per_cpu(trace_active, cpu)++ !=3D 0)
 		goto out;
=20
-	check_stack(&stack);
+	check_stack(parent_ip, &stack);
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

iQEcBAABAgAGBQJRQ3u9AAoJEOdOSU1xswtMRrEH/3T4PS45wNaviyz8atB6nLrL
H0KNAqP+0u3DpKdblVfs1Mh2M6oIbEdG8KTbR4KOUgwaH8+kcLl2RtwpckYx5Ul+
RHn5ICBWMCQxbLk+jDUH5RCoRnfYJu/ONXKaYQZn/pvRychFBlf77m3yriV16RB9
/9fs/9bqhDUIFADJFv++WuGq9c8CqTmURyvm1ql5i2nlGieawewsz2rAvWceiZB5
V8fVoMDTPL62UVCsHozypx9af37pqa1U2+EZHGV/oyb/XLHhkWhQh715BQlwgApT
RcnkeoTVeX3zB3X7TufpELMLxol0a52xdCg6NK1pM+BwfgLDJyvGIPaqazROY84=
=RAQ1
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
