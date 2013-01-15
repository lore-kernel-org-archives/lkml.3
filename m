Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab3AOD1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 22:27:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18390 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab3AOD1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 22:27:11 -0500
X-Authority-Analysis: v=2.0 cv=O9a7TWBW c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=0wqTFTmITKQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Wxt34Yf_-nYA:10 a=20KFwNOVAAAA:8 a=GHEZzRn9zFxKzoQV2bAA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=sJDl17kiXk2sdYg0wuUA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130115032710.101377650@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 14 Jan 2013 22:20:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] tracing: Fix regression with irqsoff tracer and tracing_on file
References: <20130115032042.472099050@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Fix-regression-with-irqsoff-tracer-and-traci.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Commit 02404baf1b47 "tracing: Remove deprecated tracing_enabled file"
removed the tracing_enabled file as it never worked properly and
the tracing_on file should be used instead. But the tracing_on file
didn't call into the tracers start/stop routines like the
tracing_enabled file did. This caused trace-cmd to break when it
enabled the irqsoff tracer.

If you just did "echo irqsoff > current_tracer" then it would work
properly. But the tool trace-cmd disables tracing first by writing
"0" into the tracing_on file. Then it writes "irqsoff" into
current_tracer and then writes "1" into tracing_on. Unfortunately,
the above commit changed the irqsoff tracer to check the tracing_on
status instead of the tracing_enabled status. If it's disabled then
it does not start the tracer internals.

The problem is that writing "1" into tracing_on does not call the
tracers "start" routine like writing "1" into tracing_enabled did.
This makes the irqsoff tracer not start when using the trace-cmd
tool, and is a regression for userspace.

Simple fix is to have the tracing_on file call the tracers start()
method when being enabled (and the stop() method when disabled).

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 1bbfa04..f3ec1cf 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4817,10 +4817,17 @@ rb_simple_write(struct file *filp, const char __use=
r *ubuf,
 		return ret;
=20
 	if (buffer) {
-		if (val)
+		mutex_lock(&trace_types_lock);
+		if (val) {
 			ring_buffer_record_on(buffer);
-		else
+			if (current_trace->start)
+				current_trace->start(tr);
+		} else {
 			ring_buffer_record_off(buffer);
+			if (current_trace->stop)
+				current_trace->stop(tr);
+		}
+		mutex_unlock(&trace_types_lock);
 	}
=20
 	(*ppos)++;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQ9MyOAAoJEOdOSU1xswtMjeMIAI4ZTUshVcJRspnOAS+L8cHT
lyMuRcYPUPfZj17S+OITLk7j5UNTGbHzjc3Tyaj5GW3nrcZGpZ6TufUG9/DtqYF7
/xjtg62xtFKYPfU35PSlEUbAimAoPzPVd3nh2yL/UOe7jj2ILIx1ddKPhVUaer23
J0C9TFg2/OJ7qx3V0fGBO6RSdngHCKUvfNpeYaJ9NQjeczbEor+mjskegc7eHLNa
vKR9A14VHfC+H7hJHJEEaHXUrGNRwN3BiSfboN2oMDyjQ99sUMOoirlNDHI3BVC6
zzNphcMpqozeeCv7cASG8dDQvOsvaUGUb4mM3hUlJzJO1wdXe3UEGLYbZQKtP4Q=
=isG+
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
