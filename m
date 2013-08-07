Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab3HGCze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 22:55:34 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:35018 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756833Ab3HGCzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 22:55:33 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Phil Carmody <phil.carmody@partner.samsung.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] checkpatch: Better --fix of SPACING errors.
Date: Tue,  6 Aug 2013 19:55:29 -0700
Message-Id: <55837ac7d8f48eb8dc9060f1b705c9c8b01bea59.1375843905.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous attempt at fixing SPACING errors could
make a hash of several defects.

This patch should make --fix be a lot better at
correcting these defects.

Trim left and right sides of these defects
appropriately instead of a somewhat random attempt
at it.

Trim left spaces from any following bit of the
modified line when only a single space is required
around an operator.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 64 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 42 insertions(+), 22 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index ca5079e..c25af23 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1472,7 +1472,23 @@ sub check_absolute_file {
 sub trim {
 	my ($string) = @_;
 
-	$string =~ s/(^\s+|\s+$)//g;
+	$string =~ s/^\s+|\s+$//g;
+
+	return $string;
+}
+
+sub ltrim {
+	my ($string) = @_;
+
+	$string =~ s/^\s+//;
+
+	return $string;
+}
+
+sub rtrim {
+	my ($string) = @_;
+
+	$string =~ s/\s+$//;
 
 	return $string;
 }
@@ -2821,6 +2837,7 @@ sub process {
 			$off = 0;
 
 			my $blank = copy_spacing($opline);
+			my $last_after = -1;
 
 			for (my $n = 0; $n < $#elements; $n += 2) {
 
@@ -2886,7 +2903,7 @@ sub process {
 					    $cc !~ /^\\/ && $cc !~ /^;/) {
 						if (ERROR("SPACING",
 							  "space required after that '$op' $at\n" . $hereptr)) {
-							$good = trim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]) . " ";
+							$good = $fix_elements[$n] . trim($fix_elements[$n + 1]) . " ";
 							$line_fixed = 1;
 						}
 					}
@@ -2901,11 +2918,11 @@ sub process {
 					if ($ctx =~ /Wx.|.xW/) {
 						if (ERROR("SPACING",
 							  "spaces prohibited around that '$op' $at\n" . $hereptr)) {
-							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
-							$line_fixed = 1;
+							$good = rtrim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
 							if (defined $fix_elements[$n + 2]) {
 								$fix_elements[$n + 2] =~ s/^\s+//;
 							}
+							$line_fixed = 1;
 						}
 					}
 
@@ -2914,8 +2931,9 @@ sub process {
 					if ($ctx !~ /.x[WEC]/ && $cc !~ /^}/) {
 						if (ERROR("SPACING",
 							  "space required after that '$op' $at\n" . $hereptr)) {
-							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]) . " ";
+							$good = $fix_elements[$n] . trim($fix_elements[$n + 1]) . " ";
 							$line_fixed = 1;
+							$last_after = $n;
 						}
 					}
 
@@ -2932,8 +2950,10 @@ sub process {
 					if ($ctx !~ /[WEBC]x./ && $ca !~ /(?:\)|!|~|\*|-|\&|\||\+\+|\-\-|\{)$/) {
 						if (ERROR("SPACING",
 							  "space required before that '$op' $at\n" . $hereptr)) {
-							$good = trim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]);
-							$line_fixed = 1;
+							if ($n != $last_after + 2) {
+								$good = $fix_elements[$n] . " " . ltrim($fix_elements[$n + 1]);
+								$line_fixed = 1;
+							}
 						}
 					}
 					if ($op eq '*' && $cc =~/\s*$Modifier\b/) {
@@ -2942,12 +2962,11 @@ sub process {
 					} elsif ($ctx =~ /.xW/) {
 						if (ERROR("SPACING",
 							  "space prohibited after that '$op' $at\n" . $hereptr)) {
-							$fixed_line =~ s/\s+$//;
-							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
-							$line_fixed = 1;
+							$good = $fix_elements[$n] . rtrim($fix_elements[$n + 1]);
 							if (defined $fix_elements[$n + 2]) {
 								$fix_elements[$n + 2] =~ s/^\s+//;
 							}
+							$line_fixed = 1;
 						}
 					}
 
@@ -2956,8 +2975,7 @@ sub process {
 					if ($ctx !~ /[WEOBC]x[^W]/ && $ctx !~ /[^W]x[WOBEC]/) {
 						if (ERROR("SPACING",
 							  "space required one side of that '$op' $at\n" . $hereptr)) {
-							$fixed_line =~ s/\s+$//;
-							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]) . " ";
+							$good = $fix_elements[$n] . trim($fix_elements[$n + 1]) . " ";
 							$line_fixed = 1;
 						}
 					}
@@ -2965,20 +2983,18 @@ sub process {
 					    ($ctx =~ /Wx./ && $cc =~ /^;/)) {
 						if (ERROR("SPACING",
 							  "space prohibited before that '$op' $at\n" . $hereptr)) {
-							$fixed_line =~ s/\s+$//;
-							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
+							$good = rtrim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
 							$line_fixed = 1;
 						}
 					}
 					if ($ctx =~ /ExW/) {
 						if (ERROR("SPACING",
 							  "space prohibited after that '$op' $at\n" . $hereptr)) {
-							$fixed_line =~ s/\s+$//;
-							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
-							$line_fixed = 1;
+							$good = $fix_elements[$n] . trim($fix_elements[$n + 1]);
 							if (defined $fix_elements[$n + 2]) {
 								$fix_elements[$n + 2] =~ s/^\s+//;
 							}
+							$line_fixed = 1;
 						}
 					}
 
@@ -2992,8 +3008,10 @@ sub process {
 					if ($ctx =~ /Wx[^WCE]|[^WCE]xW/) {
 						if (ERROR("SPACING",
 							  "need consistent spacing around '$op' $at\n" . $hereptr)) {
-							$fixed_line =~ s/\s+$//;
-							$good = trim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]) . " ";
+							$good = rtrim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]) . " ";
+							if (defined $fix_elements[$n + 2]) {
+								$fix_elements[$n + 2] =~ s/^\s+//;
+							}
 							$line_fixed = 1;
 						}
 					}
@@ -3004,7 +3022,7 @@ sub process {
 					if ($ctx =~ /Wx./) {
 						if (ERROR("SPACING",
 							  "space prohibited before that '$op' $at\n" . $hereptr)) {
-							$good = trim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
+							$good = rtrim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
 							$line_fixed = 1;
 						}
 					}
@@ -3031,8 +3049,10 @@ sub process {
 					if ($ok == 0) {
 						if (ERROR("SPACING",
 							  "spaces required around that '$op' $at\n" . $hereptr)) {
-							$good = trim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]) . " ";
-							$good = $fix_elements[$n] . " " . trim($fix_elements[$n + 1]) . " ";
+							$good = rtrim($fix_elements[$n]) . " " . trim($fix_elements[$n + 1]) . " ";
+							if (defined $fix_elements[$n + 2]) {
+								$fix_elements[$n + 2] =~ s/^\s+//;
+							}
 							$line_fixed = 1;
 						}
 					}
-- 
1.8.1.2.459.gbcd45b4.dirty

