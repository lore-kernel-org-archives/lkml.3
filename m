Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbaGNNzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:55:35 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:44314 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbaGNNzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:55:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Mon, 14 Jul 2014 15:55:29 +0200
From: Stefan Agner <stefan@agner.ch>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: mkl@pengutronix.de, kernel@pengutronix.de,
        Jingchang Lu <b35083@freescale.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] ARM: imx: clk-vf610: fix FlexCAN clock gating
In-Reply-To: <20140714133926.GH2197@dragon>
References: <cover.1405322992.git.stefan@agner.ch>
 <94282392d8355ac25bb998b89032c1c980d5ccce.1405322992.git.stefan@agner.ch>
 <20140714133926.GH2197@dragon>
Message-ID: <5a57efd52b0092ad61ff6a2b5bf68ba7@agner.ch>
User-Agent: Roundcube Webmail/1.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-07-14 15:39, schrieb Shawn Guo:
> Copy Jingchang ...
> 
> On Mon, Jul 14, 2014 at 09:48:29AM +0200, Stefan Agner wrote:
>> Extend the clock control for FlexCAN with the second gate which
>> enable the clocks in the Clock Divider (CCM_CSCDR2) register too.
>>
>> Signed-off-by: Stefan Agner <stefan@agner.ch>
>> ---
>>  arch/arm/mach-imx/clk-vf610.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/mach-imx/clk-vf610.c b/arch/arm/mach-imx/clk-vf610.c
>> index 22dc3ee..b12b888 100644
>> --- a/arch/arm/mach-imx/clk-vf610.c
>> +++ b/arch/arm/mach-imx/clk-vf610.c
>> @@ -295,8 +295,10 @@ static void __init vf610_clocks_init(struct device_node *ccm_node)
>>
>>  	clk[VF610_CLK_ASRC] = imx_clk_gate2("asrc", "ipg_bus", CCM_CCGR4, CCM_CCGRx_CGn(1));
>>
>> -	clk[VF610_CLK_FLEXCAN0] = imx_clk_gate2("flexcan0", "ipg_bus", CCM_CCGR0, CCM_CCGRx_CGn(0));
>> -	clk[VF610_CLK_FLEXCAN1] = imx_clk_gate2("flexcan1", "ipg_bus", CCM_CCGR9, CCM_CCGRx_CGn(4));
>> +	clk[VF610_CLK_FLEXCAN0] = imx_clk_gate("flexcan0_en", "ipg_bus", CCM_CSCDR2, 11);
>> +	clk[VF610_CLK_FLEXCAN0] = imx_clk_gate2("flexcan0", "flexcan0_en", CCM_CCGR0, CCM_CCGRx_CGn(0));
> 
> I do not quite understand what "flexcan0_en" clock is and the
> relationship between it and clock "flexcan0".  I do not think it's a
> parent-child clock relationship.  Jingchang, do you have more info on
> this?
> 
> Also when you add a new clock, you should have a new clock ID, something
> like VF610_CLK_FLEXCAN0_EN.

There are two enable (gates) bits to enable the FlexCAN clocks: the
first is in the divider register, the second in the clock gate register.
For most clocks there is a divider in between, then it looks like this:

clk[VF610_CLK_ESDHC0_SEL] = imx_clk_mux("esdhc0_sel", CCM_CSCMR1, 16, 2,
esdhc_sels, 4);
clk[VF610_CLK_ESDHC0_EN] = imx_clk_gate("esdhc0_en", "esdhc0_sel",
CCM_CSCDR2, 28);
clk[VF610_CLK_ESDHC0_DIV] = imx_clk_divider("esdhc0_div", "esdhc0_en",
CCM_CSCDR2, 16, 4);
clk[VF610_CLK_ESDHC0] = imx_clk_gate2("eshc0", "esdhc0_div", CCM_CCGR7,
CCM_CCGRx_CGn(1));

However, for FlexCAN no clock selection and no divider is available,
hence its just a chain of an enable and gate register...

But yes, there should be two clock entries for this (I just asking
myself how this code actually could work, afaik the boot loader don't
touches these clocks).

--
Stefan


> 
> Shawn
> 
>> +	clk[VF610_CLK_FLEXCAN1] = imx_clk_gate("flexcan1_en", "ipg_bus", CCM_CSCDR2, 12);
>> +	clk[VF610_CLK_FLEXCAN1] = imx_clk_gate2("flexcan1", "flexcan1_en", CCM_CCGR9, CCM_CCGRx_CGn(4));
>>
>>  	clk[VF610_CLK_DMAMUX0] = imx_clk_gate2("dmamux0", "platform_bus", CCM_CCGR0, CCM_CCGRx_CGn(4));
>>  	clk[VF610_CLK_DMAMUX1] = imx_clk_gate2("dmamux1", "platform_bus", CCM_CCGR0, CCM_CCGRx_CGn(5));
>> --
>> 2.0.1
>>
