Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030476Ab3HIHXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 03:23:31 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7944 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030430Ab3HIHX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 03:23:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 09 Aug 2013 00:21:43 -0700
Message-ID: <520498F3.8030101@nvidia.com>
Date: Fri, 9 Aug 2013 15:23:31 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/3] hwmon: (lm90) Add power control
References: <1375944991-29182-1-git-send-email-wni@nvidia.com> <1375944991-29182-2-git-send-email-wni@nvidia.com> <20130808110136.GA6427@sirena.org.uk>
In-Reply-To: <20130808110136.GA6427@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 07:01 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
> 
> On Thu, Aug 08, 2013 at 02:56:29PM +0800, Wei Ni wrote:
> 
>> +	mutex_lock(&data->update_lock);
>> +
>> +	if (is_enable)
>> +		ret = regulator_enable(data->lm90_reg);
>> +	else
>> +		ret = regulator_disable(data->lm90_reg);
>> +
>> +	if (ret < 0)
>> +		dev_err(&client->dev,
>> +			"Error in %s rail vdd, error %d\n",
>> +			(is_enable) ? "enabling" : "disabling", ret);
>> +	else
>> +		dev_info(&client->dev, "success in %s rail vdd\n",
>> +			 (is_enable) ? "enabling" : "disabling");
>> +
>> +	mutex_unlock(&data->update_lock);
> 
> Two things here.  One is that it's not clear what this lokc is
> protecting since the only thing in the locked region is the regulator
> operation and that is thread safe.  The other thing is that I'm not
> seeing anthing that ensures that enables and disables are matched -
> regulators are reference counted so two enables need two disables.
> 
>> +	data->lm90_reg = regulator_get(&client->dev, "vdd");
>> +	if (IS_ERR_OR_NULL(data->lm90_reg)) {
> 
> NULL is a valid regulator, use IS_ERR().
> 
>> +		if (PTR_ERR(data->lm90_reg) == -ENODEV)
>> +			dev_info(&client->dev,
>> +				 "No regulator found for vdd. Assuming vdd is always powered.");
>> +		else
>> +			dev_warn(&client->dev,
>> +				 "Error [%ld] in getting the regulator handle for vdd.\n",
>> +				 PTR_ERR(data->lm90_reg));
> 
> You shouldn't just be ignoring errors here, though there are deployment
> difficulties with making sure a stub regulator is provided.  These
> should be getting easier after the next merge window, the stubs will be
> being tweaked slightly to have an "assume it's there" option even when

Oh, really, could you show me the patch, I wish to take a look :)

Wei.

> regulators are used.  Especially in cases with device tree you should be
> paying attention to -EPROBE_DEFER, that will accurately reflect if a
> regulator is present but not loaded yet.
> 
> That said if you *are* going to do this you should request the
> regulator using devm_regulator_get_optional(), this is intended to
> support things that don't need regulators (though that's not the case
> here).
> 
> * Unknown Key
> * 0x7EA229BD
> 

