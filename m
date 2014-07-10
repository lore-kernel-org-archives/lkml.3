Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbaGJSy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:54:27 -0400
Received: from smtprelay0121.hostedemail.com ([216.40.44.121]:35270 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752524AbaGJSx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:53:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:3138:3139:3140:3141:3142:3354:3653:3865:3866:3867:3868:3871:4321:4605:5007:6261:10004:10026:10848:11026:11232:11473:11658:11914:12043:12291:12517:12519:12555:12683:14110:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: patch03_3f30be3bd7846
X-Filterd-Recvd-Size: 3329
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] checkpatch: Fix brace style misuses of else and while
Date: Thu, 10 Jul 2014 11:53:41 -0700
Message-Id: <7769e4ce33f4495fa3547db78dc7b9dd8605c85c.1405018255.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1405018255.git.joe@perches.com>
References: <cover.1405018255.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add --fix corrections for ELSE_AFTER_BRACE and WHILE_AFTER_BRACE
misuses.

	if (x) {
		...
	}
	else {
		...
	}
is corrected to
	if (x) {
		...
	} else {
		...
	}

and

	do {
		...
	}
	while (x);
is corrected to
	do {
		...
	} while (x);

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 1e95953..404e3d6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3885,14 +3885,26 @@ sub process {
 
 		# Check for }<nl>else {, these must be at the same
 		# indent level to be relevant to each other.
-		if ($prevline=~/}\s*$/ and $line=~/^.\s*else\s*/ and
-						$previndent == $indent) {
-			ERROR("ELSE_AFTER_BRACE",
-			      "else should follow close brace '}'\n" . $hereprev);
+		if ($prevline=~/}\s*$/ and $line=~/^.\s*else\s*/ &&
+		    $previndent == $indent) {
+			if (ERROR("ELSE_AFTER_BRACE",
+				  "else should follow close brace '}'\n" . $hereprev) &&
+			    $fix && $prevline =~ /^\+/ && $line =~ /^\+/) {
+				fix_delete_line($fixlinenr - 1, $prevrawline);
+				fix_delete_line($fixlinenr, $rawline);
+				my $fixedline = $prevrawline;
+				$fixedline =~ s/}\s*$//;
+				if ($fixedline !~ /^\+\s*$/) {
+					fix_insert_line($fixlinenr, $fixedline);
+				}
+				$fixedline = $rawline;
+				$fixedline =~ s/^(.\s*)else/$1} else/;
+				fix_insert_line($fixlinenr, $fixedline);
+			}
 		}
 
-		if ($prevline=~/}\s*$/ and $line=~/^.\s*while\s*/ and
-						$previndent == $indent) {
+		if ($prevline=~/}\s*$/ and $line=~/^.\s*while\s*/ &&
+		    $previndent == $indent) {
 			my ($s, $c) = ctx_statement_block($linenr, $realcnt, 0);
 
 			# Find out what is on the end of the line after the
@@ -3901,8 +3913,18 @@ sub process {
 			$s =~ s/\n.*//g;
 
 			if ($s =~ /^\s*;/) {
-				ERROR("WHILE_AFTER_BRACE",
-				      "while should follow close brace '}'\n" . $hereprev);
+				if (ERROR("WHILE_AFTER_BRACE",
+					  "while should follow close brace '}'\n" . $hereprev) &&
+				    $fix && $prevline =~ /^\+/ && $line =~ /^\+/) {
+					fix_delete_line($fixlinenr - 1, $prevrawline);
+					fix_delete_line($fixlinenr, $rawline);
+					my $fixedline = $prevrawline;
+					my $trailing = $rawline;
+					$trailing =~ s/^\+//;
+					$trailing = trim($trailing);
+					$fixedline =~ s/}\s*$/} $trailing/;
+					fix_insert_line($fixlinenr, $fixedline);
+				}
 			}
 		}
 
-- 
1.8.1.2.459.gbcd45b4.dirty

