Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbaKKJed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 04:34:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbaKKJeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 04:34:31 -0500
Message-ID: <5461D81A.40801@redhat.com>
Date: Tue, 11 Nov 2014 10:34:18 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephan Mueller <smueller@chronox.de>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        "'Sandy Harris'" <sandyinchina@gmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: AF_ALG - zeroize message digest buffer
References: <1503070.D5VR9iy8Cm@tachyon.chronox.de> <2491424.h8JBGRc3Yx@tachyon.chronox.de>
In-Reply-To: <2491424.h8JBGRc3Yx@tachyon.chronox.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephan,

On 11/11/2014 05:37 AM, Stephan Mueller wrote:
> Zeroize the buffer holding the message digest calculated for the
> consumer before the buffer is released by the hash AF_ALG interface
> handler.
>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>   crypto/algif_hash.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
> index 8502462..f75db4c 100644
> --- a/crypto/algif_hash.c
> +++ b/crypto/algif_hash.c
> @@ -258,6 +258,8 @@ static void hash_sock_destruct(struct sock *sk)
>   	struct alg_sock *ask = alg_sk(sk);
>   	struct hash_ctx *ctx = ask->private;
>
> +	memzero_explicit(ctx->result,
> +		     crypto_ahash_digestsize(crypto_ahash_reqtfm(&ctx->req)));
>   	sock_kfree_s(sk, ctx->result,

Perhaps something like this (alternatively kzfree() would work, too) ...

static void __sock_kfree_s(struct sock *sk, void *mem, int size,
			   bool clear_mem)
{
	if (WARN_ON_ONCE(!mem))
		return;
	if (clear_mem)
		memzero_explicit(mem, size);
	kfree(mem);
	atomic_sub(size, &sk->sk_omem_alloc);
}

void sock_kfree_s(struct sock *sk, void *mem, int size)
{
	__sock_kfree_s(sk, mem, size, false);
}
EXPORT_SYMBOL(sock_kfree_s);

void sock_kzfree_s(struct sock *sk, void *mem, int size)
{
	__sock_kfree_s(sk, mem, size, true);
}
EXPORT_SYMBOL(sock_kzfree_s);

... so you could then just use it as drop-in in various places:

sock_kzfree_s(sk, ctx->result, ...);

>   		     crypto_ahash_digestsize(crypto_ahash_reqtfm(&ctx->req)));
>   	sock_kfree_s(sk, ctx, ctx->len);
>

Thanks,
Daniel
