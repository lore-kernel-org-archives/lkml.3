Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761267Ab3JPRGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:06:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44790 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761085Ab3JPRGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:06:20 -0400
Message-ID: <525EC788.9000309@wwwdotorg.org>
Date: Wed, 16 Oct 2013 11:06:16 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 02/19] clk: tegra: simplify periph clock data
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com> <1381848794-11761-3-git-send-email-pdeschrijver@nvidia.com> <525D8D7D.10301@wwwdotorg.org> <20131016150619.GM5643@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20131016150619.GM5643@tbergstrom-lnx.Nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 09:06 AM, Peter De Schrijver wrote:
> On Tue, Oct 15, 2013 at 08:46:21PM +0200, Stephen Warren wrote:
>> On 10/15/2013 08:52 AM, Peter De Schrijver wrote:
>>> This patch determines the register bank for clock enable/disable and reset
>>> based on the clock ID instead of hardcoding it in the tables describing the
>>> clocks. This results in less data to be maintained in the tables, making the
>>> code easier to understand. The full benefit of the change will be realized once
>>> also other clocktypes will be table based.
>>
>>> diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c

>>>  	for (i = 0; i < ARRAY_SIZE(tegra_periph_clk_list); i++) {
>>>  		data = &tegra_periph_clk_list[i];
>>> -		clk = tegra_clk_register_periph(data->name, data->parent_names,
>>> -				data->num_parents, &data->periph,
>>> -				clk_base, data->offset, data->flags);
>>> +
>>> +		clk = tegra_clk_register_periph(data->name,
>>> +			data->parent_names, data->num_parents, &data->periph,
>>> +			clk_base, data->offset, data->flags);
>>>  		clks[data->clk_id] = clk;
>>>  	}
>>>  
>>>  	for (i = 0; i < ARRAY_SIZE(tegra_periph_nodiv_clk_list); i++) {
>>>  		data = &tegra_periph_nodiv_clk_list[i];
>>> +
>>>  		clk = tegra_clk_register_periph_nodiv(data->name,
>>
>> Nit: Seems like an unrelated change, and inconsistent with the other
>> loop above.
> 
> Actually it makes it consistent. The previous loop added an empty line
> between data = ... and tegra_clk_register_periph()

Oh right, I see you added the blank line in the chunk about and I'd
overlooked that. I guess it's fine.

>>> diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
>>
>>> +struct tegra_clk_periph_regs * __init get_reg_bank(int clkid)
>>> +{
>>> +	int reg_bank = clkid / 32;
>>> +
>>> +	if (reg_bank < periph_banks)
>>> +		return &periph_regs[reg_bank];
>>> +	else {
>>> +		WARN_ON(1);
>>> +		return NULL;
>>> +	}
>>> +}
>>> +
>>> +int __init tegra_clk_periph_banks(int num)
>>> +{
>>> +	if (num > ARRAY_SIZE(periph_regs))
>>> +		return -EINVAL;
>>> +
>>> +	periph_banks = num;
>>> +
>>> +	return 0;
>>> +}
>>
>> Shouldn't the condition in tegra_clk_periph_banks() check against
>> periph_banks rather than ARRAY_SIZE(periph_regs)? I assume the calls to
> 
> periph_banks is initialized in tegra_clk_periph_banks(), so I don't see how
> that would work?

Yes, indeed!

>> tegra_clk_periph_banks() from tegra*_clock_init() are intended to ensure
>> that periph_regs is set up correctly in this file? I wonder if
>> s/tegra_clk_periph_banks/tegra_clk_validate_periph_bank_count/ isn't
>> called for?
> 
> Yes. The calls are intended to ensure that the clk-tegra* files, don't
> refer to register banks which don't have addresses specified. This could happen
> if a wrong periph clk ID would be specified for example. In later patches
> we will also allocate memory based on the number of register banks.

Ah, so perhaps s/tegra_clk_periph_banks/tegra_clk_set_periph_banks/
would make it more obvious what it's doing.
