Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbaLKS0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 13:26:49 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49882 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbaLKS0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 13:26:47 -0500
Message-ID: <f65fbb61603f756f198c6fc66bdf1893.squirrel@www.codeaurora.org>
In-Reply-To: <20141208132827.GA13942@ulmo.nvidia.com>
References: <1417815001-9883-1-git-send-email-hali@codeaurora.org>
    <20141208132827.GA13942@ulmo.nvidia.com>
Date: Thu, 11 Dec 2014 18:26:46 -0000
Subject: Re: [PATCH 1/2] drm/msm: Initial add eDP support in msm drm driver
 (V2)
From: hali@codeaurora.org
To: "Thierry Reding" <thierry.reding@gmail.com>
Cc: "Hai Li" <hali@codeaurora.org>, dri-devel@lists.freedesktop.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com
User-Agent: SquirrelMail/1.4.22-4.el6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> +static int edp_bind(struct device *dev, struct device *master, void
>> *data)
>> +{
>> +	struct drm_device *drm = dev_get_drvdata(master);
>> +	struct msm_drm_private *priv = drm->dev_private;
>> +	struct msm_edp *edp;
>> +
>> +	DBG("");
>> +	edp = edp_init(to_platform_device(dev));
>
> There's a lot of this casting to platform devices and then using
> pdev->dev to get at the struct device. I don't immediately see a use for
> the platform device, so why not just stick with struct device *
> consistently?
>

There are some places in edp_init() to use struct platform_device *.
Also, this is to make edp code consistent with hdmi.

>> + * It will call msm_edp_aux_ctrl() function to reset the aux channel,
>> + * if the waiting is timeout.
>> + * The caller who triggers the transaction should avoid the
>> + * msm_edp_aux_ctrl() running concurrently in other threads, i.e.
>> + * start transaction only when aux channel is fully enabled.
>> + */
>> +ssize_t edp_aux_transfer(struct drm_dp_aux *drm_aux, struct
>> drm_dp_aux_msg *msg)
>> +{
>> +	struct edp_aux *aux = to_edp_aux(drm_aux);
>> +	ssize_t ret;
>> +	bool native = msg->request & (DP_AUX_NATIVE_WRITE &
>> DP_AUX_NATIVE_READ);
>> +	bool read = msg->request & (DP_AUX_I2C_READ & DP_AUX_NATIVE_READ);
>
> These checks are confusing. It seems like they might actually work
> because of how these symbols are defined, but I'd expect something like:
>
> 	native = msg->request & (DP_AUX_NATIVE_WRITE | DP_AUX_NATIVE_READ);
>

I think the above solution will not work because it will take
DP_AUX_I2C_READ as "native".

> Or perhaps even clearer:
>
> 	switch (msg->request) {
> 	case DP_AUX_NATIVE_WRITE:
> 	case DP_AUX_NATIVE_READ:
> 		native = true;
> 		break;
>
> 	...
> 	}
>

The switch/case code will work only if we remove other unrelated bits from
input msg->request.

>From my understanding, the idea to define these symbols is to take BIT(7)
as *native* mark and BIT(0) as *read* mark, and the
I2C_WRITE/I2C_READ/NATIVE_WRITE/NATIVE_READ are 4 combinations of these 2
bits. Hence i am still thinking the original way is reflecting the way
they are defined.

>> +	/* Ignore address only message */
>> +	if ((msg->size == 0) || (msg->buffer == NULL)) {
>> +		msg->reply = native ?
>> +			DP_AUX_NATIVE_REPLY_ACK : DP_AUX_I2C_REPLY_ACK;
>> +		return msg->size;
>> +	}
>
> How do you support I2C-over-AUX then? How else will the device know
> which I2C slave to address?
>

H/W takes care of the i2c details. S/W only needs to tell H/W if the
transaction is i2c or native and the address. Please see
edp_msg_fifo_tx().







>> +static int cont_splash;	/* 1 to enable continuous splash screen */
>> +EXPORT_SYMBOL(cont_splash);
>> +
>> +module_param(cont_splash, int, 0);
>> +MODULE_PARM_DESC(cont_splash, "Enable continuous splash screen on
>> eDP");
>
> Huh? Is this supposed to allow hand-off from firmware to kernel? If so I
> don't think that's going to work without having proper support for it
> across the driver. I don't see support for this in the MDP subdriver, so
> I doubt that it's going to work at all.
>
> Either way, I don't think using a module parameter for this is the right
> solution.
>

I will remove the cont_splash support for now and will have a new change
to fully support hand-off, including all display subdrivers.

>> +struct edp_ctrl {
>> +	struct platform_device *pdev;
>> +
>> +	void __iomem *base;
>> +
>> +	/* regulators */
>> +	struct regulator *vdda_vreg;
>> +	struct regulator *lvl_reg;
>> +
>> +	/* clocks */
>> +	struct clk *aux_clk;
>> +	struct clk *pixel_clk;
>> +	struct clk *ahb_clk;
>> +	struct clk *link_clk;
>> +	struct clk *mdp_core_clk;
>> +
>> +	/* gpios */
>> +	int gpio_panel_en;
>> +	int gpio_panel_hpd;
>> +	int gpio_lvl_en;
>> +	int gpio_bkl_en;
>
> These should really be using the new gpiod_*() API. Also, at least
> panel_en and bkl_en seem wrongly placed. They should be handled in the
> panel and backlight drivers, not the eDP driver.
>

I will move bkl_en to pwm_backlight DT and use gpiod_* APIs. We don't have
a panel driver and hope the eDP driver can support all the panels.


>> +static const struct edp_pixel_clk_div clk_divs[2][EDP_PIXEL_CLK_NUM] =
>> {
>> +	{ /* Link clock = 162MHz, source clock = 810MHz */
>> +		{119000, 31,  211}, /* WSXGA+ 1680x1050@60Hz CVT */
>> +		{130250, 32,  199}, /* UXGA 1600x1200@60Hz CVT */
>> +		{148500, 11,  60},  /* FHD 1920x1080@60Hz */
>> +		{154000, 50,  263}, /* WUXGA 1920x1200@60Hz CVT */
>> +		{209250, 31,  120}, /* QXGA 2048x1536@60Hz CVT */
>> +		{268500, 119, 359}, /* WQXGA 2560x1600@60Hz CVT */
>> +		{138530, 33,  193}, /* AUO B116HAN03.0 Panel */
>> +		{141400, 48,  275}, /* AUO B133HTN01.2 Panel */
>> +	},
>> +	{ /* Link clock = 270MHz, source clock = 675MHz */
>> +		{119000, 52,  295}, /* WSXGA+ 1680x1050@60Hz CVT */
>> +		{130250, 11,  57},  /* UXGA 1600x1200@60Hz CVT */
>> +		{148500, 11,  50},  /* FHD 1920x1080@60Hz */
>> +		{154000, 47,  206}, /* WUXGA 1920x1200@60Hz CVT */
>> +		{209250, 31,  100}, /* QXGA 2048x1536@60Hz CVT */
>> +		{268500, 107, 269}, /* WQXGA 2560x1600@60Hz CVT */
>> +		{138530, 63,  307}, /* AUO B116HAN03.0 Panel */
>> +		{141400, 53,  253}, /* AUO B133HTN01.2 Panel */
>> +	},
>> +};
>
> Can't you compute these programmatically? If you rely on this table
> you'll need to extend it everytime you want to support a new panel or
> resolution.
>

The computation are from internal tools. We can add more entries when we
need to support new panels.

>> +static void edp_ctrl_on_worker(struct work_struct *work)
>> +{
> [...]
>> +}
>> +
>> +static void edp_ctrl_off_worker(struct work_struct *work)
>> +{
>> +	struct edp_ctrl *ctrl = container_of(
>> +				work, struct edp_ctrl, off_work);

>> +}
>
> Why are these two functions workers?
>

msm_edp_ctrl_power() is called by user thread in bridge->enable/disable
and during edp on/off, it will send command to panel and block and wait
for panel's response. We don't want to block user thread. Also, the
bridge->enable/disable have no return value and there is no way to report
error to user. During test, we had a issue when a signal is pending, it
will interrupt and wake up the user thread waiting process. In this case,
user has no way to know it.

>> +
>> +irqreturn_t msm_edp_ctrl_irq(struct edp_ctrl *ctrl)
>> +{
> [...]
>> +	if (isr1 & EDP_INTERRUPT_REG_1_HPD)
>> +		DBG("edp_hpd");
>
> Don't you want to handle this?
>

We will have another change to support HPD. Also, this is not a reliable
signal for HPD.

>> +
>> +	if (!ctrl->power_on) {
>> +		if (!ctrl->cont_splash)
>> +			edp_ctrl_phy_aux_enable(ctrl, 1);
>> +		edp_ctrl_irq_enable(ctrl, 1);
>> +	}
>> +
>> +	ret = drm_dp_link_probe(ctrl->drm_aux, &ctrl->dp_link);
>> +	if (ret) {
>> +		pr_err("%s: read dpcd cap failed, %d\n", __func__, ret);
>> +		goto disable_ret;
>> +	}
>> +
>> +	/* Initialize link rate as panel max link rate */
>> +	ctrl->link_rate = drm_dp_link_rate_to_bw_code(ctrl->dp_link.rate);
>
> There's a lot of code here that should probably be a separate function
> rather than be called as part of retrieving the EDID.
>

I will change the function name.


>> diff --git a/drivers/gpu/drm/msm/edp/edp_phy.c
>> b/drivers/gpu/drm/msm/edp/edp_phy.c
> [...]
>> +bool msm_edp_phy_ready(struct edp_phy *phy)
>> +{
>> +	u32 status;
>> +	int cnt;
>> +
>> +	cnt = 100;
>> +	while (--cnt) {
>> +		status = edp_read(phy->base +
>> +				REG_EDP_PHY_GLB_PHY_STATUS);
>> +		if (status & 0x01)
>
> Can you add a define for 0x01?
>

>> +		pr_err("%s: PHY NOT ready\n", __func__);
>> +		return false;
>> +	} else {
>> +		return true;
>> +	}
>> +}
>> +
>> +void msm_edp_phy_ctrl(struct edp_phy *phy, int enable)
>> +{
>> +	DBG("enable=%d", enable);
>> +	if (enable) {
>> +		/* Reset */
>> +		edp_write(phy->base + REG_EDP_PHY_CTRL, 0x005); /* bit 0, 2 */
>> +		wmb();
>> +		usleep_range(500, 1000);
>> +		edp_write(phy->base + REG_EDP_PHY_CTRL, 0x000);
>> +		edp_write(phy->base + REG_EDP_PHY_GLB_PD_CTL, 0x3f);
>> +		edp_write(phy->base + REG_EDP_PHY_GLB_CFG, 0x1);
>> +	} else {
>> +		edp_write(phy->base + REG_EDP_PHY_GLB_PD_CTL, 0xc0);
>> +	}
>
> Please, also add defines for the values here. It's impossible to tell
> from the code what this does or what might need fixing if there was a
> bug.
>
Some of the values are magic number for H/W. They are hard to define.

Thanks,
Hai

