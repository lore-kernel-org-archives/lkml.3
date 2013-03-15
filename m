Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab3COTwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:52:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27896 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab3COTv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:51:28 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=s_RgK2cmG0wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=WukFj3UbrbAA:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=h1MK9b_5XSt2kY3lgxsA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=MSl-tDqOz04A:10 a=C6ltGn-DcIJCmzeQ65oA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130315195125.537300562@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 15:39:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [for-next][PATCH 18/20] tracing: Add "uptime" trace clock that uses jiffies
References: <20130315193935.359219613@goodmis.org>
Content-Disposition: inline; filename=0018-tracing-Add-uptime-trace-clock-that-uses-jiffies.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add a simple trace clock called "uptime" for those that are
interested in the uptime of the trace. It uses jiffies as that's
the safest method, as other uptime clocks grab seq locks, which could
cause a deadlock if taken from an event or function tracer.

Requested-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/trace_clock.h |    1 +
 kernel/trace/trace.c        |    1 +
 kernel/trace/trace_clock.c  |   10 ++++++++++
 3 files changed, 12 insertions(+)

diff --git a/include/linux/trace_clock.h b/include/linux/trace_clock.h
index d563f37..1d7ca27 100644
--- a/include/linux/trace_clock.h
+++ b/include/linux/trace_clock.h
@@ -16,6 +16,7 @@
=20
 extern u64 notrace trace_clock_local(void);
 extern u64 notrace trace_clock(void);
+extern u64 notrace trace_clock_jiffies(void);
 extern u64 notrace trace_clock_global(void);
 extern u64 notrace trace_clock_counter(void);
=20
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f90ca16..8eabfbb 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -647,6 +647,7 @@ static struct {
 	{ trace_clock_local,	"local",	1 },
 	{ trace_clock_global,	"global",	1 },
 	{ trace_clock_counter,	"counter",	0 },
+	{ trace_clock_jiffies,	"uptime",	1 },
 	ARCH_TRACE_CLOCKS
 };
=20
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index aa8f5f4..26dc348 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -57,6 +57,16 @@ u64 notrace trace_clock(void)
 	return local_clock();
 }
=20
+/*
+ * trace_jiffy_clock(): Simply use jiffies as a clock counter.
+ */
+u64 notrace trace_clock_jiffies(void)
+{
+	u64 jiffy =3D jiffies - INITIAL_JIFFIES;
+
+	/* Return nsecs */
+	return (u64)jiffies_to_usecs(jiffy) * 1000ULL;
+}
=20
 /*
  * trace_clock_global(): special globally coherent trace clock
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ3u9AAoJEOdOSU1xswtM4H4IAJ/hhqY1RHvlUanIzVGDXT8f
kZodVWCEacPmyTTRJ205TXVZOY2FG+x5mzZvgikAzsHTVuqUi9n3ouYrWXu3UQiI
3N91Zs2hYS7jqkORJRBPQY7VmBB7GQbnkSnJfbdS6lidUa/NnGZi7KY8dBgpgq47
urBnhISd5N8lNUwRp2V/rnA9kQAdZLzKO4mkuwpHWa1Lx4ROVDLkLdlZYR48oqBD
qUihdeGLNkD7IuHDvncFDhPuk25n6v1zi6dW5JS4C2np8wSeRDnPqNq4se9039Rc
CWFSQvhLK9i6iuDZycP6jm3NBWmQ+BjFTbG9EH9iZoO/49bWsSgu3fnhLkyn3qM=
=ecJE
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
