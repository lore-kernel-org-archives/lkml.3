Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840Ab3GRKOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:14:18 -0400
Received: from service87.mimecast.com ([91.220.42.44]:57357 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab3GRKOQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:14:16 -0400
Message-ID: <51E7BFFA.8010101@arm.com>
Date: Thu, 18 Jul 2013 11:14:18 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [RFC PATCH v2 11/15] cpufreq: kirkwood-cpufreq: remove device
 tree parsing for cpu nodes
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1374069984-20567-12-git-send-email-Sudeep.KarkadaNagesha@arm.com> <20130717144355.GE1026@lunn.ch> <51E7A63F.7020207@arm.com>
In-Reply-To: <51E7A63F.7020207@arm.com>
X-OriginalArrivalTime: 18 Jul 2013 10:14:12.0254 (UTC) FILETIME=[8C9E33E0:01CE839F]
X-MC-Unique: 113071811141401301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/07/13 09:24, Sudeep KarkadaNagesha wrote:
> On 17/07/13 15:43, Andrew Lunn wrote:
>> On Wed, Jul 17, 2013 at 03:06:20PM +0100, Sudeep.KarkadaNagesha@arm.com wrote:
>>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>>
[...]
>>> diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
>>> index c233ea6..18aa3eb 100644
>>> --- a/drivers/cpufreq/kirkwood-cpufreq.c
>>> +++ b/drivers/cpufreq/kirkwood-cpufreq.c
>>> @@ -13,6 +13,7 @@
>>>  #include <linux/module.h>
>>>  #include <linux/clk.h>
>>>  #include <linux/clk-provider.h>
>>> +#include <linux/cpu.h>
>>>  #include <linux/cpufreq.h>
>>>  #include <linux/of.h>
>>>  #include <linux/platform_device.h>
>>> @@ -165,6 +166,7 @@ static struct cpufreq_driver kirkwood_cpufreq_driver = {
>>>  static int kirkwood_cpufreq_probe(struct platform_device *pdev)
>>>  {
>>>  	struct device_node *np;
>>> +	struct device *cpu_dev;
>>>  	struct resource *res;
>>>  	int err;
>>>  
>>> @@ -175,9 +177,17 @@ static int kirkwood_cpufreq_probe(struct platform_device *pdev)
>>>  	if (IS_ERR(priv.base))
>>>  		return PTR_ERR(priv.base);
>>>  
>>> -	np = of_find_node_by_path("/cpus/cpu@0");
>>> -	if (!np)
>>> +	cpu_dev = get_cpu_device(0);
>>> +	if (!cpu_dev) {
>>> +		dev_err(&pdev->dev, "failed to get cpu device\n");
>>>  		return -ENODEV;
>>> +	}
>>> +
>>> +	np = of_node_get(cpu_dev->of_node);
>>> +	if (!np) {
>>> +		dev_err(&pdev->dev, "failed to get cpu device node\n");
>>> +		return -ENODEV;
>>> +	}
>>
>> Hi Sudeep
>>
>> Are we not going a bit backwards here? You are replacing two lines
>> with 10 lines.
>>
>> How about putting these 10 lines into some helper,
>> of_get_cpu_device()?  It would be useful for spear, kirkwood and
>> imx6q, and maybe others.
>>
> Yes I realised that after making changes to this and pmac32 drivers. I
> have already made those changes in v3. I am waiting for more response
> before posting them.
> 
I thought of placing this helper in include/linux/of_device.h but I see:
#include <linux/of_platform.h> /* temporary until merge */

Does this mean of_platform.h and of_device.h will be merged ?
If so, which will be the final merged one ? I would like to avoid
changing all the header file inclusions later in users of this new helper.

Regards,
Sudeep


