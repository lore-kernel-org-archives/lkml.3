Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab3EPVb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 17:31:26 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25735 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab3EPVbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 17:31:25 -0400
X-IronPort-AV: E=Sophos;i="4.87,686,1363158000"; 
   d="scan'208";a="47968933"
Message-ID: <5195502B.3070003@codeaurora.org>
Date: Thu, 16 May 2013 14:31:23 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, Paul Walmsley <paul@pwsan.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] clk: Fix race condition between clk_set_parent and
 clk_enable()
References: <1367383328-25700-1-git-send-email-skannan@codeaurora.org> <1368677244-7279-1-git-send-email-skannan@codeaurora.org> <20130516204455.12127.75296@quantum>
In-Reply-To: <20130516204455.12127.75296@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 01:44 PM, Mike Turquette wrote:
> Quoting Saravana Kannan (2013-05-15 21:07:24)
>> Without this patch, the following race condition is possible.
>> * clk-A has two parents - clk-X and clk-Y.
>> * All three are disabled and clk-X is current parent.
>> * Thread A: clk_set_parent(clk-A, clk-Y).
>> * Thread A: <snip execution flow>
>> * Thread A: Grabs enable lock.
>> * Thread A: Sees enable count of clk-A is 0, so doesn't enable clk-Y.
>> * Thread A: Updates clk-A SW parent to clk-Y
>> * Thread A: Releases enable lock.
>> * Thread B: clk_enable(clk-A).
>> * Thread B: clk_enable() enables clk-Y, then enabled clk-A and returns.
>>
>> clk-A is now enabled in software, but not clocking in hardware since the
>> hardware parent is still clk-X.
>>
>> The only way to avoid race conditions between clk_set_parent() and
>> clk_enable/disable() is to ensure that clk_enable/disable() calls don't
>> require changes to hardware enable state between changes to software clock
>> topology and hardware clock topology.
>>
>> The options to achieve the above are:
>> 1. Grab the enable lock before changing software/hardware topology and
>>     release it afterwards.
>> 2. Keep the clock enabled for the duration of software/hardware topology
>>     change so that any additional enable/disable calls don't try to change
>>     the hardware state. Once the topology change is complete, the clock can
>>     be put back in its original enable state.
>>
>> Option (1) is not an acceptable solution since the set_parent() ops might
>> need to sleep.
>>
>> Therefore, this patch implements option (2).
>>
>> This patch doesn't violate any API semantics. clk_disable() doesn't
>> guarantee that the clock is actually disabled. So, no clients of a clock
>> can assume that a clock is disabled after their last call to clk_disable().
>> So, enabling the clock during a parent change is not a violation of any API
>> semantics.
>>
>> This also has the nice side effect of simplifying the error handling code.
>>
>> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
>
> Updated to this version in clk-next.
>

Thanks Mike. I forgot to add the Ack by Ulf. Would be nice if you can 
put that in.

Btw, I did send this email to the list. But looks like this mail is 
wedged in the series of tubes in the arm mailing list.

-Saravana


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
