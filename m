Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab3DVPWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 11:22:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13446 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab3DVPV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 11:21:29 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=EsX4LdtBJsMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VQ89Lxangj4A:10 a=t7CeM3EgAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=7d_E57ReAAAA:8 a=_KjU36Xe4x118lI4yFoA:9 a=QEXdDO2ut3YA:10 a=2e6ZYRoF4I4A:10 a=MSl-tDqOz04A:10 a=D6-X0JM3zdQA:10 a=jeBq3FmKZ4MA:10 a=EuyifR2uOWlHVzAnQooA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130422152127.190263706@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 22 Apr 2013 11:20:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sahara <keun-o.park@windriver.com>
Subject: [for-next][PATCH 2/2] tracepoints: Prevent null probe from being added
References: <20130422152026.207981701@goodmis.org>
Content-Disposition: inline; filename=0002-tracepoints-Prevent-null-probe-from-being-added.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Sahara <keun-o.park@windriver.com>

Somehow tracepoint_entry_add_probe() function allows a null probe function.
And, this may lead to unexpected results since the number of probe
functions in an entry can be counted by checking whether a probe is null
or not in the for-loop.
This patch prevents a null probe from being added.
In tracepoint_entry_remove_probe() function, checking probe parameter
within the for-loop is moved out for code efficiency, leaving the null probe
feature which removes all probe functions in the entry.

Link: http://lkml.kernel.org/r/1365991995-19445-1-git-send-email-kpark3469@=
gmail.com

Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Sahara <keun-o.park@windriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/tracepoint.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index d96ba22..99e7e31 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -112,7 +112,8 @@ tracepoint_entry_add_probe(struct tracepoint_entry *ent=
ry,
 	int nr_probes =3D 0;
 	struct tracepoint_func *old, *new;
=20
-	WARN_ON(!probe);
+	if (WARN_ON(!probe))
+		return ERR_PTR(-EINVAL);
=20
 	debug_print_probes(entry);
 	old =3D entry->funcs;
@@ -152,13 +153,18 @@ tracepoint_entry_remove_probe(struct tracepoint_entry=
 *entry,
=20
 	debug_print_probes(entry);
 	/* (N -> M), (N > 1, M >=3D 0) probes */
-	for (nr_probes =3D 0; old[nr_probes].func; nr_probes++) {
-		if (!probe ||
-		    (old[nr_probes].func =3D=3D probe &&
-		     old[nr_probes].data =3D=3D data))
-			nr_del++;
+	if (probe) {
+		for (nr_probes =3D 0; old[nr_probes].func; nr_probes++) {
+			if (old[nr_probes].func =3D=3D probe &&
+			     old[nr_probes].data =3D=3D data)
+				nr_del++;
+		}
 	}
=20
+	/*
+	 * If probe is NULL, then nr_probes =3D nr_del =3D 0, and then the
+	 * entire entry will be removed.
+	 */
 	if (nr_probes - nr_del =3D=3D 0) {
 		/* N -> 0, (N > 1) */
 		entry->funcs =3D NULL;
@@ -173,8 +179,7 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *=
entry,
 		if (new =3D=3D NULL)
 			return ERR_PTR(-ENOMEM);
 		for (i =3D 0; old[i].func; i++)
-			if (probe &&
-			    (old[i].func !=3D probe || old[i].data !=3D data))
+			if (old[i].func !=3D probe || old[i].data !=3D data)
 				new[j++] =3D old[i];
 		new[nr_probes - nr_del].func =3D NULL;
 		entry->refcount =3D nr_probes - nr_del;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEbBAABAgAGBQJRdVV3AAoJEOdOSU1xswtMvLQH+OrnMCEY0cdFycehPlpsp4xW
jCcGrNLczRFyVJ5+v+i/LvC9kPqYu63ZzPucRAoy58b294eQZMPdGqshHvL012Xg
rfIsHK/rYk3UrVdcrnr2VAt9OsoTuIcHkf8qXAicxuUMHd+0rqKkb/1Ntxc5ylkM
LnAWnf9uwCwxrOVy61ekGgzNtcTVDdwE/ofG10hzHNauLHl7o9PX4Ss1wLX5lnty
uJ2rWfqzhr7/zHRfef5biU0RCSOanfi+KYBlaHLhSk3OXnlQYuoUJn4s9N4a35VC
CWNp4rlaZMmBOHSm+BYHqHM0t8yN9oxmhxQFNZ7bt1ItASjD0gjM6Zxo7THHOQ==
=yLvE
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
