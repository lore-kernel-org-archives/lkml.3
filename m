Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaAUVvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:51:40 -0500
Received: from smtprelay0234.hostedemail.com ([216.40.44.234]:39732 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754554AbaAUVve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:51:34 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3653:3865:3872:3874:5007:7652:8957:10004:10400:10848:11026:11473:11658:11914:12043:12438:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rain28_d42cec951118
X-Filterd-Recvd-Size: 1838
Message-ID: <1390341089.31946.14.camel@joe-AO722>
Subject: [PATCH] checkpatch: Prefer ether_addr_copy to memcpy(foo, bar,
 ETH_ALEN)
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 21 Jan 2014 13:51:29 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ether_addr_copy was added for kernel version 3.14.
It's slightly smaller/faster for some arches.
Encourage its use.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index be53ba7..0ea2a1e 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4096,6 +4096,16 @@ sub process {
 			}
 		}
 
+# Check for memcpy(foo, bar, ETH_ALEN) that could be ether_addr_copy(foo, bar)
+		if ($^V && $^V ge 5.10.0 &&
+		    $line =~ /^\+(?:.*?)\bmemcpy\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*ETH_ALEN\s*\)/s) {
+			if (WARN("PREFER_ETHER_ADDR_COPY",
+				 "Prefer ether_addr_copy() over memcpy() if the Ethernet addresses are __aligned(2)\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~ s/\bmemcpy\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\,\s*ETH_ALEN\s*\)/ether_addr_copy($2, $7)/;
+			}
+		}
+
 # typecasts on min/max could be min_t/max_t
 		if ($^V && $^V ge 5.10.0 &&
 		    defined $stat &&


