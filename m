Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbaKLPp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:45:56 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:58305 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbaKLPpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:45:54 -0500
Date: Wed, 12 Nov 2014 16:45:50 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-tegra@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        mikko.perttunen@kapsi.fi, acourbot@nvidia.com,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 10/13] memory: tegra: Add EMC (external memory
 controller) driver
Message-ID: <20141112154549.GF26488@ulmo>
References: <1415779051-26410-1-git-send-email-tomeu.vizoso@collabora.com>
 <1415779051-26410-11-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VuQYccsttdhdIfIP"
Content-Disposition: inline
In-Reply-To: <1415779051-26410-11-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VuQYccsttdhdIfIP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 12, 2014 at 08:56:33AM +0100, Tomeu Vizoso wrote:
[...]
> diff --git a/drivers/memory/tegra/tegra124-emc.c b/drivers/memory/tegra/tegra124-emc.c
[...]
> +static int t124_emc_burst_regs[] = {

The t124 prefix seems rather redundant in a Tegra124-specific file. Also
these should really be unsigned.

> +struct emc_timing {
> +	unsigned long rate;
> +
> +	/*
> +	 * Store EMC burst data in a union to minimize mistakes. This allows
> +	 * us to use the same burst data lists as used by the downstream and
> +	 * ChromeOS kernels.

I don't understand what this means. Can you elaborate?

> +	 */
> +	union {
> +		u32 emc_burst_data[ARRAY_SIZE(t124_emc_burst_regs)];
> +		struct {
> +			u32 __pad0[121];
> +			u32 emc_xm2dqspadctrl2;
> +			u32 __pad1[15];
> +			u32 emc_zcal_interval;
> +			u32 __pad2[1];
> +			u32 emc_mrs_wait_cnt;
> +		};
> +	};
[...]
> +struct tegra_emc {
> +	struct platform_device *pdev;

I don't see this ever used other than for accessing pdev->dev, in which
case it would be much simpler and save a lot of characters if this was
simply:

	struct device *dev;

> +	struct tegra_mc *mc;
> +
> +	void __iomem *emc_regs;

There is no second set of registers, so the emc_ prefix is useless.

> +
> +	enum emc_dram_type dram_type;
> +	u8 dram_num;

Should be an unsized type and match what's returned by the MC accessor.

> +
> +	struct emc_timing last_timing;

struct emc_timing is rather big, can this be a pointer to an entry in
the timings array instead?

> +	struct emc_timing *timings;
> +	unsigned int num_timings;
> +};
> +
> +/* Timing change sequence functions */
> +
> +static void emc_ccfifo_writel(struct tegra_emc *tegra, u32 val,
> +			      unsigned long offs)
> +{
> +	writel(val, tegra->emc_regs + EMC_CCFIFO_DATA);
> +	writel(offs, tegra->emc_regs + EMC_CCFIFO_ADDR);
> +}
> +
> +static void emc_seq_update_timing(struct tegra_emc *tegra)
> +{
> +	int i;

unsigned int, please.

> +
> +	writel(1, tegra->emc_regs + EMC_TIMING_CONTROL);
> +
> +	for (i = 0; i < EMC_STATUS_UPDATE_TIMEOUT; ++i) {
> +		if (!(readl(tegra->emc_regs + EMC_STATUS) &
> +		    EMC_STATUS_TIMING_UPDATE_STALLED))
> +			return;
> +	}

You're busy-looping 1000 times here. What are the real criteria here?
How long is this allowed to take? Should this not be a timed loop where
the number of iterations doesn't matter?

> +
> +	dev_err(&tegra->pdev->dev, "timing update failed\n");
> +}

Should this return an error that can be propagated?

> +static void emc_seq_disable_auto_cal(struct tegra_emc *tegra)
> +{
> +	int i;
> +
> +	writel(0, tegra->emc_regs + EMC_AUTO_CAL_INTERVAL);
> +
> +	for (i = 0; i < EMC_STATUS_UPDATE_TIMEOUT; ++i) {
> +		if (!(readl(tegra->emc_regs + EMC_AUTO_CAL_STATUS) &
> +		    EMC_AUTO_CAL_STATUS_ACTIVE))
> +			return;
> +	}
> +
> +	dev_err(&tegra->pdev->dev, "auto cal disable failed\n");
> +}

Same comments as for emc_seq_update_timing().

> +
> +static void emc_seq_wait_clkchange(struct tegra_emc *tegra)
> +{
> +	int i;
> +
> +	for (i = 0; i < EMC_STATUS_UPDATE_TIMEOUT; ++i) {
> +		if (readl(tegra->emc_regs + EMC_INTSTATUS) &
> +		    EMC_INTSTATUS_CLKCHANGE_COMPLETE)
> +			return;
> +	}
> +
> +	dev_err(&tegra->pdev->dev, "clkchange failed\n");
> +}

And again.

> +
> +static void emc_prepare_timing_change(struct tegra_emc *tegra,
> +				      const struct emc_timing *timing)
> +{
> +	u32 val, val2;
> +	bool update = false;
> +	int pre_wait = 0;
> +	int i;

Both of these can be unsigned.

> +	enum emc_dll_change dll_change;
> +
> +	if ((tegra->last_timing.emc_mode_1 & 0x1) == (timing->emc_mode_1 & 1))
> +		dll_change = DLL_CHANGE_NONE;
> +	else if (timing->emc_mode_1 & 1)
> +		dll_change = DLL_CHANGE_ON;
> +	else
> +		dll_change = DLL_CHANGE_OFF;
> +
> +	/* Clear CLKCHANGE_COMPLETE interrupts */
> +
> +	writel(EMC_INTSTATUS_CLKCHANGE_COMPLETE,
> +	       tegra->emc_regs + EMC_INTSTATUS);
> +
> +	/* Disable dynamic self-refresh */
> +
> +	val = readl(tegra->emc_regs + EMC_CFG);
> +	if (val & EMC_CFG_PWR_MASK) {
> +		val &= ~EMC_CFG_POWER_FEATURES_MASK;
> +		writel(val, tegra->emc_regs + EMC_CFG);
> +
> +		pre_wait = 5;
> +	}
> +
> +	/* Disable SEL_DPD_CTRL for clock change */
> +
> +	val = readl(tegra->emc_regs + EMC_SEL_DPD_CTRL);
> +	if (val & (tegra->dram_type == DRAM_TYPE_DDR3 ?
> +	    EMC_SEL_DPD_CTRL_DDR3_MASK : EMC_SEL_DPD_CTRL_MASK)) {

This is really hard to read. Perhaps something like:

	if (tegra->dram_type == DRAM_TYPE_DDR3)
		mask = EMC_SEL_DPD_CTRL_DDR3_MASK;
	else
		mask = EMC_SEL_DPD_CTRL_MASK;

?

> +		val &= ~(EMC_SEL_DPD_CTRL_DATA_SEL_DPD |
> +				EMC_SEL_DPD_CTRL_ODT_SEL_DPD |
> +				EMC_SEL_DPD_CTRL_CA_SEL_DPD |
> +				EMC_SEL_DPD_CTRL_CLK_SEL_DPD);
> +		if (tegra->dram_type == DRAM_TYPE_DDR3)
> +			val &= ~EMC_SEL_DPD_CTRL_RESET_SEL_DPD;

These seem to be all the fields already present in the respective masks,
so why not just:

	val &= ~mask;

?

> +		writel(val, tegra->emc_regs + EMC_SEL_DPD_CTRL);
> +	}
> +
> +	/* Prepare DQ/DQS for clock change */
> +
> +	val = readl(tegra->emc_regs + EMC_BGBIAS_CTL0);
> +	val2 = tegra->last_timing.emc_bgbias_ctl0;
> +	if (!(timing->emc_bgbias_ctl0 &
> +	      EMC_BGBIAS_CTL0_BIAS0_DSC_E_PWRD_IBIAS_RX) &&
> +	    (val & EMC_BGBIAS_CTL0_BIAS0_DSC_E_PWRD_IBIAS_RX)) {
> +		val2 &= ~EMC_BGBIAS_CTL0_BIAS0_DSC_E_PWRD_IBIAS_RX;
> +		update = true;
> +	}
> +
> +	if ((val & EMC_BGBIAS_CTL0_BIAS0_DSC_E_PWRD) ||
> +	    (val & EMC_BGBIAS_CTL0_BIAS0_DSC_E_PWRD_IBIAS_VTTGEN)) {
> +		update = true;
> +	}
> +
> +	if (update) {
> +		writel(val2, tegra->emc_regs + EMC_BGBIAS_CTL0);
> +		if (pre_wait < 5)
> +			pre_wait = 5;
> +	}
> +
> +	update = false;
> +	val = readl(tegra->emc_regs + EMC_XM2DQSPADCTRL2);
> +	if (timing->emc_xm2dqspadctrl2 & EMC_XM2DQSPADCTRL2_VREF_ENABLE &&
> +	    !(val & EMC_XM2DQSPADCTRL2_VREF_ENABLE)) {
> +		val |= EMC_XM2DQSPADCTRL2_VREF_ENABLE;
> +		update = true;
> +	}
> +
> +	if (timing->emc_xm2dqspadctrl2 & EMC_XM2DQSPADCTRL2_RX_FT_REC_ENABLE &&
> +	    !(val & EMC_XM2DQSPADCTRL2_RX_FT_REC_ENABLE)) {
> +		val |= EMC_XM2DQSPADCTRL2_RX_FT_REC_ENABLE;
> +		update = true;
> +	}
> +
> +	if (update) {
> +		writel(val, tegra->emc_regs + EMC_XM2DQSPADCTRL2);
> +		if (pre_wait < 30)
> +			pre_wait = 30;
> +	}
> +
> +	/* Wait to settle */
> +
> +	if (pre_wait) {
> +		emc_seq_update_timing(tegra);
> +		udelay(pre_wait);
> +	}
> +
> +	/* Program CTT_TERM control */
> +
> +	if (tegra->last_timing.emc_ctt_term_ctrl != timing->emc_ctt_term_ctrl) {

There are a whole lot of very long lines caused by tegra->last_timing.
How about introducing a temporary variable:

	struct emc_timing *last = &tegra->last_timing;

or simply:

	struct emc_timing *last = tegra->last_timing;

after a change I suggested earlier.

> +		emc_seq_disable_auto_cal(tegra);
> +		writel(timing->emc_ctt_term_ctrl,
> +			tegra->emc_regs + EMC_CTT_TERM_CTRL);
> +		emc_seq_update_timing(tegra);
> +	}
> +
> +	/* Program burst shadow registers */
> +
> +	for (i = 0; i < ARRAY_SIZE(timing->emc_burst_data); ++i)
> +		__raw_writel(timing->emc_burst_data[i],
> +			     tegra->emc_regs + t124_emc_burst_regs[i]);
> +
> +	tegra_mc_write_emem_configuration(tegra->mc, timing->rate);
> +
> +	val = timing->emc_cfg & ~EMC_CFG_POWER_FEATURES_MASK;
> +	emc_ccfifo_writel(tegra, val, EMC_CFG);
> +
> +	/* Program AUTO_CAL_CONFIG */
> +
> +	if (timing->emc_auto_cal_config2 !=
> +	    tegra->last_timing.emc_auto_cal_config2)
> +		emc_ccfifo_writel(tegra, timing->emc_auto_cal_config2,
> +				  EMC_AUTO_CAL_CONFIG2);
> +	if (timing->emc_auto_cal_config3 !=
> +	    tegra->last_timing.emc_auto_cal_config3)
> +		emc_ccfifo_writel(tegra, timing->emc_auto_cal_config3,
> +				  EMC_AUTO_CAL_CONFIG3);
> +	if (timing->emc_auto_cal_config !=
> +	    tegra->last_timing.emc_auto_cal_config) {
> +		val = timing->emc_auto_cal_config;
> +		val &= EMC_AUTO_CAL_CONFIG_AUTO_CAL_START;
> +		emc_ccfifo_writel(tegra, val, EMC_AUTO_CAL_CONFIG);
> +	}
> +
> +	/* DDR3: predict MRS long wait count */
> +
> +	if (tegra->dram_type == DRAM_TYPE_DDR3 && dll_change == DLL_CHANGE_ON) {
> +		u32 cnt = 32;
> +
> +		if (timing->emc_zcal_interval != 0 &&
> +		    tegra->last_timing.emc_zcal_interval == 0)
> +			cnt -= tegra->dram_num * 256;

Hmm... I don't understand this: cnt == 32 at the beginning, now you're
subtracting something that's >= 256 if dram_num > 0. Is that really
intended?

> +
> +		val = timing->emc_mrs_wait_cnt
> +			& EMC_MRS_WAIT_CNT_SHORT_WAIT_MASK
> +			>> EMC_MRS_WAIT_CNT_SHORT_WAIT_SHIFT;

I think >> has higher precedence than &, so you probably want
parentheses here.

> +		if (cnt < val)
> +			cnt = val;
> +
> +		val = timing->emc_mrs_wait_cnt
> +			& ~EMC_MRS_WAIT_CNT_LONG_WAIT_MASK;
> +		val |= (cnt << EMC_MRS_WAIT_CNT_LONG_WAIT_SHIFT)
> +			& EMC_MRS_WAIT_CNT_LONG_WAIT_MASK;
> +
> +		writel(val, tegra->emc_regs + EMC_MRS_WAIT_CNT);
> +	}
> +
> +	val = timing->emc_cfg_2;
> +	val &= ~EMC_CFG_2_DIS_STP_OB_CLK_DURING_NON_WR;
> +	emc_ccfifo_writel(tegra, val, EMC_CFG_2);
> +
> +	/* DDR3: Turn off DLL and enter self-refresh */
> +
> +	if (tegra->dram_type == DRAM_TYPE_DDR3 && dll_change == DLL_CHANGE_OFF)
> +		emc_ccfifo_writel(tegra, timing->emc_mode_1, EMC_EMRS);
> +
> +	/* Disable refresh controller */
> +
> +	emc_ccfifo_writel(tegra, EMC_REFCTRL_DEV_SEL(tegra->dram_num),
> +			  EMC_REFCTRL);
> +	if (tegra->dram_type == DRAM_TYPE_DDR3)
> +		emc_ccfifo_writel(tegra,
> +				  EMC_DRAM_DEV_SEL(tegra->dram_num)
> +					| EMC_SELF_REF_CMD_ENABLED,
> +				  EMC_SELF_REF);
> +
> +	/* Flow control marker */
> +
> +	emc_ccfifo_writel(tegra, 1, EMC_STALL_THEN_EXE_AFTER_CLKCHANGE);
> +
> +	/* DDR3: Exit self-refresh */
> +
> +	if (tegra->dram_type == DRAM_TYPE_DDR3)
> +		emc_ccfifo_writel(tegra,
> +				  EMC_DRAM_DEV_SEL(tegra->dram_num),
> +				  EMC_SELF_REF);
> +	emc_ccfifo_writel(tegra,
> +			  EMC_REFCTRL_DEV_SEL(tegra->dram_num)
> +				| EMC_REFCTRL_ENABLE,
> +			  EMC_REFCTRL);
> +
> +	/* Set DRAM mode registers */
> +
> +	if (tegra->dram_type == DRAM_TYPE_DDR3) {
> +		if (timing->emc_mode_1 != tegra->last_timing.emc_mode_1)
> +			emc_ccfifo_writel(tegra, timing->emc_mode_1, EMC_EMRS);
> +		if (timing->emc_mode_2 != tegra->last_timing.emc_mode_2)
> +			emc_ccfifo_writel(tegra, timing->emc_mode_2, EMC_EMRS2);

These patterns repeat a lot, perhaps some helpers would be useful.
Something like:

#define emc_ccfifo_writel_if_changed(emc, old, new, field, offset)	\
	if ((new)->field != (old)->field)				\
		emc_ccfifo_writel(emc, (new)->field, offset);

...

			emc_ccfifo_writel_if_changed(tegra, last, timing,
						     emc_mode_1, EMC_EMRS);

That's not as much of an improvement as I had hoped... so feel free to
ignore.

> +static int load_timings_from_dt(struct tegra_emc *tegra,
> +				struct device_node *node)
> +{
> +	struct device_node *child;
> +	int child_count = of_get_child_count(node);
> +	int i = 0, err;

unsigned int for i.

> +
> +	tegra->timings = devm_kzalloc(&tegra->pdev->dev,
> +				      sizeof(struct emc_timing) * child_count,
> +				      GFP_KERNEL);

devm_kcalloc()/

> +	if (!tegra->timings)
> +		return -ENOMEM;
> +
> +	tegra->num_timings = child_count;
> +
> +	for_each_child_of_node(node, child) {
> +		struct emc_timing *timing = tegra->timings + (i++);

timing = &tegra->timings[i++];?

> +
> +		err = load_one_timing_from_dt(tegra, timing, child);
> +		if (err)
> +			return err;
> +	}
> +
> +	sort(tegra->timings, tegra->num_timings, sizeof(struct emc_timing),
> +	     cmp_timings, NULL);

sizeof(*timing)?

> +
> +	return 0;
> +}
> +
> +static const struct of_device_id tegra_emc_of_match[] = {
> +	{ .compatible = "nvidia,tegra124-emc" },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, tegra_emc_of_match);
> +
> +static struct tegra_emc *emc_instance;

Can we find a way around this global variable? I suppose that somebody
is going to call the tegra_emc_{prepare,complete}_timing_change() below,
so perhaps the caller needs to get a reference to the EMC and pass that
in?

> +static struct emc_timing *tegra_emc_find_timing(unsigned long rate)
> +{
> +	int i;

unsigned

> +
> +	if (!emc_instance)
> +		return NULL;
> +
> +	for (i = 0; i < emc_instance->num_timings; ++i) {
> +		if (emc_instance->timings[i].rate == rate)
> +			break;
> +	}
> +
> +	if (i == emc_instance->num_timings) {
> +		dev_err(&emc_instance->pdev->dev, "no timing for rate %lu\n", rate);
> +		return NULL;
> +	}
> +
> +	return emc_instance->timings + i;

This could be rewritten in a similar way than I suggested for the MC
changes earlier.

> +}
> +
> +int tegra_emc_prepare_timing_change(unsigned long rate)
> +{
> +	struct emc_timing *timing = tegra_emc_find_timing(rate);
> +
> +	if (!timing)
> +		return -ENOENT;
> +
> +	emc_prepare_timing_change(emc_instance, timing);
> +
> +	return 0;
> +}

It seems like this really ought to return an error if
emc_prepare_timing_change() fails.

> +
> +void tegra_emc_complete_timing_change(unsigned long rate)
> +{
> +	struct emc_timing *timing = tegra_emc_find_timing(rate);
> +
> +	if (!timing)
> +		return;
> +
> +	emc_complete_timing_change(emc_instance, timing);
> +}
> +
> +static int tegra_emc_probe(struct platform_device *pdev)
> +{
> +	struct tegra_emc *tegra;
> +	struct device_node *node;
> +	struct platform_device *mc_pdev;

Perhaps simply "mc"?

> +	struct resource *res;
> +	u32 ram_code, node_ram_code;

You only need node_ram_code in the loop, so perhaps move it there and
make the name something less cumbersome like "value"?

> +	int err;
> +
> +	tegra = devm_kzalloc(&pdev->dev, sizeof(*tegra), GFP_KERNEL);
> +	if (!tegra)
> +		return -ENOMEM;
> +
> +	tegra->pdev = pdev;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	tegra->emc_regs = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(tegra->emc_regs)) {
> +		dev_err(&pdev->dev, "failed to map EMC regs\n");

No need for this error message, devm_ioremap_resource() prints one of
you.

> +		return PTR_ERR(tegra->emc_regs);
> +	}
> +
> +	node = of_parse_phandle(pdev->dev.of_node,
> +				"nvidia,memory-controller", 0);
> +	if (!node) {
> +		dev_err(&pdev->dev, "could not get memory controller\n");
> +		return -ENOENT;
> +	}
> +
> +	mc_pdev = of_find_device_by_node(node);
> +	if (!mc_pdev)
> +		return -ENOENT;
> +
> +	tegra->mc = platform_get_drvdata(mc_pdev);
> +	if (!tegra->mc)
> +		return -ENOENT;

Perhaps this ought to be -EPROBE_DEFER to handle that case?

> +
> +	of_node_put(node);

I think that should go right after the call to of_find_device_by_node(),
otherwise it'll leak in case of errors earlier.

> +
> +	ram_code = tegra_read_ram_code();
> +
> +	tegra->num_timings = 0;
> +
> +	for_each_child_of_node(pdev->dev.of_node, node) {
> +		err = of_property_read_u32(node, "nvidia,ram-code", &node_ram_code);
> +		if (err || (node_ram_code != ram_code))
> +			continue;
> +
> +		err = load_timings_from_dt(tegra, node);
> +		if (err)
> +			return err;
> +		break;
> +	}
> +
> +	if (tegra->num_timings == 0)
> +		dev_warn(&pdev->dev, "no memory timings for ram code %u registered\n", ram_code);

Isn't this an error? What's the use of proceeding if this happens?

This is slightly more complicated than I think it should be. Perhaps
split this into a helper function that finds a node matching the RAM
code, then:

	node = tegra_emc_find_node_by_ram_code(pdev->dev.of_node, ram_code);
	if (!node)
		return -ENOENT;

	err = load_timings_from_dt(tegra, node);
	if (err)
		return err;

Also I think you need to of_node_put() the node when you're done with
it.

> +
> +	err = emc_init(tegra);
> +	if (err) {
> +		dev_err(&pdev->dev, "initialization failed: %d\n", err);
> +		return err;
> +	}
> +
> +	platform_set_drvdata(pdev, tegra);
> +
> +	emc_instance = tegra;
> +
> +	return 0;
> +};
> +
> +static struct platform_driver tegra_emc_driver = {
> +	.probe = tegra_emc_probe,
> +	.driver = {
> +		.name = "tegra-emc",
> +		.of_match_table = tegra_emc_of_match,

Perhaps you also want to add a ".suppress_bind_attrs = true;" here to
avoid people from causing oopses by unbinding via sysfs.

Thierry

--VuQYccsttdhdIfIP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUY4CtAAoJEN0jrNd/PrOhGZMQAIG+l457hbNAZuraxn6vRWTV
/FK/jdkCFBkqwqfynwWQd2zWh81TNqXVCN+kWY0PRCGa+oOGe9rcE6ET3D+H5uCV
SUXXaUJ68DyDihiATjAy0fE3TXcCq22Wvj7lVysEcIuNnlyTOPaFxjjEXiPUkwqX
yHjcKpZLdPS90NG3CD9kujGD0uMsSABMlcolzcr7dveY2qX1k2dmg4XShLmddkP+
cZQTER+fgIDcZVLkBEp3/OcREpD4+Q6buV77prUt0Um+BM0KPt6pjxLFMGjh1WLr
yP+fPib9/SwPQcNMtR4kXe0Z11jZAZUzvuLY/1hxObxHu6zm65nyyOA1bUJ1mYqp
2UQGxKT9SeZvCqalvK3/iYviChIOAZCL39dKVXhBevJKH3vxyoS+M62rILYLucm+
089zaGUT5P56JFjqfNOe90vpws3vKD0tALs7VFxHgteZgRO+7CYH4shq2oQyFsmN
19ofR1dTghAbNIGfbzVS53kJoKlZLdkUpzIr0jPBJZIHFB2hIYVTXK2hFwnR5tyD
DiEGedVKnno5chXX9WYrRhlBjT/BzsKF3WTmyvHnA3B9Aad7wAnb0kMMhQ5Oz4SJ
EO9liZ3hE05hZTd7NfpPQ0KU4rxeTNZhL6+FMh4Z73UAZUh1NnWgjb2ydLcKModi
HW8oKOw+mdkv9znNaMgz
=FDRM
-----END PGP SIGNATURE-----

--VuQYccsttdhdIfIP--
