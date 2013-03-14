Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab3CNVkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 17:40:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10468 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab3CNVka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 17:40:30 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=yN-yRz-q-KUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=0lIkNrKItr4A:10 a=VwQbUJbxAAAA:8 a=xyjClV9khCZf7UbR_SUA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=YIKy3ce8_hazBf9GSlsA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130314214028.916737591@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 14 Mar 2013 17:33:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, <stable@vger.kernel.org>
Subject: [PATCH 1/3] tracing: Protect tracer flags with trace_types_lock
References: <20130314213303.302538352@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Protect-tracer-flags-with-trace_types_lock.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Seems that the tracer flags have never been protected from
synchronous writes. Luckily, admins don't usually modify the
tracing flags via two different tasks. But if scripts were to
be used to modify them, then they could get corrupted.

Move the trace_types_lock that protects against tracers changing
to also protect the flags being set.

Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 53df283..00daf5f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2916,6 +2916,8 @@ static int trace_set_options(char *option)
 		cmp +=3D 2;
 	}
=20
+	mutex_lock(&trace_types_lock);
+
 	for (i =3D 0; trace_options[i]; i++) {
 		if (strcmp(cmp, trace_options[i]) =3D=3D 0) {
 			set_tracer_flags(1 << i, !neg);
@@ -2924,11 +2926,10 @@ static int trace_set_options(char *option)
 	}
=20
 	/* If no option could be set, test the specific tracer options */
-	if (!trace_options[i]) {
-		mutex_lock(&trace_types_lock);
+	if (!trace_options[i])
 		ret =3D set_tracer_option(current_trace, cmp, neg);
-		mutex_unlock(&trace_types_lock);
-	}
+
+	mutex_unlock(&trace_types_lock);
=20
 	return ret;
 }
@@ -4781,7 +4782,10 @@ trace_options_core_write(struct file *filp, const ch=
ar __user *ubuf, size_t cnt,
=20
 	if (val !=3D 0 && val !=3D 1)
 		return -EINVAL;
+
+	mutex_lock(&trace_types_lock);
 	set_tracer_flags(1 << index, val);
+	mutex_unlock(&trace_types_lock);
=20
 	*ppos +=3D cnt;
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQkPNAAoJEOdOSU1xswtM6HAIAJDY/8Z3eZ7ycFTCjjZyqAv6
vELmoSI5bXp5nLVEB3zS2TMHArzNE0bKQKwwWG1e7OqfgRb9UOPv3IfS9e1KzM7W
iPcxBU7N14irj4d5LwSqUgSLTK9W3IhJThyLWzfJcJUf5vBXuo0Nq3z55r28PhGo
Vnep2cBwRVkvXa/oBoMDr0P1fUhe5u1A19YtS+S4z7vkFD3zRK5WT0ws4hd6sdts
Cgu56ZNZa6zet+K7C837ukoOKBXmbYfyeCuZIyAK+jDkpJxwawr9zwqMeOMUpcri
qgr6aBEQnpwGffmp+rMk5b5aev9/5VDVtGkl58uC/3fAq6zCPfK4vGdm80hCD2U=
=oILp
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
