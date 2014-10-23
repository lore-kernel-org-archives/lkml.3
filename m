Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbaJWR3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 13:29:16 -0400
Received: from smtprelay0072.hostedemail.com ([216.40.44.72]:41683 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932090AbaJWR3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 13:29:15 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:355:379:541:800:960:967:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2525:2560:2563:2682:2685:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3653:3865:3867:3868:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:5007:6119:6261:6299:7875:7903:9010:9025:9388:9392:10004:10400:10848:11026:11257:11658:11914:12043:12291:12296:12438:12517:12519:12555:12679:12683:13019:13221:13229:14093:14097:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: uncle26_33594b12b0361
X-Filterd-Recvd-Size: 3431
Message-ID: <1414085351.15751.10.camel@perches.com>
Subject: [PATCH] checkpatch: fix use via symlink, make missing spelling file
 non-fatal
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jani Nikula <jani.nikula@intel.com>, Andy Whitcroft <apw@canonical.com>,
        Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 23 Oct 2014 10:29:11 -0700
In-Reply-To: <87ppdktewn.fsf@intel.com>
References: <874muwv0ym.fsf@intel.com>
	 <1413980418.18654.8.camel@perches.com> <87ppdktewn.fsf@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 66b47b4a9dad ("checkpatch: look for common misspellings")
made it difficult to use checkpatch via a symlink.

Fix that and make a missing spelling.txt file non-fatal.
Emit a warning when the spelling.txt file can not be opened.

Reference: http://xkcd.com/1172/

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Jani Nikula <jani.nikula@intel.com>
Tested-by: Jani Nikula <jani.nikula@intel.com>
---
 scripts/checkpatch.pl | 38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d94f5d8..a6354ec 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -7,10 +7,11 @@
 
 use strict;
 use POSIX;
+use File::Basename;
+use Cwd 'abs_path';
 
 my $P = $0;
-$P =~ s@(.*)/@@g;
-my $D = $1;
+my $D = dirname(abs_path($P));
 
 my $V = '0.32';
 
@@ -438,26 +439,29 @@ our $allowed_asm_includes = qr{(?x:
 
 # Load common spelling mistakes and build regular expression list.
 my $misspellings;
-my @spelling_list;
 my %spelling_fix;
-open(my $spelling, '<', $spelling_file)
-    or die "$P: Can't open $spelling_file for reading: $!\n";
-while (<$spelling>) {
-	my $line = $_;
 
-	$line =~ s/\s*\n?$//g;
-	$line =~ s/^\s*//g;
+if (open(my $spelling, '<', $spelling_file)) {
+	my @spelling_list;
+	while (<$spelling>) {
+		my $line = $_;
 
-	next if ($line =~ m/^\s*#/);
-	next if ($line =~ m/^\s*$/);
+		$line =~ s/\s*\n?$//g;
+		$line =~ s/^\s*//g;
 
-	my ($suspect, $fix) = split(/\|\|/, $line);
+		next if ($line =~ m/^\s*#/);
+		next if ($line =~ m/^\s*$/);
+
+		my ($suspect, $fix) = split(/\|\|/, $line);
 
-	push(@spelling_list, $suspect);
-	$spelling_fix{$suspect} = $fix;
+		push(@spelling_list, $suspect);
+		$spelling_fix{$suspect} = $fix;
+	}
+	close($spelling);
+	$misspellings = join("|", @spelling_list);
+} else {
+	warn "No typos will be found - file '$spelling_file': $!\n";
 }
-close($spelling);
-$misspellings = join("|", @spelling_list);
 
 sub build_types {
 	my $mods = "(?x:  \n" . join("|\n  ", @modifierList) . "\n)";
@@ -2246,7 +2250,7 @@ sub process {
 		}
 
 # Check for various typo / spelling mistakes
-		if ($in_commit_log || $line =~ /^\+/) {
+		if (defined($misspellings) && ($in_commit_log || $line =~ /^\+/)) {
 			while ($rawline =~ /(?:^|[^a-z@])($misspellings)(?:$|[^a-z@])/gi) {
 				my $typo = $1;
 				my $typo_fix = $spelling_fix{lc($typo)};



