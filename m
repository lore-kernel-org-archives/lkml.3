Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab3LZTUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 14:20:43 -0500
Received: from smtprelay0031.hostedemail.com ([216.40.44.31]:47804 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753879Ab3LZTUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 14:20:41 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:3138:3139:3140:3141:3142:3352:3653:3866:3867:5007:6119:6261:6642:7875:8957:10004:10026:10848:11658:11914:12043:12438:12517:12519:12555:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: death64_5d1e47cfc3f4d
X-Filterd-Recvd-Size: 2126
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] checkpatch: check for if's with unnecessary parentheses
Date: Thu, 26 Dec 2013 11:20:31 -0800
Message-Id: <c338a811bcaab4c3b684cf50575722af8d286865.1388085015.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1388085015.git.joe@perches.com>
References: <cover.1388085015.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If statements don't need multiple parentheses around tested
comparisons like "if ((foo == bar))".

An == comparison maybe a sign of an intended assignment,
so emit a slightly different message if so.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index db72b88..c12234e 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3322,6 +3322,20 @@ sub process {
 			}
 		}
 
+# if statements using unnecessary parentheses - ie: if ((foo == bar))
+		if ($^V && $^V ge 5.10.0 &&
+		    $line =~ /\bif\s*((?:\(\s*){2,})/) {
+			my $openparens = $1;
+			my $count = $openparens =~ tr@\(@\(@;
+			my $msg = "";
+			if ($line =~ /\bif\s*(?:\(\s*){$count,$count}$LvalOrFunc\s*($Compare)\s*$LvalOrFunc(?:\s*\)){$count,$count}/) {
+				my $comp = $4;	#Not $1 because of $LvalOrFunc
+				$msg = " - maybe == should be = ?" if ($comp eq "==");
+				WARN("UNNECESSARY_PARENTHESES",
+				     "Unnecessary parentheses$msg\n" . $herecurr);
+			}
+		}
+
 # Return of what appears to be an errno should normally be -'ve
 		if ($line =~ /^.\s*return\s*(E[A-Z]*)\s*;/) {
 			my $name = $1;
-- 
1.8.1.2.459.gbcd45b4.dirty

