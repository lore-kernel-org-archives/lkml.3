Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193AbaJUQZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:25:46 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33996 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568AbaJUQZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:25:43 -0400
Message-ID: <54468902.1040802@gmail.com>
Date: Tue, 21 Oct 2014 18:25:38 +0200
From: Corentin LABBE <clabbe.montjoie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Vladimir Zapolskiy <vz@mleia.com>, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, maxime.ripard@free-electrons.com,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
        davem@davemloft.net, grant.likely@linaro.org,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, joe@perches.com,
        mchehab@osg.samsung.com, crope@iki.fi
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 4/4] crypto: Add Allwinner Security System crypto accelerator
References: <1413728182-13569-1-git-send-email-clabbe.montjoie@gmail.com> <1413728182-13569-5-git-send-email-clabbe.montjoie@gmail.com> <54459AA5.2030705@mleia.com>
In-Reply-To: <54459AA5.2030705@mleia.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/14 01:28, Vladimir Zapolskiy wrote:
> Hello LABBE,
> 
> On 19.10.2014 17:16, LABBE Corentin wrote:
>> Add support for the Security System included in Allwinner SoC A20.
>> The Security System is a hardware cryptographic accelerator that support AES/MD5/SHA1/DES/3DES/PRNG algorithms.
>>
[]
>> +
>> +	/* If we have only one SG, we can use kmap_atomic */
>> +	if (sg_next(in_sg) == NULL && sg_next(out_sg) == NULL)
>> +		return sunxi_ss_aes_poll_atomic(areq);
> 
> for clarity it might be better to move all "mutex_unlock(&ss->lock)"
> calls from sunxi_ss_aes_poll_atomic() body right to here.
> 

Ok
I have moved all mutex_unlock/writel(0, SS_CTL) at the end of function, it is cleaner now.

