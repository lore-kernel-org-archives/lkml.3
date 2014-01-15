Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaAOP34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:29:56 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:19833 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752157AbaAOP3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:29:12 -0500
Message-Id: <20140115152911.626396126@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 15 Jan 2014 10:28:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 2/2] ktest: Add eval =~ command to modify variables in config file
References: <20140115152805.592972467@goodmis.org>
Content-Disposition: inline; filename=0002-ktest-Add-eval-command-to-modify-variables-in-config.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

With the added variable ${KERNEL_VERSION}, it is useful to be
able to use parts of it for other variables.

For example, if you want to create a warnings file for each major
kernel version to test sub versions against you can create
your warnings file with like this:

  WARNINGS_FILE = warnings-file-${KERNEL_VERSION}

But this may add 3.8.12 or something, and we want all 3.8.* to
use the same file, and 3.10.* to use another file, and so on.
With the eval command we can, by adding:

  WARNINGS_FILE =~ s/(-file-\d+\.\d+).*/$1/

Which will chop off the extra characters after the 3.8.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl | 102 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 81 insertions(+), 21 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index b285933..82006c2 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -18,6 +18,7 @@ $| = 1;
 my %opt;
 my %repeat_tests;
 my %repeats;
+my %evals;
 
 #default opts
 my %default = (
@@ -448,6 +449,27 @@ $config_help{"REBOOT_SCRIPT"} = << "EOF"
 EOF
     ;
 
+sub _logit {
+    if (defined($opt{"LOG_FILE"})) {
+	open(OUT, ">> $opt{LOG_FILE}") or die "Can't write to $opt{LOG_FILE}";
+	print OUT @_;
+	close(OUT);
+    }
+}
+
+sub logit {
+    if (defined($opt{"LOG_FILE"})) {
+	_logit @_;
+    } else {
+	print @_;
+    }
+}
+
+sub doprint {
+    print @_;
+    _logit @_;
+}
+
 sub read_prompt {
     my ($cancel, $prompt) = @_;
 
@@ -665,6 +687,22 @@ sub set_value {
     }
 }
 
+sub set_eval {
+    my ($lvalue, $rvalue, $name) = @_;
+
+    my $prvalue = process_variables($rvalue);
+    my $arr;
+
+    if (defined($evals{$lvalue})) {
+	$arr = $evals{$lvalue};
+    } else {
+	$arr = [];
+	$evals{$lvalue} = $arr;
+    }
+
+    push @{$arr}, $rvalue;
+}
+
 sub set_variable {
     my ($lvalue, $rvalue) = @_;
 
@@ -950,6 +988,20 @@ sub __read_config {
 		$test_case = 1;
 	    }
 
+	} elsif (/^\s*([A-Z_\[\]\d]+)\s*=~\s*(.*?)\s*$/) {
+
+	    next if ($skip);
+
+	    my $lvalue = $1;
+	    my $rvalue = $2;
+
+	    if ($default || $lvalue =~ /\[\d+\]$/) {
+		set_eval($lvalue, $rvalue, $name);
+	    } else {
+		my $val = "$lvalue\[$test_num\]";
+		set_eval($val, $rvalue, $name);
+	    }
+
 	} elsif (/^\s*([A-Z_\[\]\d]+)\s*=\s*(.*?)\s*$/) {
 
 	    next if ($skip);
@@ -1147,6 +1199,33 @@ sub __eval_option {
     return $retval;
 }
 
+sub process_evals {
+    my ($name, $option, $i) = @_;
+
+    my $option_name = "$name\[$i\]";
+    my $ev;
+
+    my $old_option = $option;
+
+    if (defined($evals{$option_name})) {
+	$ev = $evals{$option_name};
+    } elsif (defined($evals{$name})) {
+	$ev = $evals{$name};
+    } else {
+	return $option;
+    }
+
+    for my $e (@{$ev}) {
+	eval "\$option =~ $e";
+    }
+
+    if ($option ne $old_option) {
+	doprint("$name changed from '$old_option' to '$option'\n");
+    }
+
+    return $option;
+}
+
 sub eval_option {
     my ($name, $option, $i) = @_;
 
@@ -1167,28 +1246,9 @@ sub eval_option {
 	$option = __eval_option($name, $option, $i);
     }
 
-    return $option;
-}
-
-sub _logit {
-    if (defined($opt{"LOG_FILE"})) {
-	open(OUT, ">> $opt{LOG_FILE}") or die "Can't write to $opt{LOG_FILE}";
-	print OUT @_;
-	close(OUT);
-    }
-}
-
-sub logit {
-    if (defined($opt{"LOG_FILE"})) {
-	_logit @_;
-    } else {
-	print @_;
-    }
-}
+    $option = process_evals($name, $option, $i);
 
-sub doprint {
-    print @_;
-    _logit @_;
+    return $option;
 }
 
 sub run_command;
-- 
1.8.4.3


