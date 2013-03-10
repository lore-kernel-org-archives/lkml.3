Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338Ab3CJKUU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 06:20:20 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:61270 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3CJKUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 06:20:18 -0400
Message-ID: <513C5EBA.7040402@gmail.com>
Date: Sun, 10 Mar 2013 11:21:46 +0100
From: Francesco Lavra <francescolavra.fl@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org
Subject: Re: [PATCH 2/5] clk: notifier handler for dynamic voltage scaling
References: <1362026969-11457-1-git-send-email-mturquette@linaro.org> <1362026969-11457-3-git-send-email-mturquette@linaro.org>
In-Reply-To: <1362026969-11457-3-git-send-email-mturquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 05:49 AM, Mike Turquette wrote:
> Dynamic voltage and frequency scaling (dvfs) is a common power saving
> technique in many of today's modern processors.  This patch introduces a
> common clk rate-change notifier handler which scales voltage
> appropriately whenever clk_set_rate is called on an affected clock.
> 
> There are three prerequisites to using this feature:
> 
> 1) the affected clocks must be using the common clk framework
> 2) voltage must be scaled using the regulator framework
> 3) clock frequency and regulator voltage values must be paired via the
> OPP library
> 
> If a platform or device meets these requirements then using the notifier
> handler is straightforward.  A struct device is used as the basis for
> performing initial look-ups for clocks via clk_get and regulators via
> regulator_get.  This means that notifiers are subscribed on a per-device
> basis and multiple devices can have notifiers subscribed to the same
> clock.  Put another way, the voltage chosen for a rail during a call to
> clk_set_rate is a function of the device, not the clock.
> 
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
[...]
> +struct dvfs_info *dvfs_clk_notifier_register(struct dvfs_info_init *dii)
> +{
> +	struct dvfs_info *di;
> +	int ret = 0;
> +
> +	if (!dii)
> +		return ERR_PTR(-EINVAL);
> +
> +	di = kzalloc(sizeof(struct dvfs_info), GFP_KERNEL);
> +	if (!di)
> +		return ERR_PTR(-ENOMEM);
> +
> +	di->dev = dii->dev;
> +	di->clk = clk_get(di->dev, dii->con_id);
> +	if (IS_ERR(di->clk)) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	di->reg = regulator_get(di->dev, dii->reg_id);
> +	if (IS_ERR(di->reg)) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	di->tol = dii->tol;
> +	di->nb.notifier_call = dvfs_clk_notifier_handler;
> +
> +	ret = clk_notifier_register(di->clk, &di->nb);
> +
> +	if (ret)
> +		goto err;

Shouldn't regulator_put() and clk_put() be called in the error path?

> +
> +	return di;
> +
> +err:
> +	kfree(di);
> +	return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL_GPL(dvfs_clk_notifier_register);
> +
> +void dvfs_clk_notifier_unregister(struct dvfs_info *di)
> +{
> +	clk_notifier_unregister(di->clk, &di->nb);
> +	clk_put(di->clk);
> +	regulator_put(di->reg);
> +	kfree(di);
> +}
> +EXPORT_SYMBOL_GPL(dvfs_clk_notifier_unregister);

Regards,
Francesco
