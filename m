Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab3HEQ2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:28:31 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56880 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab3HEQ22 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:28:28 -0400
Message-ID: <51FFD2B1.70509@arm.com>
Date: Mon, 05 Aug 2013 17:28:33 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Jason Cooper <jason@lakedaemon.net>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 05/16] ARM: mvebu: remove device tree parsing for cpu
 nodes
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1374492747-13879-6-git-send-email-Sudeep.KarkadaNagesha@arm.com> <51FA3064.9080502@arm.com> <20130801120256.GW5882@titan.lakedaemon.net>
In-Reply-To: <20130801120256.GW5882@titan.lakedaemon.net>
X-OriginalArrivalTime: 05 Aug 2013 16:28:22.0302 (UTC) FILETIME=[CD532BE0:01CE91F8]
X-MC-Unique: 113080517282503501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/13 13:02, Jason Cooper wrote:
> Sudeep,
> 
> On Thu, Aug 01, 2013 at 10:54:44AM +0100, Sudeep KarkadaNagesha wrote:
>> On 22/07/13 12:32, Sudeep KarkadaNagesha wrote:
>>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>>
>>> Currently set_secondary_cpus_clock assume the CPU logical ordering
>>> and the MPDIR in DT are same, which is incorrect.
>>>
>>> Since the CPU device nodes can be retrieved in the logical ordering
>>> using the DT helper, we can remove the devices tree parsing.
>>>
>>> This patch removes DT parsing by making use of of_get_cpu_node.
>>>
>>> Cc: Gregory Clement <gregory.clement@free-electrons.com>
>>> Cc: Andrew Lunn <andrew@lunn.ch>
>>> Cc: Jason Cooper <jason@lakedaemon.net>
>>> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>
>> Hi Gregory/Andrew/Jason,
>>
>> Does this change look fine for mvebu?
>> If yes, can I have your ACKs ?
> 
> Gregory is the one best suited to review/Ack this.  He'll be back on
> Monday.
> 
Hi Gregory,

Can you please review this patch ?

Regards,
Sudeep
>>> ---
>>>  arch/arm/mach-mvebu/platsmp.c | 52 ++++++++++++++++++++-----------------------
>>>  1 file changed, 24 insertions(+), 28 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-mvebu/platsmp.c b/arch/arm/mach-mvebu/platsmp.c
>>> index ce81d30..001dd42 100644
>>> --- a/arch/arm/mach-mvebu/platsmp.c
>>> +++ b/arch/arm/mach-mvebu/platsmp.c
>>> @@ -23,51 +23,47 @@
>>>  #include <linux/of.h>
>>>  #include <linux/mbus.h>
>>>  #include <asm/cacheflush.h>
>>> +#include <asm/prom.h>
>>>  #include <asm/smp_plat.h>
>>>  #include "common.h"
>>>  #include "armada-370-xp.h"
>>>  #include "pmsu.h"
>>>  #include "coherency.h"
>>>  
>>> +static struct clk *__init get_cpu_clk(int cpu)
>>> +{
>>> +	struct clk *cpu_clk;
>>> +	struct device_node *np = of_get_cpu_node(cpu);
>>> +
>>> +	if (WARN(!np, "missing cpu node\n"))
>>> +		return NULL;
>>> +	cpu_clk = of_clk_get(np, 0);
>>> +	if (WARN_ON(IS_ERR(cpu_clk)))
>>> +		return NULL;
>>> +	return cpu_clk;
>>> +}
>>> +
>>>  void __init set_secondary_cpus_clock(void)
>>>  {
>>> -	int thiscpu;
>>> +	int thiscpu, cpu;
>>>  	unsigned long rate;
>>> -	struct clk *cpu_clk = NULL;
>>> -	struct device_node *np = NULL;
>>> +	struct clk *cpu_clk;
>>>  
>>>  	thiscpu = smp_processor_id();
>>> -	for_each_node_by_type(np, "cpu") {
>>> -		int err;
>>> -		int cpu;
>>> -
>>> -		err = of_property_read_u32(np, "reg", &cpu);
>>> -		if (WARN_ON(err))
>>> -			return;
>>> -
>>> -		if (cpu == thiscpu) {
>>> -			cpu_clk = of_clk_get(np, 0);
>>> -			break;
>>> -		}
>>> -	}
>>> -	if (WARN_ON(IS_ERR(cpu_clk)))
>>> +	cpu_clk = get_cpu_clk(thiscpu);
>>> +	if (!cpu_clk)
>>>  		return;
>>>  	clk_prepare_enable(cpu_clk);
>>>  	rate = clk_get_rate(cpu_clk);
>>>  
>>>  	/* set all the other CPU clk to the same rate than the boot CPU */
>>> -	for_each_node_by_type(np, "cpu") {
>>> -		int err;
>>> -		int cpu;
>>> -
>>> -		err = of_property_read_u32(np, "reg", &cpu);
>>> -		if (WARN_ON(err))
>>> +	for_each_possible_cpu(cpu) {
>>> +		if (cpu == thiscpu)
>>> +			continue;
>>> +		cpu_clk = get_cpu_clk(cpu);
>>> +		if (!cpu_clk)
>>>  			return;
>>> -
>>> -		if (cpu != thiscpu) {
>>> -			cpu_clk = of_clk_get(np, 0);
>>> -			clk_set_rate(cpu_clk, rate);
>>> -		}
>>> +		clk_set_rate(cpu_clk, rate);
>>>  	}
>>>  }
>>>  
>>>
>>
>>
> 


