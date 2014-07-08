Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbaGHRxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 13:53:54 -0400
Received: from smtprelay0241.hostedemail.com ([216.40.44.241]:60986 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755092AbaGHRxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 13:53:51 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:2:41:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1535:1605:1730:1747:1777:1792:2197:2198:2199:2200:2393:2559:2562:2892:2895:3138:3139:3140:3141:3142:3653:3865:3866:3867:3868:3874:4049:4118:4321:4605:5007:6119:6261:6299:7903:10007:10026:10226:10848:11026:11232:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:14110:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: camp39_3e19d011e24c
X-Filterd-Recvd-Size: 7868
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] checkpatch: Add ability to insert and delete lines to patch/file
Date: Tue,  8 Jul 2014 10:53:36 -0700
Message-Id: <678bea67f00c0b59cb17d0e9ee722e0ab0616b43.1404840958.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1404840958.git.joe@perches.com>
References: <cover.1404840958.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This can be valuable to insert or delete blank lines as well
as fix misplaced brace or else uses.

Store indexes of lines to be added/deleted and the new lines.

When creating the --fix file, insert or delete the appropriate
lines and update the patch range information.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 141 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 130 insertions(+), 11 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index ecb8290..d5d7764 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -583,6 +583,8 @@ $chk_signoff = 0 if ($file);
 my @rawlines = ();
 my @lines = ();
 my @fixed = ();
+my @fixed_inserted = ();
+my @fixed_deleted = ();
 my $fixlinenr = -1;
 
 my $vname;
@@ -613,6 +615,8 @@ for my $filename (@ARGV) {
 	@rawlines = ();
 	@lines = ();
 	@fixed = ();
+	@fixed_inserted = ();
+	@fixed_deleted = ();
 	$fixlinenr = -1;
 }
 
@@ -1526,6 +1530,69 @@ sub report_dump {
 	our @report;
 }
 
+sub fixup_current_range {
+	my ($lineRef, $offset, $length) = @_;
+
+	if ($$lineRef =~ /^\@\@ -\d+,\d+ \+(\d+),(\d+) \@\@/) {
+		my $o = $1;
+		my $l = $2;
+		my $no = $o + $offset;
+		my $nl = $l + $length;
+		$$lineRef =~ s/\+$o,$l \@\@/\+$no,$nl \@\@/;
+	}
+}
+
+sub fix_inserted_deleted_lines {
+	my ($linesRef, $insertedRef, $deletedRef) = @_;
+
+	my $range_last_linenr = 0;
+	my $delta_offset = 0;
+
+	my $old_linenr = 0;
+	my $new_linenr = 0;
+
+	my $next_insert = 0;
+	my $next_delete = 0;
+
+	my @lines = ();
+
+	my $inserted = @{$insertedRef}[$next_insert++];
+	my $deleted = @{$deletedRef}[$next_delete++];
+
+	foreach my $old_line (@{$linesRef}) {
+		my $save_line = 1;
+		my $line = $old_line;	#don't modify the array
+		if ($line =~ /^(?:\+\+\+\|\-\-\-)\s+\S+/) {	#new filename
+			$delta_offset = 0;
+		} elsif ($line =~ /^\@\@ -\d+,\d+ \+\d+,\d+ \@\@/) {	#new hunk
+			$range_last_linenr = $new_linenr;
+			fixup_current_range(\$line, $delta_offset, 0);
+		}
+
+		while (defined($deleted) && ${$deleted}{'LINENR'} == $old_linenr) {
+			$deleted = @{$deletedRef}[$next_delete++];
+			$save_line = 0;
+			fixup_current_range(\$lines[$range_last_linenr], $delta_offset--, -1);
+		}
+
+		while (defined($inserted) && ${$inserted}{'LINENR'} == $old_linenr) {
+			push(@lines, ${$inserted}{'LINE'});
+			$inserted = @{$insertedRef}[$next_insert++];
+			$new_linenr++;
+			fixup_current_range(\$lines[$range_last_linenr], $delta_offset++, 1);
+		}
+
+		if ($save_line) {
+			push(@lines, $line);
+			$new_linenr++;
+		}
+
+		$old_linenr++;
+	}
+
+	return @lines;
+}
+
 sub ERROR {
 	my ($type, $msg) = @_;
 
@@ -2366,16 +2433,31 @@ sub process {
 		      $line =~ /^\+\s*(?:static\s+)?[A-Z_]*ATTR/ ||
 		      $line =~ /^\+\s*DECLARE/ ||
 		      $line =~ /^\+\s*__setup/)) {
-			CHK("LINE_SPACING",
-			    "Please use a blank line after function/struct/union/enum declarations\n" . $hereprev);
+			if (CHK("LINE_SPACING",
+				"Please use a blank line after function/struct/union/enum declarations\n" . $hereprev) &&
+			    $fix) {
+			my $inserted = {
+				LINENR => $fixlinenr,
+				LINE => "\+",
+			};
+			push(@fixed_inserted, $inserted);
+			}
 		}
 
 # check for multiple consecutive blank lines
 		if ($prevline =~ /^[\+ ]\s*$/ &&
 		    $line =~ /^\+\s*$/ &&
 		    $last_blank_line != ($linenr - 1)) {
-			CHK("LINE_SPACING",
-			    "Please don't use multiple blank lines\n" . $hereprev);
+			if (CHK("LINE_SPACING",
+				"Please don't use multiple blank lines\n" . $hereprev) &&
+			    $fix) {
+			my $deleted = {
+				LINENR => $fixlinenr,
+				LINE => $rawline,
+			};
+			push(@fixed_deleted, $deleted);
+			}
+
 			$last_blank_line = $linenr;
 		}
 
