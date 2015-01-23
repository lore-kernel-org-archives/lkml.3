Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbbAWRk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:40:26 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:60909 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914AbbAWRkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:40:23 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-de-54c286f2ac90
Message-id: <54C2877A.3040500@samsung.com>
Date: Fri, 23 Jan 2015 18:40:10 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: tomasz.figa@gmail.com, mturquette@linaro.org, kgene@kernel.org,
        pankaj.dubey@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, sw0312.kim@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 01/12] clk: samsung: exynos5433: Add clocks using common
 clock framework
References: <1421821618-8627-1-git-send-email-cw00.choi@samsung.com>
 <1421821618-8627-2-git-send-email-cw00.choi@samsung.com>
 <54C129B0.1090404@samsung.com> <54C1FBF6.4040405@samsung.com>
In-reply-to: <54C1FBF6.4040405@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t/xK7qf2w6FGJwssri8X9vi+pfnrBaT
	7k9gseh//JrZ4vKuOWwWM87vY7J4OuEim8WirV/YLWZMfslmsWrXH0YHLo+ds+6ye2xa1cnm
	cefaHjaPvi2rGD0+b5ILYI3isklJzcksSy3St0vgytjasp6p4JhCxdHpZ9kaGG9KdjFycEgI
	mEgceefcxcgJZIpJXLi3nq2LkYtDSGApo8SGzUuYIJxPjBKbDx9gBKniFdCSuLxnGTuIzSKg
	KvHi+UsWEJtNwFCi92gfWI2oQITEybt72CHqBSV+TL4HViMioCEx8+8VsBpmgTeMEi86vUCO
	EBZIlNi9jgti135GiZ0394P1cgpoS9ycu5wNpIZZQE/i/kUtiFZ5ic1r3jJPYBSYhWTDLISq
	WUiqFjAyr2IUTS1NLihOSs810itOzC0uzUvXS87P3cQICf2vOxiXHrM6xCjAwajEw3vgzcEQ
	IdbEsuLK3EOMEhzMSiK8GSmHQoR4UxIrq1KL8uOLSnNSiw8xMnFwSjUwFrOvYc7b8+18Y+u5
	POkNL9uXVETurGvU4F/Z9z1yB4+H/TzNwgTh9/NyTzVPvOMqnW5ju+agU9G9vYenZE+fvcZy
	3fyHO5/Zp1W93HJC5lpx0dZ7Hvt2br9Y58Mc+5t31Rrv3Wd/CP37f/8aw0/Wa7M/srhOfay9
	S2fBslcpvLXeCdO4zE/GcCqxFGckGmoxFxUnAgDFX6o5WwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/15 08:44, Chanwoo Choi wrote:
>>> +	cmu_top: clock-controller@0x10030000 {
>>> >> +		compatible = "samsung,exynos5433-cmu-top";
>>> >> +		reg = <0x10030000 0x0c04>;
>>> >> +		#clock-cells = <1>;
>>> >> +	};
>>> >> +

>>> >> +	cmu_fsys: clock-controller@0x156e0000 {
>>> >> +		compatible = "samsung,exynos5433-cmu-fsys";
>>> >> +		reg = <0x156e0000 0x0b04>;
>>> >> +		#clock-cells = <1>;
>>> >> +	};
>> > 
>> > What are the reasons to split the whole clock controller into separate
>> > device nodes with different compatible strings like this? I doubt drivers
>> > associated with each of those compatible strings could be ever reused on
>> > different Exynos SoCs.
>
> No special reason. I added the clock controller according to clock domain
> separately. As I knew, samsung clk drivers use this way to support various
> clock domains. For exmaple, drivers/clk/samsung/clk-exynos7.c.

I'm afraid exynos7 has that initialization ordering issue, unfortunately I
didn't notice it before.

>> > There are hardware dependencies between these clock domains, which are
>> > not currently modelled in DT with your binding.
>
> Right. current samsung clock drivers cannot show the hierarchy among clock 
> domains in DT.
> 
>> > IOW, there is currently
>> > no way to ensure proper registration order of the CMUs (clock domains).
>> > This may be important in some cases.
>> > 
>> > To address this we could either add clocks/clock-names properties in
>> > respective CMU device nodes, pointing to any clocks in other CMU(s) or
>> > make a single device node for the whole clock controller, with an
>> > aggregated reg entry, e.g.
>> > 
>> >  cmu: clock-controller@0x10030000 {
>> > 	compatible = "samsung,exynos5433-cmu";
>> > 	reg =   <0x10030000 0x0c04>,
>> > 		<0x10fc0000 0x0c04>,
>> > 		<0x105b0000 0x100c>,
>> > 		<0x14c80000 0x0b08>,
>> > 		<0x10040000 0x0b20>,
>> > 		<0x156e0000 0x0b04>,
>> > 			...
>> > 	reg-names = "top", "cpif", "mif", "peric", "peris", "fsys"...
>> > 	#clock-cells = <1>;
>> >  };
>
> If you make a single device node to support various clock domain,
> How are you indicate the specific clock in some clock domain?

This might be an issue, we would need to make all the clk indexes a one
contiguous set. I'm wondering if there is really any use of having such
information expressed explicitly in DT, or it would just make the DT
binding closer resembling the SoC's documentation ?

Similarly, the clock controller is divided into subdomains in older SoCs,
like exynos4, yet we do not create separate device nodes for each domain.
Is reference to each individual clock domain required in any other SoC's
part in case of exynos5433 ?

> For example,
> The serial dt node in exynos7.dtsi. serial_0 dt node use the uart clocks
> in 'clock_peric0' clock domain and serial_1 dt node use the uart clocks
> in 'clock-peric1' clock domain.
>
> When using the clock in specific clock domain,
> we need to phandle(e.g., clock_peric0, clock_peric1) of clock domain.
> 
> 		serial_0: serial@13630000 {
> 			compatible = "samsung,exynos4210-uart";
> 			reg = <0x13630000 0x100>;
> 			interrupts = <0 440 0>;
> 			clocks = <&clock_peric0 PCLK_UART0>,
> 				 <&clock_peric0 SCLK_UART0>;
> 			clock-names = "uart", "clk_uart_baud0";
> 			status = "disabled";
> 		};
> 
> 		serial_1: serial@14c20000 {
> 			compatible = "samsung,exynos4210-uart";
> 			reg = <0x14c20000 0x100>;
> 			interrupts = <0 456 0>;
> 			clocks = <&clock_peric1 PCLK_UART1>,
> 				 <&clock_peric1 SCLK_UART1>;
> 			clock-names = "uart", "clk_uart_baud0";
> 			status = "disabled";
> 		};
>
>> > Then we could modify samsung_cmu_register_one() function by adding
>> > the reg entry index or name argument. What do you think ?
>
> If there is more reasonable way to show the dependency between clock domains,
> I will agree.

The other option I mentioned is specifying all parent clocks of a given
clock domain in its device node with clocks(/clock-names) properties.
But it might be a bit hard to list all the clock domain dependencies
this way

--
Regards,
Sylwester
