Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbbAKTuH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 14:50:07 -0500
Received: from smtprelay0180.hostedemail.com ([216.40.44.180]:43507 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750767AbbAKTuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 14:50:05 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3653:3865:3866:3867:3870:3871:3872:4321:4605:5007:6261:8957:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12555:12740:13069:13161:13229:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rain69_7478c5a4de419
X-Filterd-Recvd-Size: 2532
Message-ID: <1421005797.9233.3.camel@perches.com>
Subject: [PATCH] checkpatch: Add likely/unlikely comparison misuse test
From: Joe Perches <joe@perches.com>
To: Christoph Jaeger <cj@linux.com>, Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Cc: Alan <alan@linux.intel.com>, davem@davemloft.net, willemb@google.com,
        edumazet@google.com, dborkman@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 11 Jan 2015 11:49:57 -0800
In-Reply-To: <20150111193404.GN1513@betelgeuse.hsd1.ma.comcast.net>
References: <1420999276-28225-1-git-send-email-cj@linux.com>
	 <1421002345.9233.1.camel@perches.com>
	 <20150111193404.GN1513@betelgeuse.hsd1.ma.comcast.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a test for probably likely/unlikely misuses where
the comparison is likely misplaced

	if (likely(foo) > 0)
vs
	if (likely(foo > 0))

Signed-off-by: Joe Perches <joe@perches.com>
---
On Sun, 2015-01-11 at 14:34 -0500, Christoph Jaeger wrote:
> > drivers/platform/goldfish/goldfish_pipe.c:285:	if (unlikely(bufflen) == 0)
> 
> Well, the conditional statement works as intended. Of course, the branch
> prediction doesn't.
> 
> Coccinelle should be able to check for this kind of likely()/unlikely() usage,
> shouldn't it?

Most likely,  checkpatch could too, but not as well.
This misuse isn't very common. (2 in current source?)

 scripts/checkpatch.pl | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 6afc24b..b8d47dc 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -5219,6 +5219,13 @@ sub process {
 			      "#define of '$1' is wrong - use Kconfig variables or standard guards instead\n" . $herecurr);
 		}
 
+# likely/unlikely comparisons similar to "(likely(foo) > 0)"
+		if ($^V && $^V ge 5.10.0 &&
+		    $line =~ /\b((?:un)?likely)\s*\(\s*$FuncArg\s*\)\s*$Compare/) {
+			WARN("LIKELY_MISUSE",
+			     "Using $1 should generally have parentheses around the comparison\n" . $herecurr);
+		}
+
 # whine mightly about in_atomic
 		if ($line =~ /\bin_atomic\s*\(/) {
 			if ($realfile =~ m@^drivers/@) {


