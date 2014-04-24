Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbaDXQLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:11:38 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:34118 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758551AbaDXQIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:08:52 -0400
Message-Id: <20140424160850.754070793@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 24 Apr 2014 12:06:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 3/7] ktest: Rewrite the config-bisect to actually work
References: <20140424160626.491010573@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-ktest-Rewrite-the-config-bisect-to-actually-work.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

I never liked the way config-bisect worked. I would assume the bad config
had some config that broke the system. But it would not work if the bad
config just happened to be missing something that the good config had.

I rewrote the config-bisect to do this properly. It does a diff of the two
configs, and sets half of the configs that are in one and not the other.
The way it works is that when it "sets", it really just makes one copy
what the other has. That is, a "set" can be setting a:

  # CONFIG_FOO is not set

Basically, it looks at the differences between the two files and makes
them similar until it comes down to one config that makes it work or
not work depending on if it is set or not.

Note, if more than one config change makes the bad config not work, it
will only find one of them. But this is true with all bisect logic.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl | 452 +++++++++++++++++++++----------------------
 1 file changed, 226 insertions(+), 226 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index c34f0de..52f558e 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2784,12 +2784,17 @@ my %dependency;
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
 
@@ -2841,53 +2846,97 @@ sub get_dependencies {
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
@@ -2923,253 +2972,204 @@ sub process_failed {
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
-    }
+    my %tmp_config = %{$tc};
+    my %good_configs = %{$gc};
+    my %bad_configs = %{$bc};
 
-    doprint "***** RUN TEST ***\n";
-    my $type = $config_bisect_type;
-    my $ret;
-    my %current_config;
+    my %new_configs;
 
-    my $count = $#start_list + 1;
-    doprint "  $count configs to test\n";
+    my $runtest = 1;
+    my $ret;
 
-    my $half = int($#start_list / 2);
+    create_config "tmp_configs", \%tmp_config;
+    assign_configs \%new_configs, $output_config;
 
-    do {
-	my @tophalf = @start_list[0 .. $half];
+    $ret = compare_configs \%new_configs, \%bad_configs;
+    if (!$ret) {
+	doprint "New config equals bad config, try next test\n";
+	$runtest = 0;
+    }
 
-	# keep the bottom half off
-	if ($half < $#start_list) {
-	    @config_off_tmp = @start_list[$half + 1 .. $#start_list];
-	} else {
-	    @config_off_tmp = ();
+    if ($runtest) {
+	$ret = compare_configs \%new_configs, \%good_configs;
+	if (!$ret) {
+	    doprint "New config equals good config, try next test\n";
+	    $runtest = 0;
 	}
+    }
 
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
-	    }
-	    $count = $#tophalf + 1;
-	    doprint "Testing $count configs\n";
-	}
+    %{$nc} = %new_configs;
 
-	$ret = run_config_bisect_test $type;
-	if ($bisect_manual) {
-	    $ret = answer_bisect;
-	}
-	if ($ret) {
-	    process_passed %current_config;
-	    return 0;
-	}
+    return $runtest;
+}
 
-	doprint "This config had a failure.\n";
-	doprint "Removing these configs that were not set in this config:\n";
-	doprint "config copied to $outputdir/config_bad\n";
-	run_command "cp -f $output_config $outputdir/config_bad";
+sub run_config_bisect {
+    my ($pgood, $pbad) = @_;
 
-	# A config exists in this group that was bad.
-	foreach my $config (keys %config_list) {
-	    if (!defined($current_config{$config})) {
-		doprint " removing $config\n";
-		delete $config_list{$config};
-	    }
-	}
+    my $type = $config_bisect_type;
 
-	@start_list = @tophalf;
+    my %good_configs = %{$pgood};
+    my %bad_configs = %{$pbad};
 
-	if ($#start_list == 0) {
-	    process_failed $start_list[0];
-	    return 1;
-	}
+    my %diff_configs = diff_config_vals \%good_configs, \%bad_configs;
+    my %b_configs = diff_configs \%good_configs, \%bad_configs;
+    my %g_configs = diff_configs \%bad_configs, \%good_configs;
 
-	# remove half the configs we are looking at and see if
-	# they are good.
-	$half = int($#start_list / 2);
-    } while ($#start_list > 0);
+    my @diff_arr = keys %diff_configs;
+    my $len_diff = $#diff_arr + 1;
 
-    # we found a single config, try it again unless we are running manually
+    my @b_arr = keys %b_configs;
+    my $len_b = $#b_arr + 1;
 
-    if ($bisect_manual) {
-	process_failed $start_list[0];
-	return 1;
-    }
+    my @g_arr = keys %g_configs;
+    my $len_g = $#g_arr + 1;
 
-    my @tophalf = @start_list[0 .. 0];
+    my $runtest = 1;
+    my %new_configs;
+    my $ret;
 
-    $ret = run_config_bisect_test $type;
-    if ($ret) {
-	process_passed %current_config;
-	return 0;
-    }
+    # First, lets get it down to a single subset.
+    # Is the problem with a difference in values?
+    # Is the problem with a missing config?
+    # Is the problem with a config that breaks things?
 
-    process_failed $start_list[0];
-    return 1;
-}
+    # Enable all of one set and see if we get a new bad
+    # or good config.
 
-sub config_bisect {
-    my ($i) = @_;
+    # first set the good config to the bad values.
 
-    my $start_config = $config_bisect;
+    doprint "d=$len_diff g=$len_g b=$len_b\n";
 
-    my $tmpconfig = "$tmpdir/use_config";
+    # first lets enable things in bad config that are enabled in good config
 
-    if (defined($config_bisect_good)) {
-	process_config_ignore $config_bisect_good;
-    }
+    if ($len_diff > 0) {
+	if ($len_b > 0 || $len_g > 0) {
+	    my %tmp_config = %bad_configs;
 
-    # Make the file with the bad config and the min config
-    if (defined($minconfig)) {
-	# read the min config for things to ignore
-	run_command "cp $minconfig $tmpconfig" or
-	    dodie "failed to copy $minconfig to $tmpconfig";
-    } else {
-	unlink $tmpconfig;
-    }
+	    doprint "Set tmp config to be bad config with good config values\n";
+	    foreach my $item (@diff_arr) {
+		$tmp_config{$item} = $good_configs{$item};
+	    }
 
-    if (-f $tmpconfig) {
-	load_force_config($tmpconfig);
-	process_config_ignore $tmpconfig;
+	    $runtest = process_new_config \%tmp_config, \%new_configs,
+			    \%good_configs, \%bad_configs;
+	}
     }
 
-    # now process the start config
-    run_command "cp $start_config $output_config" or
-	dodie "failed to copy $start_config to $output_config";
+    if (!$runtest && $len_diff > 0) {
 
-    # read directly what we want to check
-    my %config_check;
-    open (IN, $output_config)
-	or dodie "failed to open $output_config";
+	if ($len_diff == 1) {
+	    doprint "The bad config setting is: $diff_arr[0]\n";
+	    return 1;
+	}
+	my %tmp_config = %bad_configs;
 
-    while (<IN>) {
-	if (/^((CONFIG\S*)=.*)/) {
-	    $config_check{$2} = $1;
+	my $half = int($#diff_arr / 2);
+	my @tophalf = @diff_arr[0 .. $half];
+
+	doprint "Settings bisect with top half:\n";
+	doprint "Set tmp config to be bad config with some good config values\n";
+	foreach my $item (@tophalf) {
+	    $tmp_config{$item} = $good_configs{$item};
 	}
-    }
-    close(IN);
 
-    # Now run oldconfig with the minconfig
-    make_oldconfig;
+	$runtest = process_new_config \%tmp_config, \%new_configs,
+			    \%good_configs, \%bad_configs;
 
-    # check to see what we lost (or gained)
-    open (IN, $output_config)
-	or dodie "Failed to read $start_config";
+	if (!$runtest) {
+	    my %tmp_config = %bad_configs;
 
-    my %removed_configs;
-    my %added_configs;
+	    doprint "Try bottom half\n";
 
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
+	    my @bottomhalf = @diff_arr[$half+1 .. $#diff_arr];
+
+	    foreach my $item (@bottomhalf) {
+		$tmp_config{$item} = $good_configs{$item};
 	    }
-	} elsif (/^# ((CONFIG\S*).*)/) {
-	    # Keep these configs disabled
-	    $config_set{$2} = $1;
-	    $config_off{$2} = $1;
-	}
-    }
-    close(IN);
 
-    my @confs = keys %removed_configs;
-    if ($#confs >= 0) {
-	doprint "Configs overridden by default configs and removed from check:\n";
-	foreach my $config (@confs) {
-	    doprint " $config\n";
+	    $runtest = process_new_config \%tmp_config, \%new_configs,
+			    \%good_configs, \%bad_configs;
 	}
     }
-    @confs = keys %added_configs;
-    if ($#confs >= 0) {
-	doprint "Configs appearing in make oldconfig and added:\n";
-	foreach my $config (@confs) {
-	    doprint " $config\n";
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
 	}
+	return 0;
     }
 
-    my %config_test;
-    my $once = 0;
+    fail "Hmm, need to do a mix match?\n";
+    return -1;
+}
 
-    @config_off_tmp = ();
+sub config_bisect {
+    my ($i) = @_;
 
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
-	    }
-	    doprint "  $config\n";
-	    delete $config_list{$config};
-	}
-    }
-    my $ret;
+    my $type = $config_bisect_type;
 
-    if (defined($config_bisect_check) && $config_bisect_check) {
-	doprint " Checking to make sure bad config with min config fails\n";
-	create_config keys %config_list;
-	$ret = run_config_bisect_test $config_bisect_type;
-	if ($ret) {
-	    doprint " FAILED! Bad config with min config boots fine\n";
-	    return -1;
+    $bad_config = $config_bisect;
+
+    if (defined($config_bisect_good)) {
+	$good_config = $config_bisect_good;
+    } elsif (defined($minconfig)) {
+	$good_config = $minconfig;
+    } else {
+	doprint "No config specified, checking if defconfig works";
+	my $ret = run_bisect_test $type, "defconfig";
+	if (!$ret) {
+	    fail "Have no good config to compare with, please set CONFIG_BISECT_GOOD";
+	    return 1;
 	}
-	doprint " Bad config with min config fails as expected\n";
+	$good_config = $output_config;
     }
 
+    # we don't want min configs to cause issues here.
+    doprint "Disabling 'MIN_CONFIG' for this test\n";
+    undef $minconfig;
+
+    my %good_configs;
+    my %bad_configs;
+    my %tmp_configs;
+
+    doprint "Run good configs through make oldconfig\n";
+    assign_configs \%tmp_configs, $good_config;
+    create_config "$good_config", \%tmp_configs;
+    assign_configs \%good_configs, $output_config;
+
+    doprint "Run bad configs through make oldconfig\n";
+    assign_configs \%tmp_configs, $bad_config;
+    create_config "$bad_config", \%tmp_configs;
+    assign_configs \%bad_configs, $output_config;
+
+    $good_config = "$tmpdir/good_config";
+    $bad_config = "$tmpdir/bad_config";
+
+    save_config \%good_configs, $good_config;
+    save_config \%bad_configs, $bad_config;
+
+    my $ret;
+
     do {
-	$ret = run_config_bisect;
+	$ret = run_config_bisect \%good_configs, \%bad_configs;
     } while (!$ret);
 
     return $ret if ($ret < 0);
-- 
1.8.5.3


