Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbaLHR5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:57:40 -0500
Received: from smtprelay0058.hostedemail.com ([216.40.44.58]:37426 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756149AbaLHR5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:57:39 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::,RULES_HIT:41:69:355:379:541:960:973:988:989:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3354:3653:3865:3866:3867:3874:4321:4605:5007:6261:7903:8660:10004:10400:10848:11026:11658:11914:12043:12266:12291:12296:12438:12517:12519:12555:12679:12683:13148:13161:13229:13230:13870:14093:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: burn84_427762bfe1e37
X-Filterd-Recvd-Size: 4270
Date: Mon, 8 Dec 2014 12:57:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] ktest: Updates for 3.19
Message-ID: <20141208125735.6126f8fb@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

The following ktest updates were done:

 o Fix handling the make kernelrelease change
 o Fix make_min_config that was broken by new bisect_config changes
 o Allow tests to undefine default options (not just being able to override
    them)
 o Print name of test (if defined) to start of test output

Please pull the latest ktest-v3.19 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
ktest-v3.19

Tag SHA1: 388ee892c32a0b32fe52093b22e868edaad79b3d
Head SHA1: 17150fef4ab1f48d838008657cdaa168453a9fa6


Michal Marek (1):
      ktest: Use make -s kernelrelease

Steven Rostedt (Red Hat) (4):
      ktest: Fix make_min_config to handle new assign_configs call
      ktest: Allow tests to undefine default options
      ktest: Add name to running title
      ktest: Add back "tail -1" to kernelrelease make

----
 tools/testing/ktest/ktest.pl | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)
---------------------------
diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index bf1398180785..b9cd036f0442 100755
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
@@ -2005,7 +2002,7 @@ sub get_version {
     # get the release name
     return if ($have_version);
     doprint "$make kernelrelease ... ";
-    $version = `$make kernelrelease | tail -1`;
+    $version = `$make -s kernelrelease | tail -1`;
     chomp($version);
     doprint "$version\n";
     $have_version = 1;
@@ -3571,7 +3568,9 @@ sub test_this_config {
     undef %configs;
     assign_configs \%configs, $output_config;
 
-    return $config if (!defined($configs{$config}));
+    if (!defined($configs{$config}) || $configs{$config} =~ /^#/) {
+	return $config;
+    }
 
     doprint "disabling config $config did not change .config\n";
 
@@ -3945,12 +3944,22 @@ for (my $i = 0, my $repeat = 1; $i <= $opt{"NUM_TESTS"}; $i += $repeat) {
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
 
@@ -3958,13 +3967,13 @@ sub __set_test_option {
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
 
@@ -4077,8 +4086,14 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     my $installme = "";
     $installme = " no_install" if ($no_install);
 
+    my $name = "";
+
+    if (defined($test_name)) {
+	$name = " ($test_name)";
+    }
+
     doprint "\n\n";
-    doprint "RUNNING TEST $i of $opt{NUM_TESTS} with option $test_type $run_type$installme\n\n";
+    doprint "RUNNING TEST $i of $opt{NUM_TESTS}$name with option $test_type $run_type$installme\n\n";
 
     if (defined($pre_test)) {
 	run_command $pre_test;
