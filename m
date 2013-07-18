Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874Ab3GRMCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 08:02:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47198 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757578Ab3GRMCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 08:02:40 -0400
Message-ID: <51E7D90D.6070101@ti.com>
Date: Thu, 18 Jul 2013 15:01:17 +0300
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
References: <1374061312-25469-1-git-send-email-grygorii.strashko@ti.com> <1374061312-25469-4-git-send-email-grygorii.strashko@ti.com> <20130717153248.GI7656@atomide.com> <51E6C939.40208@ti.com> <20130718080953.GR7656@atomide.com> <51E7AD38.6010108@ti.com> <20130718090408.GU7656@atomide.com>
In-Reply-To: <20130718090408.GU7656@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On 07/18/2013 12:04 PM, Tony Lindgren wrote:
> * Grygorii Strashko <grygorii.strashko@ti.com> [130718 02:01]:
>> On 07/18/2013 11:09 AM, Tony Lindgren wrote:
>>
>> Don't think it's debug code - IO chain need to be rearmed after each
>> PRCM IO IRQ - otherwise IO wakeup events may be lost (at least on
>> OMAP4, OMAP5 requires more complex handling(( ).
>
> Nope, only after the mux register changes. I've verified it on
> am3730 with off-idle for both serial and wl12xx.

Unfortunately, there is a possibility to lose wake up events in case if
IO daisy chain will be rearmed (this will clean up all WAKEUPEVENT bits)
while there is some pending  WAKEUP event present. In this case, 
pcs_omap_handle_irq() will not call generic_handle_irq(wakeirq).

The below patch contains explanation of such kind of issue we've solved
in K3.4
http://git.omapzoom.org/?p=kernel/omap.git;a=commit;h=5ff316db224a2c3c23bfe44261275d520b4f78bb

Currently, in Mainline the same is possible on OMAP4 (which is SMP) if
some Device will be switched to idle and rearm IO chain while there is
pending WAKEUP event form USB for example. So, IO rearming need to be 
delayed until PRCM irq will be served served and PRCM irq handler should 
finally rearm IO daisy chain.


>
>> I didn't pick up your padconf patches yet -seems i need to be in sync :)
>
> Well you need those for proper wake-up event support..
>
>> Below the diff I used to verify IO wake up (It follows old IO daisy
>> chain hanlding models in hwmod before DT):
>
> ..then these changes not needed with the pinctrl-single changes.
>
> Regards,
>
> Tony
>

