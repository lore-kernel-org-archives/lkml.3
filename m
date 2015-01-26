Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbbAZEjf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 23:39:35 -0500
Received: from mail.eperm.de ([89.247.134.16]:60136 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbbAZEjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 23:39:32 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH v11 1/2] crypto: AF_ALG: add AEAD support
Date: Mon, 26 Jan 2015 05:39:27 +0100
Message-ID: <1793732.EQDAUxrRn5@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.8-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20150126043218.GA20911@gondor.apana.org.au>
References: <1923793.K38mGRD6eo@tachyon.chronox.de> <1526868.qaVuSjCOn7@tachyon.chronox.de> <20150126043218.GA20911@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 26. Januar 2015, 15:32:18 schrieb Herbert Xu:

Hi Herbert,

> On Mon, Jan 26, 2015 at 05:26:33AM +0100, Stephan Mueller wrote:
> > Am Montag, 26. Januar 2015, 10:55:50 schrieb Herbert Xu:
> > 
> > Hi Herbert,
> > 
> > > On Wed, Jan 21, 2015 at 02:19:17AM +0100, Stephan Mueller wrote:
> > > > +		/* use the existing memory in an allocated page */
> > > > +		if (ctx->merge) {
> > > > +			sg = sgl->sg + sgl->cur - 1;
> > > > +			len = min_t(unsigned long, len,
> > > > +				    PAGE_SIZE - sg->offset - sg-
>length);
> > > > +			err = 
memcpy_from_msg(page_address(sg_page(sg)) +
> > > > +					      sg->offset + sg->length,
> > > > +					      msg, len);
> > > > +			if (err)
> > > > +				goto unlock;
> > > > +
> > > > +			sg->length += len;
> > > > +			ctx->merge = (sg->offset + sg->length) &
> > > > +				     (PAGE_SIZE - 1);
> > > > +
> > > > +			ctx->used += len;
> > > > +			copied += len;
> > > > +			size -= len;
> > > 
> > > Need to add a continue here to recheck size != 0.
> > 
> > Why would that be needed?
> > 
> > When size is still != 0 (i.e. the existing buffer is completely filled, we
> > have still some remaining data), we fall through to the while loop that
> > generates a new buffer.
> 
> Because when size == 0 you should exit the loop.  IOW if the new
> data is completely merged you should get out and not continue.

But does it really matter if we consider size == 0 or != at this point? In 
case size == 0, the len calculation before the inner while loop will return 0. 
Thus the inner while loop will not start. Thus, the current code will not run 
the inner loop and exit the outer loop in the next round. So, I am not sure I 
see the benefit from another check here.

-- 
Ciao
Stephan
