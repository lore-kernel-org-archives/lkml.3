Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191Ab3CGPwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 10:52:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10044 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154Ab3CGPvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 10:51:42 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=5F4bDbGb4DAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=UuzHrLScM88A:10 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=HsiUkt9cFOICQau9JCQA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=2MPnpATkE56Zip89:21 a=xhVnXdrTU_g9-5ow:21 a=WSZqgEkYlkhjIBMEnE8A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130307155140.957920663@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Mar 2013 10:34:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [PATCH 1/2] tracing: Add help of snapshot feature when snapshot is empty
References: <20130307153442.755353831@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Add-help-of-snapshot-feature-when-snapshot-i.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <srostedt@redhat.com>

When cat'ing the snapshot file, instead of showing an empty trace
header like the trace file does, show how to use the snapshot
feature.

Also, this is a good place to show if the snapshot has been allocated
or not. Users may want to "pre allocate" the snapshot to have a fast
"swap" of the current buffer. Otherwise, a swap would be slow and might
fail as it would need to allocate the snapshot buffer, and that might
fail under tight memory constraints.

Here's what it looked like before:

 # tracer: nop
 #
 # entries-in-buffer/entries-written: 0/0   #P:4
 #
 #                              _-----=3D> irqs-off
 #                             / _----=3D> need-resched
 #                            | / _---=3D> hardirq/softirq
 #                            || / _--=3D> preempt-depth
 #                            ||| /     delay
 #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
 #              | |       |   ||||       |         |

Here's what it looks like now:

 # tracer: nop
 #
 #
 # * Snapshot is freed *
 #
 # Snapshot commands:
 # echo 0 > snapshot : Clears and frees snapshot buffer
 # echo 1 > snapshot : Allocates snapshot buffer, if not already allocated.
 #                      Takes a snapshot of the main buffer.
 # echo 2 > snapshot : Clears snapshot buffer (but does not allocate)
 #                      (Doesn't have to be '2' works with any number that
 #                       is not a '0' or '1')

Acked-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c2e2c23..9e3120b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2400,6 +2400,27 @@ static void test_ftrace_alive(struct seq_file *m)
 	seq_printf(m, "#          MAY BE MISSING FUNCTION EVENTS\n");
 }
=20
+#ifdef CONFIG_TRACER_MAX_TRACE
+static void print_snapshot_help(struct seq_file *m, struct trace_iterator =
*iter)
+{
+	if (iter->trace->allocated_snapshot)
+		seq_printf(m, "#\n# * Snapshot is allocated *\n#\n");
+	else
+		seq_printf(m, "#\n# * Snapshot is freed *\n#\n");
+
+	seq_printf(m, "# Snapshot commands:\n");
+	seq_printf(m, "# echo 0 > snapshot : Clears and frees snapshot buffer\n");
+	seq_printf(m, "# echo 1 > snapshot : Allocates snapshot buffer, if not al=
ready allocated.\n");
+	seq_printf(m, "#                      Takes a snapshot of the main buffer=
.\n");
+	seq_printf(m, "# echo 2 > snapshot : Clears snapshot buffer (but does not=
 allocate)\n");
+	seq_printf(m, "#                      (Doesn't have to be '2' works with =
any number that\n");
+	seq_printf(m, "#                       is not a '0' or '1')\n");
+}
+#else
+/* Should never be called */
+static inline void print_snapshot_help(struct seq_file *m, struct trace_it=
erator *iter) { }
+#endif
+
 static int s_show(struct seq_file *m, void *v)
 {
 	struct trace_iterator *iter =3D v;
@@ -2411,7 +2432,9 @@ static int s_show(struct seq_file *m, void *v)
 			seq_puts(m, "#\n");
 			test_ftrace_alive(m);
 		}
-		if (iter->trace && iter->trace->print_header)
+		if (iter->snapshot && trace_empty(iter))
+			print_snapshot_help(m, iter);
+		else if (iter->trace && iter->trace->print_header)
 			iter->trace->print_header(m);
 		else
 			trace_default_header(m);
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJROLeNAAoJEOdOSU1xswtMF94H/iZzeNzbKw9LdU4F4ouWpDb7
Y7n7yJ/yxAP80S+95zsPe2NQ6ESEWPYdc/0MLXPAQaISEoyHv78aER2a6N0JTchS
tN7Ar+5z8gc+d8Q0S8rv82Wb457Y8ZjET0CARLmyhfW0TuV8frZ8PuOte6K5uaW0
9B+QxZ7fMf6tAMZp2B38CQmheP+glGRKwfZtaMI/Wsyb4jfNwM+Xe036f2S2m8pQ
2vzY0LEXl7e3CsiBOdhVgbzwn5TJrCaN4R1CYli0GZGjZUXE+1Iv46GlR5WzrXc7
lLVv8Um4Xxuz6JgcAc6ski7RLY8kp84g1sh4HQTwXUoDMHV0Oh1EPiu0/i0LA8g=
=9R5B
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
