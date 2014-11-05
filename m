Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaKESmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:42:04 -0500
Received: from smtprelay0075.hostedemail.com ([216.40.44.75]:40162 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751603AbaKESmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:42:01 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3353:3653:3865:3866:3867:3868:3874:5007:6119:6261:7903:10004:10400:10848:11232:11658:11914:12043:12291:12438:12517:12519:12555:12679:13069:13161:13229:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: angle12_85c4978dbd32b
X-Filterd-Recvd-Size: 2726
Message-ID: <1415212917.6634.17.camel@perches.com>
Subject: [PATCH] checkpatch: Add --strict test for function pointer calling
 style
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org
Date: Wed, 05 Nov 2014 10:41:57 -0800
In-Reply-To: <1415208392-16189-3-git-send-email-peter@hurleysoftware.com>
References: <1415208392-16189-1-git-send-email-peter@hurleysoftware.com>
	 <1415208392-16189-3-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Hurley wrote:

The use of older function ptr calling style, (*fn)(), makes static
analysis more error-prone; replace with modern fn() style.

So make checkpatch emit a --strict test for that condition.

Update the unnecessary parentheses test for dereferencing
objects at the same time and create a $fix mechanism too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 24d6702..552e5dd 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3838,9 +3838,27 @@ sub process {
 # ie: &(foo->bar) should be &foo->bar and *(foo->bar) should be *foo->bar
 
 		while ($line =~ /(?:[^&]&\s*|\*)\(\s*($Ident\s*(?:$Member\s*)+)\s*\)/g) {
-			CHK("UNNECESSARY_PARENTHESES",
-			    "Unnecessary parentheses around $1\n" . $herecurr);
-		    }
+			my $var = $1;
+			if (CHK("UNNECESSARY_PARENTHESES",
+				"Unnecessary parentheses around $var\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$fixlinenr] =~ s/\(\s*\Q$var\E\s*\)/$var/;
+			}
+		}
+
+# check for unnecessary parentheses around function pointer uses
+# ie: (foo->bar)(); should be foo->bar();
+# but not "if (foo->bar) (" to avoid some false positives
+		if ($line =~ /(\bif\s*|)(\(\s*$Ident\s*(?:$Member\s*)+\))[ \t]*\(/ && $1 !~ /^if/) {
+			my $var = $2;
+			if (CHK("UNNECESSARY_PARENTHESES",
+				"Unnecessary parentheses around function pointer $var\n" . $herecurr) &&
+			    $fix) {
+				my $var2 = deparenthesize($var);
+				$var2 =~ s/\s//g;
+				$fixed[$fixlinenr] =~ s/\Q$var\E/$var2/;
+			}
+		}
 
 #goto labels aren't indented, allow a single space however
 		if ($line=~/^.\s+[A-Za-z\d_]+:(?![0-9]+)/ and


