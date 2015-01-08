Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbbAHLJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 06:09:40 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:35862 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbbAHLJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 06:09:38 -0500
Date: Thu, 8 Jan 2015 22:09:31 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        Daniel Borkmann <dborkman@redhat.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v8 1/2] crypto: AF_ALG: add AEAD support
Message-ID: <20150108110931.GA8568@gondor.apana.org.au>
References: <33040723.pAXIT3fl8h@tachyon.chronox.de>
 <6260799.4x68Msg3Li@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6260799.4x68Msg3Li@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 04:51:38PM +0100, Stephan Mueller wrote:
>
> +		if (!aead_writable(sk)) {
> +			/*
> +			 * If there is more data to be expected, but we cannot
> +			 * write more data, forcefully define that we do not
> +			 * expect more data to invoke the AEAD operation. This
> +			 * prevents a deadlock in user space.
> +			 */
> +			ctx->more = 0;

We should return EMSGSIZE here.  Also we should clear out the
existing data so that the socket may be reused again.

> +	ctx->more = msg->msg_flags & MSG_MORE;
> +	if (!ctx->more && !aead_sufficient_data(ctx))
> +		err = -EINVAL;

Ditto, we should discard the data that's queued up.  Also perhaps
use EBADMSG instead of EINVAL.

> +	/*
> +	 * Require exactly one IOV block as the AEAD operation is a one shot
> +	 * due to the authentication tag.
> +	 */
> +	if (msg->msg_iter.nr_segs != 1)
> +		return -ENOMSG;

Why does the receive buffer have to be contiguous?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
