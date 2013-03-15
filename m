Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab3COTzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:55:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27573 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab3COTvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:51:24 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Obq2zRT1GpAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=S61o32V4jScA:10 a=XMM7hMTiu_RcBDN4TwMA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=DZ58KUZh8eTxzy7QDGoA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130315195122.339042353@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 15:39:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [for-next][PATCH 02/20] tracing: Consolidate ftrace_trace_onoff_unreg() into callback
References: <20130315193935.359219613@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Consolidate-ftrace_trace_onoff_unreg-into-ca.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The only thing ftrace_trace_onoff_unreg() does is to do a strcmp()
against the cmd parameter to determine what op to unregister. But
this compare is also done after the location that this function is
called (and returns). By moving the check for '!' to unregister after
the strcmp(), the callback function itself can just do the unregister
and we can get rid of the helper function.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 38cfb29..a88a3e0 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -283,22 +283,6 @@ ftrace_trace_onoff_print(struct seq_file *m, unsigned =
long ip,
 }
=20
 static int
-ftrace_trace_onoff_unreg(char *glob, char *cmd, char *param)
-{
-	struct ftrace_probe_ops *ops;
-
-	/* we register both traceon and traceoff to this callback */
-	if (strcmp(cmd, "traceon") =3D=3D 0)
-		ops =3D &traceon_probe_ops;
-	else
-		ops =3D &traceoff_probe_ops;
-
-	unregister_ftrace_function_probe_func(glob, ops);
-
-	return 0;
-}
-
-static int
 ftrace_trace_onoff_callback(struct ftrace_hash *hash,
 			    char *glob, char *cmd, char *param, int enable)
 {
@@ -311,15 +295,17 @@ ftrace_trace_onoff_callback(struct ftrace_hash *hash,
 	if (!enable)
 		return -EINVAL;
=20
-	if (glob[0] =3D=3D '!')
-		return ftrace_trace_onoff_unreg(glob+1, cmd, param);
-
 	/* we register both traceon and traceoff to this callback */
 	if (strcmp(cmd, "traceon") =3D=3D 0)
 		ops =3D &traceon_probe_ops;
 	else
 		ops =3D &traceoff_probe_ops;
=20
+	if (glob[0] =3D=3D '!') {
+		unregister_ftrace_function_probe_func(glob+1, ops);
+		return 0;
+	}
+
 	if (!param)
 		goto out_reg;
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ3u6AAoJEOdOSU1xswtMdjAH/R02ACpwKy200cOGEO+BuKCt
unXaH45nnDPU+9SrWD+wEQ3Dfv2CpTcPsSt0T57czsYjRlglAgd/TMs/3glokGne
VOJ2VvHw5JDOd9LCHnTTwdB7TSgTuWRoBEaKtFU2iNeVPO3V79h7vliP+I7oKmK5
oh52zkohSb+KKQqNoMR/hFfGj/rCeXd5Vbg9G0bJqslhJ2G7ACZU2Epc8SqSHCVT
+imcyC6GguQKjfH0dPQcva4rvuXDgEzR/XOBuLIWJ/aY9FQv85BxxVWS2BjoR6In
fzGKg8lPdyPNRATJz+BRiEqkSUFnPgAxavQVO5eupp0nOgDFM34zjIguCs40hU0=
=b/MM
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
