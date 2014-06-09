Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750842AbaFIEL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 00:11:29 -0400
Received: from smtprelay0227.hostedemail.com ([216.40.44.227]:47520 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750720AbaFIELZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 00:11:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3653:3865:3866:3868:3870:3871:4321:4823:5007:7652:7903:7904:10004:10400:10848:11658:11914:12043:12296:12438:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: gate05_c330c7e90a2c
X-Filterd-Recvd-Size: 2132
Message-ID: <1402287082.9150.7.camel@joe-AO725>
Subject: [PATCH] checkpatch: warn on unnecessary else after return or break
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Sun, 08 Jun 2014 21:11:22 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using an else following a break or return can unnecessarily
indent code blocks.

ie:
	for (i = 0; i < 100; i++) {
		int foo = bar();
		if (foo < 1)
			break;
		else
			usleep(1);
	}

is generally better written as:

	for (i = 0; i < 100; i++) {
		int foo = bar();
		if (foo < 1)
			break;
		usleep(1);
	}

Warn when a bare else statement is preceded by a
break or return indented 1 tab more than the else.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 010b18e..9059fd0 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2342,6 +2342,16 @@ sub process {
 # check we are in a valid C source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c)$/);
 
+# check indentation of any line with a bare else
+# if the previous line is a break or return and is indented 1 tab more...
+		if ($sline =~ /^\+([\t]+)(?:}[ \t]*)?else(?:[ \t]*{)?\s*$/) {
+			my $tabs = length($1) + 1;
+			if ($prevline =~ /^\+\t{$tabs,$tabs}(?:break|return)\b/) {
+				WARN("UNNECESSARY_ELSE",
+				     "else is not generally useful after a break or return\n" . $hereprev);
+			}
+		}
+
 # discourage the addition of CONFIG_EXPERIMENTAL in #if(def).
 		if ($line =~ /^\+\s*\#\s*if.*\bCONFIG_EXPERIMENTAL\b/) {
 			WARN("CONFIG_EXPERIMENTAL",


