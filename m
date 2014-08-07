Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbaHGGeD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 02:34:03 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:64353 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbaHGGeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 02:34:01 -0400
Message-ID: <53E31DD0.1000607@gmail.com>
Date: Thu, 07 Aug 2014 14:33:52 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>, hpa@zytor.com
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Toshi Kani <toshi.kani@hp.com>,
        linux-kernel@vger.kernel.org, Zhang Yang <yang.z.zhang@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v4] x86, hotplug: fix llc shared map unreleased during
 cpu hotplug
References: <1406625883-4972-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1406625883-4972-1-git-send-email-wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping

ÓÚ 14-7-29 ÏÂÎç5:24, Wanpeng Li Ð´µÀ:
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
> IP: [..] find_busiest_group
> PGD 5a9d5067 PUD 13067 PMD 0
> Oops: 0000 [#3] SMP
> [...]
> Call Trace:
> load_balance
> ? _raw_spin_unlock_irqrestore
> idle_balance
> __schedule
> schedule
> schedule_timeout
> ? lock_timer_base
> schedule_timeout_uninterruptible
> msleep
> lock_device_hotplug_sysfs
> online_store
> dev_attr_store
> sysfs_write_file
> vfs_write
> SyS_write
> system_call_fastpath
>
> Last level cache shared map is built during cpu up and build sched domain 
> routine takes advantage of it to setup sched domain cpu topology, however, 
> llc shared map is unreleased during cpu disable which lead to invalid sched 
> domain cpu topology. This patch fix it by release llc shared map correctly
> during cpu disable.
>
> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
> v1 -> v2:
>  * fix subject line
> v2 -> v3:
>  * simplify backtrace 
>
>  arch/x86/kernel/smpboot.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 5492798..0134ec7 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1292,6 +1292,9 @@ static void remove_siblinginfo(int cpu)
>  
>  	for_each_cpu(sibling, cpu_sibling_mask(cpu))
>  		cpumask_clear_cpu(cpu, cpu_sibling_mask(sibling));
> +	for_each_cpu(sibling, cpu_llc_shared_mask(cpu))
> +		cpumask_clear_cpu(cpu, cpu_llc_shared_mask(sibling));
> +	cpumask_clear(cpu_llc_shared_mask(cpu));
>  	cpumask_clear(cpu_sibling_mask(cpu));
>  	cpumask_clear(cpu_core_mask(cpu));
>  	c->phys_proc_id = 0;

