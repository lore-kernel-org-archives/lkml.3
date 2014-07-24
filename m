Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765AbaGXLFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:05:04 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:63993 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaGXLFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:05:00 -0400
Message-ID: <53D0E857.8000405@gmail.com>
Date: Thu, 24 Jul 2014 13:04:55 +0200
From: Corentin LABBE <clabbe.montjoie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, maxime.ripard@free-electrons.com,
        linux@arm.linux.org.uk, davem@davemloft.net, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 3/3] crypto: Add Allwinner Security System crypto accelerator
References: <1405169953-13695-1-git-send-email-clabbe.montjoie@gmail.com> <1405169953-13695-4-git-send-email-clabbe.montjoie@gmail.com> <20140724060054.GA6545@gondor.apana.org.au>
In-Reply-To: <20140724060054.GA6545@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 24/07/2014 08:00, Herbert Xu a écrit :
> On Sat, Jul 12, 2014 at 02:59:13PM +0200, LABBE Corentin wrote:
>>
>> +/* sunxi_hash_init: initialize request context
>> + * Activate the SS, and configure it for MD5 or SHA1
>> + */
>> +int sunxi_hash_init(struct ahash_request *areq)
>> +{
>> +	const char *hash_type;
>> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
>> +	struct sunxi_req_ctx *op = crypto_ahash_ctx(tfm);
>> +
>> +	mutex_lock(&ss->lock);
>> +
>> +	hash_type = crypto_tfm_alg_name(areq->base.tfm);
>> +
>> +	op->byte_count = 0;
>> +	op->nbwait = 0;
>> +	op->waitbuf = 0;
>> +
>> +	/* Enable and configure SS for MD5 or SHA1 */
>> +	if (strcmp(hash_type, "sha1") == 0)
>> +		op->mode = SS_OP_SHA1;
>> +	else
>> +		op->mode = SS_OP_MD5;
>> +
>> +	writel(op->mode | SS_ENABLED, ss->base + SS_CTL);
>> +	return 0;
> 
> The hash driver is completely broken.  You are modifying tfm
> ctx data which is shared by all users of a single tfm.  So
> if two users conduct hashes in parallel they will step all
> over each other.

So where can I store data for each request ?

> 
> Worse, the unpaired mutex_lock will quickly lead to dead locks.
> 
> You cannot assume that final will be called.

An user reported an equivalent problem when using openssl speed test with cryptodev.
Does cryptoqueue is a good answer to that problem since the device could handle only one transformation at a time ?
And perhaps with cryptoqueue,  my first question is useless.