@@ -2413,8 +2495,15 @@ sub process {
 		      $sline =~ /^\+\s+\(?\s*(?:$Compare|$Assignment|$Operators)/) &&
 			# indentation of previous and current line are the same
 		    (($prevline =~ /\+(\s+)\S/) && $sline =~ /^\+$1\S/)) {
-			WARN("LINE_SPACING",
-			     "Missing a blank line after declarations\n" . $hereprev);
+			if (WARN("LINE_SPACING",
+				 "Missing a blank line after declarations\n" . $hereprev) &&
+			    $fix) {
+			my $inserted = {
+				LINENR => $fixlinenr,
+				LINE => "\+",
+			};
+			push(@fixed_inserted, $inserted);
+			}
 		}
 
 # check for spaces at the beginning of a line.
@@ -2606,7 +2695,7 @@ sub process {
 			#print "realcnt<$realcnt> ctx_cnt<$ctx_cnt>\n";
 			#print "pre<$pre_ctx>\nline<$line>\nctx<$ctx>\nnext<$lines[$ctx_ln - 1]>\n";
 
-			if ($ctx !~ /{\s*/ && defined($lines[$ctx_ln -1]) && $lines[$ctx_ln - 1] =~ /^\+\s*{/) {
+			if ($ctx !~ /{\s*/ && defined($lines[$ctx_ln - 1]) && $lines[$ctx_ln - 1] =~ /^\+\s*{/) {
 				ERROR("OPEN_BRACE",
 				      "that open brace { should be on the previous line\n" .
 					"$here\n$ctx\n$rawlines[$ctx_ln - 1]\n");
@@ -2756,8 +2845,34 @@ sub process {
 # check for initialisation to aggregates open brace on the next line
 		if ($line =~ /^.\s*{/ &&
 		    $prevline =~ /(?:^|[^=])=\s*$/) {
-			ERROR("OPEN_BRACE",
-			      "that open brace { should be on the previous line\n" . $hereprev);
+			if (ERROR("OPEN_BRACE",
+				  "that open brace { should be on the previous line\n" . $hereprev) &&
+			    $fix && $prevline =~ /^\+/) {
+				my $deleted = {
+					LINENR => $fixlinenr - 1,
+					LINE => $prevrawline,
+				};
+				push(@fixed_deleted, $deleted);
+				$deleted = {
+					LINENR => $fixlinenr,
+					LINE => $rawline,
+				};
+				push(@fixed_deleted, $deleted);
+				my $fixedline = $prevrawline;
+				$fixedline =~ s/\s*=\s*$/ = {/;
+				my $inserted = {
+					LINENR => $fixlinenr,
+					LINE => $fixedline,
+				};
+				push(@fixed_inserted, $inserted);
+				$fixedline = $line;
+				$fixedline =~ s/^(.\s*){\s*/$1/;
+				$inserted = {
+					LINENR => $fixlinenr,
+					LINE => $fixedline,
+				};
+				push(@fixed_inserted, $inserted);
+			}
 		}
 
 #
@@ -4879,12 +4994,16 @@ sub process {
 	hash_show_words(\%use_type, "Used");
 	hash_show_words(\%ignore_type, "Ignored");
 
-	if ($clean == 0 && $fix && "@rawlines" ne "@fixed") {
+	if ($clean == 0 && $fix &&
+	    ("@rawlines" ne "@fixed" ||
+	     $#fixed_inserted >= 0 || $#fixed_deleted >= 0)) {
 		my $newfile = $filename;
 		$newfile .= ".EXPERIMENTAL-checkpatch-fixes" if (!$fix_inplace);
 		my $linecount = 0;
 		my $f;
 
+		@fixed = fix_inserted_deleted_lines(\@fixed, \@fixed_inserted, \@fixed_deleted);
+
 		open($f, '>', $newfile)
 		    or die "$P: Can't open $newfile for write\n";
 		foreach my $fixed_line (@fixed) {
@@ -4892,7 +5011,7 @@ sub process {
 			if ($file) {
 				if ($linecount > 3) {
 					$fixed_line =~ s/^\+//;
-					print $f $fixed_line. "\n";
+					print $f $fixed_line . "\n";
 				}
 			} else {
 				print $f $fixed_line . "\n";
-- 
1.8.1.2.459.gbcd45b4.dirty

