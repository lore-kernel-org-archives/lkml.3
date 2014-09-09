Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbaIIHWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 03:22:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:64976 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755951AbaIIHWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 03:22:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,491,1406617200"; 
   d="scan'208";a="588396290"
Date: Tue, 9 Sep 2014 15:24:05 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Toshi Kani <toshi.kani@hp.com>,
        Zhang Yang <yang.z.zhang@intel.com>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: Re: [PATCH RESEND v4] sched: fix llc shared map unreleased during
 cpu hotplug
Message-ID: <20140909072405.GA20678@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1408945776-92404-1-git-send-email-wanpeng.li@linux.intel.com>
 <1410246392.5088.18.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410246392.5088.18.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,
On Tue, Sep 09, 2014 at 09:06:32AM +0200, Mike Galbraith wrote:
>Hm, this patchlet seems to be having trouble taking wing.
>
>(tosses it up in the air.. flap yer little wings patchlet)
>
>I thought you had changed the title to..
>
>x86,cpu-hotplug: clear llc_shared_mask at CPU hotplug
>
>..due to Peter saying sched is only a consumer, but v4 somehow reverted
>back to being a sched patch.
>

I send out the RESEND v4 by a mistake, please refer the below link for the patch.
https://lkml.org/lkml/2014/7/29/159

Regards,
Wanpeng Li 

>On Mon, 2014-08-25 at 13:49 +0800, Wanpeng Li wrote: 
>> [  220.262245] Call Trace:
>> [  220.262252]  [<ffffffff810e8396>] load_balance+0x156/0x980
>> [  220.262259]  [<ffffffff816eeffe>] ? _raw_spin_unlock_irqrestore+0x2e/0xa0
>> [  220.262266]  [<ffffffff810e9aa3>] idle_balance+0xe3/0x150
>> [  220.262270]  [<ffffffff816ec4e7>] __schedule+0x797/0x8d0
>> [  220.262277]  [<ffffffff816ec934>] schedule+0x24/0x70
>> [  220.262283]  [<ffffffff816e9cd9>] schedule_timeout+0x119/0x1f0
>> [  220.262294]  [<ffffffff810bb6e0>] ? lock_timer_base+0x70/0x70
>> [  220.262301]  [<ffffffff816e9dc9>] schedule_timeout_uninterruptible+0x19/0x20
>> [  220.262308]  [<ffffffff810bd3e8>] msleep+0x18/0x20
>> [  220.262317]  [<ffffffff813aa11a>] lock_device_hotplug_sysfs+0x2a/0x50
>> [  220.262323]  [<ffffffff813aa16e>] online_store+0x2e/0x80
>> [  220.262358]  [<ffffffff813a873b>] dev_attr_store+0x1b/0x20
>> 
>> Last level cache shared map is built during cpu up and build sched domain 
>> routine takes advantage of it to setup sched domain cpu topology, however, 
>> llc shared map is unreleased during cpu disable which lead to invalid sched 
>> domain cpu topology. This patch fix it by release llc shared map correctly
>> during cpu disable.
>> 
>> Reviewed-by: Toshi Kani <toshi.kani@hp.com>
>> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> Tested-by: Linn Crosetto <linn@hp.com>
>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>> ---
>> v3 -> v4:
>>  * simplify backtrace
>> v2 -> v3:
>>  * simplify backtrace 
>> v1 -> v2:
>>  * fix subject line
>> 
>>  arch/x86/kernel/smpboot.c | 3 +++
>>  1 file changed, 3 insertions(+)
>> 
>> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
>> index 5492798..0134ec7 100644
>> --- a/arch/x86/kernel/smpboot.c
>> +++ b/arch/x86/kernel/smpboot.c
>> @@ -1292,6 +1292,9 @@ static void remove_siblinginfo(int cpu)
>>  
>>  	for_each_cpu(sibling, cpu_sibling_mask(cpu))
>>  		cpumask_clear_cpu(cpu, cpu_sibling_mask(sibling));
>> +	for_each_cpu(sibling, cpu_llc_shared_mask(cpu))
>> +		cpumask_clear_cpu(cpu, cpu_llc_shared_mask(sibling));
>> +	cpumask_clear(cpu_llc_shared_mask(cpu));
>>  	cpumask_clear(cpu_sibling_mask(cpu));
>>  	cpumask_clear(cpu_core_mask(cpu));
>>  	c->phys_proc_id = 0;
>
