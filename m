Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbaJCPM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:12:29 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:42067 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbaJCPM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:12:26 -0400
Message-ID: <542EBCFE.9050602@mm-sol.com>
Date: Fri, 03 Oct 2014 18:13:02 +0300
From: Georgi Djakov <gdjakov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: mturquette@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v1] clk: qcom: Add support for regmap clock dividers
References: <1412097655-10662-1-git-send-email-gdjakov@mm-sol.com> <542D953F.3030701@codeaurora.org>
In-Reply-To: <542D953F.3030701@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 09:11 PM, Stephen Boyd wrote:
> On 09/30/14 10:20, Georgi Djakov wrote:
>> This patch expands the regmap support to allow registration of clock
>> dividers. It just prepares for the introduction of a clkdiv driver,
>> that will be in a separate patch.
>> Such dividers are found in the Qualcomm PMIC chips such as PM8941,
>> PMA8084 and others.
> 
> We're going to need to rework the Makefile in clk/qcom so that we only
> build certain pieces of the "library" when we need them. Right now the
> directory is focused entirely on mmio clock controllers and if we put
> the pmic clocks in there then we need to figure out a way to only build
> the pmic pieces if only the pmic driver is selected and only build the
> mmio pieces if the mmio drivers are selected.
> 

Ok, the pmic clocks currently depend only on clk-regmap.o, but if we prefer
to separate this part of the "library", it could be moved into a separate
file. Will update.

