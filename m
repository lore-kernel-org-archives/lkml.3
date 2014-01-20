Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbaATPrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 10:47:35 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:10398 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751898AbaATPrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:47:33 -0500
Date: Mon, 20 Jan 2014 10:47:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] ktest: New features
Message-ID: <20140120104731.391271f7@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Note, I just realized that I did not base this branch on any specific
SHA1 (like a release). I must have updated the branch and forgot about
it before doing development on it. But this has been in linux-next for
a bit, and I understand that it is looked down upon to rebase this late
in the game. Sorry for the inconvenience, and I'll try to make sure
that doesn't happen again.

This code was based on:

  commit 5a5a1bf099d6942399ea0b34a62e5f0bc4c5c36e
  Merge: 74c7d2f 5379f8c
  Author: Linus Torvalds <torvalds@linux-foundation.org>
  Date:   Tue Apr 30 08:42:45 2013 -0700

    Merge branch 'x86-ras-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip


Here's some basic updates to ktest.pl. They include:

 o Add config to modify the signal to terminate console
 o Update to documentation (missing some config options)
 o Add KERNEL_VERSION variable to use for other configs
 o Add '=~' to let configs eval other configs
 o Add BISECT_TRIES to run multiple tests per git bisect good

Please pull the latest ktest-v3.14 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
ktest-v3.14

Tag SHA1: 9d6294375197af259de0afe574a4e9faf34a1cc1
Head SHA1: 961d9caceea2d5350a15c17b7d3ffc24c08c9b09


Satoru Takeuchi (1):
      ktest: Make the signal to terminate the console configurable

Steven Rostedt (Red Hat) (4):
      ktest: Add documentation of CLOSE_CONSOLE_SIGNAL
      ktest: Add special variable ${KERNEL_VERSION}
      ktest: Add eval '=~' command to modify variables in config file
      ktest: Add BISECT_TRIES to bisect test

----
 tools/testing/ktest/ktest.pl    | 158
++++++++++++++++++++++++++++++++--------
tools/testing/ktest/sample.conf |  21 ++++++ 2 files changed, 147
insertions(+), 32 deletions(-) ---------------------------
diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 0d7fd8b..a511d4a 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -18,6 +18,7 @@ $| = 1;
 my %opt;
 my %repeat_tests;
 my %repeats;
