Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375AbaIEH4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:56:43 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:41595 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353AbaIEH4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:56:41 -0400
Date: Fri, 5 Sep 2014 15:55:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] DRBG: remove check for uninitialized DRBG handle
Message-ID: <20140905075549.GA13225@gondor.apana.org.au>
References: <20140826161456.7ad100e3@canb.auug.org.au>
 <3575659.BooajjTQie@myon.chronox.de>
 <20140903232129.GA32264@gondor.apana.org.au>
 <8246803.Qk7EMfoFYT@myon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8246803.Qk7EMfoFYT@myon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 01:50:32AM +0200, Stephan Mueller wrote:
> Am Donnerstag, 4. September 2014, 07:21:29 schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > On Wed, Sep 03, 2014 at 03:33:16AM +0200, Stephan Mueller wrote:
> > > Am Montag, 1. September 2014, 07:11:20 schrieb Stephan Mueller:
> > > 
> > > Hi Herbert,
> > > 
> > > may I ask for consideration of this patch as this covers an oops FIPS
> > > mode?
> > > 
> > > In addition, may I ask for guidance on how to fix the 32 bit code path in
> > > Linus' tree as asked on 28.8? To quote: "Thus, the fix in
> > > b9347aff91ce4789619168539f08202d8d6a1177 works. However, this
> > > patch is based on 05c81ccd9087d238c10b234eadb55632742e5518. So, if we want
> > > to fix Linus' tree with minimal impact, either these two patches are
> > > pushed to Linus or I have to port
> > > b9347aff91ce4789619168539f08202d8d6a1177 to the current Linus tree."
> > 
> > I will take care of this.
> 
> Thank you.

Here is the patch I will add for 3.17:

commit fb38ab4cd05e11184fd2c3ef916fa106ecc505fc
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Sep 5 15:52:28 2014 +0800

    crypto: drbg - backport "fix maximum value checks on 32 bit systems"
    
    This is a backport of commit b9347aff91ce4789619168539f08202d8d6a1177.
    This backport is needed as without it the code will crash on 32-bit
    systems.
    
    The maximum values for additional input string or generated blocks is
    larger than 1<<32. To ensure a sensible value on 32 bit systems, return
    SIZE_MAX on 32 bit systems. This value is lower than the maximum
    allowed values defined in SP800-90A. The standard allow lower maximum
    values, but not larger values.
    
    SIZE_MAX - 1 is used for drbg_max_addtl to allow
    drbg_healthcheck_sanity to check the enforcement of the variable
    without wrapping.
    
    Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Reported-by: kbuild test robot <fengguang.wu@intel.com>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index 831d786..882675e 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -162,12 +162,25 @@ static inline size_t drbg_max_request_bytes(struct drbg_state *drbg)
 
 static inline size_t drbg_max_addtl(struct drbg_state *drbg)
 {
+#if (__BITS_PER_LONG == 32)
+	/*
+	 * SP800-90A allows smaller maximum numbers to be returned -- we
+	 * return SIZE_MAX - 1 to allow the verification of the enforcement
+	 * of this value in drbg_healthcheck_sanity.
+	 */
+	return (SIZE_MAX - 1);
+#else
 	return (1UL<<(drbg->core->max_addtllen));
+#endif
 }
 
 static inline size_t drbg_max_requests(struct drbg_state *drbg)
 {
+#if (__BITS_PER_LONG == 32)
+	return SIZE_MAX;
+#else
 	return (1UL<<(drbg->core->max_req));
+#endif
 }
 
 /*

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
