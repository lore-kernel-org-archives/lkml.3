Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab3IQLy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 07:54:27 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:7872 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab3IQLyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 07:54:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 17 Sep 2013 04:54:24 -0700
Message-ID: <523847E0.2020400@nvidia.com>
Date: Tue, 17 Sep 2013 17:45:28 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "rob@landley.net" <rob@landley.net>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "florian.lobmaier@ams.com" <florian.lobmaier@ams.com>
Subject: Re: [PATCH 3/4] regulator: as3722: add regulator driver for AMS AS3722
References: <1379400338-20704-1-git-send-email-ldewangan@nvidia.com> <1379400338-20704-4-git-send-email-ldewangan@nvidia.com> <20130917114133.GV21013@sirena.org.uk>
In-Reply-To: <20130917114133.GV21013@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> +static int as3722_ldo_get_voltage_sel(struct regulator_dev *rdev)
>> +{
>> +	int ret;
>> +
>> +	ret = regulator_get_voltage_sel_regmap(rdev);
>> +	if (ret >= 0x40)
>> +		ret -= 0x1B;
>> +	return ret;
>> +}
> This looks very strange.  What's going on here?  A gap in the selectors?
> If that's the case you probably want to be using linear ranges.

Yes device does not want to be configure the vsel to 0x25 to 0x3F

   01h-24h : V_LDO1=0.8V+ldo1_vsel*25mV
   25h-3Fh : do not use
   40h-7Fh : V_LDO1=1.725V+(ldo1_vsel-40h)*25mV

Let me use linear range.

>> +		if (reg_config->ext_control) {
>> +			ret = regulator_enable_regmap(rdev);
>> +			if (ret < 0) {
>> +				dev_err(&pdev->dev,
>> +					"Regulator %d enable failed: %d\n",
>> +					id, ret);
>> +				goto scrub;
>> +			}
> This looks wrong...  why is the regualtor being enabled by something
> other than the core?

When the rail is configured externally controlled then we are not 
providing the enable/disable callback to enable through register access. 
So core will not be able to enable it.
Here, we are making sure that it is enabled through register write.
After that enable/disable can be done by device-input pin toggeling.

