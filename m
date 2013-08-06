Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab3HFIgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:36:40 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52651 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754506Ab3HFIge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:36:34 -0400
X-Greylist: delayed 674 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Aug 2013 04:36:33 EDT
Message-ID: <5200B2E9.8090009@free-electrons.com>
Date: Tue, 06 Aug 2013 10:25:13 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
CC: Andrew Lunn <andrew@lunn.ch>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 05/16] ARM: mvebu: remove device tree parsing for cpu
 nodes
References: <1374069984-20567-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1374492747-13879-6-git-send-email-Sudeep.KarkadaNagesha@arm.com> <51FA3064.9080502@arm.com> <20130801120256.GW5882@titan.lakedaemon.net> <51FFD2B1.70509@arm.com>
In-Reply-To: <51FFD2B1.70509@arm.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 18:28, Sudeep KarkadaNagesha wrote:
> On 01/08/13 13:02, Jason Cooper wrote:
>> Sudeep,
>>
>> On Thu, Aug 01, 2013 at 10:54:44AM +0100, Sudeep KarkadaNagesha wrote:
>>> On 22/07/13 12:32, Sudeep KarkadaNagesha wrote:
>>>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>>>
>>>> Currently set_secondary_cpus_clock assume the CPU logical ordering
>>>> and the MPDIR in DT are same, which is incorrect.
>>>>
>>>> Since the CPU device nodes can be retrieved in the logical ordering
>>>> using the DT helper, we can remove the devices tree parsing.
>>>>
>>>> This patch removes DT parsing by making use of of_get_cpu_node.
>>>>
>>>> Cc: Gregory Clement <gregory.clement@free-electrons.com>
>>>> Cc: Andrew Lunn <andrew@lunn.ch>
>>>> Cc: Jason Cooper <jason@lakedaemon.net>
>>>> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>>
>>> Hi Gregory/Andrew/Jason,
>>>
>>> Does this change look fine for mvebu?
>>> If yes, can I have your ACKs ?
>>
>> Gregory is the one best suited to review/Ack this.  He'll be back on
>> Monday.
>>
> Hi Gregory,
> 
> Can you please review this patch ?

Your patch is a nice improvement, I reviewed it and I also tested it on the
Armada XP DB board.

You can add my:
Acked-by: Gregory Clement <gregory.clement@free-electrons.com>

> 
> Regards,
> Sudeep
>>>> ---
>>>>  arch/arm/mach-mvebu/platsmp.c | 52 ++++++++++++++++++++-----------------------
>>>>  1 file changed, 24 insertions(+), 28 deletions(-)
>>>>
>>>> diff --git a/arch/arm/mach-mvebu/platsmp.c b/arch/arm/mach-mvebu/platsmp.c
>>>> index ce81d30..001dd42 100644
>>>> --- a/arch/arm/mach-mvebu/platsmp.c
>>>> +++ b/arch/arm/mach-mvebu/platsmp.c
>>>> @@ -23,51 +23,47 @@
>>>>  #include <linux/of.h>
>>>>  #include <linux/mbus.h>
>>>>  #include <asm/cacheflush.h>
>>>> +#include <asm/prom.h>
>>>>  #include <asm/smp_plat.h>
>>>>  #include "common.h"
>>>>  #include "armada-370-xp.h"
>>>>  #include "pmsu.h"
>>>>  #include "coherency.h"
>>>>  
>>>> +static struct clk *__init get_cpu_clk(int cpu)
>>>> +{
>>>> +	struct clk *cpu_clk;
>>>> +	struct device_node *np = of_get_cpu_node(cpu);
>>>> +
>>>> +	if (WARN(!np, "missing cpu node\n"))
>>>> +		return NULL;
>>>> +	cpu_clk = of_clk_get(np, 0);
>>>> +	if (WARN_ON(IS_ERR(cpu_clk)))
>>>> +		return NULL;
>>>> +	return cpu_clk;
>>>> +}
>>>> +
>>>>  void __init set_secondary_cpus_clock(void)
>>>>  {
>>>> -	int thiscpu;
>>>> +	int thiscpu, cpu;
>>>>  	unsigned long rate;
>>>> -	struct clk *cpu_clk = NULL;
>>>> -	struct device_node *np = NULL;
>>>> +	struct clk *cpu_clk;
>>>>  
>>>>  	thiscpu = smp_processor_id();
>>>> -	for_each_node_by_type(np, "cpu") {
>>>> -		int err;
>>>> -		int cpu;
>>>> -
>>>> -		err = of_property_read_u32(np, "reg", &cpu);
>>>> -		if (WARN_ON(err))
>>>> -			return;
>>>> -
>>>> -		if (cpu == thiscpu) {
>>>> -			cpu_clk = of_clk_get(np, 0);
>>>> -			break;
>>>> -		}
>>>> -	}
>>>> -	if (WARN_ON(IS_ERR(cpu_clk)))
>>>> +	cpu_clk = get_cpu_clk(thiscpu);
>>>> +	if (!cpu_clk)
>>>>  		return;
>>>>  	clk_prepare_enable(cpu_clk);
>>>>  	rate = clk_get_rate(cpu_clk);
>>>>  
>>>>  	/* set all the other CPU clk to the same rate than the boot CPU */
>>>> -	for_each_node_by_type(np, "cpu") {
>>>> -		int err;
>>>> -		int cpu;
>>>> -
>>>> -		err = of_property_read_u32(np, "reg", &cpu);
>>>> -		if (WARN_ON(err))
>>>> +	for_each_possible_cpu(cpu) {
>>>> +		if (cpu == thiscpu)
>>>> +			continue;
>>>> +		cpu_clk = get_cpu_clk(cpu);
>>>> +		if (!cpu_clk)
>>>>  			return;
>>>> -
>>>> -		if (cpu != thiscpu) {
>>>> -			cpu_clk = of_clk_get(np, 0);
>>>> -			clk_set_rate(cpu_clk, rate);
>>>> -		}
>>>> +		clk_set_rate(cpu_clk, rate);
>>>>  	}
>>>>  }
>>>>  
>>>>
>>>
>>>
>>
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
