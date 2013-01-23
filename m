Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab3AWKAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:00:41 -0500
Received: from smtp-out-073.synserver.de ([212.40.185.73]:1367 "EHLO
	smtp-out-073.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab3AWKAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:00:40 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 23291
Message-ID: <50FFB4D8.5060801@metafoo.de>
Date: Wed, 23 Jan 2013 11:00:56 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: Add axi-clkgen driver
References: <1357755120-32735-1-git-send-email-lars@metafoo.de> <20130122175552.24671.27893@quantum>
In-Reply-To: <20130122175552.24671.27893@quantum>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 06:55 PM, Mike Turquette wrote:
> Quoting Lars-Peter Clausen (2013-01-09 10:12:00)
> <snip>
>> +static void axi_clkgen_write(struct axi_clkgen *axi_clkgen,
>> +       unsigned int reg, unsigned int val)
>> +{
>> +       iowrite32(val, axi_clkgen->base + reg);
> 
> Silly question: any reason to use this over readl()?  This is more for
> my understanding than a real criticism.

I think I read somewhere at some point that ioread{8,16,32} is preferred
over write{b,h,l} in new code.

> 
>> +}
>> +
>> +static void axi_clkgen_read(struct axi_clkgen *axi_clkgen,
>> +       unsigned int reg, unsigned int *val)
>> +{
>> +       *val = ioread32(axi_clkgen->base + reg);
> 
> Same as above, any reason to use this over writel?

Same answer.

> 
> <snip>
>> +static unsigned long axi_clkgen_recalc_rate(struct clk_hw *clk_hw,
>> +       unsigned long parent_rate)
>> +{
>> +       struct axi_clkgen *axi_clkgen = clk_hw_to_axi_clkgen(clk_hw);
>> +       unsigned int d, m, dout;
>> +       unsigned int reg;
>> +
>> +       axi_clkgen_read(axi_clkgen, AXI_CLKGEN_REG_CLK_OUT1, &reg);
>> +       dout = (reg & 0x3f) + ((reg >> 6) & 0x3f);
>> +       axi_clkgen_read(axi_clkgen, AXI_CLKGEN_REG_CLK_DIV, &reg);
>> +       d = (reg & 0x3f) + ((reg >> 6) & 0x3f);
>> +       axi_clkgen_read(axi_clkgen, AXI_CLKGEN_REG_CLK_FB1, &reg);
>> +       m = (reg & 0x3f) + ((reg >> 6) & 0x3f);
>> +
>> +       if (d == 0 || dout == 0)
>> +               return 0;
>> +
>> +       return parent_rate / d * m / dout;
> 
> Any chance of overflow here?  Maybe do_div should be used?

Not if all the parameters are within spec. But since this is on a slowpath I
guess it does not hurt to use do_div.

Will send a v2.

Thanks for the review,
- Lars

