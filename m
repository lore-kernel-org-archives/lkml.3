Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab3CUVcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:32:55 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:36905 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab3CUVcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:32:53 -0400
Message-ID: <514B7C80.2070008@gmail.com>
Date: Thu, 21 Mar 2013 22:32:48 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Dom Cobley <popcornmix@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rabeeh Khoury <rabeeh@solid-run.com>, Daniel Mack <zonque@gmail.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] clk: add si5351 i2c common clock driver
References: <1360414772-12232-1-git-send-email-sebastian.hesselbarth@gmail.com> <1363603397-2762-1-git-send-email-sebastian.hesselbarth@gmail.com> <514B4CBF.7070106@metafoo.de>
In-Reply-To: <514B4CBF.7070106@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 07:09 PM, Lars-Peter Clausen wrote:
> On 03/18/2013 11:43 AM, Sebastian Hesselbarth wrote:
>> This patch adds a common clock driver for Silicon Labs Si5351a/b/c
>> i2c programmable clock generators. Currently, the driver supports
>> DT kernels only and VXCO feature of si5351b is not implemented. DT
>> bindings selectively allow to overwrite stored Si5351 configuration
>> which is very helpful for clock generators with empty eeprom
>> configuration. Corresponding device tree binding documentation is
>> also added.
>>
>> Signed-off-by: Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>
>
> Hi,
>
> Couple of comments inside.

Lars-Peter,

thanks for the review.

>> ---
> [...]
>> +==Child nodes==
>> +
>> +Each of the clock outputs can be overwritten individually by
>> +using a child node to the I2C device node. If a child node for a clock
>> +output is not set, the eeprom configuration is not overwritten.
>> +
>> +Required child node properties:
>> +- reg: number of clock output.
>> +
>> +Optional child node properties:
>> +- clock-source: source clock of the output divider stage N, shall be
>> +  0 = multisynth N
>> +  1 = multisynth 0 for output clocks 0-3, else multisynth4
>> +  2 = xtal
>> +  3 = clkin (si5351c only)
>> +- drive-strength: output drive strength in mA, shall be one of {2,4,6,8}.
>> +- multisynth-source: source pll A(0) or B(1) of corresponding multisynth
>> +  divider.
>> +- pll-master: boolean, multisynth can change pll frequency.
>
> Custom properties need a vendor prefix.

Good catch, I will add "silabs" prefix here.

> [...]
>
>> diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
>> new file mode 100644
>> index 0000000..38540e7
>> --- /dev/null
>> +++ b/drivers/clk/clk-si5351.c
>> @@ -0,0 +1,1429 @@
> [...]
>> +
>> +/*
>> + * Si5351 vxco clock input (Si5351B only)
>> + */
>> +
>> +static int si5351_vxco_prepare(struct clk_hw *hw)
>> +{
>> +	struct si5351_hw_data *hwdata =
>> +		container_of(hw, struct si5351_hw_data, hw);
>> +
>> +	dev_warn(&hwdata->drvdata->client->dev, "VXCO currently unsupported\n");
>
> Wouldn't it be better to not add the vxco clock if it is not supported?

Hmm, I thought about that already and knew someone will suggest to remove it.
But, IMHO it is better to leave that functions there for two reasons:

1. It is only a small part of one of three supported si5351 variant and doesn't
take much space.

2. The most common user of this driver is a hardware engineer and I want him/her
to help to add support. No warning, no note.

I can make the clock registration fail, if that is what you suggest.

> [..]
>> +
>> +static const struct of_device_id si5351_dt_ids[] = {
>> +	{ .compatible = "silabs,si5351a", .data = (void *)SI5351_VARIANT_A, },
>> +	{ .compatible = "silabs,si5351a-msop",
>> +					 .data = (void *)SI5351_VARIANT_A3, },
>> +	{ .compatible = "silabs,si5351b", .data = (void *)SI5351_VARIANT_B, },
>> +	{ .compatible = "silabs,si5351c", .data = (void *)SI5351_VARIANT_C, },
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(i2c, si5351_dt_ids);
>
> MODULE_DEVICE_TABLE(of,  ....

Ack.

>> +static int si5351_i2c_probe(
>> +	struct i2c_client *client, const struct i2c_device_id *id)
>
> This should easily fit in one line.

Ack.

>> +{
>> +	struct si5351_driver_data *drvdata;
>> +	struct clk_init_data init;
>> +	struct clk *clk;
>> +	const char *parent_names[4];
>> +	u8 num_parents, num_clocks;
>> +	int ret, n;
>> +
>> +	drvdata = devm_kzalloc(&client->dev, sizeof(struct si5351_driver_data),
>
> sizeof(*drvdata) is the preferred way of writing this, same for a few other
> similar instances.

Yeah, I will change that.

>> +			       GFP_KERNEL);
>> +	if (drvdata == NULL) {
>> +		dev_err(&client->dev, "unable to allocate driver data\n");
>> +		return -ENOMEM;
>> +	}
>> +
> [...]
>> +	of_clk_add_provider(client->dev.of_node, of_clk_src_onecell_get,
>> +			&drvdata->onecell);
>
> You should check the return value of of_clk_add_provider

Ack.

>> +
>> +	dev_info(&client->dev, "registered si5351 i2c client\n");
>> +
>
> That's just noise, imagine every driver would print such a line, your bootlog
> would be scrolling for hours ;) I'd either remove it or make it dev_dbg

Actually, I understand not to have it, but if you don't want it you can still
boot with "quiet", can't you? Having one single line that helps you see it has
been probed helps a lot. But, I don't have a strong opinion on that and can
make it dev_dbg.

>> +	return 0;
>> +}
>> +
>> +static int si5351_i2c_remove(struct i2c_client *client)
>> +{
>> +	i2c_set_clientdata(client, NULL);
>
> This is not required anymore, the core takes care of it these days. I think you
> can drop the whole remove callback.

Ok.

>> +	return 0;
>> +}
>> +
>> +static const struct i2c_device_id si5351_i2c_ids[] = {
>> +	{ "silabs,si5351", SI5351_BUS_BASE_ADDR | 0 },
>> +	{ "silabs,si5351", SI5351_BUS_BASE_ADDR | 1 },
>> +	{ }
>> +};
>
> This is not how it is supposed to be used. The second field is not the i2c
> address of the device, but device specific data, which you can use inside your
> probe function. Since your driver only supports dt based probe you can just set
> it to 0.

Ok, thanks for the hint.

>> +MODULE_DEVICE_TABLE(i2c, si5351_i2c_ids);
>> +
>> +static struct i2c_driver si5351_driver = {
>> +	.driver = {
>> +		.name = "si5351",
>> +		.of_match_table = si5351_dt_ids,
>> +	},
>> +	.probe = si5351_i2c_probe,
>> +	.remove = si5351_i2c_remove,
>> +	.id_table = si5351_i2c_ids,
>> +};
>> +
>> +static int __init si5351_module_init(void)
>> +{
>> +	return i2c_add_driver(&si5351_driver);
>> +}
>> +module_init(si5351_module_init);
>> +
>> +static void __exit si5351_module_exit(void)
>> +{
>> +	i2c_del_driver(&si5351_driver);
>> +}
>> +module_exit(si5351_module_exit);
>
> module_i2c_driver(si5351_driver) can be used to replace the two function above.

Ack.

>> +
>> +MODULE_AUTHOR("Sebastian Hesselbarth<sebastian.hesselbarth@gmail.de");
>> +MODULE_DESCRIPTION("Silicon Labs Si5351A/B/C clock generator driver");
>> +MODULE_LICENSE("GPL");
[...]

Again, thanks for the review.

Sebastian

