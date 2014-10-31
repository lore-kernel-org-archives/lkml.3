Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760111AbaJaOQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 10:16:49 -0400
Received: from smtp07.online.nl ([194.134.42.52]:44908 "EHLO smtp07.online.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759849AbaJaOQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 10:16:47 -0400
X-Greylist: delayed 527 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Oct 2014 10:16:47 EDT
Message-ID: <545397BD.1070701@topic.nl>
Date: Fri, 31 Oct 2014 15:07:57 +0100
From: Mike Looijmans <mike.looijmans@topic.nl>
Organization: Topic
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Add ltc3562 voltage regulator driver
References: <1414570560-10320-2-git-send-email-mike.looijmans@topic.nl> <1414668415-597-1-git-send-email-mike.looijmans@topic.nl> <20141030165133.GB18557@sirena.org.uk>
In-Reply-To: <20141030165133.GB18557@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Online-Scanned: by Cloudmark authority (on smtp07.online.nl)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-10-2014 17:51, Mark Brown wrote:
> On Thu, Oct 30, 2014 at 12:26:55PM +0100, Mike Looijmans wrote:
>> The ltc3562 is an I2C controlled regulator supporting 4 independent
>> outputs.
>>
>> v2: Prefix "lltc" to devicetree properties. Use the same property names
>>      as the ltc3589 driver. Remove default-voltage property. Use
>>      devm_register_regulator.
>
> As covered in SubmittingPatches things like this should be after ---.
>
>> +Required properties:
>> +- compatible: "ltc3562"
>
> This needs a vendor in the compatible string.

Will do.

>> +Required child node:
>> +- regulators: Contains four regulator child nodes R400B, R600B, R400A, R600A,
>> +  specifying the initialization data as documented in
>> +  Documentation/devicetree/bindings/regulator/regulator.txt.
>
> All regulator child nodes should be optional.
>
>> +			R600A_reg: R600A {
>> +				regulator-name = "R600A";
>
> Remove these regulator-names, this is for the name of the supplies on
> the board not the regulator itself.
>
>> +static int ltc3562_write(struct i2c_client *i2c, u8 reg_a, u8 reg_b);
>> +static int ltc3562_dummy_write(struct i2c_client *i2c);
>
> This appears to be reimplementing regmap (including a cache).  Please
> use that instead.  Pretty much the entire driver could then be replaced
> with the regmap helpers, none of the operations look like they'd be
> needed, and you'd get the regmap diagnostic infrastructure.

The chip doesn't have an I2C register map, it uses "commands".
It does not support read transactions at all, it will NACK those. The 
first byte contains a bit mask that tells which outputs are to be 
configured and in what mode, the next is the enable bit and setpoint 
value. The first byte already contains data, it's not just an address.

I would have used regmap if I thought it'd help (if only for the 
diagnostics), but it simply doesn't fit here.

If you insist, I can probably get it to fit on regmap, but that would 
still mean implementing some custom write method that translates between 
some non-existing registry format and what the chip really wants.


>> +	np = of_node_get(i2c->dev.of_node);
>> +	np_regulators = of_get_child_by_name(np, "regulators");
>
>> +		np_child = of_get_child_by_name(np_regulators,
>> +			ltc3562_regulators[i].name);
>> +		if (np_child == NULL) {
>
> Use the core support for looking up constraints please - set
> regulators_node and so on.

I'll dig into it, seems that there's more infrastructure here to use.

>> +static struct i2c_driver ltc3562_i2c_driver = {
>> +	.driver = {
>> +		.name = "LTC3562",
>> +		.owner = THIS_MODULE,
>> +	},
>> +	.probe    = ltc3562_i2c_probe,
>> +	.id_table = ltc3562_i2c_id,
>> +};
>
> You need to supply an of_match_table too.

Hmm, that would explain why I couldn't get it to work using 
"lltc,ltc3562" during our first attempts at the driver.


-- 
Mike Looijmans
