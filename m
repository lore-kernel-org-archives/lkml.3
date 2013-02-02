Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab3BBOUf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 09:20:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20565 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757731Ab3BBOUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 09:20:00 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=SJNEzihk9ykA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=X76ShSH4OSwA:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=y5Yq1ZyPAAAA:8 a=zg3aau197bQW10xJqsEA:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=nt6uV6JkblEA:10 a=jeBq3FmKZ4MA:10 a=OZBcLlpx_0lzDtNcssMA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130202141956.510541914@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 02 Feb 2013 09:18:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rob Landley <rob@landley.net>,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [PATCH 10/11] tracing: Add documentation of snapshot utility
References: <20130202141842.189550803@goodmis.org>
Content-Disposition: inline; filename=0010-tracing-Add-documentation-of-snapshot-utility.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>

This patch adds snapshot description in ftrace documentation.
This description includes what the snapshot is and how to use it.

Link: http://lkml.kernel.org/r/20121226025309.3252.150.stgit@liselsia

Cc: Rob Landley <rob@landley.net>
Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/ftrace.txt |   83 ++++++++++++++++++++++++++++++++++++=
++++
 1 file changed, 83 insertions(+)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 6f51fed..53d6a3c 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -1842,6 +1842,89 @@ an error.
  # cat buffer_size_kb
 85
=20
+Snapshot
+--------
+CONFIG_TRACER_SNAPSHOT makes a generic snapshot feature
+available to all non latency tracers. (Latency tracers which
+record max latency, such as "irqsoff" or "wakeup", can't use
+this feature, since those are already using the snapshot
+mechanism internally.)
+
+Snapshot preserves a current trace buffer at a particular point
+in time without stopping tracing. Ftrace swaps the current
+buffer with a spare buffer, and tracing continues in the new
+current (=3Dprevious spare) buffer.
+
+The following debugfs files in "tracing" are related to this
+feature:
+
+  snapshot:
+
+	This is used to take a snapshot and to read the output
+	of the snapshot. Echo 1 into this file to allocate a
+	spare buffer and to take a snapshot (swap), then read
+	the snapshot from this file in the same format as
+	"trace" (described above in the section "The File
+	System"). Both reads snapshot and tracing are executable
+	in parallel. When the spare buffer is allocated, echoing
+	0 frees it, and echoing else (positive) values clear the
+	snapshot contents.
+	More details are shown in the table below.
+
+	status\input  |     0      |     1      |    else    |
+	--------------+------------+------------+------------+
+	not allocated |(do nothing)| alloc+swap |   EINVAL   |
+	--------------+------------+------------+------------+
+	allocated     |    free    |    swap    |   clear    |
+	--------------+------------+------------+------------+
+
+Here is an example of using the snapshot feature.
+
+ # echo 1 > events/sched/enable
+ # echo 1 > snapshot
+ # cat snapshot
+# tracer: nop
+#
+# entries-in-buffer/entries-written: 71/71   #P:8
+#
+#                              _-----=3D> irqs-off
+#                             / _----=3D> need-resched
+#                            | / _---=3D> hardirq/softirq
+#                            || / _--=3D> preempt-depth
+#                            ||| /     delay
+#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
+#              | |       |   ||||       |         |
+          <idle>-0     [005] d...  2440.603828: sched_switch: prev_comm=3D=
swapper/5 prev_pid=3D0 prev_prio=3D120 prev_state=3DR =3D=3D> next_comm=3Ds=
napshot-test-2 next_pid=3D2242 next_prio=3D120
+           sleep-2242  [005] d...  2440.603846: sched_switch: prev_comm=3D=
snapshot-test-2 prev_pid=3D2242 prev_prio=3D120 prev_state=3DR =3D=3D> next=
_comm=3Dkworker/5:1 next_pid=3D60 next_prio=3D120
+[...]
+          <idle>-0     [002] d...  2440.707230: sched_switch: prev_comm=3D=
swapper/2 prev_pid=3D0 prev_prio=3D120 prev_state=3DR =3D=3D> next_comm=3Ds=
napshot-test-2 next_pid=3D2229 next_prio=3D120
+
+ # cat trace
+# tracer: nop
+#
+# entries-in-buffer/entries-written: 77/77   #P:8
+#
+#                              _-----=3D> irqs-off
+#                             / _----=3D> need-resched
+#                            | / _---=3D> hardirq/softirq
+#                            || / _--=3D> preempt-depth
+#                            ||| /     delay
+#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
+#              | |       |   ||||       |         |
+          <idle>-0     [007] d...  2440.707395: sched_switch: prev_comm=3D=
swapper/7 prev_pid=3D0 prev_prio=3D120 prev_state=3DR =3D=3D> next_comm=3Ds=
napshot-test-2 next_pid=3D2243 next_prio=3D120
+ snapshot-test-2-2229  [002] d...  2440.707438: sched_switch: prev_comm=3D=
snapshot-test-2 prev_pid=3D2229 prev_prio=3D120 prev_state=3DS =3D=3D> next=
_comm=3Dswapper/2 next_pid=3D0 next_prio=3D120
+[...]
+
+
+If you try to use this snapshot feature when current tracer is
+one of the latency tracers, you will get the following results.
+
+ # echo wakeup > current_tracer
+ # echo 1 > snapshot
+bash: echo: write error: Device or resource busy
+ # cat snapshot
+cat: snapshot: Device or resource busy
+
 -----------
=20
 More details can be found in the source code, in the
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRDSCMAAoJEOdOSU1xswtMEvwH+gI55p+xaK33TTsfrJ98Mq+q
UjM+WrntX60Yzhuls2DvS7q29iKmNv0XP+zHevnmDi+zrR4cD+btXR4prY95IIX4
X3K9ca25V+iEzowNkN6U+lTrsQMavq/bLwLfRUR90fGD2zyz/wjq9kFgJU6/YRb8
Yiro6yVocirNqiF1fC+BKrM8PUfXZAQ82gR1mjQGSOya/OnGxVAFPiRoaACnOnp8
VJmbdhRv1CUO2hkid5vpA+u4zBiktnfgiLip9xgmpPA0uhJ9BE7suEJTcF6t27A/
M09hiw4MWELgLH3HSmbaFbR7luEXeKRzCm9ArYTBB3a8PsYrlyu0PNZFhcJMr+g=
=K738
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
