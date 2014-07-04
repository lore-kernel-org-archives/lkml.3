Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbaGDJw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:52:29 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:51624 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537AbaGDJw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:52:27 -0400
Message-ID: <1404467544.27680.22.camel@x220>
Subject: Re: [PATCH] crypto: caam - Check for CAAM block presence before
 registering with crypto layer
From: Paul Bolle <pebolle@tiscali.nl>
To: Ruchika Gupta <ruchika.gupta@freescale.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        alexandru.porosanu@freescale.com, horia.geanta@freescale.com,
        NiteshNarayanLal@freescale.com, vakul@freescale.com, marex@denx.de,
        kim.phillips@freescale.com
Date: Fri, 04 Jul 2014 11:52:24 +0200
In-Reply-To: <1404474048-30767-1-git-send-email-ruchika.gupta@freescale.com>
References: <1404474048-30767-1-git-send-email-ruchika.gupta@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jul 2014 09:52:25.0517 (UTC) FILETIME=[A8BC35D0:01CF976D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-04 at 17:10 +0530, Ruchika Gupta wrote:
> The layer which registers with the crypto API should check for the presence of
> the CAAM device it is going to use.  If the platform's device tree doesn't have
> the required CAAM node, the layer should return an error and not register the
> algorithms with crypto API layer.
> 
> Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>
> Reviewed-by: Horia Ioan Geanta Neag <horia.geanta@freescale.com>

Just a thing I noticed because the time on this message is (at this
moment) in the future, putting this message a the top of its folder. Not
really a valid reason to have a look at a patch, but I did anyway.

> ---
>  drivers/crypto/caam/caamalg.c  | 27 +++++++++++++++++++++++++++
>  drivers/crypto/caam/caamhash.c | 26 ++++++++++++++++++++++++++
>  drivers/crypto/caam/caamrng.c  | 26 ++++++++++++++++++++++++++
>  3 files changed, 79 insertions(+)
> 
> diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
> index 87d9de4..d479dfb 100644
> --- a/drivers/crypto/caam/caamalg.c
> +++ b/drivers/crypto/caam/caamalg.c
> @@ -2441,8 +2441,35 @@ static struct caam_crypto_alg *caam_alg_alloc(struct caam_alg_template
>  
>  static int __init caam_algapi_init(void)
>  {
> +	struct device_node *dev_node;
> +	struct platform_device *pdev;
> +	struct device *ctrldev;
> +	void *priv;
>  	int i = 0, err = 0;
>  
> +	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
> +	if (!dev_node) {
> +		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
> +		if (!dev_node)
> +			return -ENODEV;
> +	}
> +
> +	pdev = of_find_device_by_node(dev_node);
> +	if (!pdev)

Doesn't this leak a reference to dev_node here?

> +		return -ENODEV;
> +
> +	ctrldev = &pdev->dev;
> +	priv = dev_get_drvdata(ctrldev);
> +	of_node_put(dev_node);
> +
> +	/*
> +	 * If priv is NULL, it's probably because the caam driver wasn't
> +	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
> +	 */
> +	if (!priv)
> +		return -ENODEV;
> +
> +
>  	INIT_LIST_HEAD(&alg_list);
>  
>  	/* register crypto algorithms the device supports */
> diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
> index 2ab057b..5e172a2 100644
> --- a/drivers/crypto/caam/caamhash.c
> +++ b/drivers/crypto/caam/caamhash.c
> @@ -1793,8 +1793,34 @@ caam_hash_alloc(struct caam_hash_template *template,
>  
>  static int __init caam_algapi_hash_init(void)
>  {
> +	struct device_node *dev_node;
> +	struct platform_device *pdev;
> +	struct device *ctrldev;
> +	void *priv;
>  	int i = 0, err = 0;
>  
> +	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
> +	if (!dev_node) {
> +		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
> +		if (!dev_node)
> +			return -ENODEV;
> +	}
> +
> +	pdev = of_find_device_by_node(dev_node);
> +	if (!pdev)

Ditto.

> +		return -ENODEV;
> +
> +	ctrldev = &pdev->dev;
> +	priv = dev_get_drvdata(ctrldev);
> +	of_node_put(dev_node);
> +
> +	/*
> +	 * If priv is NULL, it's probably because the caam driver wasn't
> +	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
> +	 */
> +	if (!priv)
> +		return -ENODEV;
> +
>  	INIT_LIST_HEAD(&hash_list);
>  
>  	/* register crypto algorithms the device supports */
> diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
> index 8c07d31..c4c36c4 100644
> --- a/drivers/crypto/caam/caamrng.c
> +++ b/drivers/crypto/caam/caamrng.c
> @@ -278,6 +278,32 @@ static void __exit caam_rng_exit(void)
>  static int __init caam_rng_init(void)
>  {
>  	struct device *dev;
> +	struct device_node *dev_node;
> +	struct platform_device *pdev;
> +	struct device *ctrldev;
> +	void *priv;
> +
> +	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
> +	if (!dev_node) {
> +		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
> +		if (!dev_node)
> +			return -ENODEV;
> +	}
> +
> +	pdev = of_find_device_by_node(dev_node);
> +	if (!pdev)

Ditto.

> +		return -ENODEV;
> +
> +	ctrldev = &pdev->dev;
> +	priv = dev_get_drvdata(ctrldev);
> +	of_node_put(dev_node);
> +
> +	/*
> +	 * If priv is NULL, it's probably because the caam driver wasn't
> +	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
> +	 */
> +	if (!priv)
> +		return -ENODEV;
>  
>  	dev = caam_jr_alloc();
>  	if (IS_ERR(dev)) {



Paul Bolle

