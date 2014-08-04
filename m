Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaHDOXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:23:46 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:22352 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751373AbaHDOXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:23:44 -0400
Date: Mon, 4 Aug 2014 10:23:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] ktest: New and improved config bisect
Message-ID: <20140804102335.18824518@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Note, this was suppose to go into 3.16, but I simply forgot to ask for
you to pull it. :-/ (been in linux-next for too long)

The big change here is the rewrite of config-bisect. The old way never
worked properly as it assumed the bad config was a subset of the good
config, and just found the config that would break the build.

The new way does a diff of the bad config verses the good config and makes
the similar until it finds that one config works and the other does not
and reports the config that makes that difference. The two configs do
not need to be related. It is much more useful now.

Please pull the latest ktest-v3.17 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
ktest-v3.17

Tag SHA1: e1abe4d56eebd88a679f61478845e7079cc90da3
Head SHA1: 4c16b1d6d5e0ca0612de65596a3d1ead8a3372fb


Satoru Takeuchi (2):
      ktest: add 2nd parameter of run_command() to set the redirect target file
      ktest: Some cleanup for improving readability

Steven Rostedt (Red Hat) (5):
      ktest: Rewrite the config-bisect to actually work
      ktest: Put back in the CONFIG_BISECT_CHECK
      ktest: Remove unused functions
      ktest: Add the config bisect manual back
      ktest: Update documentation on config_bisect

----
 tools/testing/ktest/ktest.pl    | 581 +++++++++++++++++++---------------------
 tools/testing/ktest/sample.conf |  65 ++---
 2 files changed, 297 insertions(+), 349 deletions(-)
---------------------------
diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 40631569a0fd..55ab700f6ba5 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -72,7 +72,7 @@ my %default = (
     "IGNORE_UNUSED"		=> 0,
 );
 
-my $ktest_config;
+my $ktest_config = "ktest.conf";
 my $version;
 my $have_version = 0;
 my $machine;
@@ -149,7 +149,6 @@ my $bisect_ret_abort;
 my $bisect_ret_default;
 my $in_patchcheck = 0;
 my $run_test;
-my $redirect;
 my $buildlog;
 my $testlog;
 my $dmesg;
@@ -522,7 +521,7 @@ sub read_ync {
     return read_prompt 1, $prompt;
 }
 
