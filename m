Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaKXPoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:44:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:3774 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753122AbaKXPne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:43:34 -0500
Message-Id: <20141124154332.112939757@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 24 Nov 2014 10:42:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 3/5] ktest: Allow tests to undefine default options
References: <20141124154251.345600733@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0003-ktest-Allow-tests-to-undefine-default-options.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Tests can set options that override the default ones. But if a test
tries to undefine a default option, it is simply ignored and the
default option stays as is.

For example, if you want to have a test that defines no MIN_CONFIG
then the test should be able to do that with:

   TEST_START
   MIN_CONFIG =

Which should make MIN_CONFIG not defined for that test. But the way
the code currently works, undefined options in tests are dropped.
This is because the NULL options are evaluated during the reading of
the config file and since one can disable default options in the default
section with this method, it is evaluated there (the option turns to a
undef). But undef options in the test section mean to use the default
option.

To fix this, keep the empty string in the option during the reading
of the config file, and then evaluate it when running the test. This
will allow tests to null out default options.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 89c2257bed98..ea43dd2f2fd5 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -684,11 +684,8 @@ sub set_value {
 	}
 	${$overrides}{$lvalue} = $prvalue;
     }
-    if ($rvalue =~ /^\s*$/) {
-	delete $opt{$lvalue};
-    } else {
-	$opt{$lvalue} = $prvalue;
-    }
+
+    $opt{$lvalue} = $prvalue;
 }
 
 sub set_eval {
@@ -3947,12 +3944,22 @@ for (my $i = 0, my $repeat = 1; $i <= $opt{"NUM_TESTS"}; $i += $repeat) {
     }
 }
 
+sub option_defined {
+    my ($option) = @_;
+
+    if (defined($opt{$option}) && $opt{$option} !~ /^\s*$/) {
+	return 1;
+    }
+
+    return 0;
+}
+
 sub __set_test_option {
     my ($name, $i) = @_;
 
     my $option = "$name\[$i\]";
 
-    if (defined($opt{$option})) {
+    if (option_defined($option)) {
 	return $opt{$option};
     }
 
@@ -3960,13 +3967,13 @@ sub __set_test_option {
 	if ($i >= $test &&
 	    $i < $test + $repeat_tests{$test}) {
 	    $option = "$name\[$test\]";
-	    if (defined($opt{$option})) {
+	    if (option_defined($option)) {
 		return $opt{$option};
 	    }
 	}
     }
 
-    if (defined($opt{$name})) {
+    if (option_defined($name)) {
 	return $opt{$name};
     }
 
-- 
2.1.1


