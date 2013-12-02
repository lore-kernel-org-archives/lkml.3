Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab3LBLeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 06:34:00 -0500
Received: from mail.kmu-office.ch ([178.209.48.102]:41975 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab3LBLd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 06:33:57 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Mon, 02 Dec 2013 12:38:58 +0100
From: Stefan Agner <stefan@agner.ch>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: swarren@wwwdotorg.org, dev@lynxeye.de, lee.jones@linaro.org,
        lgirdwood@gmail.com, broonie@kernel.org,
        kai.poggensee@avionic-design.de, sameo@linux.intel.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra-owner@vger.kernel.org
Subject: Re: [PATCH v2 2/3] regulator: tps6586x: add and use correct voltage
 table
In-Reply-To: <20131202093622.GF17834@ulmo.nvidia.com>
References: <cover.1385913227.git.stefan@agner.ch>
 <77c960e6e3a91cf39bc866ccb9cd578ccc5acc95.1385913228.git.stefan@agner.ch>
 <20131202093622.GF17834@ulmo.nvidia.com>
Message-ID: <7ec014a74ccbcf975f45e0c517615ae2@agner.ch>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2013-12-02 10:36, schrieb Thierry Reding:
> On Sun, Dec 01, 2013 at 04:59:14PM +0100, Stefan Agner wrote:
> [...]
> 
> This looks pretty good generally. A few minor nits below...
> 
>> diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
> [...]
>> +#define tps658623_sm2_voltages tps6586x_ldo4_voltages
>>  static const unsigned int tps6586x_ldo4_voltages[] = {
>>  	1700000, 1725000, 1750000, 1775000, 1800000, 1825000, 1850000, 1875000,
>>  	1900000, 1925000, 1950000, 1975000, 2000000, 2025000, 2050000, 2075000,
> 
> I'd put the #define below the ldo4 table. This doesn't actually matter
> for the preprocessor, but it makes it easier to read the code. Also an
> additional blank line would help with readability.
> 
>> +	TPS6586X_LDO(LDO_0, "vinldo01", tps6586x_ldo0, SUPPLYV1, 5, 3, ENC, 0,
>> +					END, 0),
> 
> Perhaps reduce the indentation here so there's more room in case this
> ever needs to be extended?

The last 4 lines indentation was already that far, so I just adopted
those lines in order to avoid having to touch them too.


> 
>> @@ -351,6 +380,7 @@ static int tps6586x_regulator_probe(struct platform_device *pdev)
>>  	struct regulator_init_data *reg_data;
>>  	struct tps6586x_platform_data *pdata;
>>  	struct of_regulator_match *tps6586x_reg_matches = NULL;
>> +	int reg_version;
> 
> Why the prefix "reg_"?
> 
>> @@ -373,10 +403,27 @@ static int tps6586x_regulator_probe(struct platform_device *pdev)
>>  		return -ENOMEM;
>>  	}
>>
>> +	reg_version = tps6586x_get_version(pdev->dev.parent);
>> +
>>  	for (id = 0; id < TPS6586X_ID_MAX_REGULATOR; ++id) {
>>  		reg_data = pdata->reg_init_data[id];
>>
>> -		ri = find_regulator_info(id);
>> +		switch(reg_version) {
>> +		case TPS658623:
>> +			ri = find_regulator_info(id, tps658623_regulator,
>> +					ARRAY_SIZE(tps658623_regulator));
>> +			break;
>> +		case TPS658643:
>> +			ri = find_regulator_info(id, tps658643_regulator,
>> +					ARRAY_SIZE(tps658643_regulator));
>> +			break;
>> +		}
> 
> Perhaps instead of repeating the function calls this could be:
> 
> 		switch (version) {
> 		case TPS6586XYZ:
> 			num = ARRAY_SIZE(tps6586xyz_regulator);
> 			table = tps6586xys_regulator;
> 			break;
> 
> 		...
> 		}
> 
> 		if (table)
> 			ri = find_regulator_info(id, table, num);
> 
> That's slightly longer, but I find that to be more intuitive. Perhaps
> a bit more future-proof since you only have a single call. But that's
> perhaps subjective, so I'm fine with your alternative, too.

Sounds reasonable, will change that accordingly in the next patch
version.
