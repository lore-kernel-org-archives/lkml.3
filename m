Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750944AbbABIzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 03:55:15 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:42237 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbbABIzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 03:55:12 -0500
Message-ID: <54A65CEA.9060202@gmail.com>
Date: Fri, 02 Jan 2015 17:55:06 +0900
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
CC: Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linus.walleij@linaro.org, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com, Mark Rutland <mark.rutland@arm.com>,
        khilman@linaro.org
Subject: Re: [PATCH v10 2/8] ARM: l2c: Refactor the driver to use commit-like
 interface
References: <1419331716-8972-1-git-send-email-m.szyprowski@samsung.com> <1419331716-8972-3-git-send-email-m.szyprowski@samsung.com> <54A19C17.1020909@ti.com>
In-Reply-To: <54A19C17.1020909@ti.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.12.2014 03:23, Nishanth Menon wrote:
> On 12/23/2014 04:48 AM, Marek Szyprowski wrote:
>
>> -static void l2c310_resume(void)
>> +static void l2c310_configure(void __iomem *base)
>>   {
>> -	void __iomem *base = l2x0_base;
>> +	unsigned revision;
>>
>> -	if (!(readl_relaxed(base + L2X0_CTRL) & L2X0_CTRL_EN)) {
>> -		unsigned revision;
>> -
>> -		/* restore pl310 setup */
>> -		writel_relaxed(l2x0_saved_regs.tag_latency,
>> -			       base + L310_TAG_LATENCY_CTRL);
>> -		writel_relaxed(l2x0_saved_regs.data_latency,
>> -			       base + L310_DATA_LATENCY_CTRL);
>> -		writel_relaxed(l2x0_saved_regs.filter_end,
>> -			       base + L310_ADDR_FILTER_END);
>> -		writel_relaxed(l2x0_saved_regs.filter_start,
>> -			       base + L310_ADDR_FILTER_START);
>> -
>> -		revision = readl_relaxed(base + L2X0_CACHE_ID) &
>> -				L2X0_CACHE_ID_RTL_MASK;
>> -
>> -		if (revision >= L310_CACHE_ID_RTL_R2P0)
>> -			l2c_write_sec(l2x0_saved_regs.prefetch_ctrl, base,
>> -				      L310_PREFETCH_CTRL);
>> -		if (revision >= L310_CACHE_ID_RTL_R3P0)
>> -			l2c_write_sec(l2x0_saved_regs.pwr_ctrl, base,
>> -				      L310_POWER_CTRL);
>> -
>> -		l2c_enable(base, l2x0_saved_regs.aux_ctrl, 8);
>> -
>> -		/* Re-enable full-line-of-zeros for Cortex-A9 */
>> -		if (l2x0_saved_regs.aux_ctrl & L310_AUX_CTRL_FULL_LINE_ZERO)
>> -			set_auxcr(get_auxcr() | BIT(3) | BIT(2) | BIT(1));
>> -	}
>> +	/* restore pl310 setup */
>> +	writel_relaxed(l2x0_saved_regs.tag_latency,
>> +		       base + L310_TAG_LATENCY_CTRL);
>> +	writel_relaxed(l2x0_saved_regs.data_latency,
>> +		       base + L310_DATA_LATENCY_CTRL);
>> +	writel_relaxed(l2x0_saved_regs.filter_end,
>> +		       base + L310_ADDR_FILTER_END);
>> +	writel_relaxed(l2x0_saved_regs.filter_start,
>> +		       base + L310_ADDR_FILTER_START);
>> +
>
> ^^ The above change broke AM437xx. Looks like the change causes the
> following behavior difference on AM437x. For some reason, touching any
> of the above 4 registers(even with the values read from the same
> registers) causes AM437x to go beserk. Comment the 4 writes and we
> reach shell. looks like l2c310_resume is not invoked prior to this
> series. :(.. now that we reuse that logic to actually do programming,
> we start to see the problem.

OK, I probably have answer for this. Apparently all four register above 
cannot be written in non-secure mode and they should go through 
l2c_write_sec(). More on this can be found in CoreLink Level 2 Cache 
Controller L2C-310 Technical Reference Manual, 3.2. Register summary, 
table 3.1. I have checked the TRM for r3p3, but I guess this should be 
uniform for all revisions.

Why this worked before? The registers were not written unless respective 
properties in DT were present and OMAP do not have them in DT. Current 
code always writes them, which should not really matter if the code is 
correct. (But it isn't - writel_relaxed() can't be used directly for 
those registers.)

Could you check if replacing those four writel_relaxed() with 
l2c_write_sec() does the thing?

Best regards,
Tomasz
