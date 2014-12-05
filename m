Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaLEPqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 10:46:21 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:34899 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaLEPqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 10:46:18 -0500
Date: Fri, 5 Dec 2014 23:46:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "'Quentin Gouchet'" <quentin.gouchet@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v4 2/5] crypto: AF_ALG: add AEAD support
Message-ID: <20141205154606.GA30180@gondor.apana.org.au>
References: <2105559.EmODblLYuY@tachyon.chronox.de>
 <4875720.jRoMDtjHB4@tachyon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4875720.jRoMDtjHB4@tachyon.chronox.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 08:57:24PM +0100, Stephan Mueller wrote:
>
> +	if (ctx->merge) {
> +		sg = sgl->sg + sgl->cur - 1;
> +		len = min_t(unsigned long, len,
> +			    PAGE_SIZE - sg->offset - sg->length);
> +
> +		err = memcpy_fromiovec(page_address(sg_page(sg)) +
> +				       sg->offset + sg->length,
> +				       msg->msg_iov, len);
> +		if (err)
> +			goto unlock;
> +
> +		sg->length += len;
> +		ctx->merge = (sg->offset + sg->length) & (PAGE_SIZE - 1);
> +
> +		ctx->used += len;
> +		copied += len;
> +		size -= len;
> +	}

Any reason why you got rid of the outer loop here? This will cause
short writes I think.

> +static struct proto_ops algif_aead_ops = {
> +	.family		=	PF_ALG,
> +
> +	.connect	=	sock_no_connect,
> +	.socketpair	=	sock_no_socketpair,
> +	.getname	=	sock_no_getname,
> +	.ioctl		=	sock_no_ioctl,
> +	.listen		=	sock_no_listen,
> +	.shutdown	=	sock_no_shutdown,
> +	.getsockopt	=	sock_no_getsockopt,
> +	.mmap		=	sock_no_mmap,
> +	.bind		=	sock_no_bind,
> +	.accept		=	sock_no_accept,
> +
> +	.release	=	af_alg_release,
> +	.sendmsg	=	aead_sendmsg,
> +	.sendpage	=	aead_sendpage,
> +	.recvmsg	=	aead_recvmsg,
> +	.poll		=	aead_poll,
> +	.setsockopt	=	aead_setsockopt,

No it should go into the parent setsockopt.  Perhaps add a setsockopt
to af_alg_type in order to keep this out of the generic code.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
