Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaGZOBd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:01:33 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55774 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaGZOBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:01:31 -0400
Message-ID: <53D3B4B6.3000100@gmail.com>
Date: Sat, 26 Jul 2014 16:01:26 +0200
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
References: <1405169953-13695-1-git-send-email-clabbe.montjoie@gmail.com> <1405169953-13695-4-git-send-email-clabbe.montjoie@gmail.com> <20140724060054.GA6545@gondor.apana.org.au> <53D0E857.8000405@gmail.com> <20140724133823.GA9638@gondor.apana.org.au>
In-Reply-To: <20140724133823.GA9638@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 24/07/2014 15:38, Herbert Xu a écrit :
> On Thu, Jul 24, 2014 at 01:04:55PM +0200, Corentin LABBE wrote:
>> Le 24/07/2014 08:00, Herbert Xu a écrit :
>>> On Sat, Jul 12, 2014 at 02:59:13PM +0200, LABBE Corentin wrote:
>>>>
>>>> +/* sunxi_hash_init: initialize request context
>>>> + * Activate the SS, and configure it for MD5 or SHA1
>>>> + */
>>>> +int sunxi_hash_init(struct ahash_request *areq)
>>>> +{
>>>> +	const char *hash_type;
>>>> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
>>>> +	struct sunxi_req_ctx *op = crypto_ahash_ctx(tfm);
>>>> +
>>>> +	mutex_lock(&ss->lock);
>>>> +
>>>> +	hash_type = crypto_tfm_alg_name(areq->base.tfm);
>>>> +
>>>> +	op->byte_count = 0;
>>>> +	op->nbwait = 0;
>>>> +	op->waitbuf = 0;
>>>> +
>>>> +	/* Enable and configure SS for MD5 or SHA1 */
>>>> +	if (strcmp(hash_type, "sha1") == 0)
>>>> +		op->mode = SS_OP_SHA1;
>>>> +	else
>>>> +		op->mode = SS_OP_MD5;
>>>> +
>>>> +	writel(op->mode | SS_ENABLED, ss->base + SS_CTL);
>>>> +	return 0;
>>>
>>> The hash driver is completely broken.  You are modifying tfm
>>> ctx data which is shared by all users of a single tfm.  So
>>> if two users conduct hashes in parallel they will step all
>>> over each other.
>>
>> So where can I store data for each request ?
> 
> Well, first of all you need to stop storing state in the hardware.
> After each operation the hardware may be used by some other user
> for a completely different hash request.  So leaving the hash state
> in the hardware is a no-no.
> 
> If your hardware supports exporting the hash state then you just
> have to export it after each operation and reimporting before the
> next one.

Even if it is undocumented, the hardware seems to support it.
Since crypto_ahash_ctx is for a tfm, does ahash_request_ctx is the good place to store data ?
(after a call to crypto_ahash_set_reqsize in cra_init)

I have also seen export/import function, does I need to use it ?


> 
> If your hardware is incapable of exporting partial hash state then
> you will have to use a software fallback for init/update.  If your
> hardware is incapable of importing partial hash state then you will
> also have to do finup/final using a software fallback.
> 
> Cheers,
> 

