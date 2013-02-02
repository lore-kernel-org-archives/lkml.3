Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab3BBOUk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 09:20:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7481 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757563Ab3BBOT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 09:19:57 -0500
X-Authority-Analysis: v=2.0 cv=NqdTgrhJ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=U268sceQe-gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=hWNkcvGvoSMA:10 a=BQAXH_W91nN-Ym3oDY4A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=AwkJTDR0FhKAvPza:21 a=Eg14JJjTZqj6ocLT:21 a=HnboOlaG0lJzeyiOYr4A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130202141955.701304493@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 02 Feb 2013 09:18:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 06/11] ring-buffer: Add stats field for amount read from trace ring buffer
References: <20130202141842.189550803@goodmis.org>
Content-Disposition: inline; filename=0006-ring-buffer-Add-stats-field-for-amount-read-from-tra.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add a stat about the number of events read from the ring buffer:

 #  cat /debug/tracing/per_cpu/cpu0/stats
entries: 39869
overrun: 870512
commit overrun: 0
bytes: 1449912
oldest event ts:  6561.368690
now ts:  6565.246426
dropped events: 0
read events: 112    <-- Added

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ring_buffer.h |    1 +
 kernel/trace/ring_buffer.c  |   18 ++++++++++++++++++
 kernel/trace/trace.c        |    3 +++
 3 files changed, 22 insertions(+)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 519777e..1342e69 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -167,6 +167,7 @@ unsigned long ring_buffer_entries_cpu(struct ring_buffe=
r *buffer, int cpu);
 unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu);
 unsigned long ring_buffer_commit_overrun_cpu(struct ring_buffer *buffer, i=
nt cpu);
 unsigned long ring_buffer_dropped_events_cpu(struct ring_buffer *buffer, i=
nt cpu);
+unsigned long ring_buffer_read_events_cpu(struct ring_buffer *buffer, int =
cpu);
=20
 u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu);
 void ring_buffer_normalize_time_stamp(struct ring_buffer *buffer,
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 13950d9..7244acd 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3103,6 +3103,24 @@ ring_buffer_dropped_events_cpu(struct ring_buffer *b=
uffer, int cpu)
 EXPORT_SYMBOL_GPL(ring_buffer_dropped_events_cpu);
=20
 /**
+ * ring_buffer_read_events_cpu - get the number of events successfully read
+ * @buffer: The ring buffer
+ * @cpu: The per CPU buffer to get the number of events read
+ */
+unsigned long
+ring_buffer_read_events_cpu(struct ring_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+		return 0;
+
+	cpu_buffer =3D buffer->buffers[cpu];
+	return cpu_buffer->read;
+}
+EXPORT_SYMBOL_GPL(ring_buffer_read_events_cpu);
+
+/**
  * ring_buffer_entries - get the number of entries in a buffer
  * @buffer: The ring buffer
  *
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d399592..90a1c71 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4430,6 +4430,9 @@ tracing_stats_read(struct file *filp, char __user *ub=
uf,
 	cnt =3D ring_buffer_dropped_events_cpu(tr->buffer, cpu);
 	trace_seq_printf(s, "dropped events: %ld\n", cnt);
=20
+	cnt =3D ring_buffer_read_events_cpu(tr->buffer, cpu);
+	trace_seq_printf(s, "read events: %ld\n", cnt);
+
 	count =3D simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
=20
 	kfree(s);
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRDSCLAAoJEOdOSU1xswtMLV0H/2vHa9Afth+dnebOVvr5E7fc
9bofBeh3jff2h6NUuGSoIgKOV1HhYjQJOfptZ6VuGAKBTrzVctHhDIRluaApclcH
KNw/ukICMAxQQJtUzOdoaKZTVAZrpmfVVwlK8lkNTEM75laSiIZDdkUWVO6Ai1LA
BP5DhOWvXv9OzXJMD/5aebJvgsj+yyt6p/gbwjFxq/BCGD7PYbHH3KqWuDrgcFSl
exHRatbw1kba6GpFmvliMwNhM/UohUJ8eCFam/UbpIuUvav17M3Ye/XYLDc1bVTn
3oi+jh27FEuIaS4cSi77DvIfU4zX6uhPWvlIBdYKz3Y/5n6v4vrybtiaE3DkjPc=
=IgDR
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
