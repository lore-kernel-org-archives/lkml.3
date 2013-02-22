Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab3BVPwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 10:52:47 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:41086 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757196Ab3BVPwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 10:52:46 -0500
Message-ID: <51279444.7060308@slimlogic.co.uk>
Date: Fri, 22 Feb 2013 15:52:36 +0000
From: Ian Lartey <ian@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH 2/2] mfd: palmas add variant and OTP detection
References: <1361494325-4416-1-git-send-email-ian@slimlogic.co.uk> <1361494325-4416-2-git-send-email-ian@slimlogic.co.uk> <512748DF.8080401@nvidia.com>
In-Reply-To: <512748DF.8080401@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/02/13 10:30, Laxman Dewangan wrote:
> On Friday 22 February 2013 06:22 AM, Ian Lartey wrote:
>> From: Graeme Gregory <gg@slimlogic.co.uk>
>>
>> Read the chip varient and the OTP information from the chip and display
>> this on probe to aid in debugging of issues.
>>
>
>> +    /* Read varient info from the device */
>> +    slave = PALMAS_BASE_TO_SLAVE(PALMAS_ID_BASE);
>> +    addr = PALMAS_BASE_TO_REG(PALMAS_ID_BASE, PALMAS_PRODUCT_ID_LSB);
>> +    ret = regmap_read(palmas->regmap[slave], addr, &reg);
>> +    if (ret < 0) {
>> +        dev_err(palmas->dev, "Unable to read ID err: %d\n", ret);
>> +        goto err;
>> +    }
>> +
>
> Can you please use the api palmas_* for reading register which I added
> recently. This will reduce the calc of slave and addr and done in single
> call?
> Same of following code also.

Will do.
>
>
> Also can we move all these new code to one function where we read id and
> diaplay. To keep probe() smaller.

Yes, I'll do that too.
>
>
>> +    palmas->id = reg;
>> +
>> +    slave = PALMAS_BASE_TO_SLAVE(PALMAS_ID_BASE);
>> +    addr = PALMAS_BASE_TO_REG(PALMAS_ID_BASE, PALMAS_PRODUCT_ID_MSB);
>> +    ret = regmap_read(palmas->regmap[slave], addr, &reg);
>> +    if (ret < 0) {
>> +        dev_err(palmas->dev, "Unable to read ID err: %d\n", ret);
>> +        goto err;
>> +    }
>> +
>> +    palmas->id |= reg << 8;
>
> Is it possible to change variable name id to product_id and then update
> to have more meaningful name?
> We can add for vendor_id also if require.

The rename of id to product_id is fine, if this what you mean by
"update to have a more meaningful name" then I agree.
Though if you wish for a additional change, I am not sure what the 
additional change is.

>
>> +
>> +    dev_info(palmas->dev, "Product ID %x\n", palmas->id);
>> +
>> +    slave = PALMAS_BASE_TO_SLAVE(PALMAS_DESIGNREV_BASE);
>> +    addr = PALMAS_BASE_TO_REG(PALMAS_DESIGNREV_BASE, PALMAS_DESIGNREV);
>> +    ret = regmap_read(palmas->regmap[slave], addr, &reg);
>> +    if (ret < 0) {
>> +        dev_err(palmas->dev, "Unable to read DESIGNREV err: %d\n", ret);
>> +        goto err;
>> +    }
>> +
>> +    palmas->designrev = reg & PALMAS_DESIGNREV_DESIGNREV_MASK;
>> +
>> +    dev_info(palmas->dev, "Product Design Rev %x\n", palmas->designrev);
>> +
>> +    slave = PALMAS_BASE_TO_SLAVE(PALMAS_PMU_CONTROL_BASE);
>> +    addr = PALMAS_BASE_TO_REG(PALMAS_PMU_CONTROL_BASE,
>> PALMAS_SW_REVISION);
>> +    ret = regmap_read(palmas->regmap[slave], addr, &reg);
>> +    if (ret < 0) {
>> +        dev_err(palmas->dev, "Unable to read SW_REVISION err: %d\n",
>> +                ret);
>> +        goto err;
>> +    }
>> +
>> +    palmas->sw_revision = reg;
>> +
>> +    dev_info(palmas->dev, "Product SW Rev %x\n", palmas->sw_revision);
>> +
>
>
> Here designrev also says the ES version and sw revision says the OTP SW
> revision.
> TI has make the design revision as ES1.0, ES2.0, ES2.1, ES2.2 like this
> and other technical names are 0xA0, 0xB0, 0xB1, 0xB2 etc.
>
> Probably I will add this in follow on patch becasue we have some errata
> which we need to implement based on the version number.

OK, I'll not make this change in favour of your later patch.
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

