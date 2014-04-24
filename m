Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbaDXQI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:08:57 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:8996 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758716AbaDXQIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:08:54 -0400
Message-Id: <20140424160851.071881458@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 24 Apr 2014 12:06:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 5/7] ktest: Remove unused functions
References: <20140424160626.491010573@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0005-ktest-Remove-unused-functions.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

After the rewrite of the config bisect, there were several unused
functions that can be removed.

One of the unused functions printed out the failed config nicer than
what the rewrite did, so I kept that and used it to output the
bad config.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl | 63 +-------------------------------------------
 1 file changed, 1 insertion(+), 62 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 59697ea..8805668 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
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
 
@@ -2947,23 +2926,6 @@ sub run_config_bisect_test {
     return run_bisect_test $type, "oldconfig";
 }
 
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
-    }
-    doprint "config copied to $outputdir/config_good\n";
-    run_command "cp -f $output_config $outputdir/config_good";
-}
-
 sub process_failed {
     my ($config) = @_;
 
@@ -3066,7 +3028,7 @@ sub run_config_bisect {
     if (!$runtest && $len_diff > 0) {
 
 	if ($len_diff == 1) {
-	    doprint "The bad config setting is: $diff_arr[0]\n";
+	    process_failed $diff_arr[0];
 	    return 1;
 	}
 	my %tmp_config = %bad_configs;
@@ -3471,29 +3433,6 @@ sub read_depends {
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
 
-- 
1.8.5.3