>>
>> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
>> ---
>>  drivers/clk/qcom/clk-regmap.c |   68 +++++++++++++++++++++++++++++++++++++++++
>>  drivers/clk/qcom/clk-regmap.h |   24 +++++++++++++++
>>  2 files changed, 92 insertions(+)
>>
>> diff --git a/drivers/clk/qcom/clk-regmap.c b/drivers/clk/qcom/clk-regmap.c
>> index a58ba39..d63b8ca 100644
>> --- a/drivers/clk/qcom/clk-regmap.c
>> +++ b/drivers/clk/qcom/clk-regmap.c
>> @@ -112,3 +112,71 @@ struct clk *devm_clk_register_regmap(struct device *dev,
>>  	return devm_clk_register(dev, &rclk->hw);
>>  }
>>  EXPORT_SYMBOL_GPL(devm_clk_register_regmap);
>> +
>> +/**
>> + * clkdiv_recalc_rate_regmap - Calculate clock divider output rate
> 
> Arguments should be documented?
>> + */
>> +unsigned long clkdiv_recalc_rate_regmap(struct clk_hw *hw,
> 
> Or this should be static.
> 
>> +					unsigned long parent_rate)
>> +{
>> +	struct clk_regmap *rclk = to_clk_regmap(hw);
>> +	struct clkdiv_regmap *clkdiv = to_clkdiv_regmap(rclk);
>> +	unsigned int div, val;
>> +
>> +	regmap_read(rclk->regmap, clkdiv->reg, &val);
>> +	if (!val)
>> +		return parent_rate;
>> +
>> +	div = (val >> clkdiv->shift) & ((1 << clkdiv->width)-1);
>> +
>> +	return parent_rate / div;
> 
> I don't know if you saw the patch to split out the clk-divider.c logic
> from the readl/writel patch I sent[1]? That could make this slightly
> smaller.
> tabl

Could you please provide a link to that patch?

>> +}
>> +EXPORT_SYMBOL_GPL(clkdiv_recalc_rate_regmap);
>> +
>> +static const struct clk_ops clkdiv_ops = {
>> +	.enable = clk_enable_regmap,
>> +	.disable = clk_disable_regmap,
> 
> This isn't exactly a divider if it also has enable/disable control. At
> which point this starts to look like a composite clock. Perhaps call
> this clk_div_gate_ops?
> 
>> +	.is_enabled = clk_is_enabled_regmap,
>> +	.recalc_rate = clkdiv_recalc_rate_regmap,
> 
> No .set_rate? So call it clk_fixed_div_gate_ops?
> 

Actually there is a set_rate that i somehow missed here, it looks this way:

int clkdiv_set_rate_regmap(struct clk_hw *hw, unsigned long rate,
                           unsigned long parent_rate)
{
        struct clk_regmap *rclk = to_clk_regmap(hw);
        struct clkdiv_regmap *clkdiv = to_clkdiv_regmap(rclk);
        struct clk_div_table *table = clkdiv->table;
        unsigned long div;

        if (rate > parent_rate)
                return -EINVAL;

        div = DIV_ROUND_UP(parent_rate, rate);
                                                                                                                                                                                             
        for(; table->div; table++)
                if (table->div == div)
                        return regmap_update_bits(rclk->regmap, clkdiv->reg,
                                                  rclk->enable_mask,
                                                  table->val);
        return -EINVAL;
}

>> +};
>> +EXPORT_SYMBOL_GPL(clkdiv_ops);
>> +
>> +/**
>> + * devm_clkdiv_register_regmap - register a clk_regmap clock divider
>> + *
>> + * @dev: device that is registering this clock
>> + * @name: name of this clock
>> + * @parent_name: name of clock's parent
>> + * @flags: framework-specific flags
>> + * @clkdiv: clock divider to operate on
>> + *
>> + * Clocks that use regmap for their register I/O should register their
>> + * clk_regmap struct via this function so that the regmap is initialized
>> + * and so that the clock is registered with the common clock framework.
>> + */
>> +struct clk *devm_clkdiv_register_regmap(struct device *dev, const char *name,
>> +					const char *parent_name,
>> +					unsigned long flags,
>> +					struct clkdiv_regmap *clkdiv)
>> +{
>> +	struct clk_init_data init;
>> +
>> +	if (!clkdiv)
>> +		return ERR_PTR(-ENODEV);
> 
> Looks like a useless check. Just blow up instead so we don't have to
> tolerate bad code.
> 

Ok, sure!

>> +
>> +	clkdiv->rclk.regmap = dev_get_regmap(dev->parent, NULL);
>> +
>> +	if (!clkdiv->rclk.regmap)
>> +		return ERR_PTR(-ENXIO);
>> +
>> +	init.name = name;
>> +	init.parent_names = (parent_name ? &parent_name : NULL);
>> +	init.num_parents = (parent_name ? 1 : 0);
>> +	init.flags = flags;
>> +	init.ops = &clkdiv_ops;
>> +
>> +	clkdiv->rclk.hw.init = &init;
>> +
>> +	return devm_clk_register(dev, &clkdiv->rclk.hw);
>> +}
>> +EXPORT_SYMBOL_GPL(devm_clkdiv_register_regmap);
>> diff --git a/drivers/clk/qcom/clk-regmap.h b/drivers/clk/qcom/clk-regmap.h
>> index 491a63d..02582cf 100644
>> --- a/drivers/clk/qcom/clk-regmap.h
>> +++ b/drivers/clk/qcom/clk-regmap.h
>> @@ -42,4 +42,28 @@ void clk_disable_regmap(struct clk_hw *hw);
>>  struct clk *
>>  devm_clk_register_regmap(struct device *dev, struct clk_regmap *rclk);
>>  
>> +/**
>> + * struct clkdiv_regmap - regmap supporting clock divider
>> + * @rclk:   regmap supporting clock struct
>> + * @reg:    offset into regmap for the control register
>> + * @shift:  bit position for divider value
>> + * @width:  number of bits used for divider value
>> + * @table:  pointer to table containing an array of divider/value pairs
>> + */
>> +struct clkdiv_regmap {
>> +	struct clk_regmap rclk;
>> +	unsigned int reg;
>> +	unsigned int shift;
>> +	unsigned int width;
>> +	struct clk_div_table *table;
> 
> Is this used?
> 

Yes, its passed from the driver that will be registered by devm_clkdiv_register_regmap().
Its just a divider/value pairs table. Will be used in set_rate() and round_rate().

Thank you for the comments!

BR,
Georgi
