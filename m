Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbaBDM7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 07:59:32 -0500
Received: from smtprelay0241.hostedemail.com ([216.40.44.241]:52931 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752927AbaBDM73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:59:29 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:421:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3653:3865:3866:3867:3870:3871:3872:3874:4250:4321:5007:7652:7875:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: key72_6f96aa4609748
X-Filterd-Recvd-Size: 3021
Message-ID: <1391518765.2538.18.camel@joe-AO722>
Subject: [PATCH] checkpatch: Add test for long udelay
From: Joe Perches <joe@perches.com>
To: Holger Schurig <holgerschurig@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Sujith Manoharan <sujith@msujith.org>,
        ath9k-devel <ath9k-devel@venema.h4ckr.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        John Linville <linville@tuxdriver.com>
Date: Tue, 04 Feb 2014 04:59:25 -0800
In-Reply-To: <CAOpc7mFQZ3efZda0cC28BLATqRDJ99BRNu=ezQq8wa+dyFyOvA@mail.gmail.com>
References: <1391483274-20331-1-git-send-email-sujith@msujith.org>
	 <1391483274-20331-2-git-send-email-sujith@msujith.org>
	 <1391484878.2538.11.camel@joe-AO722>
	 <21232.24855.201543.400943@gargle.gargle.HOWL>
	 <CAOpc7mFQZ3efZda0cC28BLATqRDJ99BRNu=ezQq8wa+dyFyOvA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-04 at 08:03 +0100, Holger Schurig wrote:
> The macro udelay
> cannot handle large values because of lost-of-precision.
> 
> IMHO udelay on ARM is broken, because it also cannot work with fast
> ARM processors (where bogomips >= 3355, which is in sight now). It's
> just not broken enought that someone did something against it ...   so
> the current kludge is good enought.

Until then, warn on long udelay uses.

Also fix uses of $line that should have been $herecurr.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 0ea2a1e..36275c5 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3912,10 +3912,15 @@ sub process {
 
 # prefer usleep_range over udelay
 		if ($line =~ /\budelay\s*\(\s*(\d+)\s*\)/) {
+			my $delay = $1;
 			# ignore udelay's < 10, however
-			if (! ($1 < 10) ) {
+			if (! ($delay < 10) ) {
 				CHK("USLEEP_RANGE",
-				    "usleep_range is preferred over udelay; see Documentation/timers/timers-howto.txt\n" . $line);
+				    "usleep_range is preferred over udelay; see Documentation/timers/timers-howto.txt\n" . $herecurr);
+			}
+			if ($delay > 2000) {
+				WARN("LONG_UDELAY",
+				     "long udelay - prefer mdelay; see arch/arm/include/asm/delay.h\n" . $herecurr);
 			}
 		}
 
@@ -3923,7 +3928,7 @@ sub process {
 		if ($line =~ /\bmsleep\s*\((\d+)\);/) {
 			if ($1 < 20) {
 				WARN("MSLEEP",
-				     "msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt\n" . $line);
+				     "msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt\n" . $herecurr);
 			}
 		}
 


