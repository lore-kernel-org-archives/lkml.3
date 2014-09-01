Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaIAHRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 03:17:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57281 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752165AbaIAHRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 03:17:40 -0400
Message-ID: <54041D90.3030107@free-electrons.com>
Date: Mon, 01 Sep 2014 09:17:36 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Leigh Brown <leigh@solinno.co.uk>
CC: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Simon Boulay <simon.boulay@vitec.com>,
        Arnaud Ebalard <arno@natisbad.org>, Nadav Haklai <nadavh@marvell.com>,
        Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Raphael Rigo <ml-arm@syscall.eu>, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 1/4] clk: mvebu: Fix clk frequency value if SSCG is enabled
References: <1409312620-20631-1-git-send-email-gregory.clement@free-electrons.com> <1409312620-20631-2-git-send-email-gregory.clement@free-electrons.com> <d9e3be49b00eb7dd8827f05a955b4497@doppler.thel33t.co.uk>
In-Reply-To: <d9e3be49b00eb7dd8827f05a955b4497@doppler.thel33t.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Leigh,

On 01/09/2014 00:25, Leigh Brown wrote:
> Hi Gregory,
> 
> On 2014-08-29 12:43, Gregory CLEMENT wrote:
>> When the SSCG (Spread Spectrum Clock Generator) is enabled, it shifts
>> the frequency of the clock. The percentage is no more than 1% but when
>> the clock is used for a timer it leads to a clock drift.
> 
> Thank you so much for this series.  I'm running 3.16 and without these 
> patches ntpd is all over the place, so it is a huge improvement  I do 
> have a comment further down though..
> 
>> This patch allows to correct the affected clock when the SSCG is
>> enabled. The check is done in an new optional function related to each
>> SoC: is_sscg_enabled(). If this function is not present then no
>> correction is done on the clock frequency.
>>
>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>> ---
>>  drivers/clk/mvebu/common.c | 74 
>> ++++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/clk/mvebu/common.h |  1 +
>>  2 files changed, 75 insertions(+)
>>
>> diff --git a/drivers/clk/mvebu/common.c b/drivers/clk/mvebu/common.c
>> index 25ceccf939ad..834d36cf79b0 100644
>> --- a/drivers/clk/mvebu/common.c
>> +++ b/drivers/clk/mvebu/common.c
>> @@ -26,8 +26,78 @@
>>   * Core Clocks
>>   */
>>
>> +#define SSCG_CONF_MODE(reg)	(((reg) >> 16) & 0x3)
>> +#define SSCG_SPREAD_DOWN	0x0
>> +#define SSCG_SPREAD_UP		0x1
>> +#define SSCG_SPREAD_CENTRAL	0x2
>> +#define SSCG_CONF_LOW(reg)	(((reg) >> 8) & 0xFF)
>> +#define SSCG_CONF_HIGH(reg)	((reg) & 0xFF)
>> +
>>  static struct clk_onecell_data clk_data;
>>
>> +static u32 fix_sscg_deviation(struct device_node *np, u32 system_clk)
>> +{
>> +	struct device_node *sscg_np = NULL;
>> +	void __iomem *sscg_map;
>> +	u32 sscg_reg;
>> +	s32 low_bound, high_bound;
>> +	u64 freq_swing_half;
>> +
>> +	sscg_np = of_find_node_by_name(np, "sscg");
>> +	if (sscg_np == NULL) {
>> +		pr_err("cannot get SSCG register node\n");
>> +		return system_clk;
>> +	}
>> +
>> +	sscg_map = of_iomap(sscg_np, 0);
>> +	if (sscg_map == NULL) {
>> +		pr_err("cannot map SSCG register\n");
>> +		goto out;
>> +	}
>> +
>> +	sscg_reg = readl(sscg_map);
>> +	high_bound = SSCG_CONF_HIGH(sscg_reg);
>> +	low_bound = SSCG_CONF_LOW(sscg_reg);
>> +
>> +	if ((high_bound - low_bound) <= 0)
>> +		goto out;
>> +	/*
>> +	 * From the datasheet we got the following formula
>> +	 * Spread percentage = 1/96 * (H - L) / H
> 
> In the datasheet it says the percentage is 0.96 * (H - L) / H.  1/96 is 
> close but not the same as 0.0096.

Actually the public datasheet is wrong (even the NDA datasheet).

> 
>> +	 * H = SSCG_High_Boundary
>> +	 * L = SSCG_Low_Boundary
>> +	 *
>> +	 * As the deviation is half of spread then it lead to the
>> +	 * following formula in the code.
>> +	 *
>> +	 * To avoid an overflow and not lose any significant digit in
>> +	 * the same time we have to use a 64 bit integer.
>> +	 */
>> +
>> +	freq_swing_half = (((u64)high_bound - (u64)low_bound)
>> +			* (u64)system_clk);
>> +	do_div(freq_swing_half, (2 * 96 * high_bound));
> 
> So this would be become :-
> 
> 	/* NB: 0.96% = 0.0048 or 3/625 */
> 	freq_swing_half = (((u64)high_bound - (u64)low_bound)
> 			* (u64)system_clk * 3);
> 	do_div(freq_swing_half, (625 * high_bound));

It was the first implementation I tried, but with this one
the drift was about 200ppm instead of 50ppm. After having
checked this with the Marvell engineers, they confirmed me
that the datasheet was erroneous.


Thanks for your feedback: I will add a comment in the code
about the fact that the datasheet is erroneous.



-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
