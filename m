Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbaGJSxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:53:51 -0400
Received: from smtprelay0065.hostedemail.com ([216.40.44.65]:59779 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750877AbaGJSxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:53:48 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1534:1543:1711:1730:1747:1777:1792:2197:2198:2199:2200:2393:2559:2562:3138:3139:3140:3141:3142:3354:3653:3865:3866:3874:4321:5007:6261:10004:10026:10848:11026:11232:11658:11914:12043:12291:12438:12517:12519:12555:12683:14110:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pest99_3e12ca18bb21d
X-Filterd-Recvd-Size: 3828
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] checkpatch: Add fix_insert_line and fix_delete_line helpers
Date: Thu, 10 Jul 2014 11:53:38 -0700
Message-Id: <198369a7699c05876e34ac6f743bd33354f0bc94.1405018255.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1405018255.git.joe@perches.com>
References: <cover.1405018255.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neaten the uses of patch/file line insertions or deletions.
Hide the mechanism used.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 65 +++++++++++++++++++++++----------------------------
 1 file changed, 29 insertions(+), 36 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f3d9a88..7c29069 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1593,6 +1593,27 @@ sub fix_inserted_deleted_lines {
 	return @lines;
 }
 
+sub fix_insert_line {
+	my ($linenr, $line) = @_;
+
+	my $inserted = {
+		LINENR => $linenr,
+		LINE => $line,
+	};
+	push(@fixed_inserted, $inserted);
+}
+
+sub fix_delete_line {
+	my ($linenr, $line) = @_;
+
+	my $deleted = {
+		LINENR => $linenr,
+		LINE => $line,
+	};
+
+	push(@fixed_deleted, $deleted);
+}
+
 sub ERROR {
 	my ($type, $msg) = @_;
 
@@ -2447,11 +2468,7 @@ sub process {
 			if (CHK("LINE_SPACING",
 				"Please use a blank line after function/struct/union/enum declarations\n" . $hereprev) &&
 			    $fix) {
-			my $inserted = {
-				LINENR => $fixlinenr,
-				LINE => "\+",
-			};
-			push(@fixed_inserted, $inserted);
+				fix_insert_line($fixlinenr, "\+");
 			}
 		}
 
@@ -2462,11 +2479,7 @@ sub process {
 			if (CHK("LINE_SPACING",
 				"Please don't use multiple blank lines\n" . $hereprev) &&
 			    $fix) {
-			my $deleted = {
-				LINENR => $fixlinenr,
-				LINE => $rawline,
-			};
-			push(@fixed_deleted, $deleted);
+				fix_delete_line($fixlinenr, $rawline);
 			}
 
 			$last_blank_line = $linenr;
@@ -2509,11 +2522,7 @@ sub process {
 			if (WARN("LINE_SPACING",
 				 "Missing a blank line after declarations\n" . $hereprev) &&
 			    $fix) {
-			my $inserted = {
-				LINENR => $fixlinenr,
-				LINE => "\+",
-			};
-			push(@fixed_inserted, $inserted);
+				fix_insert_line($fixlinenr, "\+");
 			}
 		}
 
@@ -2868,31 +2877,15 @@ sub process {
 		    $prevline =~ /(?:^|[^=])=\s*$/) {
 			if (ERROR("OPEN_BRACE",
 				  "that open brace { should be on the previous line\n" . $hereprev) &&
-			    $fix && $prevline =~ /^\+/) {
-				my $deleted = {
-					LINENR => $fixlinenr - 1,
-					LINE => $prevrawline,
-				};
-				push(@fixed_deleted, $deleted);
-				$deleted = {
-					LINENR => $fixlinenr,
-					LINE => $rawline,
-				};
-				push(@fixed_deleted, $deleted);
+			    $fix && $prevline =~ /^\+/ && $line =~ /^\+/) {
+				fix_delete_line($fixlinenr - 1, $prevrawline);
+				fix_delete_line($fixlinenr, $rawline);
 				my $fixedline = $prevrawline;
 				$fixedline =~ s/\s*=\s*$/ = {/;
-				my $inserted = {
-					LINENR => $fixlinenr,
-					LINE => $fixedline,
-				};
-				push(@fixed_inserted, $inserted);
+				fix_insert_line($fixlinenr, $fixedline);
 				$fixedline = $line;
 				$fixedline =~ s/^(.\s*){\s*/$1/;
-				$inserted = {
-					LINENR => $fixlinenr,
-					LINE => $fixedline,
-				};
-				push(@fixed_inserted, $inserted);
+				fix_insert_line($fixlinenr, $fixedline);
 			}
 		}
 
-- 
1.8.1.2.459.gbcd45b4.dirty

