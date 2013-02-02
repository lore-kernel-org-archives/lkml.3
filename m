Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab3BBOUu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 09:20:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20565 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653Ab3BBOT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 09:19:57 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=f6AJohfk66MA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=hZThTVmvb6gA:10 a=pGLkceISAAAA:8 a=VqJqp3NRGl-_L7Ud1H4A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=3SB9BO7HcYhJhif8x14A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130202141955.509272919@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 02 Feb 2013 09:18:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 05/11] tracing/fgraph: Adjust fgraph depth before calling trace return
 callback
References: <20130202141842.189550803@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-fgraph-Adjust-fgraph-depth-before-calling-tr.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

While debugging the virtual cputime with the function graph tracer
with a max_depth of 1 (most common use of the max_depth so far),
I found that I was missing kernel execution because of a race condition.

The code for the return side of the function has a slight race:

	ftrace_pop_return_trace(&trace, &ret, frame_pointer);
	trace.rettime =3D trace_clock_local();
	ftrace_graph_return(&trace);
	barrier();
	current->curr_ret_stack--;

The ftrace_pop_return_trace() initializes the trace structure for
the callback. The ftrace_graph_return() uses the trace structure
for its own use as that structure is on the stack and is local
to this function. Then the curr_ret_stack is decremented which
is what the trace.depth is set to.

If an interrupt comes in after the ftrace_graph_return() but
before the curr_ret_stack, then the called function will get
a depth of 2. If max_depth is set to 1 this function will be
ignored.

The problem is that the trace has already been called, and the
timestamp for that trace will not reflect the time the function
was about to re-enter userspace. Calls to the interrupt will not
be traced because the max_depth has prevented this.

To solve this issue, the ftrace_graph_return() can safely be
moved after the current->curr_ret_stack has been updated.
This way the timestamp for the return callback will reflect
the actual time.

If an interrupt comes in after the curr_ret_stack update and
ftrace_graph_return(), it will be traced. It may look a little
confusing to see it within the other function, but at least
it will not be lost.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions_graph.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_func=
tions_graph.c
index 7008d2e..39ada66 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -191,10 +191,16 @@ unsigned long ftrace_return_to_handler(unsigned long =
frame_pointer)
=20
 	ftrace_pop_return_trace(&trace, &ret, frame_pointer);
 	trace.rettime =3D trace_clock_local();
-	ftrace_graph_return(&trace);
 	barrier();
 	current->curr_ret_stack--;
=20
+	/*
+	 * The trace should run after decrementing the ret counter
+	 * in case an interrupt were to come in. We don't want to
+	 * lose the interrupt if max_depth is set.
+	 */
+	ftrace_graph_return(&trace);
+
 	if (unlikely(!ret)) {
 		ftrace_graph_stop();
 		WARN_ON(1);
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRDSCLAAoJEOdOSU1xswtMNcIIAMYHLqm0v8wefxh6A0glqhpr
zYhjPGsrdMxtcgx6wwHcchkRIXyOVlFBzpisnIwV7UQ9V7zCi1gE3OjqkZcN0D/O
ayrIek8CJBFU+K6Wr+wJBb2msmoiBIIUINsyoDMnC27l2kVeYngjt6RZySWieJYA
CFN3rPLXHWuduOTD2qZTGwiq39Rg7ME+fjagI7UrhR3xtXbiSYd5Dgr40XeUQuin
Jj8J2DnCggxWk3eUk7/RQT7uMzvzhBUTKMe/ZJ5bTdGGM9nij+JJSECzviA0fUR0
nTKCG8eKxaSOWsFLqtLxU1IwNjzjwPuht5PRHs/wK46vTX7EvtbBtsHVA46OE8w=
=6hyz
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
