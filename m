Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab3AOQeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 11:34:17 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:34698 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab3AOQeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 11:34:16 -0500
Message-ID: <50F584F5.6030007@free-electrons.com>
Date: Tue, 15 Jan 2013 17:33:57 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>, Cong Ding <dinggnu@gmail.com>,
        Mike Turquette <mturquette@ti.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] clk: mvebu/clk-cpu.c: fix memory leakage
References: <1358183892-28928-1-git-send-email-dinggnu@gmail.com> <50F563EC.3030804@free-electrons.com> <20130115152307.GA25615@gmail.com> <20130115153716.GF13433@titan.lakedaemon.net>
In-Reply-To: <20130115153716.GF13433@titan.lakedaemon.net>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 04:37 PM, Jason Cooper wrote:
> Mike,
> 
> On Tue, Jan 15, 2013 at 03:23:08PM +0000, Cong Ding wrote:
>> From 75c73077905b822be6e8a32a09d6b0cdb5e61763 Mon Sep 17 00:00:00 2001
>> From: Cong Ding <dinggnu@gmail.com>
>> Date: Mon, 14 Jan 2013 18:06:26 +0100
>> Subject: [PATCH v2] clk: mvebu/clk-cpu.c: fix memory leakage
>>
>> the variable cpuclk and clk_name should be properly freed when error happens.
>>
>> Signed-off-by: Cong Ding <dinggnu@gmail.com>
>> ---
>>  drivers/clk/mvebu/clk-cpu.c |   15 ++++++++++-----
>>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> 
> Do you want to take this fix through the clock tree?  If so,
> 
> Acked-by: Jason Cooper <jason@lakedaemon.net>
> 

I also think it should go through the clock tree but before this
I'd like we fix the last issue.

Cong Ding,

you didn't take in account the case when the allocation of the 1st clocks
when the 2nd cpu clock failed. In this case there is still a memory leak with
the clock_name of the first cpu clock. See below for my proposal:

> Otherwise, just let me know.
> 
> thx,
> 
> Jason.
> 
>> diff --git a/drivers/clk/mvebu/clk-cpu.c b/drivers/clk/mvebu/clk-cpu.c
>> index ff004578..1066a43 100644
>> --- a/drivers/clk/mvebu/clk-cpu.c
>> +++ b/drivers/clk/mvebu/clk-cpu.c
>> @@ -124,7 +124,7 @@ void __init of_cpu_clk_setup(struct device_node *node)
>>  
>>  	clks = kzalloc(ncpus * sizeof(*clks), GFP_KERNEL);
>>  	if (WARN_ON(!clks))
>> -		return;
>> +		goto clks_out;
>>  
>>  	for_each_node_by_type(dn, "cpu") {
>>  		struct clk_init_data init;
>> @@ -134,11 +134,13 @@ void __init of_cpu_clk_setup(struct device_node *node)
>>  		int cpu, err;
>>  
>>  		if (WARN_ON(!clk_name))
>> -			return;
>> +			goto bail_out;
>>  
>>  		err = of_property_read_u32(dn, "reg", &cpu);
>> -		if (WARN_ON(err))
>> -			return;
>> +		if (WARN_ON(err)) {

>> +			kfree(clk_name);
we can free it later

>> +			goto bail_out;
>> +		}
>>  
>>  		sprintf(clk_name, "cpu%d", cpu);
>>  		parent_clk = of_clk_get(node, 0);
>> @@ -156,8 +158,10 @@ void __init of_cpu_clk_setup(struct device_node *node)
>>  		init.num_parents = 1;
>>  
>>  		clk = clk_register(NULL, &cpuclk[cpu].hw);
>> -		if (WARN_ON(IS_ERR(clk)))
>> +		if (WARN_ON(IS_ERR(clk))) {

>> +			kfree(clk_name);
we can free it later

>>  			goto bail_out;
>> +		}
>>  		clks[cpu] = clk;
>>  	}
>>  	clk_data.clk_num = MAX_CPU;
>> @@ -167,6 +171,7 @@ void __init of_cpu_clk_setup(struct device_node *node)
>>  	return;
>>  bail_out:
>>  	kfree(clks);
>> +clks_out:

as cpuclk is allocated with all its member set to 0, and kfree(0) is a valid call.
We can add the following lines:

while(ncpus--)
	kfree(cpuclk[ncpus].clk_name);

>>  	kfree(cpuclk);
>>  }
>>  
>> -- 
>> 1.7.9.5
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
