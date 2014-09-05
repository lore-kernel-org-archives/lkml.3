Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144AbaIELZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 07:25:39 -0400
Received: from mail.eperm.de ([89.247.134.16]:47019 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478AbaIELZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 07:25:38 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] DRBG: remove check for uninitialized DRBG handle
Date: Fri, 05 Sep 2014 13:25:29 +0200
Message-ID: <8982542.15qJOCEf3S@tauon>
User-Agent: KMail/4.13.3 (Linux/3.15.10-200.fc20.x86_64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20140905075549.GA13225@gondor.apana.org.au>
References: <20140826161456.7ad100e3@canb.auug.org.au> <8246803.Qk7EMfoFYT@myon.chronox.de> <20140905075549.GA13225@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 5. September 2014, 15:55:49 schrieb Herbert Xu:

Hi Herbert,

>On Thu, Sep 04, 2014 at 01:50:32AM +0200, Stephan Mueller wrote:
>> Am Donnerstag, 4. September 2014, 07:21:29 schrieb Herbert Xu:
>> 
>> Hi Herbert,
>> 
>> > On Wed, Sep 03, 2014 at 03:33:16AM +0200, Stephan Mueller wrote:
>> > > Am Montag, 1. September 2014, 07:11:20 schrieb Stephan Mueller:
>> > > 
>> > > Hi Herbert,
>> > > 
>> > > may I ask for consideration of this patch as this covers an oops
>> > > FIPS
>> > > mode?
>> > > 
>> > > In addition, may I ask for guidance on how to fix the 32 bit code
>> > > path in Linus' tree as asked on 28.8? To quote: "Thus, the fix
>> > > in
>> > > b9347aff91ce4789619168539f08202d8d6a1177 works. However, this
>> > > patch is based on 05c81ccd9087d238c10b234eadb55632742e5518. So,
>> > > if we want to fix Linus' tree with minimal impact, either these
>> > > two patches are pushed to Linus or I have to port
>> > > b9347aff91ce4789619168539f08202d8d6a1177 to the current Linus
>> > > tree."
>> > 
>> > I will take care of this.
>> 
>> Thank you.
>
>Here is the patch I will add for 3.17:
>
>commit fb38ab4cd05e11184fd2c3ef916fa106ecc505fc
>Author: Herbert Xu <herbert@gondor.apana.org.au>
>Date:   Fri Sep 5 15:52:28 2014 +0800
>
>    crypto: drbg - backport "fix maximum value checks on 32 bit
>systems"
>
>    This is a backport of commit
>b9347aff91ce4789619168539f08202d8d6a1177. This backport is needed as
>without it the code will crash on 32-bit systems.

The kernel / module will not crash, It will simply refuse to work by 
always returning an error. I have tested the 3.17-rc1 code on 32 bit 
which returned always the error unless I apply this patch.
>
>    The maximum values for additional input string or generated blocks
>is larger than 1<<32. To ensure a sensible value on 32 bit systems,
>return SIZE_MAX on 32 bit systems. This value is lower than the
>maximum allowed values defined in SP800-90A. The standard allow lower
>maximum values, but not larger values.
>
>    SIZE_MAX - 1 is used for drbg_max_addtl to allow
>    drbg_healthcheck_sanity to check the enforcement of the variable
>    without wrapping.
>
>    Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
>    Reported-by: kbuild test robot <fengguang.wu@intel.com>
>    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
>diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
>index 831d786..882675e 100644
>--- a/include/crypto/drbg.h
>+++ b/include/crypto/drbg.h
>@@ -162,12 +162,25 @@ static inline size_t
>drbg_max_request_bytes(struct drbg_state *drbg)
>
> static inline size_t drbg_max_addtl(struct drbg_state *drbg)
> {
>+#if (__BITS_PER_LONG == 32)
>+	/*
>+	 * SP800-90A allows smaller maximum numbers to be returned -- we
>+	 * return SIZE_MAX - 1 to allow the verification of the 
enforcement
>+	 * of this value in drbg_healthcheck_sanity.
>+	 */
>+	return (SIZE_MAX - 1);
>+#else
> 	return (1UL<<(drbg->core->max_addtllen));
>+#endif
> }
>
> static inline size_t drbg_max_requests(struct drbg_state *drbg)
> {
>+#if (__BITS_PER_LONG == 32)
>+	return SIZE_MAX;
>+#else
> 	return (1UL<<(drbg->core->max_req));
>+#endif
> }
>
> /*
>
>Cheers,

Thank you very much!

Acked-by: Stephan Mueller <smueller@chronox.de>


Ciao
Stephan