>> +
>> +};
>> +
>> +static int sunxi_ss_probe(struct platform_device *pdev)
>> +{
>> +	struct resource *res;
>> +	u32 v;
>> +	int err;
>> +	unsigned long cr;
>> +	const unsigned long cr_ahb = 24 * 1000 * 1000;
>> +	const unsigned long cr_mod = 150 * 1000 * 1000;
>> +
>> +	if (!pdev->dev.of_node)
>> +		return -ENODEV;
>> +
>> +	ss = devm_kzalloc(&pdev->dev, sizeof(*ss), GFP_KERNEL);
>> +	if (ss == NULL)
>> +		return -ENOMEM;
> 
> Why do you dynamically allocate memory for "struct sunxi_ss_ctx *ss"?
> Since you have a single global pointer, it makes sense to declare
> "struct sunxi_ss_ctx ss" statically instead.
> 
> And even a better solution is to remove a single global pointer.

All other crypto driver I have read use a global structure and it made things easy.
Thanks to M. Ripard that pointed to me the talitos driver that solve the global device pointer by using alg template and container_of().

But since I think there will never 2 Security System at the same time on the same SoC, I do not know if it is worth the cost to add more complexity just to remove a pointer.

> 
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	ss->base = devm_ioremap_resource(&pdev->dev, res);
>> +	if (IS_ERR(ss->base)) {
>> +		dev_err(&pdev->dev, "Cannot request MMIO\n");
>> +		return PTR_ERR(ss->base);
>> +	}
>> +
>> +	ss->ssclk = devm_clk_get(&pdev->dev, "mod");
>> +	if (IS_ERR(ss->ssclk)) {
>> +		err = PTR_ERR(ss->ssclk);
>> +		dev_err(&pdev->dev, "Cannot get SS clock err=%d\n", err);
>> +		return err;
>> +	}
>> +	dev_dbg(&pdev->dev, "clock ss acquired\n");
>> +
>> +	ss->busclk = devm_clk_get(&pdev->dev, "ahb");
>> +	if (IS_ERR(ss->busclk)) {
>> +		err = PTR_ERR(ss->busclk);
>> +		dev_err(&pdev->dev, "Cannot get AHB SS clock err=%d\n", err);
>> +		return err;
>> +	}
>> +	dev_dbg(&pdev->dev, "clock ahb_ss acquired\n");
>> +
>> +	/* Enable both clocks */
>> +	err = clk_prepare_enable(ss->busclk);
>> +	if (err != 0) {
>> +		dev_err(&pdev->dev, "Cannot prepare_enable busclk\n");
>> +		return err;
>> +	}
>> +	err = clk_prepare_enable(ss->ssclk);
>> +	if (err != 0) {
>> +		dev_err(&pdev->dev, "Cannot prepare_enable ssclk\n");
>> +		clk_disable_unprepare(ss->busclk);
> 
> goto somewhere to the end of the function?

OK

> 
>> +		return err;
>> +	}
>> +
>> +	/*
>> +	 * Check that clock have the correct rates gived in the datasheet
>> +	 * Try to set the clock to the maximum allowed
>> +	 */
>> +	err = clk_set_rate(ss->ssclk, cr_mod);
>> +	if (err != 0) {
>> +		dev_err(&pdev->dev, "Cannot set clock rate to ssclk\n");
>> +		clk_disable_unprepare(ss->ssclk);
>> +		clk_disable_unprepare(ss->busclk);
> 
> goto "error_md5"?

Ok

> 
>> +		return err;
>> +	}
>> +
>> +	cr = clk_get_rate(ss->busclk);
>> +	if (cr >= cr_ahb)
>> +		dev_dbg(&pdev->dev, "Clock bus %lu (%lu MHz) (must be >= %lu)\n",
>> +				cr, cr / 1000000, cr_ahb);
>> +	else
>> +		dev_warn(&pdev->dev, "Clock bus %lu (%lu MHz) (must be >= %lu)\n",
>> +				cr, cr / 1000000, cr_ahb);
> 
> See next comment.
> 
>> +	cr = clk_get_rate(ss->ssclk);
>> +	if (cr <= cr_mod)
>> +		if (cr < cr_mod)
>> +			dev_info(&pdev->dev, "Clock ss %lu (%lu MHz) (must be <= %lu)\n",
>> +					cr, cr / 1000000, cr_mod);
>> +		else
>> +			dev_dbg(&pdev->dev, "Clock ss %lu (%lu MHz) (must be <= %lu)\n",
>> +					cr, cr / 1000000, cr_mod);
>> +	else
>> +		dev_warn(&pdev->dev, "Clock ss is at %lu (%lu MHz) (must be <= %lu)\n",
>> +				cr, cr / 1000000, cr_mod);
> 
> The management of kernel log levels looks pretty strange. As far as I
> understand there is no error on any clock rate, I'd recommend to keep
> only one information message.
> 

If clock rate are below the recommended value, the only impact I found was bad performance.
So it explain the warn and no error. (yes the info must be warn, ...fixed)

But I will put comment for explain that.

>> +	/*
>> +	 * Datasheet named it "Die Bonding ID"
>> +	 * I expect to be a sort of Security System Revision number.
>> +	 * Since the A80 seems to have an other version of SS
>> +	 * this info could be useful
>> +	 */
>> +	writel(SS_ENABLED, ss->base + SS_CTL);
>> +	v = readl(ss->base + SS_CTL);
>> +	v >>= 16;
>> +	v &= 0x07;
>> +	dev_info(&pdev->dev, "Die ID %d\n", v);
>> +	writel(0, ss->base + SS_CTL);
>> +
>> +	ss->dev = &pdev->dev;
>> +
>> +	mutex_init(&ss->lock);
>> +	mutex_init(&ss->bufin_lock);
>> +	mutex_init(&ss->bufout_lock);
>> +
>> +	err = crypto_register_ahash(&sunxi_md5_alg);
>> +	if (err)
>> +		goto error_md5;
>> +	err = crypto_register_ahash(&sunxi_sha1_alg);
>> +	if (err)
>> +		goto error_sha1;
>> +	err = crypto_register_algs(sunxi_cipher_algs,
>> +			ARRAY_SIZE(sunxi_cipher_algs));
>> +	if (err)
>> +		goto error_ciphers;
>> +
>> +	return 0;
>> +error_ciphers:
>> +	crypto_unregister_ahash(&sunxi_sha1_alg);
>> +error_sha1:
>> +	crypto_unregister_ahash(&sunxi_md5_alg);
>> +error_md5:
>> +	clk_disable_unprepare(ss->ssclk);
>> +	clk_disable_unprepare(ss->busclk);
>> +	return err;
>> +}
>> +
>> +static int __exit sunxi_ss_remove(struct platform_device *pdev)
>> +{
>> +	if (!pdev->dev.of_node)
>> +		return 0;
> 
> Redundant check.
> 

Ok

> 
> 
> --
> With best wishes,
> Vladimir
> 

Thanks for the review


