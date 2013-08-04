Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab3HDVVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 17:21:44 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41466 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753879Ab3HDVVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 17:21:42 -0400
Message-ID: <1375651302.3133.16.camel@joe-AO722>
Subject: [PATCH] checkpatch: Add --types option to report only specific
 message types
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Sun, 04 Aug 2013 14:21:42 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a --types convenience option to show only specific
message types.  Combined with the --fix option, this can
produce specific suggested formatting patches to files.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 56 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 18 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9185883..3ba2db6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -31,8 +31,10 @@ my $show_types = 0;
 my $fix = 0;
 my $root;
 my %debug;
-my %ignore_type = ();
 my %camelcase = ();
+my %use_type = ();
+my @use = ();
+my %ignore_type = ();
 my @ignore = ();
 my $help = 0;
 my $configuration_file = ".checkpatch.conf";
@@ -56,6 +58,7 @@ Options:
   --terse                    one line per report
   -f, --file                 treat FILE as regular source file
   --subjective, --strict     enable more subjective tests
+  --types TYPE(,TYPE2...)    show only these comma separated message types
   --ignore TYPE(,TYPE2...)   ignore various comma separated message types
   --max-line-length=n        set the maximum line length, if exceeded, warn
   --show-types               show the message "types" in the output
@@ -120,6 +123,7 @@ GetOptions(
 	'subjective!'	=> \$check,
 	'strict!'	=> \$check,
 	'ignore=s'	=> \@ignore,
+	'types=s'	=> \@use,
 	'show-types!'	=> \$show_types,
 	'max-line-length=i' => \$max_line_length,
 	'root=s'	=> \$root,
@@ -150,19 +154,38 @@ if ($#ARGV < 0) {
 	exit(1);
 }
 
-@ignore = split(/,/, join(',',@ignore));
-foreach my $word (@ignore) {
-	$word =~ s/\s*\n?$//g;
-	$word =~ s/^\s*//g;
-	$word =~ s/\s+/ /g;
-	$word =~ tr/[a-z]/[A-Z]/;
+sub hash_save_array_words {
+	my ($hashRef, $arrayRef) = @_;
+
+	my @array = split(/,/, join(',', @$arrayRef));
+	foreach my $word (@array) {
+		$word =~ s/\s*\n?$//g;
+		$word =~ s/^\s*//g;
+		$word =~ s/\s+/ /g;
+		$word =~ tr/[a-z]/[A-Z]/;
+
+		next if ($word =~ m/^\s*#/);
+		next if ($word =~ m/^\s*$/);
+
+		$hashRef->{$word}++;
+	}
+}
 
-	next if ($word =~ m/^\s*#/);
-	next if ($word =~ m/^\s*$/);
+sub hash_show_words {
+	my ($hashRef, $prefix) = @_;
 
-	$ignore_type{$word}++;
+	if ($quiet == 0 && keys $hashRef) {
+		print "NOTE: $prefix message types:";
+		foreach my $word (sort keys $hashRef) {
+			print " $word";
+		}
+		print "\n\n";
+	}
 }
 
+hash_save_array_words(\%ignore_type, \@ignore);
+hash_save_array_words(\%use_type, \@use);
+
 my $dbg_values = 0;
 my $dbg_possible = 0;
 my $dbg_type = 0;
@@ -1367,7 +1390,9 @@ sub possible {
 my $prefix = '';
 
 sub show_type {
-       return !defined $ignore_type{$_[0]};
+	return defined $use_type{$_[0]} if (scalar keys %use_type > 0);
+
+	return !defined $ignore_type{$_[0]};
 }
 
 sub report {
@@ -4190,13 +4215,8 @@ sub process {
 		}
 	}
 
-	if ($quiet == 0 && keys %ignore_type) {
-	    print "NOTE: Ignored message types:";
-	    foreach my $ignore (sort keys %ignore_type) {
-		print " $ignore";
-	    }
-	    print "\n\n";
-	}
+	hash_show_words(\%use_type, "Used");
+	hash_show_words(\%ignore_type, "Ignored");
 
 	if ($clean == 0 && $fix && "@rawlines" ne "@fixed") {
 		my $newfile = $filename . ".EXPERIMENTAL-checkpatch-fixes";


