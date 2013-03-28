Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab3C1Mwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 08:52:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21484 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab3C1Mwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 08:52:34 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=qON8pLPu1-gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=t3S1shvx5yMA:10 a=zavyHLYIyEpDPWPh8yUA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=AFRf9X2jmpNIDBB1MPYA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130328125232.322105284@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 28 Mar 2013 08:52:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/3] tracing: Fix race with update_max_tr_single and changing tracers
References: <20130328125214.132479321@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Fix-race-with-update_max_tr_single-and-chang.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The commit 34600f0e9 "tracing: Fix race with max_tr and changing tracers"
fixed the updating of the main buffers with the race of changing
tracers, but left out the fix to the updating of just a per cpu buffer.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4f1dade..7ba7fc7 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -744,8 +744,11 @@ update_max_tr_single(struct trace_array *tr, struct ta=
sk_struct *tsk, int cpu)
 		return;
=20
 	WARN_ON_ONCE(!irqs_disabled());
-	if (WARN_ON_ONCE(!current_trace->allocated_snapshot))
+	if (!current_trace->allocated_snapshot) {
+		/* Only the nop tracer should hit this when disabling */
+		WARN_ON_ONCE(current_trace !=3D &nop_trace);
 		return;
+	}
=20
 	arch_spin_lock(&ftrace_max_lock);
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRVD0QAAoJEOdOSU1xswtMSIwH/iwcmskQzCtUxgoErfUnEZZD
UCNEtCGb0AQuoMvHVsxvwzdcusLlLJFLFw1O6SZkqgzBCsr8tjydpgnObTohWa8S
a192crOgIutHpkq8gLi8IPnQ0Mad4SFluCo+3PkmKwMtBAysMbmgkdE+JB48M0P0
SDpbQWlLvIWCt+s7GklGv/wxOjol+9q3N7Zw9IcE5o1bqsvh9vbgEMShmLous4Qk
76M10c+x1uWFRvUCoYZ0x8brXm8ebXCUF0OXYAfj/zg4y0hipSfPZJi9oirgLRDS
5dlofXmx5RXpE0o3Md/yGxGVpFYEpushaWHC+0wsGDPdjrvGUnHeQuCjTvwDt9c=
=wvv4
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
