Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab3GQQmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:42:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57563 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680Ab3GQQmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:42:50 -0400
Message-ID: <51E6C939.40208@ti.com>
Date: Wed, 17 Jul 2013 19:41:29 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Kevin Hilman <khilman@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 3/3] ARM: dts: omap4-sdp: add dynamic pin states for uart3/4
References: <1374061312-25469-1-git-send-email-grygorii.strashko@ti.com> <1374061312-25469-4-git-send-email-grygorii.strashko@ti.com> <20130717153248.GI7656@atomide.com>
In-Reply-To: <20130717153248.GI7656@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/17/2013 06:32 PM, Tony Lindgren wrote:
> * Grygorii Strashko <grygorii.strashko@ti.com> [130717 04:49]:
>> Add dynamic "active"/"idle" pin states for uart3/4 which will be applied
>> when uart3/4 state is switched from active to idle and back by Runtime
>> PM or during system suspend.
>
> This is good for testing code, but should not be merged because
> omap4 has the iopad wake-ups available for uarts. So those can
> be always enabled.

In this case, 2 IRQ will be received per each UART RX event - one from
PRCM and from UART - and that's not good from PM perspective (It will
affect on CPUIdle and CPUFreq at least).

-- log when wake-up enabled always
106:        729          0       GIC 106  OMAP UART2
115:         13          0       GIC 115  mmc0
118:         68          0       GIC 118  mmc1
151:          0          0       GIC 151  twl6040
361:        322          0      PRCM  hwmod_io
             ^^^^
-- log when wake-up enabled only when UART3 (console) is active
106:       1104          0       GIC 106  OMAP UART2
115:         13          0       GIC 115  mmc0
118:         68          0       GIC 118  mmc1
151:          0          0       GIC 151  twl6040
361:          7          0      PRCM  hwmod_io

The same is valid for all devices which will leave WAKEUP_EN set
all the time (

>
>> --- a/arch/arm/boot/dts/omap4-sdp.dts
>> +++ b/arch/arm/boot/dts/omap4-sdp.dts
>> @@ -181,18 +181,40 @@
>>   		pinctrl-single,pins = <
>>   			0x100 (PIN_INPUT_PULLUP | MUX_MODE0)	/* uart3_cts_rctx.uart3_cts_rctx */
>>   			0x102 (PIN_OUTPUT | MUX_MODE0)		/* uart3_rts_sd.uart3_rts_sd */
>> -			0x104 (PIN_INPUT | MUX_MODE0)		/* uart3_rx_irrx.uart3_rx_irrx */
>>   			0x106 (PIN_OUTPUT | MUX_MODE0)		/* uart3_tx_irtx.uart3_tx_irtx */
>>   		>;
>>   	};
>
> This just need to become:
> 		pinctrl-single,pins = <
> 			...
> 			0x104 (WAKEUP_EN | PIN_INPUT_MUX_MODE0)	/* uart3_rx_irrx.uart3_rx_irrx */
> 			...
> 		>;
> 		interrupts = <GIC_SPI 74 IRQ_TYPE_LEVEL_HIGH>;
> 	};
>
> And so on. For am33xx you need to remux things to GPIO for the wake-up
> events, so you should maybe test on that instead.
>
> Regards,
>
> Tony
>

Regards,
- grygorii
