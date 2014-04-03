Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbaDCXgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 19:36:51 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:2691 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753818AbaDCXgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 19:36:44 -0400
Date: Thu, 3 Apr 2014 16:38:44 -0700
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 1/9] crypto: qce: Add core driver implementation
Message-ID: <20140403233844.GF17066@sonymobile.com>
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com>
 <1396541886-10966-2-git-send-email-svarbanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1396541886-10966-2-git-send-email-svarbanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 06:17:58PM +0200, Stanimir Varbanov wrote:
> This adds core driver files. The core part is implementing a
> platform driver probe and remove callbaks, the probe enables
> clocks, checks crypto version, initialize and request dma
> channels, create done tasklet and work queue and finally
> register the algorithms into crypto subsystem.
> 
> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> ---
>  drivers/crypto/qce/core.c | 333 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/crypto/qce/core.h |  69 ++++++++++
>  2 files changed, 402 insertions(+)
>  create mode 100644 drivers/crypto/qce/core.c
>  create mode 100644 drivers/crypto/qce/core.h
> 
> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
[...]
> +static struct qce_algo_ops qce_ops[] = {
> +	{
> +		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
> +		.register_alg = qce_ablkcipher_register,
> +	},
> +	{
> +		.type = CRYPTO_ALG_TYPE_AHASH,
> +		.register_alg = qce_ahash_register,
> +	},
> +};
> +
> +static void qce_unregister_algs(struct qce_device *qce)
> +{
> +	struct qce_alg_template *tmpl, *n;
> +
> +	list_for_each_entry_safe(tmpl, n, &qce->alg_list, entry) {
> +		if (tmpl->crypto_alg_type == CRYPTO_ALG_TYPE_AHASH)
> +			crypto_unregister_ahash(&tmpl->alg.ahash);
> +		else
> +			crypto_unregister_alg(&tmpl->alg.crypto);
> +
> +		list_del(&tmpl->entry);
> +		kfree(tmpl);

I find this whole memory/list management to be very disorganised.
ops->register_alg() is supposed to allocate this item--more precisely,
multiple items--using something that must be able to be kfree'd
directly, register it with the crypto core, and put it on this list
manually.  Here we unregister/remove/free this in the core.  Josh's
recommendation of a unregister_alg callback might help, but it all
remains a bit unclear with register_alg/unregister_alg managing X
algorithms per call. 

Additionally, above you have qce_ops, which clearly defines the
operations for specific algorithms types/groups, which in later patches
are shown to be seperated out into independent implementations.

>From what I can tell, this seems to be a framework with built-in yet
independent crypto implementations which call the crypto API directly.

It would be more logical to me if this was seperated out into a
"library/core" API, with the individual implementations as platform
drivers of their own.  Then they can register with the core, managing
memory how they please.

What am I missing?

> +	}
> +}
> +
> +static int qce_register_algs(struct qce_device *qce)
> +{
> +	struct qce_algo_ops *ops;
> +	int i, rc = -ENODEV;
> +
> +	for (i = 0; i < ARRAY_SIZE(qce_ops); i++) {
> +		ops = &qce_ops[i];
> +		ops->async_req_queue = qce_async_request_queue;
> +		ops->async_req_done = qce_async_request_done;
> +		rc = ops->register_alg(qce, ops);
> +		if (rc)
> +			break;
> +	}
> +
> +	if (rc)
> +		qce_unregister_algs(qce);
> +
> +	return rc;
> +}

-Courtney
