Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaJTXxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 19:53:01 -0400
Received: from smtprelay0019.hostedemail.com ([216.40.44.19]:46784 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752177AbaJTXw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 19:52:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2106:2393:2559:2562:2692:2828:2892:2894:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6117:6261:6742:7208:7903:9113:10004:10400:10466:10848:11026:11232:11473:11658:11914:12043:12296:12517:12519:12555:12740:13095:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: yard03_197594fa12b59
X-Filterd-Recvd-Size: 4003
Message-ID: <1413849173.5407.6.camel@perches.com>
Subject: Re: [PATCH v5 4/4] crypto: Add Allwinner Security System crypto
 accelerator
From: Joe Perches <joe@perches.com>
To: Vladimir Zapolskiy <vz@mleia.com>
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        maxime.ripard@free-electrons.com, linux@arm.linux.org.uk,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        grant.likely@linaro.org, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, mchehab@osg.samsung.com, crope@iki.fi,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Mon, 20 Oct 2014 16:52:53 -0700
In-Reply-To: <54459AA5.2030705@mleia.com>
References: <1413728182-13569-1-git-send-email-clabbe.montjoie@gmail.com>
	 <1413728182-13569-5-git-send-email-clabbe.montjoie@gmail.com>
	 <54459AA5.2030705@mleia.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 02:28 +0300, Vladimir Zapolskiy wrote:
> On 19.10.2014 17:16, LABBE Corentin wrote:
> > Add support for the Security System included in Allwinner SoC A20.
> > The Security System is a hardware cryptographic accelerator that support AES/MD5/SHA1/DES/3DES/PRNG algorithms.
[]
> > diff --git a/drivers/crypto/sunxi-ss/sunxi-ss-core.c b/drivers/crypto/sunxi-ss/sunxi-ss-core.c
[]
> > +	cr = clk_get_rate(ss->busclk);
> > +	if (cr >= cr_ahb)
> > +		dev_dbg(&pdev->dev, "Clock bus %lu (%lu MHz) (must be >= %lu)\n",
> > +				cr, cr / 1000000, cr_ahb);
> > +	else
> > +		dev_warn(&pdev->dev, "Clock bus %lu (%lu MHz) (must be >= %lu)\n",
> > +				cr, cr / 1000000, cr_ahb);
> 
> See next comment.
> 
> > +	cr = clk_get_rate(ss->ssclk);
> > +	if (cr <= cr_mod)
> > +		if (cr < cr_mod)
> > +			dev_info(&pdev->dev, "Clock ss %lu (%lu MHz) (must be <= %lu)\n",
> > +					cr, cr / 1000000, cr_mod);
> > +		else
> > +			dev_dbg(&pdev->dev, "Clock ss %lu (%lu MHz) (must be <= %lu)\n",
> > +					cr, cr / 1000000, cr_mod);
> > +	else
> > +		dev_warn(&pdev->dev, "Clock ss is at %lu (%lu MHz) (must be <= %lu)\n",
> > +				cr, cr / 1000000, cr_mod);
> 
> The management of kernel log levels looks pretty strange. As far as I
> understand there is no error on any clock rate, I'd recommend to keep
> only one information message.

And if not, please add some braces.

> hash_init: initialize request context */
> > +int sunxi_hash_init(struct ahash_request *areq)
> > +{
> > +	const char *hash_type;
> > +	struct sunxi_req_ctx *op = ahash_request_ctx(areq);
> > +
> > +	memset(op, 0, sizeof(struct sunxi_req_ctx));
> > +
> > +	hash_type = crypto_tfm_alg_name(areq->base.tfm);
> > +
> > +	if (strcmp(hash_type, "sha1") == 0)
> > +		op->mode = SS_OP_SHA1;
> > +	if (strcmp(hash_type, "md5") == 0)
> > +		op->mode = SS_OP_MD5;

else if ?

> > +	if (op->mode == 0)
> > +		return -EINVAL;

maybe this?

	if (!strcmp(hash_type, "sha1"))
		op->mode = SS_OP_SHA1;
	else if (!strcmp(hash_type, "md5"))
		op->mode = SH_OP_MD5;
	else
		return -EINVAL;

> > +
> > +	return 0;
> > +}
[]
> > +int sunxi_hash_update(struct ahash_request *areq)
> > +{
[]
> > +	dev_dbg(ss->dev, "%s %s bc=%llu len=%u mode=%x bw=%u ww=%u",
> > +			__func__, crypto_tfm_alg_name(areq->base.tfm),
> > +			op->byte_count, areq->nbytes, op->mode,
> > +			op->nbw, op->nwait);

dev_dbg statements generally don't need __func__ as
dynamic_debug can add it.

If you want to keep it, the most common output form for
__func__ is '"%s: ...", __func__'

