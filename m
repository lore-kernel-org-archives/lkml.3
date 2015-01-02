Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbbABR6D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 12:58:03 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39462 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbbABR6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 12:58:00 -0500
Message-ID: <54A6DBFD.1040900@ti.com>
Date: Fri, 2 Jan 2015 11:57:17 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Kyungmin Park <kyungmin.park@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, <lauraa@codeaurora.org>,
        <linus.walleij@linaro.org>, <tony@atomide.com>, <drake@endlessm.com>,
        <loeliger@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        <khilman@linaro.org>
Subject: Re: [PATCH v10 2/8] ARM: l2c: Refactor the driver to use commit-like
 interface
References: <1419331716-8972-1-git-send-email-m.szyprowski@samsung.com> <1419331716-8972-3-git-send-email-m.szyprowski@samsung.com> <54A19C17.1020909@ti.com> <54A65CEA.9060202@gmail.com>
In-Reply-To: <54A65CEA.9060202@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2015 02:55 AM, Tomasz Figa wrote:
> On 30.12.2014 03:23, Nishanth Menon wrote:
>> On 12/23/2014 04:48 AM, Marek Szyprowski wrote:
>>
>>> -static void l2c310_resume(void)
>>> +static void l2c310_configure(void __iomem *base)
>>>   {
>>> -	void __iomem *base = l2x0_base;
>>> +	unsigned revision;
>>>
>>> -	if (!(readl_relaxed(base + L2X0_CTRL) & L2X0_CTRL_EN)) {
>>> -		unsigned revision;
>>> -
>>> -		/* restore pl310 setup */
>>> -		writel_relaxed(l2x0_saved_regs.tag_latency,
>>> -			       base + L310_TAG_LATENCY_CTRL);
>>> -		writel_relaxed(l2x0_saved_regs.data_latency,
>>> -			       base + L310_DATA_LATENCY_CTRL);
>>> -		writel_relaxed(l2x0_saved_regs.filter_end,
>>> -			       base + L310_ADDR_FILTER_END);
>>> -		writel_relaxed(l2x0_saved_regs.filter_start,
>>> -			       base + L310_ADDR_FILTER_START);
>>> -
>>> -		revision = readl_relaxed(base + L2X0_CACHE_ID) &
>>> -				L2X0_CACHE_ID_RTL_MASK;
>>> -
>>> -		if (revision >= L310_CACHE_ID_RTL_R2P0)
>>> -			l2c_write_sec(l2x0_saved_regs.prefetch_ctrl, base,
>>> -				      L310_PREFETCH_CTRL);
>>> -		if (revision >= L310_CACHE_ID_RTL_R3P0)
>>> -			l2c_write_sec(l2x0_saved_regs.pwr_ctrl, base,
>>> -				      L310_POWER_CTRL);
>>> -
>>> -		l2c_enable(base, l2x0_saved_regs.aux_ctrl, 8);
>>> -
>>> -		/* Re-enable full-line-of-zeros for Cortex-A9 */
>>> -		if (l2x0_saved_regs.aux_ctrl & L310_AUX_CTRL_FULL_LINE_ZERO)
>>> -			set_auxcr(get_auxcr() | BIT(3) | BIT(2) | BIT(1));
>>> -	}
>>> +	/* restore pl310 setup */
>>> +	writel_relaxed(l2x0_saved_regs.tag_latency,
>>> +		       base + L310_TAG_LATENCY_CTRL);
>>> +	writel_relaxed(l2x0_saved_regs.data_latency,
>>> +		       base + L310_DATA_LATENCY_CTRL);
>>> +	writel_relaxed(l2x0_saved_regs.filter_end,
>>> +		       base + L310_ADDR_FILTER_END);
>>> +	writel_relaxed(l2x0_saved_regs.filter_start,
>>> +		       base + L310_ADDR_FILTER_START);
>>> +
>>
>> ^^ The above change broke AM437xx. Looks like the change causes the
>> following behavior difference on AM437x. For some reason, touching any
>> of the above 4 registers(even with the values read from the same
>> registers) causes AM437x to go beserk. Comment the 4 writes and we
>> reach shell. looks like l2c310_resume is not invoked prior to this
>> series. :(.. now that we reuse that logic to actually do programming,
>> we start to see the problem.
> 
> OK, I probably have answer for this. Apparently all four register above 
> cannot be written in non-secure mode and they should go through 
> l2c_write_sec(). More on this can be found in CoreLink Level 2 Cache 
> Controller L2C-310 Technical Reference Manual, 3.2. Register summary, 
> table 3.1. I have checked the TRM for r3p3, but I guess this should be 
> uniform for all revisions.

Yep, you seemed to have caught the issue correctly.

> 
> Why this worked before? The registers were not written unless respective 
> properties in DT were present and OMAP do not have them in DT. Current 
> code always writes them, which should not really matter if the code is 
> correct. (But it isn't - writel_relaxed() can't be used directly for 
> those registers.)
> 
> Could you check if replacing those four writel_relaxed() with 
> l2c_write_sec() does the thing?

Considering that
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/arch/arm/mach-omap2/omap4-common.c#n169
has no implementation of DATA,TAG_LATENCY, FILTER_*
I did a few patches for those - separate from this series and posted
(v2 of the series):
https://patchwork.kernel.org/patch/5560231/
https://patchwork.kernel.org/patch/5560211/

Anyways, l2c_write_sec will refuse to write if the read value is same
as requested value - that is exactly what we want here. So, for
testing, I hacked it and remove the check to force the writes
(http://slexy.org/view/s2p8c3gl32)

The replaced raw_writels with secure writes(fix needed for this
patch): http://slexy.org/view/s21PbM73tt

(with secure writes, my patches and force write hack applied):
 1: am437x-sk: BOOT: PASS: http://slexy.org/raw/s2BxqX5NOz
 2: am43xx-epos: BOOT: PASS: http://slexy.org/raw/s2VkKYuYed
 3: am43xx-gpevm: BOOT: PASS: http://slexy.org/raw/s2kO95WSuY
 4: pandaboard-es: BOOT: PASS: http://slexy.org/raw/s21sx5gmUl
 5: pandaboard-vanilla: BOOT: PASS: http://slexy.org/raw/s21lpUJK6r
 6: sdp4430: BOOT: PASS: http://slexy.org/raw/s21UVKHle5


(with just secure writes and none of my patches or hacks applied):
 1: am437x-sk: BOOT: PASS: http://slexy.org/raw/s21UxoDdo5
 2: am43xx-epos: BOOT: PASS: http://slexy.org/raw/s2ECrLZ1FH
 3: am43xx-gpevm: BOOT: PASS: http://slexy.org/raw/s2CowTVA9P
 4: pandaboard-es: BOOT: PASS: http://slexy.org/raw/s205MVIWf0
 5: pandaboard-vanilla: BOOT: PASS: http://slexy.org/raw/s29oJ66Rqs
 6: sdp4430: BOOT: PASS: http://slexy.org/raw/s20jLzW2cX


Awesome :). Thanks for catching this.

-- 
Regards,
Nishanth Menon
