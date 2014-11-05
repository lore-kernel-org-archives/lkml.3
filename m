Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbaKEBpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 20:45:23 -0500
Received: from smtprelay0033.hostedemail.com ([216.40.44.33]:50218 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752037AbaKEBpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 20:45:21 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:973:982:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3653:3865:3866:3867:3868:3870:3871:3872:4250:5007:6119:6120:6261:8957:10004:10400:10848:11026:11232:11473:11658:11914:12043:12517:12519:12555:13069:13095:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: guide04_85e1583b1003d
X-Filterd-Recvd-Size: 1983
Message-ID: <1415151918.6634.3.camel@perches.com>
Subject: [RFC PATCH] checkpatch: add --strict "pointer comparison to NULL"
 test
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 04 Nov 2014 17:45:18 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems there are more and more uses of "if (!ptr)"
in preference to "if (ptr == NULL)" so add a --strict
test to emit a message when using the latter form.

This also finds (ptr != NULL).

Fix it too if desired.

---

Anyone think this is useful?

 scripts/checkpatch.pl | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 24d6702..d4e08bc 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4490,6 +4490,20 @@ sub process {
 			     "Possible precedence defect with mask then right shift - may need parentheses\n" . $herecurr);
 		}
 
+# check for pointer comparisons to NULL
+		if ($^V && $^V ge 5.10.0) {
+			while ($line =~ /\b$LvalOrFunc\s*(==|\!=)\s*NULL\b/g) {
+				my $val = $1;
+				my $equal = "!";
+				$equal = "" if ($4 eq "!=");
+				if (CHK("COMPARISON_TO_NULL",
+					"Comparison to NULL could be written \"${equal}${val}\"\n" . $herecurr) &&
+					    $fix) {
+					$fixed[$fixlinenr] =~ s/\b\Q$val\E\s*(?:==|\!=)\s*NULL\b/$equal$val/;
+				}
+			}
+		}
+
 # check for bad placement of section $InitAttribute (e.g.: __initdata)
 		if ($line =~ /(\b$InitAttribute\b)/) {
 			my $attr = $1;


