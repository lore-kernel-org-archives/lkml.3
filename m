Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbaE1X3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:29:25 -0400
Received: from smtprelay0125.hostedemail.com ([216.40.44.125]:50140 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754948AbaE1X3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:29:24 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 64,4,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2332:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3653:3865:3867:3870:3874:4321:4605:5007:7652:8957:10004:10400:10848:11026:11473:11658:11914:12043:12291:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: slave01_6ef94744fcf53
X-Filterd-Recvd-Size: 2082
Message-ID: <1401319761.19335.21.camel@joe-AO725>
Subject: [PATCH] checkpatch: Prefer kstrto<foo> to sscanf(buf, "%<lhuidx>",
 &bar);
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 28 May 2014 16:29:21 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the kstrto<foo> functions in preference to sscanf.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 7774025..862cc7a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4314,6 +4314,27 @@ sub process {
 			     "unchecked sscanf return value\n" . "$here\n$stat_real\n");
 		}
 
+# check for simple sscanf that should be kstrto<foo>
+		if ($^V && $^V ge 5.10.0 &&
+		    defined $stat &&
+		    $line =~ /\bsscanf\b/) {
+			my $lc = $stat =~ tr@\n@@;
+			$lc = $lc + $linenr;
+			my $stat_real = raw_line($linenr, 0);
+		        for (my $count = $linenr + 1; $count <= $lc; $count++) {
+				$stat_real = $stat_real . "\n" . raw_line($count, 0);
+			}
+			if ($stat_real =~ /\bsscanf\b\s*\(\s*$FuncArg\s*,\s*("[^"]+")/) {
+				my $format = $6;
+				my $count = $format =~ tr@%@%@;
+				if ($count == 1 &&
+				    $format =~ /^"\%(?i:ll[udxi]|[udxi]ll|ll|[hl]h?[udxi]|[udxi][hl]h?|[hl]h?|[udxi])"$/) {
+					WARN("SSCANF_TO_KSTRTO",
+					     "Prefer kstrto<type> to single variable sscanf\n" . "$here\n$stat_real\n");
+				}
+			}
+		}
+
 # check for new externs in .h files.
 		if ($realfile =~ /\.h$/ &&
 		    $line =~ /^\+\s*(extern\s+)$Type\s*$Ident\s*\(/s) {


