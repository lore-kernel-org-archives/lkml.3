Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab3LCFof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 00:44:35 -0500
Received: from smtprelay0046.hostedemail.com ([216.40.44.46]:54899 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751912Ab3LCFoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 00:44:20 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3870:3871:3874:4605:5007:6119:7652:7808:7809:10004:10400:10848:11026:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:12663:12679:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stem39_42bd356dba95d
X-Filterd-Recvd-Size: 3144
Message-ID: <1386049457.15309.23.camel@joe-AO722>
Subject: [PATCH] checkpatch: More comprehensive split strings warning
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Date: Mon, 02 Dec 2013 21:44:17 -0800
In-Reply-To: <20131202213358.GA15802@jtriplet-mobl1>
References: <1386019438.2680.32.camel@joe-AO722>
	 <20131202213358.GA15802@jtriplet-mobl1>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current checkpatch test for split strings does
not find several cases that should be found.

For instance:

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
[]
@@ -1868,7 +1865,8 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 		/* Else poor success; go back to mode in "active" table */
 		} else {
 			IWL_DEBUG_RATE(mvm,
-				       "LQ: GOING BACK TO THE OLD TABLE suc=%d cur-tpt=%d old-tpt=%d\n",
+				       "GOING BACK TO THE OLD TABLE: SR %d "
+				       "cur-tpt %d old-tpt %d\n",
 				       window->success_ratio,
 				       window->average_tpt,
 				      lq_sta->last_tpt);

does not currently emit a warning.

Improve the test to find these cases.

Add more exceptions to reduce false positives for
assembly and octal/hex string constants.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 38be5d5..1d0d5ac 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2049,16 +2049,12 @@ sub process {
 		}
 
 # Check for user-visible strings broken across lines, which breaks the ability
-# to grep for the string.  Limited to strings used as parameters (those
-# following an open parenthesis), which almost completely eliminates false
-# positives, as well as warning only once per parameter rather than once per
-# line of the string.  Make an exception when the previous string ends in a
-# newline (multiple lines in one string constant) or \n\t (common in inline
-# assembly to indent the instruction on the following line).
+# to grep for the string.  Make exceptions when the previous string ends in a
+# newline (multiple lines in one string constant) or '\t', '\r', ';', or '{'
+# (common in inline assembly) or is a octal \123 or hexadecimal \xaf value
 		if ($line =~ /^\+\s*"/ &&
 		    $prevline =~ /"\s*$/ &&
-		    $prevline =~ /\(/ &&
-		    $prevrawline !~ /\\n(?:\\t)*"\s*$/) {
+		    $prevrawline !~ /(?:\\(?:[ntr]|[0-7]{1,3}|x[0-9a-fA-F]{1,2})|;\s*|\{\s*)"\s*$/) {
 			WARN("SPLIT_STRING",
 			     "quoted string split across lines\n" . $hereprev);
 		}


