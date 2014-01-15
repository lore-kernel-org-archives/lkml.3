Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaAOP3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:29:15 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:12719 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751259AbaAOP3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:29:12 -0500
Message-Id: <20140115152911.477670261@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 15 Jan 2014 10:28:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 1/2] ktest: Add special variable ${KERNEL_VERSION}
References: <20140115152805.592972467@goodmis.org>
Content-Disposition: inline; filename=0001-ktest-Add-special-variable-KERNEL_VERSION.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add a special variable that can be used in other variables called
${KERNEL_VERSION}. This will embed the current kernel version into
the variable. For example:

WARNINGS_FILE = ${OUTPUT_DIR}/warnings-${KERNEL_VERSION}

If the current version is v3.8 then the WARNINGS_FILE will become

  ${OUTPUT_DIR}/warnings-v3.8

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 5dc5704..b285933 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1129,6 +1129,10 @@ sub __eval_option {
 	} elsif (defined($opt{$var})) {
 	    $o = $opt{$var};
 	    $retval = "$retval$o";
+	} elsif ($var eq "KERNEL_VERSION" && defined($make)) {
+	    # special option KERNEL_VERSION uses kernel version
+	    get_version();
+	    $retval = "$retval$version";
 	} else {
 	    $retval = "$retval\$\{$var\}";
 	}
@@ -3919,6 +3923,18 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
 
     my $makecmd = set_test_option("MAKE_CMD", $i);
 
+    $outputdir = set_test_option("OUTPUT_DIR", $i);
+    $builddir = set_test_option("BUILD_DIR", $i);
+
+    chdir $builddir || die "can't change directory to $builddir";
+
+    if (!-d $outputdir) {
+	mkpath($outputdir) or
+	    die "can't create $outputdir";
+    }
+
+    $make = "$makecmd O=$outputdir";
+
     # Load all the options into their mapped variable names
     foreach my $opt (keys %option_map) {
 	${$option_map{$opt}} = set_test_option($opt, $i);
@@ -3943,13 +3959,9 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
 	$start_minconfig = $minconfig;
     }
 
-    chdir $builddir || die "can't change directory to $builddir";
-
-    foreach my $dir ($tmpdir, $outputdir) {
-	if (!-d $dir) {
-	    mkpath($dir) or
-		die "can't create $dir";
-	}
+    if (!-d $tmpdir) {
+	mkpath($tmpdir) or
+	    die "can't create $tmpdir";
     }
 
     $ENV{"SSH_USER"} = $ssh_user;
@@ -3958,7 +3970,6 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     $buildlog = "$tmpdir/buildlog-$machine";
     $testlog = "$tmpdir/testlog-$machine";
     $dmesg = "$tmpdir/dmesg-$machine";
-    $make = "$makecmd O=$outputdir";
     $output_config = "$outputdir/.config";
 
     if (!$buildonly) {
-- 
1.8.4.3


