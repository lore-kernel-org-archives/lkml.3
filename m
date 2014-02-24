Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaBXXjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 18:39:11 -0500
Received: from yotta.elopez.com.ar ([31.220.24.173]:45796 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbaBXXjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 18:39:09 -0500
Message-ID: <530BD804.5090806@elopez.com.ar>
Date: Mon, 24 Feb 2014 20:38:44 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        devicetree@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5] clk: sun6i: Protect CPU clock
References: <1393258967-4843-1-git-send-email-maxime.ripard@free-electrons.com> <1393258967-4843-2-git-send-email-maxime.ripard@free-electrons.com> <20140224163034.GN21483@n2100.arm.linux.org.uk>
In-Reply-To: <20140224163034.GN21483@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

El 24/02/14 13:30, Russell King - ARM Linux escribió:
> On Mon, Feb 24, 2014 at 05:22:43PM +0100, Maxime Ripard wrote:
>> Right now, AHB is an indirect child clock of the CPU clock. If that happens to
>> change, since the CPU clock has no other consumers declared in Linux, it would
>> be shut down, which is not really a good idea.
>>
>> Prevent this by forcing it enabled.
>>
>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>> ---
>>   drivers/clk/sunxi/clk-sunxi.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
>> index 23baad9..cedaf4b 100644
>> --- a/drivers/clk/sunxi/clk-sunxi.c
>> +++ b/drivers/clk/sunxi/clk-sunxi.c
>> @@ -1301,6 +1301,14 @@ static void __init sunxi_clock_protect(void)
>>   		clk_prepare_enable(clk);
>>   		clk_put(clk);
>>   	}
>> +
>> +	/* CPU clocks - sun6i */
>> +	clk = clk_get(NULL, "cpu");
>> +	if (!IS_ERR(clk)) {
>> +		clk_prepare_enable(clk);
>> +		clk_put(clk);
>> +	}
>
> This is broken.  I'm not sure what's difficult to grasp about the concept
> of "while a clock is in use, you should keep a reference to that clock".
>
> That implies that if you get a clock, and then enable it, you don't
> put the clock until you've disabled it.

Why is this so? Can't a clock be left enabled while nobody has a 
reference to it? I have looked around in Documentation/ (rather quickly 
I must say) and have not found any explicit mention that it is required 
to keep a reference to the clock while it's enabled. I'd appreciate it 
if you could explain this a bit more verbosely or point me to the 
relevant documents.

For what it's worth, I've seen this same pattern on 
enable/disable_clock() on drivers/base/power/clock_ops.c as well.

Cheers,

Emilio
