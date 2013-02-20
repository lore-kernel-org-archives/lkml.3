Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935801Ab3BTEJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 23:09:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11270 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935765Ab3BTEJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 23:09:31 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=9P_hks--gFAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=HzmGtjsQ8D4A:10 a=HLmj116cHHf6qvUWgrQA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=alFNdoUbM1f4N3CoJmwA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130220040928.024193269@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 19 Feb 2013 23:07:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 7/7] ktest: Remove indexes from warnings check
References: <20130220040728.921685169@goodmis.org>
Content-Disposition: inline; filename=0007-ktest-Remove-indexes-from-warnings-check.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The index of a line where a warning is tested can be returned
differently on different versions of gcc (or same version compiled
differently). That is, a tab + space can give different results. This
causes the warning check to produce a false positive. Removing the
index from the check fixes this issue.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |   34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index f3bb5da..4e67d52 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1945,6 +1945,27 @@ sub start_monitor_and_boot {
 my $check_build_re =3D ".*:.*(warning|error|Error):.*";
 my $utf8_quote =3D "\\x{e2}\\x{80}(\\x{98}|\\x{99})";
=20
+sub process_warning_line {
+    my ($line) =3D @_;
+
+    chomp $line;
+
+    # for distcc heterogeneous systems, some compilers
+    # do things differently causing warning lines
+    # to be slightly different. This makes an attempt
+    # to fixe those issues.
+
+    # chop off the index into the line
+    # using distcc, some compilers give different indexes
+    # depending on white space
+    $line =3D~ s/^(\s*\S+:\d+:)\d+/$1/;
+
+    # Some compilers use UTF-8 extended for quotes and some don't.
+    $line =3D~ s/$utf8_quote/'/g;
+
+    return $line;
+}
+
 # Read buildlog and check against warnings file for any
 # new warnings.
 #
@@ -1965,8 +1986,9 @@ sub check_buildlog {
=20
 	while (<IN>) {
 	    if (/$check_build_re/) {
-		chomp;
-		$warnings_list{$_} =3D 1;
+		my $warning =3D process_warning_line $_;
+=09=09
+		$warnings_list{$warning} =3D 1;
 	    }
 	}
 	close(IN);
@@ -1978,13 +2000,9 @@ sub check_buildlog {
     open(IN, $buildlog) or dodie "Can't open $buildlog";
     while (<IN>) {
 	if (/$check_build_re/) {
+	    my $warning =3D process_warning_line $_;
=20
-	    # Some compilers use UTF-8 extended for quotes
-	    # for distcc heterogeneous systems, this causes issues
-	    s/$utf8_quote/'/g;
-
-	    chomp;
-	    if (!defined $warnings_list{$_}) {
+	    if (!defined $warnings_list{$warning}) {
 		fail "New warning found (not in $warnings_file)\n$_\n";
 		$no_reboot =3D $save_no_reboot;
 		return 0;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRJEx4AAoJEOdOSU1xswtMHl4H/2WSb5dV093y6y6WIIsWmDvZ
Wit8FYYSmInmwIu+DMfqiv5VhMVU8OlaBU1jCIvmdon/m/nzw8dzIXp5Hguqv5tG
8bwcozfTTuNW8Fbm21xFDzEQmYKeI7V47yfD12dsKQo6ilW7QWW1Hlt6t0mbobt2
WQKUqp9XsmhaI3HSE4gWvQ24KbEUckMGEQ6xJ5A4e1myA9MF48FOuHR5OX22oOgt
ua1yHDjDETw5+cWhEmFVX0rKyR6DVu0qP9ghXVSEWLM1uQRRVZ6lehZcvAZj+ROF
DDc8JoSpTou9SY6wWa5k01wTcFEarqZS3BENWI+N3GryVbHYkMfZvx3jEqWQ04g=
=nvzA
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
