Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935623Ab3DHSYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:24:16 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:58181 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934930Ab3DHSYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:24:14 -0400
Message-ID: <51630B48.9050005@gmail.com>
Date: Mon, 08 Apr 2013 20:24:08 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Dom Cobley <popcornmix@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rabeeh Khoury <rabeeh@solid-run.com>, Daniel Mack <zonque@gmail.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Lars-Peter Clausen <lars@metafoo.de>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6] clk: add si5351 i2c common clock driver
References: <1365139415-17815-1-git-send-email-sebastian.hesselbarth@gmail.com> <1365439617-18816-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130408174636.GA1885@roeck-us.net>
In-Reply-To: <20130408174636.GA1885@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 07:46 PM, Guenter Roeck wrote:
> On Mon, Apr 08, 2013 at 06:46:57PM +0200, Sebastian Hesselbarth wrote:
>> This patch adds a common clock driver for Silicon Labs Si5351a/b/c
>> i2c programmable clock generators. Currently, the driver does not
>> support VXCO feature of si5351b. Passing platform_data or DT bindings
>> selectively allow to overwrite stored Si5351 configuration which is
>> very helpful for clock generators with empty eeprom configuration.
>> Corresponding device tree binding documentation is also added.
>>
>> Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
>
> [ ... ]
>
>> +
>> +/*
>> + * Si5351 i2c probe and DT
>> + */
>> +#ifdef CONFIG_OF
>> +static const struct of_device_id si5351_dt_ids[] = {
>> +	{ .compatible = "silabs,si5351a", .data = (void *)SI5351_VARIANT_A, },
>> +	{ .compatible = "silabs,si5351a-msop",
>> +					 .data = (void *)SI5351_VARIANT_A3, },
>> +	{ .compatible = "silabs,si5351b", .data = (void *)SI5351_VARIANT_B, },
>> +	{ .compatible = "silabs,si5351c", .data = (void *)SI5351_VARIANT_C, },
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(of, si5351_dt_ids);
>> +
>> +static int si5351_dt_parse(struct i2c_client *client)
>> +{
>> +	struct device_node *child, *np = client->dev.of_node;
>> +	struct si5351_platform_data *pdata;
>> +	const struct of_device_id *match;
>> +	struct property *prop;
>> +	const __be32 *p;
>> +	int num = 0;
>> +	u32 val;
>> +
>> +	if (np == NULL)
>> +		return 0;
>> +
>> +	match = of_match_node(si5351_dt_ids, np);
>> +	if (match == NULL)
>> +		return -EINVAL;
>> +
>> +	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
>> +	if (!pdata)
>> +		return -ENOMEM;
>> +
>> +	pdata->variant = (enum si5351_variant)match->data;
>> +	pdata->clk_xtal = of_clk_get(np, 0);
>> +	if (!IS_ERR(pdata->clk_xtal))
>> +		clk_put(pdata->clk_xtal);
>> +	pdata->clk_clkin = of_clk_get(np, 1);
>> +	if (!IS_ERR(pdata->clk_clkin))
>> +		clk_put(pdata->clk_clkin);
>> +
>> +	/*
>> +	 * property silabs,pll-source :<num src>, [<..>]
>> +	 * allow to selectively set pll source
>> +	 */
>> +	of_property_for_each_u32(np, "silabs,pll-source", prop, p, num) {
>> +		if (num>= 2) {
>> +			dev_err(&client->dev,
>> +				"invalid pll %d on pll-source prop\n", num);
>> +			break;
>
> You report dev_err here, but you don't return an error to the caller.
> Is this on purpose ? If it is not a fatal error, maybe it should be dev_info ?

This shouldn't break but continue with one u32 skipped. Actually, it is
a warning because somebody passed an invalid value and should be 
dev_warn(). But see my note below, I will make them all fatal.

>> +		}
>> +
>> +		p = of_prop_next_u32(prop, p,&val);
>> +		if (!p)
>> +			break;
>> +
>> +		switch (val) {
>> +		case 0:
>> +			pdata->pll_src[num] = SI5351_PLL_SRC_XTAL;
>> +			break;
>> +		case 1:
>> +			pdata->pll_src[num] = SI5351_PLL_SRC_CLKIN;
>> +			break;
>> +		default:
>> +			dev_warn(&client->dev,
>> +				 "invalid parent %d for pll %d\n", val, num);
>> +			continue;
>
> Same here, and a couple of times below. Given the context, I think it would
> be better if the error cases would return an error. After all, the condition
> suggests that the device tree data is wrong, meaning one has to assume it
> won't work anyway and should be fixed in the device tree and not be ignored
> by the driver.

I am skipping invalid DT data enties here, but I can make them all
fatal. I will also add more variant checks in the corresponding
_si5351_* functions.

>> +		}
>> +	}
>> +
>> +	/* per clkout properties */
>> +	num = of_get_child_count(np);
>> +
>> +	if (num == 0)
>> +		return 0;
>> +
>
> This doesn't set client->dev.platform_data yet returns no error, meaning the
> calling code will either use provided platform data or fail after all if it is
> NULL. That seems to be inconsistent, given that a dt entry was already detected.
> The user might end up wondering why the provided device tree data is not used,
> not realizing that it is incomplete.
>
> If children are not mandatory, you could just drop the code above and go through
> for_each_child_of_node() anyway; it won't do anything and set
> client->dev.platform_data at the end. If children are mandatory, it might make
> sense to return an eror here (if there is dt information, it should be complete
> and consistent).

Not having children is valid as you only provide them if you want to
overwrite the current config stored in the eeprom. But yes, skipping
for_each_child_of_node below is a left-over from an implementation where
I used dynamically allocated ->pll/->clkout.

>> +	for_each_child_of_node(np, child) {
>> +		if (of_property_read_u32(child, "reg",&num)) {
>> +			dev_err(&client->dev, "missing reg property of %s\n",
>> +				child->name);
>> +			continue;
>> +		}
>> +
> What if "num" returns 100 ? Or 1000 ?

Segmentation fault? ;) I will add a check for 0 <= num < 8.

Thanks for the review,
   Sebastian
