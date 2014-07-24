Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934133AbaGXGB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 02:01:56 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:42355 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaGXGBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 02:01:53 -0400
Date: Thu, 24 Jul 2014 14:00:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, maxime.ripard@free-electrons.com,
        linux@arm.linux.org.uk, davem@davemloft.net, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 3/3] crypto: Add Allwinner Security System crypto
 accelerator
Message-ID: <20140724060054.GA6545@gondor.apana.org.au>
References: <1405169953-13695-1-git-send-email-clabbe.montjoie@gmail.com>
 <1405169953-13695-4-git-send-email-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405169953-13695-4-git-send-email-clabbe.montjoie@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 02:59:13PM +0200, LABBE Corentin wrote:
>
> +/* sunxi_hash_init: initialize request context
> + * Activate the SS, and configure it for MD5 or SHA1
> + */
> +int sunxi_hash_init(struct ahash_request *areq)
> +{
> +	const char *hash_type;
> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
> +	struct sunxi_req_ctx *op = crypto_ahash_ctx(tfm);
> +
> +	mutex_lock(&ss->lock);
> +
> +	hash_type = crypto_tfm_alg_name(areq->base.tfm);
> +
> +	op->byte_count = 0;
> +	op->nbwait = 0;
> +	op->waitbuf = 0;
> +
> +	/* Enable and configure SS for MD5 or SHA1 */
> +	if (strcmp(hash_type, "sha1") == 0)
> +		op->mode = SS_OP_SHA1;
> +	else
> +		op->mode = SS_OP_MD5;
> +
> +	writel(op->mode | SS_ENABLED, ss->base + SS_CTL);
> +	return 0;

The hash driver is completely broken.  You are modifying tfm
ctx data which is shared by all users of a single tfm.  So
if two users conduct hashes in parallel they will step all
over each other.

Worse, the unpaired mutex_lock will quickly lead to dead locks.

You cannot assume that final will be called.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
