Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbaJXPJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:09:05 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:40509 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664AbaJXPJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:09:01 -0400
Message-ID: <544A6B84.2000508@mentor.com>
Date: Fri, 24 Oct 2014 18:08:52 +0300
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mikko Perttunen <mikko.perttunen@kapsi.fi>, <viresh.kumar@linaro.org>
CC: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>, <gnurou@gmail.com>,
        <pdeschrijver@nvidia.com>, <rjw@rjwysocki.net>,
        <mturquette@linaro.org>, <pwalmsley@nvidia.com>, <vinceh@nvidia.com>,
        <pgaikwad@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tuomas.tynkkynen@iki.fi>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: Re: [PATCH v5 02/16] clk: tegra: Add library for the DFLL clock source
 (open-loop mode)
References: <1414161563-16812-1-git-send-email-mikko.perttunen@kapsi.fi> <1414161563-16812-3-git-send-email-mikko.perttunen@kapsi.fi>
In-Reply-To: <1414161563-16812-3-git-send-email-mikko.perttunen@kapsi.fi>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mikko,

On 24.10.2014 17:39, Mikko Perttunen wrote:
> From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> 
> Add shared code to support the Tegra DFLL clocksource in open-loop
> mode. This root clocksource is present on the Tegra124 SoCs. The
> DFLL is the intended primary clock source for the fast CPU cluster.
> 
> This code is very closely based on a patch by Paul Walmsley from
> December (http://comments.gmane.org/gmane.linux.ports.tegra/15273),
> which in turn comes from the internal driver by originally created
> by Aleksandr Frid <afrid@nvidia.com>.
> 
> Subsequent patches will add support for closed loop mode and drivers
> for the Tegra124 fast CPU cluster DFLL devices, which rely on this
> code.
> 
> Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> Signed-off-by: Mikko Perttunen <mikko.perttunen@kapsi.fi>
> ---
> - Style fixes
> - Removed incorrect and unused DFLL_I2C_CFG_SLAVE_ADDR_MASK define
> - Documented that dfll_register_clk can return -ENOMEM
> - Harmonized clock operation order
> - Check !soc before allocating
> - Comment fixes
> 
>  drivers/clk/tegra/Makefile   |    1 +
>  drivers/clk/tegra/clk-dfll.c | 1090 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/clk/tegra/clk-dfll.h |   55 +++
>  3 files changed, 1146 insertions(+)
>  create mode 100644 drivers/clk/tegra/clk-dfll.c
>  create mode 100644 drivers/clk/tegra/clk-dfll.h
> 
> diff --git a/drivers/clk/tegra/Makefile b/drivers/clk/tegra/Makefile
> index f7dfb72..47320ca 100644
> --- a/drivers/clk/tegra/Makefile
> +++ b/drivers/clk/tegra/Makefile
> @@ -1,5 +1,6 @@
>  obj-y					+= clk.o
>  obj-y					+= clk-audio-sync.o
> +obj-y					+= clk-dfll.o
>  obj-y					+= clk-divider.o
>  obj-y					+= clk-periph.o
>  obj-y					+= clk-periph-gate.o
> diff --git a/drivers/clk/tegra/clk-dfll.c b/drivers/clk/tegra/clk-dfll.c
> new file mode 100644
> index 0000000..405fa9d
> --- /dev/null
> +++ b/drivers/clk/tegra/clk-dfll.c

[snip]

> +/*
> + * Runtime PM suspend/resume callbacks
> + */
> +
> +/**
> + * tegra_dfll_runtime_resume - enable all clocks needed by the DFLL
> + * @dev: DFLL device *
> + *
> + * Enable all clocks needed by the DFLL. Assumes that clk_prepare()
> + * has already been called on all the clocks.
> + *
> + * XXX Should also handle context restore when returning from off.
> + */
> +int tegra_dfll_runtime_resume(struct device *dev)
> +{
> +	struct tegra_dfll *td = dev_get_drvdata(dev);
> +	int ret;
> +
> +	ret = clk_enable(td->ref_clk);
> +	if (ret) {
> +		dev_err(dev, "could not enable ref clock: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = clk_enable(td->soc_clk);
> +	if (ret) {

What is the correct behaviour on error? Should you fallback and try to
enable td->i2c_clk clock or may be disable right enabled above td->ref_clk?

> +		dev_err(dev, "could not enable register clock: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = clk_enable(td->i2c_clk);
> +	if (ret) {

See the comment above.

> +		dev_err(dev, "could not enable i2c clock: %d\n", ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(tegra_dfll_runtime_resume);
> +
> +/**
> + * tegra_dfll_runtime_suspend - disable all clocks needed by the DFLL
> + * @dev: DFLL device *
> + *
> + * Disable all clocks needed by the DFLL. Assumes that other code
> + * will later call clk_unprepare().
> + */
> +int tegra_dfll_runtime_suspend(struct device *dev)
> +{
> +	struct tegra_dfll *td = dev_get_drvdata(dev);
> +
> +	clk_disable(td->ref_clk);
> +	clk_disable(td->soc_clk);
> +	clk_disable(td->i2c_clk);

Relevant to the comment above.

> +	return 0;
> +}
> +EXPORT_SYMBOL(tegra_dfll_runtime_suspend);
> +

[snip]

> +/**
> + * dfll_register_clk - register the DFLL output clock with the clock framework
> + * @td: DFLL instance
> + *
> + * Register the DFLL's output clock with the Linux clock framework and register
> + * the DFLL driver as an OF clock provider. Returns 0 upon success or -EINVAL
> + * or -ENOMEM upon failure.
> + */
> +static int dfll_register_clk(struct tegra_dfll *td)
> +{
> +	int ret;
> +
> +	dfll_clk_init_data.name = td->output_clock_name;
> +	td->dfll_clk_hw.init = &dfll_clk_init_data;
> +
> +	td->dfll_clk = clk_register(td->dev, &td->dfll_clk_hw);
> +	if (IS_ERR(td->dfll_clk)) {
> +		dev_err(td->dev, "DFLL clock registration error\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = of_clk_add_provider(td->dev->of_node, of_clk_src_simple_get,
> +				  td->dfll_clk);
> +	if (ret) {
> +		dev_err(td->dev, "of_clk_add_provider() failed\n");
> +		goto out_unregister_clk;
> +	}
> +
> +	return 0;
> +
> +out_unregister_clk:
> +	clk_unregister(td->dfll_clk);

---8<---
	if (ret) {
		dev_err(td->dev, "of_clk_add_provider() failed\n");
		clk_unregister(td->dfll_clk);
	}
---8<---

version is 5 lines and one label less.

> +	return ret;
> +}
> +

[snip]

> +/**
> + * read_dt_param - helper function for reading required parameters from the DT
> + * @td: DFLL instance
> + * @param: DT property name
> + * @dest: output pointer for the value read
> + *
> + * Read a required numeric parameter from the DFLL device node, or complain
> + * if the property doesn't exist. Returns a boolean indicating success for
> + * easy chaining of multiple calls to this function.
> + */
> +static bool read_dt_param(struct tegra_dfll *td, const char *param, u32 *dest)
> +{
> +	int err = of_property_read_u32(td->dev->of_node, param, dest);
> +
> +	if (err < 0) {
> +		dev_err(td->dev, "failed to read DT parameter %s: %d\n",
> +			param, err);
> +		return false;
> +	}
> +
> +	return true;
> +}

^^^^ Relatively useless wrapper function used only once. You are anyway
going to check the return value again...

> +
> +/**
> + * dfll_fetch_common_params - read DFLL parameters from the device tree
> + * @td: DFLL instance
> + *
> + * Read all the DT parameters that are common to both I2C and PWM operation.
> + * Returns 0 on success or -EINVAL on any failure.
> + */
> +static int dfll_fetch_common_params(struct tegra_dfll *td)
> +{
> +	bool ok = true;
> +
> +	ok &= read_dt_param(td, "nvidia,droop-ctrl", &td->droop_ctrl);

See the comment above.

> +	if (of_property_read_string(td->dev->of_node, "clock-output-names",
> +				    &td->output_clock_name)) {
> +		dev_err(td->dev, "missing clock-output-names property\n");
> +		ok = false;
> +	}
> +
> +	return ok ? 0 : -EINVAL;
> +}


--
With best wishes,
Vladimir
