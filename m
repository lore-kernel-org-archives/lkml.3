Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbaGHT5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:57:47 -0400
Received: from smtprelay0081.hostedemail.com ([216.40.44.81]:38916 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753293AbaGHT5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:57:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3653:3865:3866:3868:3870:3871:4321:4823:5007:7652:10004:10400:10848:11232:11658:11914:12043:12296:12438:12517:12519:12555:13069:13161:13229:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stem91_4351bd5dfb402
X-Filterd-Recvd-Size: 2284
Message-ID: <1404849460.932.35.camel@joe-AO725>
Subject: [PATCH] checkpatch: Warn on break after goto or return with same
 tab indentation
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Fabian Frederick <fabf@skynet.be>
Cc: Antti Palosaari <crope@iki.fi>, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Date: Tue, 08 Jul 2014 12:57:40 -0700
In-Reply-To: <20140709041215.3e1083201f5a400c37b820b0@skynet.be>
References: <1404840181-29822-1-git-send-email-fabf@skynet.be>
	 <53BC3A0E.4060505@iki.fi>
	 <20140709041215.3e1083201f5a400c37b820b0@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using break; after a goto or return is unnecessary so
emit a warning when the break is at the same indent level.

So this emits a warning on:

	switch (foo) {
	case 1:
		goto err;
		break;
	}

but not on:

	switch (foo) {
	case 1:
		if (bar())
			goto err;
		break;
	}

Signed-off-by: Joe Perches <joe@perches.com>
---
> AFAIK there's still no automatic detection of those cases.

There can be now...

 scripts/checkpatch.pl | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 496f9ab..fc22f22 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2439,6 +2439,16 @@ sub process {
 			}
 		}
 
+# check indentation of a line with a break;
+# if the previous line is a goto or return and is indented the same # of tabs
+		if ($sline =~ /^\+([\t]+)break\s*;\s*$/) {
+			my $tabs = $1;
+			if ($prevline =~ /^\+$tabs(?:goto|return)\b/) {
+				WARN("UNNECESSARY_BREAK",
+				     "break is not useful after a goto or return\n" . $hereprev);
+			}
+		}
+
 # discourage the addition of CONFIG_EXPERIMENTAL in #if(def).
 		if ($line =~ /^\+\s*\#\s*if.*\bCONFIG_EXPERIMENTAL\b/) {
 			WARN("CONFIG_EXPERIMENTAL",


