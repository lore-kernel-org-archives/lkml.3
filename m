Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934231AbaHZJhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:37:05 -0400
Received: from mail.eperm.de ([89.247.134.16]:46934 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932497AbaHZJhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:37:02 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] DRBG: fix maximum value checks on 32 bit systems
Date: Tue, 26 Aug 2014 11:36:54 +0200
Message-ID: <1471416.zGlxQVbHUr@myon.chronox.de>
User-Agent: KMail/4.13.3 (Linux/3.15.10-200.fc20.x86_64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20140826085853.GA4646@gondor.apana.org.au>
References: <20140826161456.7ad100e3@canb.auug.org.au> <2049245.HpByroTSUp@myon.chronox.de> <20140826085853.GA4646@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 26. August 2014, 16:58:53 schrieb Herbert Xu:

Hi Herbert,

> On Tue, Aug 26, 2014 at 10:52:45AM +0200, Stephan Mueller wrote:
> > Am Dienstag, 26. August 2014, 16:43:43 schrieb Herbert Xu:
> > 
> > Hi Herbert,
> > 
> > > On Tue, Aug 26, 2014 at 10:29:45AM +0200, Stephan Mueller wrote:
> > > > The maximum values for additional input string or generated blocks is
> > > > larger than 1<<32. To ensure a sensible value on 32 bit systems,
> > > > return
> > > > SIZE_MAX on 32 bit systems. This value is lower than the maximum
> > > > allowed values defined in SP800-90A. The standard allow lower maximum
> > > > values, but not larger values.
> > > > 
> > > > SIZE_MAX - 1 is used for drbg_max_addtl to allow
> > > > drbg_healthcheck_sanity to check the enforcement of the variable
> > > > without wrapping.
> > > 
> > > This is really ugly but OK.  However, I'm not sure how the sanity
> > > check ever worked.  It would appear that the drbg_generate call in
> > > drbg_healthcheck_sanity should always fail because you explicitly
> > > set addtl->len to drbg_max_addtl + 1, which should trigger the
> > > "DRBG: additional information string too long" error, no?
> > 
> > That is exactly what the test shall do: the test is intended to check
> > whether the maximum values are enforced. And it does that by checking
> > whether an error is returned.
> 
> OK that makes sense.  Patch applied.  Thanks!

I am wondering about the current code in Linus' tree though considering the 
applied patch:

Linus' code contains:

static inline size_t drbg_max_addtl(struct drbg_state *drbg)
{
        return (1UL<<(drbg->core->max_addtllen));
}

static inline size_t drbg_max_requests(struct drbg_state *drbg)
{
        return (1UL<<(drbg->core->max_req));
}

The max_addtllen and max_req are defined in drbg_cores[] in crypto/drbg.c for 
each DRBG type. As size_t on a 32 bit system is 32 bit the bit shifts would 
not work either.

Thus, I am wondering whether the just applied patch would need to go to Linus 
tree too? I would think that the following patch would be in order:

static inline size_t drbg_max_addtl(struct drbg_state *drbg)
{
#if (__BITS_PER_LONG == 32)
        return (SIZE_MAX - 1);
#else
        return (1UL<<(drbg->core->max_addtllen));
#endif
}

static inline size_t drbg_max_requests(struct drbg_state *drbg)
{
#if (__BITS_PER_LONG == 32)
        return SIZE_MAX;
#else
        return (1UL<<(drbg->core->max_req));
#endif
}


-- 
Ciao
Stephan
