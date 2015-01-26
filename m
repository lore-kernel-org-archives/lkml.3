Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbbAZE0j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 23:26:39 -0500
Received: from mail.eperm.de ([89.247.134.16]:60121 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbbAZE0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 23:26:38 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH v11 1/2] crypto: AF_ALG: add AEAD support
Date: Mon, 26 Jan 2015 05:26:33 +0100
Message-ID: <1526868.qaVuSjCOn7@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.8-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20150125235550.GB18212@gondor.apana.org.au>
References: <1923793.K38mGRD6eo@tachyon.chronox.de> <6238416.vGUni1CI4i@tachyon.chronox.de> <20150125235550.GB18212@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 26. Januar 2015, 10:55:50 schrieb Herbert Xu:

Hi Herbert,

> On Wed, Jan 21, 2015 at 02:19:17AM +0100, Stephan Mueller wrote:
> > +		/* use the existing memory in an allocated page */
> > +		if (ctx->merge) {
> > +			sg = sgl->sg + sgl->cur - 1;
> > +			len = min_t(unsigned long, len,
> > +				    PAGE_SIZE - sg->offset - sg->length);
> > +			err = memcpy_from_msg(page_address(sg_page(sg)) +
> > +					      sg->offset + sg->length,
> > +					      msg, len);
> > +			if (err)
> > +				goto unlock;
> > +
> > +			sg->length += len;
> > +			ctx->merge = (sg->offset + sg->length) &
> > +				     (PAGE_SIZE - 1);
> > +
> > +			ctx->used += len;
> > +			copied += len;
> > +			size -= len;
> 
> Need to add a continue here to recheck size != 0.

Why would that be needed?

When size is still != 0 (i.e. the existing buffer is completely filled, we 
have still some remaining data), we fall through to the while loop that 
generates a new buffer.

If we add a continue here, we start the next iteration in the outer while loop 
which again checks for the merging of data in an existing buffer. As this 
merging will never happen as we filled that buffer completely in the previous 
loop, we always will fall through to the inner while loop. Thus, not having 
the check for size != 0 is functional identical to having it (besides, it is 
more efficient to not having it). 

Note, this case is triggered in my tests, where I use sendmsg with first a 
small buffer, followed by a large buffer. And I still can send 65536 bytes to 
the kernel.

-- 
Ciao
Stephan
