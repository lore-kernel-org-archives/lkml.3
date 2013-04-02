Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761835Ab3DBRyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 13:54:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39662 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759722Ab3DBRyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:54:13 -0400
Message-ID: <515B1A25.3040800@ti.com>
Date: Tue, 2 Apr 2013 20:49:25 +0300
From: Taras Kondratiuk <taras@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linaro-dev@lists.linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <patches@linaro.org>
Subject: Re: [PATCH 2/5] clk: notifier handler for dynamic voltage scaling
In-Reply-To: <1362026969-11457-3-git-send-email-mturquette@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike

> +/*
> + * Copyright (C) 2011-2012 Linaro Ltd <mturquette@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Helper functions for dynamic voltage & frequency transitions using
> + * the OPP library.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/opp.h>
> +#include <linux/device.h>
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +
> +/*
> + * XXX clk, regulator & tolerance should be stored in the OPP table?
> + */
> +struct dvfs_info {
> +    struct device *dev;
> +    struct clk *clk;
> +    struct regulator *reg;
> +    int tol;
> +    struct notifier_block nb;
> +};
> +
> +#define to_dvfs_info(_nb) container_of(_nb, struct dvfs_info, nb)
> +
> +static int dvfs_clk_notifier_handler(struct notifier_block *nb,
> +        unsigned long flags, void *data)
> +{
> +    struct clk_notifier_data *cnd = data;
> +    struct dvfs_info *di = to_dvfs_info(nb);
> +    int ret, volt_new, volt_old;
> +    struct opp *opp;
> +
> +    volt_old = regulator_get_voltage(di->reg);
> +    rcu_read_lock();
> +    opp = opp_find_freq_floor(di->dev, &cnd->new_rate);
I think here should be opp_find_freq_ceil().
Let's imagine we have a following OPP table for some device:
1 - <100MHz - 1.0V>
2 - <200MHz - 1.2V>
3 - <400MHz - 1.4V>

If device driver scales clock to 150MHz, then OPP #1 will be chosen.
This will lead to configuration <150MHz - 1.0V> that may be unstable.
It would be better to ceil and end-up with <150MHz - 1.2V>.

> +    volt_new = opp_get_voltage(opp);
> +    rcu_read_unlock();
> +
> +    /* scaling up?  scale voltage before frequency */
> +    if (flags & PRE_RATE_CHANGE && cnd->new_rate > cnd->old_rate) {
opp_find_freq_*() functions can update cnd->new_rate,
so you may compare not exactly what you are expecting.

> +        dev_dbg(di->dev, "%s: %d mV --> %d mV\n",
> +                __func__, volt_old, volt_new);
> +
> +        ret = regulator_set_voltage_tol(di->reg, volt_new, di->tol);
I may not have a deep understanding of regulator framework,
but looks like regulator_set_voltage_tol() is not the right API here.
As per my understanding regulator framework should aggregate
voltage request from different consumers of the particular regulator.

Let's say there are two consumers of VDD regulator.
First device set 1.0V. It will map to range 0.98-1.02V (2% tolerance).
If second device will try to set 1.3V it will fail because range 1.28-1.32V
does not overlap with the first request.

Maybe better to set upper limit to max OPP voltage or just use INT_MAX.

> +
> +        if (ret) {
> +            dev_warn(di->dev, "%s: unable to scale voltage up.\n",
> +                 __func__);
> +            return notifier_from_errno(ret);
> +        }
> +    }
> +
> +    /* scaling down?  scale voltage after frequency */
> +    if (flags & POST_RATE_CHANGE && cnd->new_rate < cnd->old_rate) {
> +        dev_dbg(di->dev, "%s: %d mV --> %d mV\n",
> +                __func__, volt_old, volt_new);
> +
> +        ret = regulator_set_voltage_tol(di->reg, volt_new, di->tol);
> +
> +        if (ret) {
> +            dev_warn(di->dev, "%s: unable to scale voltage down.\n",
> +                 __func__);
> +            return notifier_from_errno(ret);
> +        }
> +    }
> +
> +    return NOTIFY_OK;
> +}
> +
> +struct dvfs_info *dvfs_clk_notifier_register(struct dvfs_info_init *dii)
> +{
> +    struct dvfs_info *di;
> +    int ret = 0;
> +
> +    if (!dii)
> +        return ERR_PTR(-EINVAL);
> +
> +    di = kzalloc(sizeof(struct dvfs_info), GFP_KERNEL);
> +    if (!di)
> +        return ERR_PTR(-ENOMEM);
> +
> +    di->dev = dii->dev;
> +    di->clk = clk_get(di->dev, dii->con_id);
> +    if (IS_ERR(di->clk)) {
> +        ret = -ENOMEM;
> +        goto err;
> +    }
> +
> +    di->reg = regulator_get(di->dev, dii->reg_id);
> +    if (IS_ERR(di->reg)) {
> +        ret = -ENOMEM;
> +        goto err;
> +    }
> +
> +    di->tol = dii->tol;
> +    di->nb.notifier_call = dvfs_clk_notifier_handler;
> +
> +    ret = clk_notifier_register(di->clk, &di->nb);
> +
> +    if (ret)
> +        goto err;
> +
> +    return di;
> +
> +err:
> +    kfree(di);
> +    return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL_GPL(dvfs_clk_notifier_register);
> +
> +void dvfs_clk_notifier_unregister(struct dvfs_info *di)
> +{
> +    clk_notifier_unregister(di->clk, &di->nb);
> +    clk_put(di->clk);
> +    regulator_put(di->reg);
> +    kfree(di);
> +}
> +EXPORT_SYMBOL_GPL(dvfs_clk_notifier_unregister);
> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index b3ac22d..28d952f 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -78,9 +78,34 @@  struct clk_notifier_data {
>      unsigned long        new_rate;
>  };
>
> -int clk_notifier_register(struct clk *clk, struct notifier_block *nb);
> +/**
> + * struct dvfs_info_init - data needs to initialize struct dvfs_info
> + * @dev:    device related to this frequency-voltage pair
> + * @con_id:    string name of clock connection
> + * @reg_id:    string name of regulator
> + * @tol:    voltage tolerance for this device
> + *
> + * Provides the data needed to register a common dvfs sequence in a clk
> + * notifier handler.  The clk and regulator lookups are stored in a
> + * private struct and the notifier handler is registered with the clk
> + * framework with a call to dvfs_clk_notifier_register.
> + *
> + * FIXME stuffing @tol here is a hack.  It belongs in the opp table.
> + * Maybe clk & regulator will also live in the opp table some day.
> + */
> +struct dvfs_info_init {
> +    struct device *dev;
> +    const char *con_id;
> +    const char *reg_id;
> +    int tol;
> +};
> +
> +struct dvfs_info;
>
> +int clk_notifier_register(struct clk *clk, struct notifier_block *nb);
>  int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb);
> +struct dvfs_info *dvfs_clk_notifier_register(struct dvfs_info_init *dii);
> +void dvfs_clk_notifier_unregister(struct dvfs_info *di);
>
>  #endif

-- 
BR
Taras Kondratiuk | GlobalLogic

