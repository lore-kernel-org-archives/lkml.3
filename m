Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbaDCSWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 14:22:54 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39798 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbaDCSWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 14:22:44 -0400
Date: Thu, 3 Apr 2014 13:19:14 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 1/9] crypto: qce: Add core driver implementation
Message-ID: <20140403181914.GG28265@joshc.qualcomm.com>
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com>
 <1396541886-10966-2-git-send-email-svarbanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396541886-10966-2-git-send-email-svarbanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Stanimir-

Just a few comments/questions from a quick scan of your patchset:

On Thu, Apr 03, 2014 at 07:17:58PM +0300, Stanimir Varbanov wrote:
[..]
> +++ b/drivers/crypto/qce/core.c
[..]
> +
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

Why no 'unregister_alg' member in qce_algo_ops?

> +
> +		list_del(&tmpl->entry);
> +		kfree(tmpl);
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

Why not set these statically?

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
[..]
> +static int qce_get_version(struct qce_device *qce)
> +{
> +	u32 major, minor, step;
> +	u32 val;
> +
> +	val = readl(qce->base + REG_VERSION);
> +	major = (val & CORE_MAJOR_REV_MASK) >> CORE_MAJOR_REV;
> +	minor = (val & CORE_MINOR_REV_MASK) >> CORE_MINOR_REV;
> +	step = (val & CORE_STEP_REV_MASK) >> CORE_STEP_REV;
> +
> +	/*
> +	 * the driver does not support v5 with minor 0 because it has special
> +	 * alignment requirements.
> +	 */
> +	if (major < QCE_MAJOR_VERSION5 && minor == 0)
> +		return -ENODEV;
> +
> +	qce->burst_size = QCE_BAM_BURST_SIZE;
> +	qce->pipe_pair_index = 1;
> +
> +	dev_info(qce->dev, "Crypto device found, version %d.%d.%d\n",
> +		 major, minor, step);

I'd suggest dev_dbg().  Kernel boot is chatty enough.

[..]
> +static int qce_clks_enable(struct qce_device *qce, int enable)
> +{
> +	int rc = 0;
> +	int i;
> +
> +	for (i = 0; i < QCE_CLKS_NUM; i++) {
> +		if (enable)
> +			rc = clk_prepare_enable(qce->clks[i]);
> +		else
> +			clk_disable_unprepare(qce->clks[i]);
> +
> +		if (rc)
> +			break;
> +	}
> +
> +	if (rc)
> +		do
> +			clk_disable_unprepare(qce->clks[i]);
> +		while (--i >= 0);
> +
> +	return rc;
> +}

See my below comment about lumping clocks together.

[..]
> +static int qce_crypto_remove(struct platform_device *pdev)
> +{
> +	struct qce_device *qce = platform_get_drvdata(pdev);
> +
> +	cancel_work_sync(&qce->queue_work);
> +	destroy_workqueue(qce->queue_wq);
> +	tasklet_kill(&qce->done_tasklet);
> +	qce_unregister_algs(qce);
> +	qce_dma_release(&qce->dma);
> +	qce_clks_enable(qce, 0);

qce_clks_enable(qce, 0) is really confusing....I'd suggest creating
separate qce_clks_enable() and qce_clks_disable() functions.

[..]
> +static const struct of_device_id qce_crypto_of_match[] = {
> +	{ .compatible = "qcom,crypto-v5.1", },
> +	{}
> +};

MODULE_DEVICE_TABLE()?

[..]
> +++ b/drivers/crypto/qce/core.h
> @@ -0,0 +1,69 @@
> +/*
> + * Copyright (c) 2010-2014, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef _CORE_H_
> +#define _CORE_H_
> +
> +static const char * const clk_names[] = {
> +	"core",		/* GCC_CE_CLK */
> +	"iface",	/* GCC_CE_AHB_CLK */
> +	"bus",		/* GCC_CE_AXI_CLK */
> +};

You probably don't want this in a header file, as now each compilation
unit will have a copy :(.

Lumping all the clocks together assumes that you will only ever have all
clocks enabled, or all clocks disabled, are you sure that's what you
want?

[..]
> +struct qce_algo_ops {
> +	u32 type;
> +	int (*register_alg)(struct qce_device *qce, struct qce_algo_ops *ops);
> +	int (*async_req_queue)(struct qce_device *qce,
> +			       struct crypto_async_request *req);
> +	void (*async_req_done)(struct qce_device *qce, int ret);

What is the relationship between qce_algo_ops and the qce_alg_template
(which has these same two identically named callbacks)?

> +	int (*async_req_handle)(struct crypto_async_request *async_req);
> +};
> +
> +#endif /* _CORE_H_ */

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
