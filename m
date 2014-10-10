Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaJJLre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 07:47:34 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:52620 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaJJLr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 07:47:29 -0400
MIME-Version: 1.0
In-Reply-To: <CABgxDoL2cztT6Y0oodtk4Q4jaDc1Rtx_RokxC+f0XykSojrdyg@mail.gmail.com>
References: <1412711104-15902-1-git-send-email-romain.perier@gmail.com> <CABgxDoL2cztT6Y0oodtk4Q4jaDc1Rtx_RokxC+f0XykSojrdyg@mail.gmail.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Fri, 10 Oct 2014 12:47:08 +0100
X-Google-Sender-Auth: P-V_8qOrmZdjjP94O8h7NGI4M0M
Message-ID: <CACxGe6vmBSgGpJgJ51Ki5KbQO65GDw3kSGSxnswYMfE8OGj9gw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/4] regulator: Add helper function to get
 "poweroff-source" property
To: PERIER Romain <romain.perier@gmail.com>
Cc: devicetree <devicetree@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, robh <robh@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2014 at 8:43 PM, PERIER Romain <romain.perier@gmail.com> wrote:
> This is not the final location, I have no idea exactly where I might
> put this helper function. This is why I ask you your opinion (and
> also, this is why that's a proposal)
>
> 2014-10-07 21:45 GMT+02:00 Romain Perier <romain.perier@gmail.com>:
>> Several drivers create their own devicetree property when they register
>> poweroff capabilities. This is for example the case for mfd, regulator
>> or power drivers which define "vendor,system-power-controller" property.
>> This patch adds support for a standard property "poweroff-source"
>> which marks the device as able to shutdown the system.
>>
>> Signed-off-by: Romain Perier <romain.perier@gmail.com>
>> ---
>>  drivers/regulator/of_regulator.c       | 12 ++++++++++++
>>  include/linux/regulator/of_regulator.h |  6 ++++++
>>  2 files changed, 18 insertions(+)
>>
>> diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
>> index 7a51814..8b898e6 100644
>> --- a/drivers/regulator/of_regulator.c
>> +++ b/drivers/regulator/of_regulator.c
>> @@ -240,3 +240,15 @@ struct regulator_init_data *regulator_of_get_init_data(struct device *dev,
>>
>>         return init_data;
>>  }
>> +
>> +/**
>> + * is_system_poweroff_source - Tells if poweroff-source is found for device_node
>> + * @np: Pointer to the given device_node
>> + *
>> + * return true if present false otherwise
>> + */
>> +bool is_system_poweroff_source(const struct device_node *np)
>> +{
>> +       return of_property_read_bool(np, "poweroff-source");
>> +}
>> +EXPORT_SYMBOL_GPL(is_system_poweroff_source);

Hi Romain,

This is an extremely simple wrapper. It may be best to simply make it
a static inline. It is also generic enough that I don't have a problem
with it living in include/linux/of.h; but of_regulator.h would be fine
too.

Since this is a device tree specific function (it doesn't work with
ACPI or platform_data), you should prefix the function name with of_

g.


What I'm more concerned about is the semantics of the property. What
do the generic code paths gain by standardizing this property? Is it
expected that
>> diff --git a/include/linux/regulator/of_regulator.h b/include/linux/regulator/of_regulator.h
>> index f921796..9d8fbb2 100644
>> --- a/include/linux/regulator/of_regulator.h
>> +++ b/include/linux/regulator/of_regulator.h
>> @@ -20,6 +20,7 @@ extern struct regulator_init_data
>>  extern int of_regulator_match(struct device *dev, struct device_node *node,
>>                               struct of_regulator_match *matches,
>>                               unsigned int num_matches);
>> +extern bool is_system_poweroff_source(const struct device_node *np);
>>  #else
>>  static inline struct regulator_init_data
>>         *of_get_regulator_init_data(struct device *dev,
>> @@ -35,6 +36,11 @@ static inline int of_regulator_match(struct device *dev,
>>  {
>>         return 0;
>>  }
>> +
>> +static inline bool is_system_poweroff_source(const struct device_node *np)
>> +{
>> +       return false;
>> +}
>>  #endif /* CONFIG_OF */
>>
>>  #endif /* __LINUX_OF_REG_H */
>> --
>> 1.9.1
>>
