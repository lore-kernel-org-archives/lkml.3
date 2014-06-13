Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbaFMPIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:08:39 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30350 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaFMPIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:08:37 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-69-539b13f27e11
Message-id: <539B13F1.8090804@samsung.com>
Date: Fri, 13 Jun 2014 17:08:33 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Tushar Behera <tushar.behera@linaro.org>
Cc: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com,
        linux@arm.linux.org.uk, pawel.moll@arm.com, t.figa@samsung.com,
        sw0312.kim@samsung.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, robh+dt@kernel.org, galak@codeaurora.org,
        grant.likely@linaro.org, m.szyprowski@samsung.com
Subject: Re: [PATCH/RFC V6 2/2] clk: Add handling of clk parent and rate
 assigned from DT
References: <1400520171-6698-1-git-send-email-s.nawrocki@samsung.com>
 <1400520171-6698-3-git-send-email-s.nawrocki@samsung.com>
 <538468B5.6090505@linaro.org>
In-reply-to: <538468B5.6090505@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t/xK7qfhGcHG5y8qGox/8g5Vov+NwtZ
	LQ782cFocbbpDbvFpsfXWC0u75rDZnH7Mq/F2iN32S2WXr/IZPF0wkU2iwnT17JYtO49wm4x
	Y/JLNov1M16zWLT/3cvmwO+xZt4aRo+W5h42j8t9vUwem1Z1snncubaHzWPzknqPvi2rGD0+
	b5IL4IjisklJzcksSy3St0vgyuj88p294IdIRffbz8wNjK8Euhg5OSQETCQe9F5khLDFJC7c
	W88GYgsJLGWUWHXHrYuRC8j+xCjx4vgUZpAEr4CWxMc3DWBFLAKqEjv/3wFrZhMwlOg92gdk
	c3CICkRIPL4gBFEuKPFj8j0WEFtEQEfiwaK9LCAzmQWeM0ms3TeFCSQhLBAtcWvzMyaIZQsZ
	Jebd+QO2jBNo2b+NX8CWMQN172+dBmXLS2xe85Z5AqPALCRLZiEpm4WkbAEj8ypG0dTS5ILi
	pPRcI73ixNzi0rx0veT83E2MkIj6uoNx6TGrQ4wCHIxKPLwvS2YFC7EmlhVX5h5ilOBgVhLh
	vdcAFOJNSaysSi3Kjy8qzUktPsTIxMEp1cAYkruyjHOZLq9U/9byRh+Rn5fS2S33csQu/c//
	rKxx6Ztmg9Xtl0+9+O6+TfMlC3P213C7/de4f89+wsFYHLPHKXBSy5lIxlcLm20uNVxUvrb/
	4G4rtoLFDF6/lnJVJ632cr78YWNbS0js6+cel67ozb8Yusx5wrLy7UbbJVknRnMm8bD/au1S
	YinOSDTUYi4qTgQAgtCNY4YCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/05/14 12:28, Tushar Behera wrote:
> On 05/19/2014 10:52 PM, Sylwester Nawrocki wrote:
>> This patch adds a helper function to configure clock parents and
>> rates as specified in clock-parents, clock-rates DT properties
>> for a consumer device and a call to it before driver is bound to
>> a device.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> 
> [ ... ]
> 
>> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
>> index 5b47210..f622733 100644
>> --- a/drivers/base/platform.c
>> +++ b/drivers/base/platform.c
>> @@ -23,6 +23,7 @@
>>  #include <linux/pm_runtime.h>
>>  #include <linux/idr.h>
>>  #include <linux/acpi.h>
>> +#include <linux/clk/clk-conf.h>
>>
>>  #include "base.h"
>>  #include "power/power.h"
>> @@ -486,6 +487,10 @@ static int platform_drv_probe(struct device *_dev)
>>  	struct platform_device *dev = to_platform_device(_dev);
>>  	int ret;
>>
>> +	ret = of_clk_set_defaults(_dev->of_node, false);
>> +	if (ret < 0)
>> +		return ret;
>> +
> 
> of_clk_set_defaults() is not getting called when the related driver is
> not registered through platform_driver_register().
> 
> I came across this issue while testing this patch on peach-pit board with
> following dts change. max98090 audio codec driver is registered through
> module_i2c_driver().

Yes, that shouldn't be surprising, since now in this RFC the clocks setting
is done only for platform bus devices. Similarly the above call would need to
be added to i2c, amba, spi and maybe other busses.

We just need to be careful to avoid attempting to set up clocks of a clock
provider device before it is probed and actually registers its clocks.

I'm still not sure if we should carry on with this approach or do all the
clocks set up in one place, similarly to disabling unused clocks. I'm afraid
when attempting to set up all clocks at one point in time the clock parent/rate
dependencies may get even more hairy.

The deferred probe mechanism helps to resolve the dependencies when the
clock defaults setting is done before or within a driver probe() call. Either
for clock supplier and consumer nodes or a supplier only.

> * arch/arm/boot/dts/exynos5420-peach-pit.dts
> 
> &hsi2c_7 {
> 
> 	status = "okay";
> 
> 	max98090: codec@10 {
> 		compatible = "maxim,max98090";
> 		reg = <0x10>;
> 		interrupts = <2 0>;
> 		interrupt-parent = <&gpx0>;
> 		pinctrl-names = "default";
> 		pinctrl-0 = <&max98090_irq>;
> +		clocks = <&pmu_system_controller 0>;
> +		clock-names = "mclk";
> +		clock-parents = <&clock CLK_FIN_PLL>;
> +		clock-rates = <24000000>;
> 	};
> };

--
Regards,
Sylwester
