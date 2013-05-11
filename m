Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab3EKANz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 20:13:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4056 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab3EKANG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 20:13:06 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=kd9cCaFNO2UA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=jIkSLBQFL3AA:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=QyXUC8HyAAAA:8 a=s8_UgaaEB5vOCuRqDJkA:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=1PMB26lXaNd-fXXZ:21 a=lHlpAJm_RINavGk9:21 a=S4hJhvZ6vEyjRpEKgOcA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130511001303.413851811@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 May 2013 20:12:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Subject: [PATCH 02/18] tracing: Dont succeed if event_enable_func did not register
 anything
References: <20130511001206.477862307@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Don-t-succeed-if-event_enable_func-did-not-r.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Return 0 instead of the number of activated ftrace function probes if
event_enable_func succeeded and return an error code if it failed or
did not register any functions. But it currently returns the number
of registered functions and if it didn't register anything, it returns 0,
but that is considered success.

This also fixes the return value. As if it succeeds, it returns the
number of functions that were enabled, which is returned back to
the user in ftrace_regex_write (the write() return code). If only
one function is enabled, then the return code of the write is one,
and this can confuse the user program in thinking it only wrote 1
byte.

Link: http://lkml.kernel.org/r/20130509054413.30398.55650.stgit@mhiramat-M0=
-7522

Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <tom.zanussi@intel.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
[ Rewrote change log to reflect that this fixes two bugs - SR ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 53582e9..44ac836 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2061,8 +2061,11 @@ event_enable_func(struct ftrace_hash *hash,
 	if (ret < 0)
 		goto out_put;
 	ret =3D register_ftrace_function_probe(glob, ops, data);
-	if (!ret)
+	if (!ret) {
+		ret =3D -ENOENT;
 		goto out_disable;
+	} else
+		ret =3D 0;
  out:
 	mutex_unlock(&event_mutex);
 	return ret;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRjY0PAAoJEOdOSU1xswtMCiUH/iF4H7vOqfQI80fJm4qduXix
OLnVV+BI7zjzsdqNk74a0NezQCSUUc3pUcQw14KplwZLJm9XsKCa7SC2eSpEeyVx
rBOg9BGLvjdg19kteZGcZHLoV2mqT3VxsLqMt7mrIrsI7JBqpgVfvex3u+DZG1YU
oKQeqKV7Ga3tQdx9J8SFsgAdg5hL8f4Itt0agC/WQrfSvxIpSIPc5XOCOekPhuoI
Ha+hv17k6hG0Xyn7C+zO7RhcmTD35lwQfX20PV3tMGSjcC+PQltxa6YmY2sZ2whF
9Gb54KM5vwLSNDdE/74S63wtrHBd5pqRHFMLSwsUA/0UZUDc1LtpWOrfiWiCGFM=
=iXyG
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
