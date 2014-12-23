Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbaLWIOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 03:14:55 -0500
Received: from mail.eperm.de ([89.247.134.16]:50995 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754896AbaLWIOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 03:14:49 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v5 3/8] crypto: AF_ALG: add AEAD support
Date: Tue, 23 Dec 2014 09:14:43 +0100
Message-ID: <101382546.xjTjAHLGAb@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.7-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20141222112341.GA19532@gondor.apana.org.au>
References: <56740432.V2v4gLHrzS@tachyon.chronox.de> <3151022.sz5v21Vqeg@tachyon.chronox.de> <20141222112341.GA19532@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 22. Dezember 2014, 22:23:41 schrieb Herbert Xu:

Hi Herbert,

> On Sun, Dec 07, 2014 at 11:22:30PM +0100, Stephan Mueller wrote:
> > +static inline bool aead_sufficient_data(struct aead_ctx *ctx)
> > +{
> > +	unsigned as = crypto_aead_authsize(crypto_aead_reqtfm(&ctx-
>aead_req));
> > +
> > +	return (ctx->used >= (ctx->aead_assoclen + ctx->enc ? : as ));
> 
> Is this supposed to be
> 
> 	return (ctx->used >= (ctx->aead_assoclen + (ctx->enc ?: as)));

Thanks, will be fixed in the next iteration
> 
> > +static int aead_recvmsg(struct kiocb *unused, struct socket *sock,
> > +			    struct msghdr *msg, size_t ignored, int flags)
> > +{
> 
> ...
> 
> > +	err = -ENOMEM;
> > +	if (!aead_sufficient_data(ctx))
> > +		goto unlock;
> 
> You should just block if there is insufficient input.
> 
I do not concur here due to the following:

- the check aead_readable() immediately before this check implements the 
blocking if we do not have sufficient data *and* more data is to be expected

- this very check for aead_sufficient_data() comes into play if the caller 
does not have more data (i.e. ctx->more is zero). In this case, more data is 
not to be expected and we cannot wait as this would be a deadlock in user 
space.

-- 
Ciao
Stephan
