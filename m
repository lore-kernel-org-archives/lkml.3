Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbaEOPnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:43:12 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:41120 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaEOPnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:43:08 -0400
Message-ID: <5374E087.7030703@gmail.com>
Date: Thu, 15 May 2014 17:43:03 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Jisheng Zhang <jszhang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/10] clk: berlin: add core clock driver for BG2/BG2CD
References: <1399839881-29895-1-git-send-email-sebastian.hesselbarth@gmail.com> <1400098522-14770-1-git-send-email-sebastian.hesselbarth@gmail.com> <1400098522-14770-7-git-send-email-sebastian.hesselbarth@gmail.com> <20140515080921.GQ29318@piout.net>
In-Reply-To: <20140515080921.GQ29318@piout.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 10:09 AM, Alexandre Belloni wrote:
> On 14/05/2014 at 22:15:17 +0200, Sebastian Hesselbarth wrote :
>> +	/* clock divider cells */
>> +	parent_names[1] = avpllb_names[CH4];
>> +	parent_names[2] = avpllb_names[CH5];
>> +	parent_names[3] = avpllb_names[CH6];
>> +	parent_names[4] = avpllb_names[CH7];
>> +
>> +	parent_names[0] = refclk_names[SYSPLL];
>
> It should actually be:
>
> parent_names[0] = avpllb_names[CH4];
> parent_names[1] = avpllb_names[CH5];
> parent_names[2] = avpllb_names[CH6];
> parent_names[3] = avpllb_names[CH7];
> parent_names[4] = refclk_names[SYSPLL];

Given the comment to remove index 0 in the last patch, I translate that
into: "the input mux bypass is there, but {cannot,should not,we do not
want it to} be used". *sigh*

Actually, almost all of this is based on Chromecast mirrored BSP code
and I though about leaving the bypass mux in - even if it is not used
at all.

The reason is that I am _very_ tired of reading through the BSP code
and have all the things in mind where the BSP code is unclear.

>> +	data = &bg2_divs[CLKID_SYS];
>> +	clks[CLKID_SYS] = berlin2_div_register(&data->map, base, data->name,
>> +		       data->div_flags, parent_names, 5, data->flags, &lock);
>> +
>> +	parent_names[0] = refclk_names[CPUPLL];
>> +	parent_names[5] = refclk_names[MEMPLL];
>
> The only valid choice here should be (remember, we are not adding 1 to
> the index anymore):
> parent_names[4] = refclk_names[MEMPLL];

Funny to see that there ought to be a CPUPLL which isn't used by the
CPU at all. This also implies to remove CPUPLL, right?

>> +	data = &bg2_divs[CLKID_CPU];
>> +	clks[CLKID_CPU] = berlin2_div_register(&data->map, base, data->name,
>> +			 data->div_flags, parent_names, 6, data->flags, &lock);
>> +
>
> This is where it gets tricky, now we should have:
> parent_names[0] = avpllb_names[CH4];
> parent_names[1] = avplla_names[CH5];
> parent_names[2] = avpllb_names[CH6];
> parent_names[3] = avpllb_names[CH7];
> parent_names[4] = refclk_names[SYSPLL];

First I thought that it is just the default input mux clocks again..
but then I noticed that it is actually AVPLL_A5 not B5.

Ok, I admit having confirmed information is maybe better. So, you agree
that we can remove the input mux bypass on the complex divider, too?
(Including all the consequences: remove it from the divmap, driver, ...)

Sebastian

>> +	parent_names[0] = refclk_names[SYSPLL];
>> +	for (n = CLKID_DRMFIGO; n <= CLKID_APP; n++) {
>> +		data = &bg2_divs[n];
>> +		clks[n] = berlin2_div_register(&data->map, base, data->name,
>> +			 data->div_flags, parent_names, 5, data->flags, &lock);
>> +	}
>> +
>

