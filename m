Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaKVU4x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 15:56:53 -0500
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:34020 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752632AbaKVU4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 15:56:51 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnwIAIL3cFRXQ7vi/2dsb2JhbABcgw5VWbdRBQEBAQEBAQUBdZNChnKBAxcBAQEBAX2EMC8jL2s3iEUBvRGQYYY6hmaDa4RVBZI9hRCHNIFzlSeBSYI1RzCCSwEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] scripts: add a graph generator based on checkpatch reports
Date: Sat, 22 Nov 2014 21:56:40 +0100
Message-Id: <1416689800-27146-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This script generates a graph based on errors/warnings/checks detected
by checkpatch -f recursively on each files of a directory.
Results are grouped by subfolders and pushed in gnuplot datasets.

By default checkstat.png is generated with an histogram.

This script should always be called from kernel source root.
eg scripts/checkstat.pl fs

Cc: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 scripts/checkstat.pl | 120 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)
 create mode 100755 scripts/checkstat.pl

diff --git a/scripts/checkstat.pl b/scripts/checkstat.pl
new file mode 100755
index 0000000..8b7d451
--- /dev/null
+++ b/scripts/checkstat.pl
@@ -0,0 +1,120 @@
+#!/usr/bin/perl
+# (c) 2014, Fabian Frederick (fabf@skynet.be)
+#
+# Based on scripts/checkpatch.pl
+#
+# This script generates a graph based on errors/warnings/checks detected
+# by checkpatch -f recursively on each files of a directory.
+# Results are grouped by subfolders.
+#
+
+use strict;
+use Getopt::Long;
+use File::Basename;
+use Chart::Gnuplot;
+
+my $P = $0;
+my $statdir = '.';
+my $files;
+my @cfiles = ();
+my %stat;
+my %stats;
+my $report;
+my $currentdir = '';
+
+my $checkpatch = "scripts/checkpatch.pl";
+my $output = "checkstat.png";
+my @dontcheck = qw/fs\/nls/;
+
+sub help {
+	my $text = << "EOM";
+Usage: $P [OPTION] [DIRECTORY]
+
+This script should always be called from kernel source root.
+
+Options:
+	--output	name of generated png graph.
+EOM
+	my $std=shift;
+	if ($std == 1) {
+		print STDERR $text;
+	} else {
+		print $text;
+	}
+	exit;
+}
+
+GetOptions(
+	'h|help'	=> \&help,
+	'output=s'	=> \$output
+);
+
+if ($#ARGV >= 0) {
+	$statdir = @ARGV[0];
+}
+
+my $graphreport = Chart::Gnuplot->new(
+	output => $output,
+	yrange => [0, '*'],
+	imagesize => '3, 2',
+	xtics => {
+		rotate => '90 right',
+	},
+	bmargin => 15,
+	title => 'Linux Kernel: checkstat - Date: `date`'
+);
+
+$files = `find $statdir -name "*.c"`;
+@cfiles = split('\n', $files);
+
+#Execute checkpatch on each file and store results
+foreach my $file (@cfiles) {
+	print "checkpatch: $file: ";
+	$currentdir = dirname($file);
+
+	if (not grep(/^$currentdir$/, @dontcheck)){
+		$report = `$checkpatch -f --terse $file | tail -n 1`;
+
+		if ($currentdir ne $statdir) {
+			$currentdir =~ s/$statdir\///;
+			$currentdir =~ s/\/(.*)//;
+			$currentdir = $statdir."/".$currentdir;
+		}
+		print "adding to ".$currentdir." stats\n";
+		my $i = 0;
+
+		foreach my $stat_type ("errors", "warnings", "checks") {
+			$report =~ m/(\d+)\s$stat_type/;
+			$stat{$currentdir}[$i++] += $1;
+			$stats{$stat_type}{$currentdir} += $1;
+		}
+	} else {
+		print "File in dontcheck list ...\n";
+	}
+}
+
+my @columns=();
+my %colors=(
+	errors => 'red',
+	warnings => 'orange',
+	checks => 'green'
+);
+
+#Reorder and push data in datasets.
+foreach my $stat_type (keys %stats) {
+	my @xdir=();
+
+	foreach my $dir (sort keys %{$stats{$stat_type}}){
+		push @xdir, [$dir, $stats{$stat_type}{$dir}];
+	}
+	push @columns, Chart::Gnuplot::DataSet->new(
+		points => \@xdir,
+		title => $stat_type,
+		color => $colors{$stat_type},
+		fill => {density => 1},
+		style => "histograms",
+	);
+}
+
+$graphreport->plot2d(@columns);
+print("graph generated: $output\n");
-- 
1.9.1

