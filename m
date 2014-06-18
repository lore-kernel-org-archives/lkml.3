Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933441AbaFRHMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 03:12:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51013 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751498AbaFRHMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 03:12:13 -0400
Message-ID: <53A13BBF.7090202@free-electrons.com>
Date: Wed, 18 Jun 2014 09:11:59 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Carlo Caione <carlo@caione.org>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH v4 4/7] regulator: axp20x: reset probe data before each
 probe
References: <1402990723-28138-1-git-send-email-boris.brezillon@free-electrons.com> <1402990723-28138-5-git-send-email-boris.brezillon@free-electrons.com> <20140617204449.GD19730@lukather>
In-Reply-To: <20140617204449.GD19730@lukather>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 17/06/2014 22:44, Maxime Ripard wrote:
> On Tue, Jun 17, 2014 at 09:38:40AM +0200, Boris BREZILLON wrote:
>> The init_data and of_node fields of the axp2xx_matches tables are filled
>> at each device probe by the axp20x_regulator_parse_dt function (which then
>> calls the of_regulator_match function).
>> This means we can probe a new device and consider data initialized during
>> the probe of another device as valid.
>>
>> Reset init_data and of_node field to NULL before each probe in order to
>> avoid this kind of issue.
>>
>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> ---
>>  drivers/regulator/axp20x-regulator.c | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/drivers/regulator/axp20x-regulator.c b/drivers/regulator/axp20x-regulator.c
>> index 7a30f49..d42bf6d 100644
>> --- a/drivers/regulator/axp20x-regulator.c
>> +++ b/drivers/regulator/axp20x-regulator.c
>> @@ -324,6 +324,15 @@ static int axp20x_regulator_probe(struct platform_device *pdev)
>>  		nregulators = AXP20X_REG_ID_MAX;
>>  	}
>>  
>> +	/*
>> +	 * Reset matches table (this table might have been modified by a
>> +	 * previous AXP2xx device probe).
>> +	 */
>> +	for (i = 0; i < nmatches; i++) {
>> +		matches[i].init_data = NULL;
>> +		matches[i].of_node = NULL;
>> +	}
>> +
> That looks rather hackish, especially since we've never been in such a
> case yet, since we have a single PMIC in our system.

Even if something is unlikely to happen, it doesn't mean it's impossible.
I'm pretty sure there are (or will be) some systems containing several
identical PMICs in the wild, and fixing this possible bug now prevents
us (or other developers) from having a big headache debugging this in
the future.

BTW, what is hackish in this code ?

>
> Can't you just use memzero here?

We can't just memset the whole matches table to zero, because some
fields (name and driver_data) are statically assigned.

>
> Maxime
>

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

