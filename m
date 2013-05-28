Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934548Ab3E1PRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:17:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23561 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934418Ab3E1PRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:17:50 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=FYiyDETUC2AA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=rZWFWbKVl5IA:10 a=JfrnYn6hAAAA:8 a=UiorTMsmAG6gtfSVMTkA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=3Rfx1nUSh_UA:10 a=c2Pr-J2djO60KOg4dasA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130528151749.688450288@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 28 May 2013 11:15:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/2] tracing: Fix crash when ftrace=nop on the kernel command line
References: <20130528151557.743203087@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Fix-crash-when-ftrace-nop-on-the-kernel-comm.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

If ftrace=3D<tracer> is on the kernel command line, when that tracer is
registered, it will be initiated by tracing_set_tracer() to execute that
tracer.

The nop tracer is just a stub tracer that is used to have no tracer
enabled. It is assigned at early bootup as it is the default tracer.

But if ftrace=3Dnop is on the kernel command line, the registering of the
nop tracer will call tracing_set_tracer() which will try to execute
the nop tracer. But it expects tr->current_trace to be assigned something
as it usually is assigned to the nop tracer. As it hasn't been assigned
to anything yet, it causes the system to crash.

The simple fix is to move the tr->current_trace =3D nop before registering
the nop tracer. The functionality is still the same as the nop tracer
doesn't do anything anyway.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ae6fa2d..4d79485 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6216,10 +6216,15 @@ __init static int tracer_alloc_buffers(void)
=20
 	trace_init_cmdlines();
=20
-	register_tracer(&nop_trace);
-
+	/*
+	 * register_tracer() might reference current_trace, so it
+	 * needs to be set before we register anything. This is
+	 * just a bootstrap of current_trace anyway.
+	 */
 	global_trace.current_trace =3D &nop_trace;
=20
+	register_tracer(&nop_trace);
+
 	/* All seems OK, enable tracing */
 	tracing_disabled =3D 0;
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRpMqdAAoJEOdOSU1xswtMIlYH/39TSwOSVdOC7AN4lnzP++wY
ATit02MAWKUo6OlYKdp/Z50m51kkpcEYeIM6azcimP25W6KEw8fxdFX3IyU3k9+A
iWLmui+0MrvMjtxne/WF+Zz+0flDiC0hvVoytVNPI7d7ymulKVIp7rL7/5GGNnZ3
PyLs0b9Usc7Qcoc6Tk+vzONda2g8C9VsW1r7FUXMmlFfR74Ro7b/voQql7gd4Eqs
KCVIBlUZmVbJ1hsStlQAb6jPI4UUTMblBwjWiEVfnrEEslRDyqS5HwWukljvx70k
dyH1q75DQM/QNhTPKEpadrmkm4ddjvgRzY6V4d0YeAJttU3oaqzUuuvpNDKzjss=
=XRWK
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
