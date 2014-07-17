Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933807AbaGQPev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:34:51 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaGQPet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:34:49 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: apw@canonical.com, joe@perches.com, tytso@mit.edu, dwalter@google.com,
        bp@suse.de, neilb@suse.de, hch@infradead.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH] checkpatch.pl: Remove --file option
Date: Thu, 17 Jul 2014 17:34:28 +0200
Message-Id: <1405611268-12463-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch.pl is a nice tool to find issues in patches.
Sadly this tool gets more and more  abused by various people to create
style cleanups for source files within the kernel.
In order to deal with that bad habit let's remove the --file option
and bring checkpatch.pl back to its original purpose.

Suggested-by: NeilBrown <neilb@suse.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 scripts/checkpatch.pl | 34 ++++++++--------------------------
 1 file changed, 8 insertions(+), 26 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 182be0f..41d2092 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -22,7 +22,6 @@ my $chk_patch = 1;
 my $tst_only;
 my $emacs = 0;
 my $terse = 0;
-my $file = 0;
 my $check = 0;
 my $check_orig = 0;
 my $summary = 1;
@@ -58,7 +57,6 @@ Options:
   --patch                    treat FILE as patchfile (default)
   --emacs                    emacs compile window format
   --terse                    one line per report
-  -f, --file                 treat FILE as regular source file
   --subjective, --strict     enable more subjective tests
   --types TYPE(,TYPE2...)    show only these comma separated message types
   --ignore TYPE(,TYPE2...)   ignore various comma separated message types
@@ -124,7 +122,6 @@ GetOptions(
 	'patch!'	=> \$chk_patch,
 	'emacs!'	=> \$emacs,
 	'terse!'	=> \$terse,
-	'f|file!'	=> \$file,
 	'subjective!'	=> \$check,
 	'strict!'	=> \$check,
 	'ignore=s'	=> \@ignore,
@@ -550,18 +547,13 @@ sub seed_camelcase_includes {
 	}
 }
 
-$chk_signoff = 0 if ($file);
-
 my @rawlines = ();
 my @lines = ();
 my @fixed = ();
 my $vname;
 for my $filename (@ARGV) {
 	my $FILE;
-	if ($file) {
-		open($FILE, '-|', "diff -u /dev/null $filename") ||
-			die "$P: $filename: diff failed - $!\n";
-	} elsif ($filename eq '-') {
+	if ($filename eq '-') {
 		open($FILE, '<&STDIN');
 	} else {
 		open($FILE, '<', "$filename") ||
@@ -1809,26 +1801,24 @@ sub process {
 		my $hunk_line = ($realcnt != 0);
 
 #make up the handle for any error we report on this line
-		$prefix = "$filename:$realline: " if ($emacs && $file);
-		$prefix = "$filename:$linenr: " if ($emacs && !$file);
+		$prefix = "$filename:$linenr: " if ($emacs);
 
-		$here = "#$linenr: " if (!$file);
-		$here = "#$realline: " if ($file);
+		$here = "#$linenr: ";
 
 		my $found_file = 0;
 		# extract the filename as it passes
 		if ($line =~ /^diff --git.*?(\S+)$/) {
 			$realfile = $1;
-			$realfile =~ s@^([^/]*)/@@ if (!$file);
+			$realfile =~ s@^([^/]*)/@@;
 			$in_commit_log = 0;
 			$found_file = 1;
 		} elsif ($line =~ /^\+\+\+\s+(\S+)/) {
 			$realfile = $1;
-			$realfile =~ s@^([^/]*)/@@ if (!$file);
+			$realfile =~ s@^([^/]*)/@@;
 			$in_commit_log = 0;
 
 			$p1_prefix = $1;
-			if (!$file && $tree && $p1_prefix ne '' &&
+			if ($tree && $p1_prefix ne '' &&
 			    -e "$root/$p1_prefix") {
 				WARN("PATCH_PREFIX",
 				     "patch prefix '$p1_prefix' exists, appears to be a -p0 patch\n");
@@ -2040,7 +2030,6 @@ sub process {
 		    $rawline =~ /\b51\s+Franklin\s+St/i) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
 			my $msg_type = \&ERROR;
-			$msg_type = \&CHK if ($file);
 			&{$msg_type}("FSF_MAILING_ADDRESS",
 				     "Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.\n" . $herevet)
 		}
@@ -3670,7 +3659,7 @@ sub process {
 					next if ($word !~ /[A-Z][a-z]|[a-z][A-Z]/);
 					if ($check) {
 						seed_camelcase_includes();
-						if (!$file && !$camelcase_file_seeded) {
+						if (!$camelcase_file_seeded) {
 							seed_camelcase_file($realfile);
 							$camelcase_file_seeded = 1;
 						}
@@ -4760,14 +4749,7 @@ sub process {
 		    or die "$P: Can't open $newfile for write\n";
 		foreach my $fixed_line (@fixed) {
 			$linecount++;
-			if ($file) {
-				if ($linecount > 3) {
-					$fixed_line =~ s/^\+//;
-					print $f $fixed_line. "\n";
-				}
-			} else {
-				print $f $fixed_line . "\n";
-			}
+			print $f $fixed_line . "\n";
 		}
 		close($f);
 
-- 
2.0.1

