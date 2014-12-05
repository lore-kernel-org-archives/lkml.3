Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaLEPyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 10:54:09 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:54936 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaLEPyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 10:54:07 -0500
Date: Fri, 5 Dec 2014 23:53:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v4 4/5] crypto: AF_ALG: add random number generator
 support
Message-ID: <20141205155359.GA30224@gondor.apana.org.au>
References: <2105559.EmODblLYuY@tachyon.chronox.de>
 <1480776.TeURZV8VLa@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1480776.TeURZV8VLa@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 08:59:01PM +0100, Stephan Mueller wrote:
>
> +static int rng_recvmsg(struct kiocb *unused, struct socket *sock,
> +		       struct msghdr *msg, size_t len, int flags)
> +{
> +	struct sock *sk = sock->sk;
> +	struct alg_sock *ask = alg_sk(sk);
> +	struct rng_ctx *ctx = ask->private;
> +	int err = -EFAULT;
> +
> +	if (len == 0)
> +		return 0;
> +	if (len > MAXSIZE)
> +		len = MAXSIZE;
> +
> +	lock_sock(sk);

This lock simply protects ctx->result.  Since you're using a
tiny buffer why not just put it on the stack?

> +		u8 *buf = kmalloc(seedsize, GFP_KERNEL);
> +		if (!buf)
> +			goto err;
> +		get_random_bytes(buf, seedsize);
> +		ret = crypto_rng_reset(private, buf, len);

I think you should leave the seeding and the seed to the user.
Perhaps do it through setsockopt (on the parent socket).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
