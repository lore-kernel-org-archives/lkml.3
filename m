Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaKGVPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 16:15:44 -0500
Received: from smtprelay0062.hostedemail.com ([216.40.44.62]:41657 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751822AbaKGVPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 16:15:43 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1461:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3653:3865:3868:3871:3874:4321:5007:6261:7903:10004:10400:10848:11658:11914:12043:12517:12519:12555:13069:13311:13357:13848:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: coach39_88f26ed929228
X-Filterd-Recvd-Size: 2087
Message-ID: <1415394939.23530.20.camel@perches.com>
Subject: [PATCH] checkpatch: Add --strict preference for #defines using
 BIT(foo)
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, jiri@resnulli.us,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 07 Nov 2014 13:15:39 -0800
In-Reply-To: <20141107.151607.480474516800359791.davem@davemloft.net>
References: <1415265610-9338-1-git-send-email-jiri@resnulli.us>
	 <1415265610-9338-10-git-send-email-jiri@resnulli.us>
	 <20141107.151607.480474516800359791.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using BIT(foo) and BIT_ULL(bar) is more common now.
Suggest using these macros over #defines with 1<<value.

Add a --fix option too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 893cbd5..b5dc3f4 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4973,6 +4973,17 @@ sub process {
 			}
 		}
 
+# check for #defines like: 1 << <digit> that could be BIT(digit)
+		if ($line =~ /#\s*define\s+\w+\s+\(?\s*1\s*([ulUL]*)\s*\<\<\s*(?:\d+|$Ident)\s*\)?/) {
+			my $ull = "";
+			$ull = "_ULL" if (defined($1) && $1 =~ /ll/i);
+			if (CHK("BIT_MACRO",
+				"Prefer using the BIT$ull macro\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$fixlinenr] =~ s/\(?\s*1\s*[ulUL]*\s*<<\s*(\d+|$Ident)\s*\)?/BIT${ull}($1)/;
+			}
+		}
+
 # check for case / default statements not preceded by break/fallthrough/switch
 		if ($line =~ /^.\s*(?:case\s+(?:$Ident|$Constant)\s*|default):/) {
 			my $has_break = 0;


