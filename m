Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbaGUOc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:32:59 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:53998 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754125AbaGUOc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:32:58 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIMAC0kzVNXQ4zh/2dsb2JhbABZgw5SryQJAQEFAW4BlX+HSYEYF3aEYCOBGhgfiEYBrU2RFYV7iGxkhE0FmyWBTZJig0Y7L4ED
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, richard@nod.at, akpm@linux-foundation.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [RFC PATCH 1/1] add makepatch script
Date: Mon, 21 Jul 2014 16:31:25 +0200
Message-Id: <1405953085-10608-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small script tries to standardize patch generation by adding patch level,
versioning and default flags.

-Patch categories:
	-RFC
	-URGENT
	-BUGFIX
	-TRIVIAL
	-CODE STYLE
	-...

Sample use: ./scripts/makepatch.pl --patchlevel "RFC" --version 3

Of course it's only an RFC which would need more specifications...

Inspired-By: Joe Perches <joe@perches.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 Documentation/SubmittingPatches |   2 +-
 scripts/makepatch.pl            | 133 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 134 insertions(+), 1 deletion(-)
 create mode 100755 scripts/makepatch.pl

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 7e9abb8..f14d809 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -167,7 +167,7 @@ in your patch description.
 If you cannot condense your patch set into a smaller set of patches,
 then only post say 15 or so at a time and wait for review and integration.
 
-
+One way to generate a standard patch and header is to use scripts/makepatch.pl.
 
 4) Style check your changes.
 
diff --git a/scripts/makepatch.pl b/scripts/makepatch.pl
new file mode 100755
index 0000000..ab4e092
--- /dev/null
+++ b/scripts/makepatch.pl
@@ -0,0 +1,133 @@
+#!/usr/bin/perl -w
+# (c) 2014, Fabian Frederick <fabf@skynet.be>
+#
+# Based on get_maintainer.pl and checkpatch.pl
+#
+# This script tries to standardize patch generation.
+# It adds patch level, versioning and default flags.
+#
+# usage: perl scripts/makepatch.pl [OPTIONS]
+#
+# Licensed under the terms of the GNU GPL License version 2
+
+use strict;
+use List::MoreUtils 'first_index';
+
+my $P = $0;
+my $V = '0.1';
+
+use Getopt::Long qw(:config no_auto_abbrev);
+
+my @patchlevels = ("RFC", "URGENT", "BUGFIX", "TRIVIAL", "CODE STYLE");
+my $patchlevel = '';
+my $patchversion = '';
+my $patchdefaultflags = '-s -n';
+my $patchadditionnalflags = '';
+my $branch = '';
+my $help = 0;
+my $subjectprefix = '';
+my $commits = 0;
+
+if (!GetOptions(
+		'patchlevel=s'		=> \$patchlevel,
+		'version=i'		=> \$patchversion,
+		'branch=s'		=> \$branch,
+		'flags=s'		=> \$patchadditionnalflags,
+                'h|help|usage'		=> \$help,
+	)) {
+    die "$P: invalid argument - use --help if necessary\n";
+}
+
+if ($help != 0) {
+    usage();
+    exit 0;
+}
+
+sub listpatchlevels () {
+	my $index = 0;
+	foreach(@patchlevels) {
+		print $_;
+		if ($index < $#patchlevels) {
+			print ", ";
+		}
+		$index++;
+	}
+	print "\n";
+}
+
+sub usage {
+	    print <<EOT;
+usage: $P [options]
+version: $V
+
+PATCH LEVEL options:
+	--patchlevel => specify patchlevel in the following:
+EOT
+listpatchlevels();
+	print <<EOT;
+
+PATCH VERSION options
+	--version => numeric patch version.
+
+BRANCH options
+	--branch => this script will generate a patch from master to this one.
+
+FLAG options
+	--flags => add flags to default ones.
+
+Note that if no branch is specified, this script will try master..current
+
+Normal use  : $P --patchlevel "CODE STYLE"
+Extended use: $P --patchlevel "CODE STYLE" --version 3 --flags "--thread --cover-letter"
+
+EOT
+}
+
+my $patchlevelindex = first_index{/^$patchlevel$/}  @patchlevels;
+
+if ($patchlevelindex > -1) {
+	#No destination branch specified, current branch ok ?
+	if ($branch eq "") {
+		my $currentbranch = `git status | head -n 1`;
+		$currentbranch = substr($currentbranch, rindex($currentbranch, " "));
+		$currentbranch =~ s/^\s+|\s+$//g;
+		if ($currentbranch eq 'master') {
+			print "This script generates a patch between master and a working branch.\n";
+			print "You're currently on master branch; please use --branch.\n";
+			exit(0);
+		}
+		$branch = $currentbranch;
+	} else {
+		my $branchexist = `git branch | grep $branch | wc -l`;
+		if ($branchexist == 0) {
+			print "You specified a branch which doesn't currently exist.\n";
+			print "Either git checkout desired branch or use correct --branch\n";
+			exit(0);
+		}
+	}
+	#Do we have some commits on that branch from master ?
+	$commits = `git rev-list master..$branch | wc -l`;
+	$commits =~ s/^\s+|\s+$//g;
+	if ($commits eq 0) {
+		print "No commits are available in current branch from master.\n";
+		exit(0);
+	}
+	#"V1" is not necessary
+	if ($patchversion && $patchversion > 1) {
+		$patchversion = " V".$patchversion;
+	} else {
+		$patchversion="";
+	}
+	$subjectprefix="$patchlevel PATCH$patchversion";
+	my $cmd = "git format-patch $patchdefaultflags $patchadditionnalflags --subject-prefix=\"".$subjectprefix."\" master..".$branch;
+	my $result = `$cmd`;
+	if ($result) {
+		print "File(s) generated:\n";
+		print $result;
+	} else {
+		print "No patch generated.";
+	}
+} else {
+	usage();
+	exit(0);
+}
-- 
1.9.1

