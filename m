Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaIAV4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 17:56:11 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:52038 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaIAV4I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 17:56:08 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Chris Zhong <zyw@rock-chips.com>, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, sameo@linux.intel.com, lee.jones@linaro.org,
        lgirdwood@gmail.com, a.zummo@towertech.it
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1409564800-18477-1-git-send-email-zyw@rock-chips.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, dianders@chromium.org, heiko@sntech.de,
        olof@lixom.net, sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com,
        "Chris Zhong" <zyw@rock-chips.com>
References: <1409562468-16586-1-git-send-email-zyw@rock-chips.com>
 <1409564800-18477-1-git-send-email-zyw@rock-chips.com>
Message-ID: <20140901215555.5251.33484@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v7 4/5] clk: RK808: Add clkout driver for RK808
Date: Mon, 01 Sep 2014 14:55:55 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chris Zhong (2014-09-01 02:46:40)
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> 
> 
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Doug Anderson <dianders@chromium.org>

Hello Chris,

Thanks for submitting this patch. Could you fill in a proper changelog?
Also you should reorder the tags like so:

Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Chris Zhong <zyw@rock-chips.com>

<snip>

> +static int rk808_clkout2_control(struct clk_hw *hw, bool enable)
> +{
> +       struct rk808_clkout *rk808_clkout = container_of(hw,
> +                                                        struct rk808_clkout,
> +                                                        clkout2_hw);
> +       struct rk808 *rk808 = rk808_clkout->rk808;
> +
> +       return regmap_update_bits(rk808->regmap, RK808_CLK32OUT_REG,
> +                                 CLK32KOUT2_EN, enable ? CLK32KOUT2_EN : 0);
> +}

Nitpick: can you rename "control" to "enable" or "ungate"? That makes it
more obvious what the function is doing without having to inspect the
code in the function body.

<snip>

> +static int rk808_clkout_probe(struct platform_device *pdev)
> +{
> +       struct rk808 *rk808 = dev_get_drvdata(pdev->dev.parent);
> +       struct i2c_client *client = rk808->i2c;
> +       struct device_node *node = client->dev.of_node;
> +       struct clk_init_data init = {};
> +       struct clk **clk_table;
> +       struct rk808_clkout *rk808_clkout;
> +
> +       rk808_clkout = devm_kzalloc(&client->dev,
> +                                   sizeof(*rk808_clkout), GFP_KERNEL);
> +       if (!rk808_clkout)
> +               return -ENOMEM;
> +
> +       rk808_clkout->rk808 = rk808;
> +
> +       clk_table = devm_kzalloc(&client->dev,
> +                                2 * sizeof(struct clk *), GFP_KERNEL);

Better to use devm_kcalloc. Also good to define a constant like:

#define RK808_NR_OUTPUT 2

... and then use RK8808_NR_OUTPUT instead of hard-coding the value 2 in
the driver.

> +       if (!clk_table)
> +               return -ENOMEM;
> +
> +       init.flags = CLK_IS_ROOT;
> +       init.parent_names = NULL;
> +       init.num_parents = 0;
> +       init.name = "rk808-clkout1";
> +       init.ops = &rk808_clkout1_ops;
> +       rk808_clkout->clkout1_hw.init = &init;
> +
> +       /* optional override of the clockname */
> +       of_property_read_string_index(node, "clock-output-names",
> +                                     0, &init.name);
> +
> +       clk_table[0] = devm_clk_register(&client->dev,
> +                                        &rk808_clkout->clkout1_hw);
> +       if (IS_ERR(clk_table[0]))
> +               return PTR_ERR(clk_table[0]);
> +
> +       init.name = "rk808-clkout2";
> +       init.ops = &rk808_clkout2_ops;
> +       rk808_clkout->clkout2_hw.init = &init;
> +
> +       /* optional override of the clockname */
> +       of_property_read_string_index(node, "clock-output-names",
> +                                     1, &init.name);
> +
> +       clk_table[1] = devm_clk_register(&client->dev,
> +                                        &rk808_clkout->clkout2_hw);
> +       if (IS_ERR(clk_table[1]))
> +               return PTR_ERR(clk_table[1]);
> +
> +       rk808_clkout->clk_data.clks = clk_table;
> +       rk808_clkout->clk_data.clk_num = 2;

Again, here you can use RK808_NR_OUTPUT.

Otherwise the driver looks pretty good to me.

Thanks,
Mike
