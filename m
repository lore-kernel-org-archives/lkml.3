Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab3F1P5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:57:33 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42268 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab3F1P5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:57:32 -0400
Message-ID: <51CDB26A.9060500@codeaurora.org>
Date: Fri, 28 Jun 2013 08:57:30 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stehle Vincent-B46079 <B46079@freescale.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: next-20130627 breaks i.MX6 sabre sd UART console
References: <F7C43F8B2814514CA05F3436BC68046EF1EB72@039-SN2MPN1-013.039d.mgd.msft.net> <alpine.DEB.2.02.1306281403530.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306281403530.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/13 05:09, Thomas Gleixner wrote:
> On Thu, 27 Jun 2013, Stehle Vincent-B46079 wrote:
>
> Cc'ed Mark and Stephen.
>
>> FYI I remark that today's Linux next 'next-20130627' breaks i.MX6
>> sabre sd UART console with ARM config imx_v6_v7_defconfig.
>> This was working fine yesterday with 'next-20130626'.
>>
>> Bisecting gave me this commit:
>>
>>   064706514ec3fea740c2656e03c4f01f6a551ac4 clocksource: Add generic
>> dummy timer driver
>>
>> If I revert it I do indeed get the boot messages on the UART console
>> again, but the kernel then crashes in wm8962_probe(). So there is
>> more to find out...



Do you have debug_ll support to get some serial logs? Also could you try
booting with maxcpus=1 on the kernel commandline? And it would be useful
to have the output of /proc/timer_list if you have it from a working
device. I believe you have a per-cpu TWD timer and a global imx-gpt? Can
you try this patch? (sorry about the whitespace damage)

----8<-----

diff --git a/arch/arm/mach-imx/time.c b/arch/arm/mach-imx/time.c
index fea9131..f05f1f1 100644
--- a/arch/arm/mach-imx/time.c
+++ b/arch/arm/mach-imx/time.c
@@ -267,7 +267,7 @@ static int __init mxc_clockevent_init(struct clk *timer_clk)
        if (timer_is_v2())
                clockevent_mxc.set_next_event = v2_set_next_event;
 
-       clockevent_mxc.cpumask = cpumask_of(0);
+       clockevent_mxc.cpumask = cpu_all_mask;
        clockevents_config_and_register(&clockevent_mxc,
                                        clk_get_rate(timer_clk),
                                        0xff, 0xfffffffe);

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

