Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbbAZEcb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 23:32:31 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:55843 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbbAZEc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 23:32:29 -0500
Date: Mon, 26 Jan 2015 15:32:18 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH v11 1/2] crypto: AF_ALG: add AEAD support
Message-ID: <20150126043218.GA20911@gondor.apana.org.au>
References: <1923793.K38mGRD6eo@tachyon.chronox.de>
 <6238416.vGUni1CI4i@tachyon.chronox.de>
 <20150125235550.GB18212@gondor.apana.org.au>
 <1526868.qaVuSjCOn7@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1526868.qaVuSjCOn7@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 05:26:33AM +0100, Stephan Mueller wrote:
> Am Montag, 26. Januar 2015, 10:55:50 schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > On Wed, Jan 21, 2015 at 02:19:17AM +0100, Stephan Mueller wrote:
> > > +		/* use the existing memory in an allocated page */
> > > +		if (ctx->merge) {
> > > +			sg = sgl->sg + sgl->cur - 1;
> > > +			len = min_t(unsigned long, len,
> > > +				    PAGE_SIZE - sg->offset - sg->length);
> > > +			err = memcpy_from_msg(page_address(sg_page(sg)) +
> > > +					      sg->offset + sg->length,
> > > +					      msg, len);
> > > +			if (err)
> > > +				goto unlock;
> > > +
> > > +			sg->length += len;
> > > +			ctx->merge = (sg->offset + sg->length) &
> > > +				     (PAGE_SIZE - 1);
> > > +
> > > +			ctx->used += len;
> > > +			copied += len;
> > > +			size -= len;
> > 
> > Need to add a continue here to recheck size != 0.
> 
> Why would that be needed?
> 
> When size is still != 0 (i.e. the existing buffer is completely filled, we 
> have still some remaining data), we fall through to the while loop that 
> generates a new buffer.

Because when size == 0 you should exit the loop.  IOW if the new
data is completely merged you should get out and not continue.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
