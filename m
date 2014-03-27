Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbaC0H6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 03:58:22 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:53635 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaC0H6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 03:58:19 -0400
Message-ID: <5333DA13.2080505@gmail.com>
Date: Thu, 27 Mar 2014 08:58:11 +0100
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, t.figa@samsung.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH] clk: register fixed-clock only if #clock-cells property
 is present
References: <1395858127-18730-1-git-send-email-s.nawrocki@samsung.com>	<CAOMZO5DJPKvha7A-foktsB2dEw9xGXL_++uBXj_3ScAPTXNOkw@mail.gmail.com>	<53333145.4080903@gmail.com> <CAOMZO5AEry8sJW_+0aJS8ush+sYPPWk9LRU0b8RUUGa-hO_G1A@mail.gmail.com>
In-Reply-To: <CAOMZO5AEry8sJW_+0aJS8ush+sYPPWk9LRU0b8RUUGa-hO_G1A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 26/03/2014 21:14, Fabio Estevam a écrit :
> On Wed, Mar 26, 2014 at 4:57 PM, Sylwester Nawrocki
> <sylvester.nawrocki@gmail.com> wrote:
>
>> Perhaps a change as below helps ?
>>
>>  From 85ee85e4a92b42442354f3f2454be50c173e1c59 Mon Sep 17 00:00:00 2001
>> From: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Date: Wed, 26 Mar 2014 20:54:13 +0100
>> Subject: [PATCH] clk: reverse default clk provider initialization order in
>> of_clk_init()
>>
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> ---
>>   drivers/clk/clk.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>> index fb3c40b..d30809c 100644
>> --- a/drivers/clk/clk.c
>> +++ b/drivers/clk/clk.c
>> @@ -2608,7 +2608,7 @@ void __init of_clk_init(const struct of_device_id
>> *matches)
>>
>>                  parent->clk_init_cb = match->data;
>>                  parent->np = np;
>> -               list_add(&parent->node, &clk_provider_list);
>> +               list_add_tail(&parent->node, &clk_provider_list);
>>          }
>>
>>          while (!list_empty(&clk_provider_list)) {
> Thanks, Sylwester!
>
> This makes my imx6q-wandboard to boot again.
>
> Tested-by: Fabio Estevam <fabio.estevam@freescale.com>

This solution solve the problem for this specific case because clks are
declared in the correct order in imx DTs.
But, even with your patch I think we could see similar issues by 
reordering DT
nodes...

The real problem here is that imx platform does not declare the CCM clocks
dependencies upon ckil, ckih1 and osc fixed clocks within the DT [1], and
retrieve these clocks when initializing the CCM clocks ([2] and [3]).

We should try to a add these dependencies in the DT and see if it works.

[1] http://lxr.free-electrons.com/source/arch/arm/boot/dts/imx6sl.dtsi#L379
[2] http://lxr.free-electrons.com/source/arch/arm/mach-imx/clk-imx6q.c#L151
[3] http://lxr.free-electrons.com/source/arch/arm/mach-imx/clk.c#L30

Best Regards,

Boris
