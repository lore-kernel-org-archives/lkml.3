Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935817Ab3BTEKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 23:10:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6692 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935137Ab3BTEJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 23:09:29 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=r1QcZtq-fU0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Goebqe3DNqwA:10 a=6vMm-9kaxRDdhEq9WlcA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=AHWTY42MBfd-7FW0:21 a=13-FJmI2ACxoEe8a:21 a=QjM_m0as4cofK8_ZE_MA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130220040927.379963505@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 19 Feb 2013 23:07:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4/7] ktest: Add make_warnings_file and process full warnings
References: <20130220040728.921685169@goodmis.org>
Content-Disposition: inline; filename=0004-ktest-Add-make_warnings_file-and-process-full-warnin.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Although the patchcheck test checks for warnings in the files that were
changed, this check does not catch warnings that were caused by header
file changes and the warnings appear in C files not touched by the
commit.

Add a new option called WARNINGS_FILE. If this option is set, then the
file it points to is read before bulid, and the file should contain a
list of known warnings. If a warning appears in the build, this file is
checked, and if the warning does not exist in this file, then it fails
the build showing the new warning.

If the WARNINGS_FILE points to a file that does not exist, this will
cause any warning in the build to fail.

A new test is also added called "make_warnings_file". This test will
create do a build and record any warnings it finds into the
WARNINGS_FILE. This test is something that can be run before other tests
to build a warnings file of "known warnings", ie, warnings that were
there before your changes.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 .../testing/ktest/examples/include/patchcheck.conf |   37 +++++++
 tools/testing/ktest/ktest.pl                       |  110 ++++++++++++++++=
++--
 tools/testing/ktest/sample.conf                    |   44 ++++++++
 3 files changed, 185 insertions(+), 6 deletions(-)

diff --git a/tools/testing/ktest/examples/include/patchcheck.conf b/tools/t=
esting/ktest/examples/include/patchcheck.conf
index 339d3e1..0eb0a5a 100644
--- a/tools/testing/ktest/examples/include/patchcheck.conf
+++ b/tools/testing/ktest/examples/include/patchcheck.conf
@@ -14,6 +14,16 @@
 PATCH_START :=3D HEAD~3
 PATCH_END :=3D HEAD
=20
+# Use the oldconfig if build_type wasn't defined
+DEFAULTS IF NOT DEFINED BUILD_TYPE
+DO_BUILD_TYPE :=3D oldconfig
+
+DEFAULTS ELSE
+DO_BUILD_TYPE :=3D ${BUILD_TYPE}
+
+DEFAULTS
+
+
 # Change PATCH_CHECKOUT to be the branch you want to test. The test will
 # do a git checkout of this branch before starting. Obviously both
 # PATCH_START and PATCH_END must be in this branch (and PATCH_START must
@@ -43,6 +53,31 @@ PATCH_TEST_TYPE :=3D boot
 # (space delimited)
 #IGNORE_WARNINGS =3D 39eaf7ef884dcc44f7ff1bac803ca2a1dcf43544 6edb2a8a385f=
0cdef51dae37ff23e74d76d8a6ce
=20
+# Instead of just checking for warnings to files that are changed
+# it can be advantageous to check for any new warnings. If a
+# header file is changed, it could cause a warning in a file not
+# touched by the commit. To detect these kinds of warnings, you
+# can use the WARNINGS_FILE option.
+#
+# If the variable CREATE_WARNINGS_FILE is set, this config will
+# enable the WARNINGS_FILE during the patchcheck test. Also,
+# before running the patchcheck test, it will create the
+# warnings file.
+#
+DEFAULTS IF DEFINED CREATE_WARNINGS_FILE
+WARNINGS_FILE =3D ${OUTPUT_DIR}/warnings_file
+
+TEST_START IF DEFINED CREATE_WARNINGS_FILE
+# WARNINGS_FILE is already set by the DEFAULTS above
+TEST_TYPE =3D make_warnings_file
+# Checkout the commit before the patches to test,
+# and record all the warnings that exist before the patches
+# to test are added
+CHECKOUT =3D ${PATCHCHECK_START}~1
+# Force a full build
+BUILD_NOCLEAN =3D 0
+BUILD_TYPE =3D ${DO_BUILD_TYPE}
+
 # If you are running a multi test, and the test failed on the first
 # test but on, say the 5th patch. If you want to restart on the
 # fifth patch, set PATCH_START1. This will make the first test start
@@ -61,6 +96,7 @@ PATCHCHECK_TYPE =3D ${PATCH_TEST_TYPE}
 PATCHCHECK_START =3D ${PATCH_START1}
 PATCHCHECK_END =3D ${PATCH_END}
 CHECKOUT =3D ${PATCH_CHECKOUT}
