Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaJBEIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 00:08:25 -0400
Received: from smtprelay0079.hostedemail.com ([216.40.44.79]:45581 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752435AbaJBEIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 00:08:24 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3653:3865:3866:3870:3874:4321:5007:6742:7652:8957:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12555:13069:13311:13357:13972:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: worm61_832da4b87121f
X-Filterd-Recvd-Size: 2306
Message-ID: <1412222900.3247.33.camel@joe-AO725>
Subject: [PATCH] checkpatch: Warn on logging functions with KERN_<LEVEL>
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul McQuade <paulmcquad@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, neilb@suse.de, sasha.levin@oracle.com,
        rientjes@google.com, hughd@google.com, paul.gortmaker@windriver.com,
        liwanp@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com,
        iamjoonsoo.kim@lge.com
Date: Wed, 01 Oct 2014 21:08:20 -0700
In-Reply-To: <20141001135055.c849d1a34e9c687775a40a0f@linux-foundation.org>
References: <1412195730-9629-1-git-send-email-paulmcquad@gmail.com>
	 <20141001135055.c849d1a34e9c687775a40a0f@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warn on probable misuses of logging functions with KERN_<LEVEL>
like pr_err(KERN_ERR "foo\n");

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Joe Perches <joe@perches.com>

---
> > -		printk(KERN_ERR "ksm: register sysfs failed\n");
> > +		pr_err(KERN_ERR "ksm: register sysfs failed\n");

> A quick grep indicates that we have the same mistake in tens of places.
> checkpatch rule, please?

 scripts/checkpatch.pl | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 52a223e..374abf4 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4447,6 +4447,17 @@ sub process {
 			}
 		}
 
+# check for logging functions with KERN_<LEVEL>
+		if ($line !~ /printk\s*\(/ &&
+		    $line =~ /\b$logFunctions\s*\(.*\b(KERN_[A-Z]+)\b/) {
+			my $level = $1;
+			if (WARN("UNNECESSARY_KERN_LEVEL",
+				 "Possible unnecessary $level\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$fixlinenr] =~ s/\s*$level\s*//;
+			}
+		}
+
 # check for bad placement of section $InitAttribute (e.g.: __initdata)
 		if ($line =~ /(\b$InitAttribute\b)/) {
 			my $attr = $1;


