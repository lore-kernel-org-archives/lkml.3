Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab3C1SYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:24:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:44920 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab3C1SYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:24:18 -0400
Message-ID: <1364495050.11644.47.camel@pasglop>
Subject: Re: Fwd: [PATCH v2] drivers/crypto/nx: fix init race, alignmasks
 and GCM bug
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kent Yoder <shpedoikal@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Date: Thu, 28 Mar 2013 19:24:10 +0100
In-Reply-To: <CAM0nabGe1ZYeZyjuCp9vSjTfnd4GHQXg4QYFimoCqZ1njjhXaw@mail.gmail.com>
References: <CAM0nabE5yQB3xQuATiAEyt3Ahpqqh7EMNDxcnK2PgSUaNG1Y_A@mail.gmail.com>
	 <CAM0nabGe1ZYeZyjuCp9vSjTfnd4GHQXg4QYFimoCqZ1njjhXaw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-28 at 11:32 -0500, Kent Yoder wrote:
> Hi Ben, will you carry this patch in the linuxppc-dev tree?

I can but I'm on vacation until end of April roughly.

Cheers,
Ben.

> Thanks,
> Kent
> 
> ---------- Forwarded message ----------
> From: Kent Yoder <shpedoikal@gmail.com>
> Date: Wed, Mar 20, 2013 at 9:22 AM
> Subject: [PATCH v2] drivers/crypto/nx: fix init race, alignmasks and GCM bug
> To: linux-kernel@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org, Benjamin Herrenschmidt
> <benh@kernel.crashing.org>
> 
> 
>   Fixes a race on driver init with registering algorithms where the
> driver status flag wasn't being set before self testing started.
> 
>   Added the cra_alignmask field for CBC and ECB modes.
> 
>   Fixed a bug in GCM where AES block size was being used instead of
> authsize.
> 
> Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
> ---
> Only changes in v2 were to leave stable off the cc and add Ben for PPC.
> 
>  drivers/crypto/nx/nx-aes-cbc.c | 1 +
>  drivers/crypto/nx/nx-aes-ecb.c | 1 +
>  drivers/crypto/nx/nx-aes-gcm.c | 2 +-
>  drivers/crypto/nx/nx.c         | 4 ++--
>  4 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/nx/nx-aes-cbc.c b/drivers/crypto/nx/nx-aes-cbc.c
> index a76d4c4..35d483f 100644
> --- a/drivers/crypto/nx/nx-aes-cbc.c
> +++ b/drivers/crypto/nx/nx-aes-cbc.c
> @@ -126,6 +126,7 @@ struct crypto_alg nx_cbc_aes_alg = {
>         .cra_blocksize   = AES_BLOCK_SIZE,
>         .cra_ctxsize     = sizeof(struct nx_crypto_ctx),
>         .cra_type        = &crypto_blkcipher_type,
> +       .cra_alignmask   = 0xf,
>         .cra_module      = THIS_MODULE,
>         .cra_init        = nx_crypto_ctx_aes_cbc_init,
>         .cra_exit        = nx_crypto_ctx_exit,
> diff --git a/drivers/crypto/nx/nx-aes-ecb.c b/drivers/crypto/nx/nx-aes-ecb.c
> index ba5f161..7bbc9a8 100644
> --- a/drivers/crypto/nx/nx-aes-ecb.c
> +++ b/drivers/crypto/nx/nx-aes-ecb.c
> @@ -123,6 +123,7 @@ struct crypto_alg nx_ecb_aes_alg = {
>         .cra_priority    = 300,
>         .cra_flags       = CRYPTO_ALG_TYPE_BLKCIPHER,
>         .cra_blocksize   = AES_BLOCK_SIZE,
> +       .cra_alignmask   = 0xf,
>         .cra_ctxsize     = sizeof(struct nx_crypto_ctx),
>         .cra_type        = &crypto_blkcipher_type,
>         .cra_module      = THIS_MODULE,
> diff --git a/drivers/crypto/nx/nx-aes-gcm.c b/drivers/crypto/nx/nx-aes-gcm.c
> index c8109ed..6cca6c3 100644
> --- a/drivers/crypto/nx/nx-aes-gcm.c
> +++ b/drivers/crypto/nx/nx-aes-gcm.c
> @@ -219,7 +219,7 @@ static int gcm_aes_nx_crypt(struct aead_request
> *req, int enc)
>         if (enc)
>                 NX_CPB_FDM(csbcpb) |= NX_FDM_ENDE_ENCRYPT;
>         else
> -               nbytes -= AES_BLOCK_SIZE;
> +               nbytes -= crypto_aead_authsize(crypto_aead_reqtfm(req));
> 
>         csbcpb->cpb.aes_gcm.bit_length_data = nbytes * 8;
> 
> diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
> index c767f23..7621d05 100644
> --- a/drivers/crypto/nx/nx.c
> +++ b/drivers/crypto/nx/nx.c
> @@ -454,6 +454,8 @@ static int nx_register_algs(void)
>         if (rc)
>                 goto out;
> 
> +       nx_driver.of.status = NX_OKAY;
> +
>         rc = crypto_register_alg(&nx_ecb_aes_alg);
>         if (rc)
>                 goto out;
> @@ -498,8 +500,6 @@ static int nx_register_algs(void)
>         if (rc)
>                 goto out_unreg_s512;
> 
> -       nx_driver.of.status = NX_OKAY;
> -
>         goto out;
> 
>  out_unreg_s512:
> --
> 1.7.11.7
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