-sub get_ktest_config {
+sub get_mandatory_config {
     my ($config) = @_;
     my $ans;
 
@@ -553,29 +552,29 @@ sub get_ktest_config {
     }
 }
 
-sub get_ktest_configs {
-    get_ktest_config("MACHINE");
-    get_ktest_config("BUILD_DIR");
-    get_ktest_config("OUTPUT_DIR");
+sub get_mandatory_configs {
+    get_mandatory_config("MACHINE");
+    get_mandatory_config("BUILD_DIR");
+    get_mandatory_config("OUTPUT_DIR");
 
     if ($newconfig) {
-	get_ktest_config("BUILD_OPTIONS");
+	get_mandatory_config("BUILD_OPTIONS");
     }
 
     # options required for other than just building a kernel
     if (!$buildonly) {
-	get_ktest_config("POWER_CYCLE");
-	get_ktest_config("CONSOLE");
+	get_mandatory_config("POWER_CYCLE");
+	get_mandatory_config("CONSOLE");
     }
 
     # options required for install and more
     if ($buildonly != 1) {
-	get_ktest_config("SSH_USER");
-	get_ktest_config("BUILD_TARGET");
-	get_ktest_config("TARGET_IMAGE");
+	get_mandatory_config("SSH_USER");
+	get_mandatory_config("BUILD_TARGET");
+	get_mandatory_config("TARGET_IMAGE");
     }
 
-    get_ktest_config("LOCALVERSION");
+    get_mandatory_config("LOCALVERSION");
 
     return if ($buildonly);
 
@@ -583,7 +582,7 @@ sub get_ktest_configs {
 
     if (!defined($rtype)) {
 	if (!defined($opt{"GRUB_MENU"})) {
-	    get_ktest_config("REBOOT_TYPE");
+	    get_mandatory_config("REBOOT_TYPE");
 	    $rtype = $entered_configs{"REBOOT_TYPE"};
 	} else {
 	    $rtype = "grub";
@@ -591,16 +590,16 @@ sub get_ktest_configs {
     }
 
     if ($rtype eq "grub") {
-	get_ktest_config("GRUB_MENU");
+	get_mandatory_config("GRUB_MENU");
     }
 
     if ($rtype eq "grub2") {
-	get_ktest_config("GRUB_MENU");
-	get_ktest_config("GRUB_FILE");
+	get_mandatory_config("GRUB_MENU");
+	get_mandatory_config("GRUB_FILE");
     }
 
     if ($rtype eq "syslinux") {
-	get_ktest_config("SYSLINUX_LABEL");
+	get_mandatory_config("SYSLINUX_LABEL");
     }
 }
 
@@ -1090,7 +1089,7 @@ sub read_config {
     $test_case = __read_config $config, \$test_num;
 
     # make sure we have all mandatory configs
-    get_ktest_configs;
+    get_mandatory_configs;
 
     # was a test specified?
     if (!$test_case) {
@@ -1529,7 +1528,7 @@ sub fail {
 }
 
 sub run_command {
-    my ($command) = @_;
+    my ($command, $redirect) = @_;
     my $dolog = 0;
     my $dord = 0;
     my $pid;
@@ -2265,9 +2264,7 @@ sub build {
     # Run old config regardless, to enforce min configurations
     make_oldconfig;
 
-    $redirect = "$buildlog";
-    my $build_ret = run_command "$make $build_options";
-    undef $redirect;
+    my $build_ret = run_command "$make $build_options", $buildlog;
 
     if (defined($post_build)) {
 	# Because a post build may change the kernel version
@@ -2360,9 +2357,7 @@ sub child_run_test {
     $poweroff_on_error = 0;
     $die_on_failure = 1;
 
-    $redirect = "$testlog";
-    run_command $run_test or $failed = 1;
-    undef $redirect;
+    run_command $run_test, $testlog or $failed = 1;
 
     exit $failed;
 }
@@ -2789,12 +2784,17 @@ my %dependency;
 sub assign_configs {
     my ($hash, $config) = @_;
 
+    doprint "Reading configs from $config\n";
+
     open (IN, $config)
 	or dodie "Failed to read $config";
 
     while (<IN>) {
+	chomp;
 	if (/^((CONFIG\S*)=.*)/) {
 	    ${$hash}{$2} = $1;
+	} elsif (/^(# (CONFIG\S*) is not set)/) {
+	    ${$hash}{$2} = $1;
 	}
     }
 
@@ -2807,27 +2807,6 @@ sub process_config_ignore {
     assign_configs \%config_ignore, $config;
 }
 
-sub read_current_config {
-    my ($config_ref) = @_;
-
-    %{$config_ref} = ();
-    undef %{$config_ref};
-
-    my @key = keys %{$config_ref};
-    if ($#key >= 0) {
-	print "did not delete!\n";
-	exit;
-    }
-    open (IN, "$output_config");
-
-    while (<IN>) {
-	if (/^(CONFIG\S+)=(.*)/) {
-	    ${$config_ref}{$1} = $2;
-	}
-    }
-    close(IN);
-}
-
 sub get_dependencies {
     my ($config) = @_;
 
@@ -2846,53 +2825,97 @@ sub get_dependencies {
     return @deps;
 }
 
+sub save_config {
+    my ($pc, $file) = @_;
+
+    my %configs = %{$pc};
+
+    doprint "Saving configs into $file\n";
+
+    open(OUT, ">$file") or dodie "Can not write to $file";
+
+    foreach my $config (keys %configs) {
+	print OUT "$configs{$config}\n";
+    }
+    close(OUT);
+}
+
 sub create_config {
-    my @configs = @_;
+    my ($name, $pc) = @_;
 
-    open(OUT, ">$output_config") or dodie "Can not write to $output_config";
+    doprint "Creating old config from $name configs\n";
 
-    foreach my $config (@configs) {
-	print OUT "$config_set{$config}\n";
-	my @deps = get_dependencies $config;
-	foreach my $dep (@deps) {
-	    print OUT "$config_set{$dep}\n";
+    save_config $pc, $output_config;
+
+    make_oldconfig;
+}
+
+# compare two config hashes, and return configs with different vals.
+# It returns B's config values, but you can use A to see what A was.
+sub diff_config_vals {
+    my ($pa, $pb) = @_;
+
+    # crappy Perl way to pass in hashes.
+    my %a = %{$pa};
+    my %b = %{$pb};
+
+    my %ret;
+
+    foreach my $item (keys %a) {
+	if (defined($b{$item}) && $b{$item} ne $a{$item}) {
+	    $ret{$item} = $b{$item};
 	}
     }
 
-    # turn off configs to keep off
-    foreach my $config (keys %config_off) {
-	print OUT "# $config is not set\n";
-    }
+    return %ret;
+}
 
-    # turn off configs that should be off for now
-    foreach my $config (@config_off_tmp) {
-	print OUT "# $config is not set\n";
-    }
+# compare two config hashes and return the configs in B but not A
+sub diff_configs {
+    my ($pa, $pb) = @_;
+
+    my %ret;
+
+    # crappy Perl way to pass in hashes.
+    my %a = %{$pa};
+    my %b = %{$pb};
 
-    foreach my $config (keys %config_ignore) {
-	print OUT "$config_ignore{$config}\n";
+    foreach my $item (keys %b) {
+	if (!defined($a{$item})) {
+	    $ret{$item} = $b{$item};
+	}
     }
-    close(OUT);
 
-    make_oldconfig;
+    return %ret;
 }
 
+# return if two configs are equal or not
+# 0 is equal +1 b has something a does not
+# +1 if a and b have a different item.
+# -1 if a has something b does not
 sub compare_configs {
-    my (%a, %b) = @_;
+    my ($pa, $pb) = @_;
 
-    foreach my $item (keys %a) {
-	if (!defined($b{$item})) {
-	    print "diff $item\n";
+    my %ret;
+
+    # crappy Perl way to pass in hashes.
+    my %a = %{$pa};
+    my %b = %{$pb};
+
+    foreach my $item (keys %b) {
+	if (!defined($a{$item})) {
+	    return 1;
+	}
+	if ($a{$item} ne $b{$item}) {
 	    return 1;
 	}
-	delete $b{$item};
     }
 
-    my @keys = keys %b;
-    if ($#keys) {
-	print "diff2 $keys[0]\n";
+    foreach my $item (keys %a) {
+	if (!defined($b{$item})) {
+	    return -1;
+	}
     }
-    return -1 if ($#keys >= 0);
 
     return 0;
 }
@@ -2900,24 +2923,13 @@ sub compare_configs {
 sub run_config_bisect_test {
     my ($type) = @_;
 
-    return run_bisect_test $type, "oldconfig";
-}
+    my $ret = run_bisect_test $type, "oldconfig";
 
-sub process_passed {
-    my (%configs) = @_;
-
-    doprint "These configs had no failure: (Enabling them for further compiles)\n";
-    # Passed! All these configs are part of a good compile.
-    # Add them to the min options.
-    foreach my $config (keys %configs) {
-	if (defined($config_list{$config})) {
-	    doprint " removing $config\n";
-	    $config_ignore{$config} = $config_list{$config};
-	    delete $config_list{$config};
-	}
+    if ($bisect_manual) {
+	$ret = answer_bisect;
     }
-    doprint "config copied to $outputdir/config_good\n";
-    run_command "cp -f $output_config $outputdir/config_good";
+
+    return $ret;
 }
 
 sub process_failed {
@@ -2928,253 +2940,225 @@ sub process_failed {
     doprint "***************************************\n\n";
 }
 
-sub run_config_bisect {
+# used for config bisecting
+my $good_config;
+my $bad_config;
 
-    my @start_list = keys %config_list;
+sub process_new_config {
+    my ($tc, $nc, $gc, $bc) = @_;
 
-    if ($#start_list < 0) {
-	doprint "No more configs to test!!!\n";
-	return -1;
+    my %tmp_config = %{$tc};
+    my %good_configs = %{$gc};
+    my %bad_configs = %{$bc};
+
+    my %new_configs;
+
+    my $runtest = 1;
+    my $ret;
+
+    create_config "tmp_configs", \%tmp_config;
+    assign_configs \%new_configs, $output_config;
+
+    $ret = compare_configs \%new_configs, \%bad_configs;
+    if (!$ret) {
+	doprint "New config equals bad config, try next test\n";
+	$runtest = 0;
+    }
+
+    if ($runtest) {
+	$ret = compare_configs \%new_configs, \%good_configs;
+	if (!$ret) {
+	    doprint "New config equals good config, try next test\n";
+	    $runtest = 0;
+	}
     }
 
-    doprint "***** RUN TEST ***\n";
+    %{$nc} = %new_configs;
+
+    return $runtest;
+}
+
+sub run_config_bisect {
+    my ($pgood, $pbad) = @_;
+
     my $type = $config_bisect_type;
+
+    my %good_configs = %{$pgood};
+    my %bad_configs = %{$pbad};
+
+    my %diff_configs = diff_config_vals \%good_configs, \%bad_configs;
+    my %b_configs = diff_configs \%good_configs, \%bad_configs;
+    my %g_configs = diff_configs \%bad_configs, \%good_configs;
+
+    my @diff_arr = keys %diff_configs;
+    my $len_diff = $#diff_arr + 1;
+
+    my @b_arr = keys %b_configs;
+    my $len_b = $#b_arr + 1;
+
+    my @g_arr = keys %g_configs;
+    my $len_g = $#g_arr + 1;
+
+    my $runtest = 1;
+    my %new_configs;
     my $ret;
-    my %current_config;
 
-    my $count = $#start_list + 1;
-    doprint "  $count configs to test\n";
+    # First, lets get it down to a single subset.
+    # Is the problem with a difference in values?
+    # Is the problem with a missing config?
+    # Is the problem with a config that breaks things?
 
-    my $half = int($#start_list / 2);
+    # Enable all of one set and see if we get a new bad
+    # or good config.
 
-    do {
-	my @tophalf = @start_list[0 .. $half];
+    # first set the good config to the bad values.
 
-	# keep the bottom half off
-	if ($half < $#start_list) {
-	    @config_off_tmp = @start_list[$half + 1 .. $#start_list];
-	} else {
-	    @config_off_tmp = ();
-	}
+    doprint "d=$len_diff g=$len_g b=$len_b\n";
 
-	create_config @tophalf;
-	read_current_config \%current_config;
-
-	$count = $#tophalf + 1;
-	doprint "Testing $count configs\n";
-	my $found = 0;
-	# make sure we test something
-	foreach my $config (@tophalf) {
-	    if (defined($current_config{$config})) {
-		logit " $config\n";
-		$found = 1;
-	    }
-	}
-	if (!$found) {
-	    # try the other half
-	    doprint "Top half produced no set configs, trying bottom half\n";
-
-	    # keep the top half off
-	    @config_off_tmp = @tophalf;
-	    @tophalf = @start_list[$half + 1 .. $#start_list];
-
-	    create_config @tophalf;
-	    read_current_config \%current_config;
-	    foreach my $config (@tophalf) {
-		if (defined($current_config{$config})) {
-		    logit " $config\n";
-		    $found = 1;
-		}
-	    }
-	    if (!$found) {
-		doprint "Failed: Can't make new config with current configs\n";
-		foreach my $config (@start_list) {
-		    doprint "  CONFIG: $config\n";
-		}
-		return -1;
+    # first lets enable things in bad config that are enabled in good config
+
+    if ($len_diff > 0) {
+	if ($len_b > 0 || $len_g > 0) {
+	    my %tmp_config = %bad_configs;
+
+	    doprint "Set tmp config to be bad config with good config values\n";
+	    foreach my $item (@diff_arr) {
+		$tmp_config{$item} = $good_configs{$item};
 	    }
-	    $count = $#tophalf + 1;
-	    doprint "Testing $count configs\n";
-	}
 
-	$ret = run_config_bisect_test $type;
-	if ($bisect_manual) {
-	    $ret = answer_bisect;
-	}
-	if ($ret) {
-	    process_passed %current_config;
-	    return 0;
+	    $runtest = process_new_config \%tmp_config, \%new_configs,
+			    \%good_configs, \%bad_configs;
 	}
+    }
 
-	doprint "This config had a failure.\n";
-	doprint "Removing these configs that were not set in this config:\n";
-	doprint "config copied to $outputdir/config_bad\n";
-	run_command "cp -f $output_config $outputdir/config_bad";
+    if (!$runtest && $len_diff > 0) {
 
-	# A config exists in this group that was bad.
-	foreach my $config (keys %config_list) {
-	    if (!defined($current_config{$config})) {
-		doprint " removing $config\n";
-		delete $config_list{$config};
-	    }
+	if ($len_diff == 1) {
+	    process_failed $diff_arr[0];
+	    return 1;
 	}
+	my %tmp_config = %bad_configs;
 
-	@start_list = @tophalf;
+	my $half = int($#diff_arr / 2);
+	my @tophalf = @diff_arr[0 .. $half];
 
-	if ($#start_list == 0) {
-	    process_failed $start_list[0];
-	    return 1;
+	doprint "Settings bisect with top half:\n";
+	doprint "Set tmp config to be bad config with some good config values\n";
+	foreach my $item (@tophalf) {
+	    $tmp_config{$item} = $good_configs{$item};
 	}
 
-	# remove half the configs we are looking at and see if
-	# they are good.
-	$half = int($#start_list / 2);
-    } while ($#start_list > 0);
+	$runtest = process_new_config \%tmp_config, \%new_configs,
+			    \%good_configs, \%bad_configs;
 
-    # we found a single config, try it again unless we are running manually
+	if (!$runtest) {
+	    my %tmp_config = %bad_configs;
 
-    if ($bisect_manual) {
-	process_failed $start_list[0];
-	return 1;
-    }
+	    doprint "Try bottom half\n";
 
-    my @tophalf = @start_list[0 .. 0];
+	    my @bottomhalf = @diff_arr[$half+1 .. $#diff_arr];
 
-    $ret = run_config_bisect_test $type;
-    if ($ret) {
-	process_passed %current_config;
+	    foreach my $item (@bottomhalf) {
+		$tmp_config{$item} = $good_configs{$item};
+	    }
+
+	    $runtest = process_new_config \%tmp_config, \%new_configs,
+			    \%good_configs, \%bad_configs;
+	}
+    }
+
+    if ($runtest) {
+	$ret = run_config_bisect_test $type;
+	if ($ret) {
+	    doprint "NEW GOOD CONFIG\n";
+	    %good_configs = %new_configs;
+	    run_command "mv $good_config ${good_config}.last";
+	    save_config \%good_configs, $good_config;
+	    %{$pgood} = %good_configs;
+	} else {
+	    doprint "NEW BAD CONFIG\n";
+	    %bad_configs = %new_configs;
+	    run_command "mv $bad_config ${bad_config}.last";
+	    save_config \%bad_configs, $bad_config;
+	    %{$pbad} = %bad_configs;
+	}
 	return 0;
     }
 
-    process_failed $start_list[0];
-    return 1;
+    fail "Hmm, need to do a mix match?\n";
+    return -1;
 }
 
 sub config_bisect {
     my ($i) = @_;
 
-    my $start_config = $config_bisect;
+    my $type = $config_bisect_type;
+    my $ret;
 
-    my $tmpconfig = "$tmpdir/use_config";
+    $bad_config = $config_bisect;
 
     if (defined($config_bisect_good)) {
-	process_config_ignore $config_bisect_good;
-    }
-
-    # Make the file with the bad config and the min config
-    if (defined($minconfig)) {
-	# read the min config for things to ignore
-	run_command "cp $minconfig $tmpconfig" or
-	    dodie "failed to copy $minconfig to $tmpconfig";
+	$good_config = $config_bisect_good;
+    } elsif (defined($minconfig)) {
+	$good_config = $minconfig;
     } else {
-	unlink $tmpconfig;
-    }
-
-    if (-f $tmpconfig) {
-	load_force_config($tmpconfig);
-	process_config_ignore $tmpconfig;
-    }
-
-    # now process the start config
-    run_command "cp $start_config $output_config" or
-	dodie "failed to copy $start_config to $output_config";
-
-    # read directly what we want to check
-    my %config_check;
-    open (IN, $output_config)
-	or dodie "failed to open $output_config";
-
-    while (<IN>) {
-	if (/^((CONFIG\S*)=.*)/) {
-	    $config_check{$2} = $1;
+	doprint "No config specified, checking if defconfig works";
+	$ret = run_bisect_test $type, "defconfig";
+	if (!$ret) {
+	    fail "Have no good config to compare with, please set CONFIG_BISECT_GOOD";
+	    return 1;
 	}
+	$good_config = $output_config;
     }
-    close(IN);
 
-    # Now run oldconfig with the minconfig
-    make_oldconfig;
+    # we don't want min configs to cause issues here.
+    doprint "Disabling 'MIN_CONFIG' for this test\n";
+    undef $minconfig;
 
-    # check to see what we lost (or gained)
-    open (IN, $output_config)
-	or dodie "Failed to read $start_config";
+    my %good_configs;
+    my %bad_configs;
+    my %tmp_configs;
 
-    my %removed_configs;
-    my %added_configs;
+    doprint "Run good configs through make oldconfig\n";
+    assign_configs \%tmp_configs, $good_config;
+    create_config "$good_config", \%tmp_configs;
+    assign_configs \%good_configs, $output_config;
 
-    while (<IN>) {
-	if (/^((CONFIG\S*)=.*)/) {
-	    # save off all options
-	    $config_set{$2} = $1;
-	    if (defined($config_check{$2})) {
-		if (defined($config_ignore{$2})) {
-		    $removed_configs{$2} = $1;
-		} else {
-		    $config_list{$2} = $1;
-		}
-	    } elsif (!defined($config_ignore{$2})) {
-		$added_configs{$2} = $1;
-		$config_list{$2} = $1;
-	    }
-	} elsif (/^# ((CONFIG\S*).*)/) {
-	    # Keep these configs disabled
-	    $config_set{$2} = $1;
-	    $config_off{$2} = $1;
-	}
-    }
-    close(IN);
+    doprint "Run bad configs through make oldconfig\n";
+    assign_configs \%tmp_configs, $bad_config;
+    create_config "$bad_config", \%tmp_configs;
+    assign_configs \%bad_configs, $output_config;
 
-    my @confs = keys %removed_configs;
-    if ($#confs >= 0) {
-	doprint "Configs overridden by default configs and removed from check:\n";
-	foreach my $config (@confs) {
-	    doprint " $config\n";
-	}
-    }
-    @confs = keys %added_configs;
-    if ($#confs >= 0) {
-	doprint "Configs appearing in make oldconfig and added:\n";
-	foreach my $config (@confs) {
-	    doprint " $config\n";
-	}
-    }
+    $good_config = "$tmpdir/good_config";
+    $bad_config = "$tmpdir/bad_config";
+
+    save_config \%good_configs, $good_config;
+    save_config \%bad_configs, $bad_config;
 
-    my %config_test;
-    my $once = 0;
 
-    @config_off_tmp = ();
+    if (defined($config_bisect_check) && $config_bisect_check ne "0") {
+	if ($config_bisect_check ne "good") {
+	    doprint "Testing bad config\n";
 
-    # Sometimes kconfig does weird things. We must make sure
-    # that the config we autocreate has everything we need
-    # to test, otherwise we may miss testing configs, or
-    # may not be able to create a new config.
-    # Here we create a config with everything set.
-    create_config (keys %config_list);
-    read_current_config \%config_test;
-    foreach my $config (keys %config_list) {
-	if (!defined($config_test{$config})) {
-	    if (!$once) {
-		$once = 1;
-		doprint "Configs not produced by kconfig (will not be checked):\n";
+	    $ret = run_bisect_test $type, "useconfig:$bad_config";
+	    if ($ret) {
+		fail "Bad config succeeded when expected to fail!";
+		return 0;
 	    }
-	    doprint "  $config\n";
-	    delete $config_list{$config};
 	}
-    }
-    my $ret;
+	if ($config_bisect_check ne "bad") {
+	    doprint "Testing good config\n";
 
-    if (defined($config_bisect_check) && $config_bisect_check) {
-	doprint " Checking to make sure bad config with min config fails\n";
-	create_config keys %config_list;
-	$ret = run_config_bisect_test $config_bisect_type;
-	if ($ret) {
-	    doprint " FAILED! Bad config with min config boots fine\n";
-	    return -1;
+	    $ret = run_bisect_test $type, "useconfig:$good_config";
+	    if (!$ret) {
+		fail "Good config failed when expected to succeed!";
+		return 0;
+	    }
 	}
-	doprint " Bad config with min config fails as expected\n";
     }
 
     do {
-	$ret = run_config_bisect;
+	$ret = run_config_bisect \%good_configs, \%bad_configs;
     } while (!$ret);
 
     return $ret if ($ret < 0);
@@ -3455,29 +3439,6 @@ sub read_depends {
     read_kconfig($kconfig);
 }
 
-sub read_config_list {
-    my ($config) = @_;
-
-    open (IN, $config)
-	or dodie "Failed to read $config";
-
-    while (<IN>) {
-	if (/^((CONFIG\S*)=.*)/) {
-	    if (!defined($config_ignore{$2})) {
-		$config_list{$2} = $1;
-	    }
-	}
-    }
-
-    close(IN);
-}
-
-sub read_output_config {
-    my ($config) = @_;
-
-    assign_configs \%config_ignore, $config;
-}
-
 sub make_new_config {
     my @configs = @_;
 
@@ -3863,7 +3824,7 @@ sub make_warnings_file {
     success $i;
 }
 
-$#ARGV < 1 or die "ktest.pl version: $VERSION\n   usage: ktest.pl config-file\n";
+$#ARGV < 1 or die "ktest.pl version: $VERSION\n   usage: ktest.pl [config-file]\n";
 
 if ($#ARGV == 0) {
     $ktest_config = $ARGV[0];
@@ -3873,8 +3834,6 @@ if ($#ARGV == 0) {
 	    exit 0;
 	}
     }
-} else {
-    $ktest_config = "ktest.conf";
 }
 
 if (! -f $ktest_config) {
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index 172eec4517fb..911e45ad657a 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -1098,49 +1098,35 @@
 #
 #  The way it works is this:
 #
-#   First it finds a config to work with. Since a different version, or
-#   MIN_CONFIG may cause different dependecies, it must run through this
-#   preparation.
+#   You can specify a good config with CONFIG_BISECT_GOOD, otherwise it
+#   will use the MIN_CONFIG, and if that's not specified, it will use
+#   the config that comes with "make defconfig".
 #
-#   Overwrites any config set in the bad config with a config set in
-#   either the MIN_CONFIG or ADD_CONFIG. Thus, make sure these configs
-#   are minimal and do not disable configs you want to test:
-#   (ie.  # CONFIG_FOO is not set).
+#   It runs both the good and bad configs through a make oldconfig to
+#   make sure that they are set up for the kernel that is checked out.
 #
-#   An oldconfig is run on the bad config and any new config that
-#   appears will be added to the configs to test.
+#   It then reads the configs that are set, as well as the ones that are
+#   not set for both the good and bad configs, and then compares them.
+#   It will set half of the good configs within the bad config (note,
+#   "set" means to make the bad config match the good config, a config
+#   in the good config that is off, will be turned off in the bad
+#   config. That is considered a "set").
 #
-#   Finally, it generates a config with the above result and runs it
-#   again through make oldconfig to produce a config that should be
-#   satisfied by kconfig.
+#   It tests this new config and if it works, it becomes the new good
+#   config, otherwise it becomes the new bad config. It continues this
+#   process until there's only one config left and it will report that
+#   config.
 #
-#   Then it starts the bisect.
+#   The "bad config" can also be a config that is needed to boot but was
+#   disabled because it depended on something that wasn't set.
 #
-#   The configs to test are cut in half. If all the configs in this
-#   half depend on a config in the other half, then the other half
-#   is tested instead. If no configs are enabled by either half, then
-#   this means a circular dependency exists and the test fails.
+#   During this process, it saves the current good and bad configs in
+#   ${TMP_DIR}/good_config and ${TMP_DIR}/bad_config respectively.
+#   If you stop the test, you can copy them to a new location to
+#   reuse them again.
 #
-#   A config is created with the test half, and the bisect test is run.
-#
-#   If the bisect succeeds, then all configs in the generated config
-#   are removed from the configs to test and added to the configs that
-#   will be enabled for all builds (they will be enabled, but not be part
-#   of the configs to examine).
-#
-#   If the bisect fails, then all test configs that were not enabled by
-#   the config file are removed from the test. These configs will not
-#   be enabled in future tests. Since current config failed, we consider
-#   this to be a subset of the config that we started with.
-#
-#   When we are down to one config, it is considered the bad config.
-#
-#   Note, the config chosen may not be the true bad config. Due to
-#   dependencies and selections of the kbuild system, mulitple
-#   configs may be needed to cause a failure. If you disable the
-#   config that was found and restart the test, if the test fails
-#   again, it is recommended to rerun the config_bisect with a new
-#   bad config without the found config enabled.
+#   Although the MIN_CONFIG may be the config it starts with, the
+#   MIN_CONFIG is ignored.
 #
 #  The option BUILD_TYPE will be ignored.
 #
@@ -1160,13 +1146,16 @@
 # CONFIG_BISECT_GOOD (optional)
 #  If you have a good config to start with, then you
 #  can specify it with CONFIG_BISECT_GOOD. Otherwise
-#  the MIN_CONFIG is the base.
+#  the MIN_CONFIG is the base, if MIN_CONFIG is not set
+#  It will build a config with "make defconfig"
 #
 # CONFIG_BISECT_CHECK (optional)
 #  Set this to 1 if you want to confirm that the config ktest
 #  generates (the bad config with the min config) is still bad.
 #  It may be that the min config fixes what broke the bad config
 #  and the test will not return a result.
+#  Set it to "good" to test only the good config and set it
+#  to "bad" to only test the bad config.
 #
 # Example:
 #   TEST_START
