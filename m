Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbaCBMGu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 07:06:50 -0500
Received: from smtprelay0041.hostedemail.com ([216.40.44.41]:46844 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751743AbaCBMGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 07:06:48 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3354:3653:3865:3866:3867:3868:3870:3871:3874:4250:4321:5007:7652:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12266:12295:12438:12517:12519:12555:12663:12740:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: gun93_f647668a143
X-Filterd-Recvd-Size: 3342
Message-ID: <1393762005.13719.13.camel@joe-AO722>
Subject: Re: [iio:togreg 3/3] WARNING: Reusing the krealloc arg is almost
 always a bug
From: Joe Perches <joe@perches.com>
To: Lars-Peter Clausen <lars@metafoo.de>, Andy Whitcroft <apw@shadowen.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jonathan Cameron <jic23@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 02 Mar 2014 04:06:45 -0800
In-Reply-To: <5312F5BC.7080607@metafoo.de>
References: <53124ca5.kw+3caZ7enyrhSmq%fengguang.wu@intel.com>
	 <20140302022404.GA16141@localhost> <5312F5BC.7080607@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Andy Whitcroft to cc's)

On Sun, 2014-03-02 at 10:11 +0100, Lars-Peter Clausen wrote:
> On 03/02/2014 03:24 AM, Fengguang Wu wrote:
> >
> > Hi Lars-Peter,
> >
> > FYI, there are new warnings show up in
> >
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git togreg
> > head:   bdc8cda1d010887c06bd8c29564b74cd61ec0a7b
> > commit: bdc8cda1d010887c06bd8c29564b74cd61ec0a7b [3/3] iio:adc: Add Xilinx XADC driver
> >
> > scripts/checkpatch.pl 0001-iio-adc-Add-Xilinx-XADC-driver.patch
> > # many are suggestions rather than must-fix
> > WARNING: Reusing the krealloc arg is almost always a bug
> > #1220: drivers/iio/adc/xilinx-xadc-core.c:1138:
> > +	indio_dev->channels = krealloc(channels, sizeof(*channels) *
> >
> 
> This is actually a false positive, checkpatch thinks that 
> 'indio_dev->channels' and 'channels' is the same. Added Joe to Cc.

Yeah.  perl finds an $Lval match for either
foo->bar and bar for

	foo->bar = krealloc(bar, 1, GFP_KERNEL);
	bar = krealloc(bar, 1, GFP_KERNEL);

I can't think of a "pretty" perl way to fix this
because I'm not much of a perl guy, but maybe this
patch below works well enough.

Find all the lvals when there's a possible krealloc
reuse.  Check the lvals before and after the krealloc.
Bleat if they not equal.

Andy?  Got any better idea?

---
 scripts/checkpatch.pl | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 91308be..7391e01 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4275,9 +4275,15 @@ sub process {
 
 # check for krealloc arg reuse
 		if ($^V && $^V ge 5.10.0 &&
-		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*krealloc\s*\(\s*\1\s*,/) {
-			WARN("KREALLOC_ARG_REUSE",
-			     "Reusing the krealloc arg is almost always a bug\n" . $herecurr);
+		    $line =~ /($Lval)\s*\=\s*(?:$balanced_parens)?\s*krealloc\s*\(\s*\1\s*,/) {
+			my @line_lvals = $line =~ m/$Lval/g;
+			for my $index (1 .. $#line_lvals - 1) {
+				if ($line_lvals[$index] eq "krealloc" &&
+				    $line_lvals[$index - 1] eq $line_lvals[$index + 1]) {
+					WARN("KREALLOC_ARG_REUSE",
+					     "Reusing the krealloc arg is almost always a bug\n" . $herecurr);
+				}
+			}
 		}
 
 # check for alloc argument mismatch


