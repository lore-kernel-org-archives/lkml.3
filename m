Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab3LDNrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 08:47:53 -0500
Received: from smtprelay0231.hostedemail.com ([216.40.44.231]:35550 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754895Ab3LDNrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:47:52 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3315:3353:3865:3866:3867:3868:3870:3871:3873:3874:4321:5007:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12555:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Cus
X-HE-Tag: rule50_7e72a915dd83d
X-Filterd-Recvd-Size: 2955
Message-ID: <1386164867.30493.70.camel@joe-AO722>
Subject: [PATCH -next] checkpatch: Warn only on "space before semicolon" at
 end of line
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Aldo Iljazi <mail@aldo.io>, Samuel Thibault <samuel.thibault@ens-lyon.org>,
        w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@reisers.ca,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Date: Wed, 04 Dec 2013 05:47:47 -0800
In-Reply-To: <20131204082137.GR5443@mwanda>
References: <1386101283-14650-1-git-send-email-mail@aldo.io>
	 <20131203221703.GE8138@type> <20131204043515.GB6909@linux>
	 <20131204073824.GP28413@mwanda> <1386143115.30493.48.camel@joe-AO722>
	 <20131204082137.GR5443@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "space before a non-naked semicolon" test has
unwanted output when used in "for ( ;; )" loops.

Make the test work only on end-of-line statement
termination semicolons.

Signed-off-by: Joe Perches <joe@perches.com>
---
On Wed, 2013-12-04 at 11:21 +0300, Dan Carpenter wrote:
> You and I generally agree on style preferences...

True, and I think that's a good thing.

> I think the warning
> should be limited to grep " ;$".

Look at the output of:

$ git grep " ;" -- "*.[ch]"  | grep -w for
...

The "| wc -l" output above in -next is
1407

Which of those should not be warned on?

$ git grep " ;" -- "*.[ch]"  | grep -P "\bfor\s*\(\s+;" | wc -l
211

I think all of the uses like "for ( ; expression;  expression)"
are unbalanced and should be avoided.

<I go off and look at checkpatch output>

Oh.  checkpatch doesn't complain about spacing around
semicolon with for loops here.  This error is a separate
test that looks only for space before semicolon.

So, we agree after all.

This test should look only for space before end-of-statement
semicolons at EOL.

This has still has false positives with multi-line fors like:

	for ( ; expression ;
	     expression);

 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 38be5d5..d26eac6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3131,7 +3131,7 @@ sub process {
 		}
 
 # check for whitespace before a non-naked semicolon
-		if ($line =~ /^\+.*\S\s+;/) {
+		if ($line =~ /^\+.*\S\s+;\s*$/) {
 			if (WARN("SPACING",
 				 "space prohibited before semicolon\n" . $herecurr) &&
 			    $fix) {


