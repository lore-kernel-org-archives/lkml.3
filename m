Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaGJSx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:53:57 -0400
Received: from smtprelay0163.hostedemail.com ([216.40.44.163]:59307 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752288AbaGJSxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:53:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:3138:3139:3140:3141:3142:3353:3653:3865:3866:3868:4321:4605:5007:6261:10004:10026:10848:11026:11232:11658:11914:12043:12291:12517:12519:12555:12683:14110:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wren79_3ecf16e1e5338
X-Filterd-Recvd-Size: 3087
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] checkpatch: Add --fix option for a couple OPEN_BRACE misuses
Date: Thu, 10 Jul 2014 11:53:40 -0700
Message-Id: <6af268570f1c0c929126a06164c983230c71754b.1405018255.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1405018255.git.joe@perches.com>
References: <cover.1405018255.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Style misuses of these types are corrected:

typedef struct foo
{
	int bar;
};

int foo(int bar) { return bar+1;
}

int foo(int bar) {
	return bar+1;
}

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 569ba31..1e95953 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3164,17 +3164,40 @@ sub process {
 
 # function brace can't be on same line, except for #defines of do while,
 # or if closed on same line
-		if (($line=~/$Type\s*$Ident\(.*\).*\s{/) and
+		if (($line=~/$Type\s*$Ident\(.*\).*\s*{/) and
 		    !($line=~/\#\s*define.*do\s{/) and !($line=~/}/)) {
-			ERROR("OPEN_BRACE",
-			      "open brace '{' following function declarations go on the next line\n" . $herecurr);
+			if (ERROR("OPEN_BRACE",
+				  "open brace '{' following function declarations go on the next line\n" . $herecurr) &&
+			    $fix) {
+				fix_delete_line($fixlinenr, $rawline);
+				my $fixed_line = $rawline;
+				$fixed_line =~ /(^..*$Type\s*$Ident\(.*\)\s*){(.*)$/;
+				my $line1 = $1;
+				my $line2 = $2;
+				fix_insert_line($fixlinenr, ltrim($line1));
+				fix_insert_line($fixlinenr, "\+{");
+				if ($line2 !~ /^\s*$/) {
+					fix_insert_line($fixlinenr, "\+\t" . trim($line2));
+				}
+			}
 		}
 
 # open braces for enum, union and struct go on the same line.
 		if ($line =~ /^.\s*{/ &&
 		    $prevline =~ /^.\s*(?:typedef\s+)?(enum|union|struct)(?:\s+$Ident)?\s*$/) {
-			ERROR("OPEN_BRACE",
-			      "open brace '{' following $1 go on the same line\n" . $hereprev);
+			if (ERROR("OPEN_BRACE",
+				  "open brace '{' following $1 go on the same line\n" . $hereprev) &&
+			    $fix && $prevline =~ /^\+/ && $line =~ /^\+/) {
+				fix_delete_line($fixlinenr - 1, $prevrawline);
+				fix_delete_line($fixlinenr, $rawline);
+				my $fixedline = rtrim($prevrawline) . " {";
+				fix_insert_line($fixlinenr, $fixedline);
+				$fixedline = $rawline;
+				$fixedline =~ s/^(.\s*){\s*/$1\t/;
+				if ($fixedline !~ /^\+\s*$/) {
+					fix_insert_line($fixlinenr, $fixedline);
+				}
+			}
 		}
 
 # missing space after union, struct or enum definition
-- 
1.8.1.2.459.gbcd45b4.dirty

