Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaL2Rdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 12:33:52 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:55286 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaL2Rdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 12:33:50 -0500
Date: Tue, 30 Dec 2014 04:33:41 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v6 1/4] crypto: AF_ALG: add AEAD support
Message-ID: <20141229173340.GA15790@gondor.apana.org.au>
References: <5682082.ffPqvQlSqN@tachyon.chronox.de>
 <5002301.TQO37u96dE@tachyon.chronox.de>
 <20141229103319.GB13334@gondor.apana.org.au>
 <29582980.qoHS2EjmLy@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29582980.qoHS2EjmLy@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 04:05:40PM +0100, Stephan Mueller wrote:
>
> This would mean that the check must stay in recvmsg as only here we know that 
> the caller wants data to be processed.

On the send side you would do the check when MSG_MORE is unset.
On the receive side you should stop waiting only when ctx->more
is false and the send-side check succeeded.

Perhaps rename ctx->more to ctx->done and then you can use it
to indicate to the receive side that we're ready and have valid
data for it.  The receive side can then simply wait for ctx->done
to become true.

> > PS we should add a length check for missing/partial auth tags
> > to crypto_aead_decrypt.  We can then remove such checks from
> > individual implementations.
> 
> I agree in full here. Shall I create such a patch together with the AEAD 
> AF_ALG interface, or can we merge the AEAD without that patch now and create a 
> separate patch later?

We should at least add a check in crypto_aead_decrypt first so as
to guarantee nothing slips through.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
