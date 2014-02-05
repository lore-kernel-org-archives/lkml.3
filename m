Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbaBEPFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 10:05:20 -0500
Received: from top.free-electrons.com ([176.31.233.9]:35420 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751840AbaBEPFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:05:18 -0500
Message-ID: <52F25324.90108@free-electrons.com>
Date: Wed, 05 Feb 2014 16:05:08 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] clk: add strict of_clk_init dependency check
References: <1391554766-11285-1-git-send-email-gregory.clement@free-electrons.com> <1391593680-9388-1-git-send-email-b.brezillon@overkiz.com> <52F24F4F.8000901@free-electrons.com>
In-Reply-To: <52F24F4F.8000901@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2014 15:48, Gregory CLEMENT wrote:
> Hi Boris,
> 
> On 05/02/2014 10:48, Boris BREZILLON wrote:
>> The parent dependency check is only available on the first parent of a given
>> clk.
>>
>> Add support for strict dependency check: all parents of a given clk must be
>> initialized.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> ---
>>
>> Hello Gregory,
>>
>> This patch adds support for strict check on clk dependencies (check if all
>> parents specified by an DT clk node are initialized).
>>
>> I'm not sure this is what you were expecting (maybe testing the first parent
>> is what you really want), so please feel free to tell me if I'm wrong.
>>
>> Best Regards,
>>
>> Boris
>>
>>  drivers/clk/clk.c |   27 +++++++++++++++++++++------
>>  1 file changed, 21 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>> index beb0f8b..6849769 100644
>> --- a/drivers/clk/clk.c
>> +++ b/drivers/clk/clk.c
>> @@ -2543,22 +2543,37 @@ static int parent_ready(struct device_node *np)
>>  {
>>  	struct of_phandle_args clkspec;
>>  	struct of_clk_provider *provider;
>> +	int num_parents;
>> +	bool found;
>> +	int i;
>>  
>>  	/*
>>  	 * If there is no clock parent, no need to wait for them, then
>>  	 * we can consider their absence as being ready
>>  	 */
>> -	if (of_parse_phandle_with_args(np, "clocks", "#clock-cells", 0,
>> -					&clkspec))
>> +	num_parents = of_count_phandle_with_args(np, "clocks", "#clock-cells");
>> +	if (num_parents <= 0)
>>  		return 1;
>>  
>> -	/* Check if we have such a provider in our array */
>> -	list_for_each_entry(provider, &of_clk_providers, link) {
>> -		if (provider->node == clkspec.np)
>> +	for (i = 0; i < num_parents; i++) {
>> +		if (of_parse_phandle_with_args(np, "clocks", "#clock-cells", i,
>> +					       &clkspec))
>>  			return 1;
>> +
>> +		/* Check if we have such a provider in our array */
>> +		found = false;
>> +		list_for_each_entry(provider, &of_clk_providers, link) {
>> +			if (provider->node == clkspec.np) {
>> +				found = true;
>> +				break;
> 
> Hum this means that as soon as you have one parent then you consider it
> as ready. It is better of what I have done because I only test the 1st
> parent. However I wondered if we should go further by ensuring all the
> parents are ready.

My bad, I read the code too fast. Your code already checks that all the
parents are ready.

So if you agree I will merge your code with mine and send a new patch.

> 
> If I am right, there is more than one parent only for the muxer. In this
> case is it really expected that all the parent are ready?
> 
> Thanks,
> 
> Gregory
> 
>> +			}
>> +		}
>> +
>> +		if (!found)
>> +			return 0;
>>  	}
>>  
>> -	return 0;
>> +	return 1;
>>  }
>>  
>>  /**
>>
> 
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