+my %evals;
 
 #default opts
 my %default = (
@@ -25,6 +26,7 @@ my %default = (
     "TEST_TYPE"			=> "build",
     "BUILD_TYPE"		=> "randconfig",
     "MAKE_CMD"			=> "make",
+    "CLOSE_CONSOLE_SIGNAL"	=> "INT",
     "TIMEOUT"			=> 120,
     "TMP_DIR"			=> "/tmp/ktest/\${MACHINE}",
     "SLEEP_TIME"		=> 60,	# sleep time between
tests @@ -39,6 +41,7 @@ my %default = (
     "CLEAR_LOG"			=> 0,
     "BISECT_MANUAL"		=> 0,
     "BISECT_SKIP"		=> 1,
+    "BISECT_TRIES"		=> 1,
     "MIN_CONFIG_TYPE"		=> "boot",
     "SUCCESS_LINE"		=> "login:",
     "DETECT_TRIPLE_FAULT"	=> 1,
@@ -137,6 +140,7 @@ my $bisect_bad_commit = "";
 my $reverse_bisect;
 my $bisect_manual;
 my $bisect_skip;
+my $bisect_tries;
 my $config_bisect_good;
 my $bisect_ret_good;
 my $bisect_ret_bad;
@@ -163,6 +167,7 @@ my $timeout;
 my $booted_timeout;
 my $detect_triplefault;
 my $console;
+my $close_console_signal;
 my $reboot_success_line;
 my $success_line;
 my $stop_after_success;
@@ -273,6 +278,7 @@ my %option_map = (
     "IGNORE_ERRORS"		=> \$ignore_errors,
     "BISECT_MANUAL"		=> \$bisect_manual,
     "BISECT_SKIP"		=> \$bisect_skip,
+    "BISECT_TRIES"		=> \$bisect_tries,
     "CONFIG_BISECT_GOOD"	=> \$config_bisect_good,
     "BISECT_RET_GOOD"		=> \$bisect_ret_good,
     "BISECT_RET_BAD"		=> \$bisect_ret_bad,
@@ -285,6 +291,7 @@ my %option_map = (
     "TIMEOUT"			=> \$timeout,
     "BOOTED_TIMEOUT"		=> \$booted_timeout,
     "CONSOLE"			=> \$console,
+    "CLOSE_CONSOLE_SIGNAL"	=> \$close_console_signal,
     "DETECT_TRIPLE_FAULT"	=> \$detect_triplefault,
     "SUCCESS_LINE"		=> \$success_line,
     "REBOOT_SUCCESS_LINE"	=> \$reboot_success_line,
@@ -445,6 +452,27 @@ $config_help{"REBOOT_SCRIPT"} = << "EOF"
 EOF
     ;
 
+sub _logit {
+    if (defined($opt{"LOG_FILE"})) {
+	open(OUT, ">> $opt{LOG_FILE}") or die "Can't write to
$opt{LOG_FILE}";
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
 
@@ -662,6 +690,22 @@ sub set_value {
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
 
@@ -947,6 +991,20 @@ sub __read_config {
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
@@ -1126,6 +1184,10 @@ sub __eval_option {
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
@@ -1140,6 +1202,33 @@ sub __eval_option {
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
 
@@ -1160,28 +1249,9 @@ sub eval_option {
 	$option = __eval_option($name, $option, $i);
     }
 
-    return $option;
-}
+    $option = process_evals($name, $option, $i);
 
-sub _logit {
-    if (defined($opt{"LOG_FILE"})) {
-	open(OUT, ">> $opt{LOG_FILE}") or die "Can't write to
$opt{LOG_FILE}";
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
-
-sub doprint {
-    print @_;
-    _logit @_;
+    return $option;
 }
 
 sub run_command;
@@ -1296,7 +1366,7 @@ sub close_console {
     my ($fp, $pid) = @_;
 
     doprint "kill child process $pid\n";
-    kill 2, $pid;
+    kill $close_console_signal, $pid;
 
     print "closing!\n";
     close($fp);
@@ -2517,12 +2587,29 @@ sub run_bisect {
 	$buildtype = "useconfig:$minconfig";
     }
 
-    my $ret = run_bisect_test $type, $buildtype;
+    # If the user sets bisect_tries to less than 1, then no tries
+    # is a success.
+    my $ret = 1;
 
-    if ($bisect_manual) {
+    # Still let the user manually decide that though.
+    if ($bisect_tries < 1 && $bisect_manual) {
 	$ret = answer_bisect;
     }
 
+    for (my $i = 0; $i < $bisect_tries; $i++) {
+	if ($bisect_tries > 1) {
+	    my $t = $i + 1;
+	    doprint("Running bisect trial $t of $bisect_tries:\n");
+	}
+	$ret = run_bisect_test $type, $buildtype;
+
+	if ($bisect_manual) {
+	    $ret = answer_bisect;
+	}
+
+	last if (!$ret);
+    }
+
     # Are we looking for where it worked, not failed?
     if ($reverse_bisect && $ret >= 0) {
 	$ret = !$ret;
@@ -3916,6 +4003,18 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
 
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
@@ -3940,13 +4039,9 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
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
@@ -3955,7 +4050,6 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     $buildlog = "$tmpdir/buildlog-$machine";
     $testlog = "$tmpdir/testlog-$machine";
     $dmesg = "$tmpdir/dmesg-$machine";
-    $make = "$makecmd O=$outputdir";
     $output_config = "$outputdir/.config";
 
     if (!$buildonly) {
diff --git a/tools/testing/ktest/sample.conf
b/tools/testing/ktest/sample.conf index 0a290fb..172eec4 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -328,6 +328,13 @@
 # For a virtual machine with guest name "Guest".
 #CONSOLE =  virsh console Guest
 
+# Signal to send to kill console.
+# ktest.pl will create a child process to monitor the console.
+# When the console is finished, ktest will kill the child process
+# with this signal.
+# (default INT)
+#CLOSE_CONSOLE_SIGNAL = HUP
+
 # Required version ending to differentiate the test
 # from other linux builds on the system.
 #LOCALVERSION = -test
@@ -1021,6 +1028,20 @@
 #   BISECT_BAD with BISECT_CHECK = good or
 #   BISECT_CHECK = bad, respectively.
 #
+# BISECT_TRIES = 5 (optional, default 1)
+#
+#   For those cases that it takes several tries to hit a bug,
+#   the BISECT_TRIES is useful. It is the number of times the
+#   test is ran before it says the kernel is good. The first failure
+#   will stop trying and mark the current SHA1 as bad.
+#
+#   Note, as with all race bugs, there's no guarantee that if
+#   it succeeds, it is really a good bisect. But it helps in case
+#   the bug is some what reliable.
+#
+#   You can set BISECT_TRIES to zero, and all tests will be considered
+#   good, unless you also set BISECT_MANUAL.
+#
 # BISECT_RET_GOOD = 0 (optional, default undefined)
 #
 #   In case the specificed test returns something other than just
