Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbbAEKrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:47:06 -0500
Received: from mail.eperm.de ([89.247.134.16]:59361 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbbAEKrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:47:01 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        ABI/API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v7 1/2] crypto: AF_ALG: add AEAD support
Date: Mon, 05 Jan 2015 11:46:50 +0100
Message-ID: <6798882.ly1QjqTYep@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.7-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20150105103159.GA24878@gondor.apana.org.au>
References: <6964260.mNa1jtPz7Z@tachyon.chronox.de> <1609020.xcc11L81HZ@tachyon.chronox.de> <20150105103159.GA24878@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 5. Januar 2015, 21:31:59 schrieb Herbert Xu:

Hi Herbert,

> On Fri, Jan 02, 2015 at 03:41:33PM +0100, Stephan Mueller wrote:
> > +		if (!con.aead_assoclen)
> > +			return -EINVAL;
> 
> AD being zero should be fine.

Ok, removed.
> 
> > +		/* aead_recvmsg limits the maximum AD size to one page */
> > +		if (con.aead_assoclen > PAGE_SIZE)
> > +			return -E2BIG;
> 
> I don't see any need to limit the size of the AD.

The need for that check lies in aead_recvmsg:

        /*
         * first chunk of input is AD -- one scatterlist entry is one page,
         * and we process only one scatterlist, the maximum size of AD is
         * one page
         */
        sg_init_table(&assoc, 1);
        sg_set_page(&assoc, sg_page(sg), ctx->aead_assoclen, sg->offset);
        aead_request_set_assoc(&ctx->aead_req, &assoc, ctx->aead_assoclen);

There you see that I only create an sg table with one entry for the AD. If we 
would allow an arbitrary AD size, I would see the need of a for loop in 
addition to the one directly beneath this AD scatterlist setting: one for 
identifying how many sg entries I need to allocate and one for the actual 
assignment.

As I felt that one page should be sufficient for the AD, I wanted to avoid the 
extra overhead for another for loop.
> 
> Cheers,


-- 
Ciao
Stephan
