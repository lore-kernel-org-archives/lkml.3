Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935093Ab3BTEKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 23:10:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11270 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934949Ab3BTEJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 23:09:30 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=tG3IZuWqQuQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KExpK_bjxQQA:10 a=DcRzKpIh7ZXw9s15WKEA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=e1L_9JPeGMYWafXcsfAA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130220040927.602765142@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 19 Feb 2013 23:07:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5/7] ktest: Search for linux banner for successful reboot
References: <20130220040728.921685169@goodmis.org>
Content-Disposition: inline; filename=0005-ktest-Search-for-linux-banner-for-successful-reboot.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Sometimes when a test kernel passed fine, but on reboot it crashed,
ktest could get stuck and not proceed. This would be frustrating if you
let a test run overnight to find out the next morning that it was stuck
on the first test.

To fix this, I made reboot check for the REBOOT_SUCCESS_LINE. If the
line was not detected, then it would power cycle the box.

What it didn't cover was if the REBOOT_SUCCESS_LINE wasn't defined or if
a 'good' kernel did not display the line. Instead have it search for the
Linux banner "Linux version". The reboot just needs to get to the start
of the next kernel, it does not need to test if the next kernel makes it
to a boot prompt.

After we find the next kernel has booted, then we just wait for either
the REBOOT_SUCCESS_LINE to appear or the timeout.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 3fd768e..839989d 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1212,11 +1212,16 @@ sub reboot {
     }
=20
     if (defined($time)) {
-	if (wait_for_monitor($time, $reboot_success_line)) {
+	# Look for the good kernel to boot
+	if (wait_for_monitor($time, "Linux version")) {
 	    # reboot got stuck?
 	    doprint "Reboot did not finish. Forcing power cycle\n";
 	    run_command "$power_cycle";
 	}
+
+	# Still need to wait for the reboot to finish
+	wait_for_monitor($time, $reboot_success_line);
+
 	end_monitor;
     }
 }
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRJEx3AAoJEOdOSU1xswtMCOIH/ROIgBsPlsbxAXehQctH0rLQ
NPktLVbMO7pWQiHZk1QGBeHy5jmoon5AfGcDVdzjyrq2vjVUpAdg6vJ4lsnSmF5c
wNzbJsghsMcYo1Z6wQJOgksPj9XUCw0SZvnGlC29XqbKAOHSlvQNah1MTkiaem+j
g7nPAQc4LwWOvT8NtOUIEmdMPTlBUi/s/r2PEluTNDmXEFqMtnhQvb2VLFRF25zs
Gq0K5JVqgs+v4GVY8bo8NC5RNHOqJXvuWewnUXZWFKA/oVgcV5GYFv8qaSTmbjjL
krQih+SDV84nnj4IupRcAVTb4jLKpfjGaU5quW6LumFKRJImloF+0vYqpVCXMZc=
=FLJ+
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
