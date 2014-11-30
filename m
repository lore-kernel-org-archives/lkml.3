Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbaK3T5c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 14:57:32 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:55625 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaK3T5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 14:57:30 -0500
MIME-Version: 1.0
In-Reply-To: <1417367029-32762-8-git-send-email-Julia.Lawall@lip6.fr>
References: <1417367029-32762-1-git-send-email-Julia.Lawall@lip6.fr>
	<1417367029-32762-8-git-send-email-Julia.Lawall@lip6.fr>
Date: Sun, 30 Nov 2014 20:57:28 +0100
Message-ID: <CAKv+Gu9op6hup253LtMpSo6aJ+mTmfDa0cxNv4bQbcnCqSsn+w@mail.gmail.com>
Subject: Re: [PATCH 7/8 v2] crypto: replace memset by memzero_explicit
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Russell King <linux@arm.linux.org.uk>, kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 November 2014 at 18:03, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Memset on a local variable may be removed when it is called just before the
> variable goes out of scope.  Using memzero_explicit defeats this
> optimization.  A simplified version of the semantic patch that makes this
> change is as follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> identifier x;
> type T;
> @@
>
> {
> ... when any
> T x[...];
> ... when any
>     when exists
> - memset
> + memzero_explicit
>   (x,
> -0,
>   ...)
> ... when != x
>     when strict
> }
> // </smpl>
>
> This change was suggested by Daniel Borkmann <dborkman@redhat.com>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
> Daniel Borkmann suggested that these patches could go through Herbert Xu's
> cryptodev tree.
>
> I was not able to compile this one.
>

Builds fine for me

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>


> v2: fixed email address
>
>  arch/arm/crypto/sha512_neon_glue.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/crypto/sha512_neon_glue.c b/arch/arm/crypto/sha512_neon_glue.c
> index f3452c6..b124dce 100644
> --- a/arch/arm/crypto/sha512_neon_glue.c
> +++ b/arch/arm/crypto/sha512_neon_glue.c
> @@ -241,7 +241,7 @@ static int sha384_neon_final(struct shash_desc *desc, u8 *hash)
>         sha512_neon_final(desc, D);
>
>         memcpy(hash, D, SHA384_DIGEST_SIZE);
> -       memset(D, 0, SHA512_DIGEST_SIZE);
> +       memzero_explicit(D, SHA512_DIGEST_SIZE);
>
>         return 0;
>  }
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