+BUILD_TYPE =3D ${DO_BUILD_TYPE}
=20
 TEST_START IF ${TEST} =3D=3D patchcheck && ${MULTI}
 TEST_TYPE =3D patchcheck
@@ -72,3 +108,4 @@ PATCHCHECK_END =3D ${PATCH_END}
 CHECKOUT =3D ${PATCH_CHECKOUT}
 # Use multi to test different compilers?
 MAKE_CMD =3D CC=3Dgcc-4.5.1 make
+BUILD_TYPE =3D ${DO_BUILD_TYPE}
diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 3d19ee4..3fd768e 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -126,6 +126,7 @@ my $start_minconfig_defined;
 my $output_minconfig;
 my $minconfig_type;
 my $use_output_minconfig;
+my $warnings_file;
 my $ignore_config;
 my $ignore_errors;
 my $addconfig;
@@ -193,6 +194,9 @@ my $patchcheck_end;
 # which would require more options.
 my $buildonly =3D 1;
=20
+# tell build not to worry about warnings, even when WARNINGS_FILE is set
+my $warnings_ok =3D 0;
+
 # set when creating a new config
 my $newconfig =3D 0;
=20
@@ -235,6 +239,7 @@ my %option_map =3D (
     "START_MIN_CONFIG"		=3D> \$start_minconfig,
     "MIN_CONFIG_TYPE"		=3D> \$minconfig_type,
     "USE_OUTPUT_MIN_CONFIG"	=3D> \$use_output_minconfig,
+    "WARNINGS_FILE"		=3D> \$warnings_file,
     "IGNORE_CONFIG"		=3D> \$ignore_config,
     "TEST"			=3D> \$run_test,
     "ADD_CONFIG"		=3D> \$addconfig,
@@ -1924,7 +1929,60 @@ sub start_monitor_and_boot {
     return monitor;
 }
=20
+my $check_build_re =3D ".*:.*(warning|error|Error):.*";
+my $utf8_quote =3D "\\x{e2}\\x{80}(\\x{98}|\\x{99})";
+
+# Read buildlog and check against warnings file for any
+# new warnings.
+#
+# Returns 1 if OK
+#         0 otherwise
 sub check_buildlog {
+    return 1 if (!defined $warnings_file);
+
+    my %warnings_list;
+
+    # Failed builds should not reboot the target
+    my $save_no_reboot =3D $no_reboot;
+    $no_reboot =3D 1;
+
+    if (-f $warnings_file) {
+	open(IN, $warnings_file) or
+	    dodie "Error opening $warnings_file";
+
+	while (<IN>) {
+	    if (/$check_build_re/) {
+		chomp;
+		$warnings_list{$_} =3D 1;
+	    }
+	}
+	close(IN);
+    }
+
+    # If warnings file didn't exist, and WARNINGS_FILE exist,
+    # then we fail on any warning!
+
+    open(IN, $buildlog) or dodie "Can't open $buildlog";
+    while (<IN>) {
+	if (/$check_build_re/) {
+
+	    # Some compilers use UTF-8 extended for quotes
+	    # for distcc heterogeneous systems, this causes issues
+	    s/$utf8_quote/'/g;
+
+	    chomp;
+	    if (!defined $warnings_list{$_}) {
+		fail "New warning found (not in $warnings_file)\n$_\n";
+		$no_reboot =3D $save_no_reboot;
+		return 0;
+	    }
+	}
+    }
+    $no_reboot =3D $save_no_reboot;
+    close(IN);
+}
+
+sub check_patch_buildlog {
     my ($patch) =3D @_;
=20
     my @files =3D `git show $patch | diffstat -l`;
@@ -3080,11 +3138,13 @@ sub patchcheck {
 	    build "oldconfig" or return 0;
 	}
=20
-
-	if (!defined($ignored_warnings{$sha1})) {
-	    check_buildlog $sha1 or return 0;
+	# No need to do per patch checking if warnings file exists
+	if (!defined($warnings_file) && !defined($ignored_warnings{$sha1})) {
+	    check_patch_buildlog $sha1 or return 0;
 	}
=20
+	check_buildlog or return 0;
+
 	next if ($type eq "build");
=20
 	my $failed =3D 0;
@@ -3642,6 +3702,39 @@ sub make_min_config {
     return 1;
 }
=20
+sub make_warnings_file {
+    my ($i) =3D @_;
+
+    if (!defined($warnings_file)) {
+	dodie "Must define WARNINGS_FILE for make_warnings_file test";
+    }
+
+    if ($build_type eq "nobuild") {
+	dodie "BUILD_TYPE can not be 'nobuild' for make_warnings_file test";
+    }
+
+    build $build_type or dodie "Failed to build";
+
+    open(OUT, ">$warnings_file") or dodie "Can't create $warnings_file";
+
+    open(IN, $buildlog) or dodie "Can't open $buildlog";
+    while (<IN>) {
+
+	# Some compilers use UTF-8 extended for quotes
+	# for distcc heterogeneous systems, this causes issues
+	s/$utf8_quote/'/g;
+
+	if (/$check_build_re/) {
+	    print OUT;
+	}
+    }
+    close(IN);
+
+    close(OUT);
+
+    success $i;
+}
+
 $#ARGV < 1 or die "ktest.pl version: $VERSION\n   usage: ktest.pl config-f=
ile\n";
=20
 if ($#ARGV =3D=3D 0) {
@@ -3843,9 +3936,9 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
 	$run_type =3D $bisect_type;
     } elsif ($test_type eq "config_bisect") {
 	$run_type =3D $config_bisect_type;
-    }
-
-    if ($test_type eq "make_min_config") {
+    } elsif ($test_type eq "make_min_config") {
+	$run_type =3D "";
+    } elsif ($test_type eq "make_warnings_file") {
 	$run_type =3D "";
     }
=20
@@ -3902,10 +3995,15 @@ for (my $i =3D 1; $i <=3D $opt{"NUM_TESTS"}; $i++) {
     } elsif ($test_type eq "make_min_config") {
 	make_min_config $i;
 	next;
+    } elsif ($test_type eq "make_warnings_file") {
+	$no_reboot =3D 1;
+	make_warnings_file $i;
+	next;
     }
=20
     if ($build_type ne "nobuild") {
 	build $build_type or next;
+	check_buildlog or next;
     }
=20
     if ($test_type eq "install") {
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.c=
onf
index 4012e93..0a290fb 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -793,6 +793,20 @@
 # Example for a virtual guest call "Guest".
 #POWER_OFF =3D virsh destroy Guest
=20
+# To have the build fail on "new" warnings, create a file that
+# contains a list of all known warnings (they must match exactly
+# to the line with 'warning:', 'error:' or 'Error:'. If the option
+# WARNINGS_FILE is set, then that file will be read, and if the
+# build detects a warning, it will examine this file and if the
+# warning does not exist in it, it will fail the build.
+#
+# Note, if this option is defined to a file that does not exist
+# then any warning will fail the build.
+#  (see make_warnings_file below)
+#
+# (optional, default undefined)
+#WARNINGS_FILE =3D ${OUTPUT_DIR}/warnings_file
+
 # The way to execute a command on the target
 # (default ssh $SSH_USER@$MACHINE $SSH_COMMAND";)
 # The variables SSH_USER, MACHINE and SSH_COMMAND are defined
@@ -1222,3 +1236,33 @@
 #  MIN_CONFIG_TYPE =3D test
 #  TEST =3D ssh ${USER}@${MACHINE} echo hi
 #
+#
+#
+#
+# For TEST_TYPE =3D make_warnings_file
+#
+# If you want the build to fail when a new warning is discovered
+# you set the WARNINGS_FILE to point to a file of known warnings.
+#
+# The test "make_warnings_file" will let you create a new warnings
+# file before you run other tests, like patchcheck.
+#
+# What this test does is to run just a build, you still need to
+# specify BUILD_TYPE to tell the test what type of config to use.
+# A BUILD_TYPE of nobuild will fail this test.
+#
+# The test will do the build and scan for all warnings. Any warning
+# it discovers will be saved in the WARNINGS_FILE (required) option.
+#
+# It is recommended (but not necessary) to make sure BUILD_NOCLEAN is
+# off, so that a full build is done (make mrproper is performed).
+# That way, all warnings will be captured.
+#
+# Example:
+#
+#  TEST_TYPE =3D make_warnings_file
+#  WARNINGS_FILE =3D ${OUTPUT_DIR}
+#  BUILD_TYPE =3D useconfig:oldconfig
+#  CHECKOUT =3D v3.8
+#  BUILD_NOCLEAN =3D 0
+#
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRJEx3AAoJEOdOSU1xswtMecYH/3+tS0gNLnWTtIiyNtk8AuW9
OGYpVPp7d1HtBF1Jss+wahDUGyLNJuOJoVvjIDZ/TWWR51e/W7vOw2KtWCyUi9J+
qEL+wYr243es2avxYp4kKfSzFn+aMlEt2yhJv0UUg5QC9lgV52cDCuLvV0JvwA7I
WaPsCck78YIzqH82/KZYVMwKYtebMUE6SGNGBZ0un0V/GZIlTxUb/022zDO7UcbW
j0Ehk1Q+1FO4AhhG4+2mla4zaOtDlXFdvS85y7himhR3rCMgkEeRHXplJr3M84r8
jE/fs2cnm5VZcgQ2cAx2jvqaxFLX0EBk2R1lTDHdWDvEJqxqGBj4FKppI8BE+Ro=
=o46E
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
