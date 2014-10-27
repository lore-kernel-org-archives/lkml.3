Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaJ0FdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:33:11 -0400
Received: from smtprelay0174.hostedemail.com ([216.40.44.174]:49524 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750855AbaJ0FdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:33:10 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3653:3865:3866:3871:3874:4321:5007:6120:6261:7901:8957:10004:10400:10848:11026:11473:11658:11914:12043:12517:12519:12555:13069:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cloud27_8fc9839bb3a06
X-Filterd-Recvd-Size: 1770
Message-ID: <1414387986.15751.28.camel@perches.com>
Subject: [PATCH] checkpatch: Try to avoid mask and shift errors
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Sun, 26 Oct 2014 22:33:06 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shift has a higher precedence that mask so warn
when a mask then shift operation is done without
parentheses around the mask.

This test works well for a right shift, but the
left shift is pretty commonly done correctly so
only warn on the right shift.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d94f5d8..9b474d5 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4478,6 +4478,14 @@ sub process {
 			}
 		}
 
+# check for mask then right shift without a parentheses
+		if ($^V && $^V ge 5.10.0 &&
+		    $line =~ /$LvalOrFunc\s*\&\s*($LvalOrFunc)\s*>>/ &&
+		    $4 !~ /^\&/) { # $LvalOrFunc may be &foo, ignore if so
+			WARN("MASK_THEN_SHIFT",
+			     "Possible precedence defect with mask then right shift - may need parentheses\n" . $herecurr);
+		}
+
 # check for bad placement of section $InitAttribute (e.g.: __initdata)
 		if ($line =~ /(\b$InitAttribute\b)/) {
 			my $attr = $1;


