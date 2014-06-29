Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbaF2Dx2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 23:53:28 -0400
Received: from smtprelay0217.hostedemail.com ([216.40.44.217]:38388 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751814AbaF2DxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 23:53:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3867:3870:3871:3872:3874:4250:4321:5007:6117:7558:7652:7903:10004:10400:10848:10967:11026:11232:11658:11914:12517:12519:12555:12740:13069:13311:13357:13972:14093:14097:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSB
X-HE-Tag: pain28_3682fb65e15
X-Filterd-Recvd-Size: 2857
Message-ID: <1404013999.9064.50.camel@joe-AO725>
Subject: Re: [PATCH 3/4] DRBG: Fix format string for debugging statements
From: Joe Perches <joe@perches.com>
To: Stephan Mueller <smueller@chronox.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        kbuild test robot <fengguang.wu@intel.com>, kbuild@01.org,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-crypto@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 28 Jun 2014 20:53:19 -0700
In-Reply-To: <4311965.FMe9YfRAnU@myon.chronox.de>
References: <4927386.WYHrRe3NJm@myon.chronox.de>
	 <10901956.0EDQunEZJL@myon.chronox.de>
	 <20140629122402.0fd014d8@canb.auug.org.au>
	 <4311965.FMe9YfRAnU@myon.chronox.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-06-29 at 05:46 +0200, Stephan Mueller wrote:
> Am Sonntag, 29. Juni 2014, 12:24:02 schrieb Stephen Rothwell:
> 
> Hi Stephen,
> 
> > Hi Stephan,
> > 
> > On Sat, 28 Jun 2014 22:01:46 +0200 Stephan Mueller <smueller@chronox.de> 
> wrote:
> > > @@ -1987,8 +1987,9 @@ static int __init drbg_init(void)
> > > 
> > >  	if (ARRAY_SIZE(drbg_cores) * 2 > ARRAY_SIZE(drbg_algs)) {
> > >  	
> > >  		pr_info("DRBG: Cannot register all DRBG types"
> > > 
> > > -			"(slots needed: %lu, slots available: %lu)\n",
> > > -			ARRAY_SIZE(drbg_cores) * 2, ARRAY_SIZE(drbg_algs));
> > > +			"(slots needed: %u, slots available: %u)\n",
> > > +			(unsigned int)ARRAY_SIZE(drbg_cores) * 2,
> > > +			(unsigned int)ARRAY_SIZE(drbg_algs));
> > 
> > Doesn't ARRAY_SIZE() always return a size_t?  In which case surely we
> > need no casts, but need to us %zu in the format string.
> 
> Unfortunately not at all. On my x86_64, I get the compiler warning that 
> ARRAY_SIZE is a long unsigned int without the cast.

This should fix that.
---
 include/linux/kernel.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 6e3d497..58bc57d 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -51,7 +51,8 @@
 #define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
 #define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
 
-#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
+#define ARRAY_SIZE(arr)						\
+	(sizeof(arr) / sizeof((arr)[0]) + (size_t)__must_be_array(arr))
 
 /*
  * This looks more complex than it should be. But we need to


