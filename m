Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaIUXMO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 19:12:14 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35078 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaIUXMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 19:12:13 -0400
Message-ID: <541F5B39.4070400@gmail.com>
Date: Mon, 22 Sep 2014 07:11:53 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>, Toshi Kani <toshi.kani@hp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] x86, cpu-hotplug: fix llc shared map unreleased during
 cpu hotplug
References: <1410938272-7217-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1410938272-7217-1-git-send-email-wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping Ingo, Peter Z, HPA,

ÓÚ 14-9-17 ÏÂÎç3:17, Wanpeng Li Ð´µÀ:
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
> This bug can be triggered by hot add and remove large number of xen
> domain0's vcpus repeatedly.
>
> Last level cache shared map is built during cpu up and build sched domain 
> routine takes advantage of it to setup sched domain cpu topology, however, 
> llc shared map is unreleased during cpu disable which lead to invalid sched 
> domain cpu topology. This patch fix it by release llc shared map correctly
> during cpu disable.
>
> Reviewed-by: Toshi Kani <toshi.kani@hp.com>
> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Tested-by: Linn Crosetto <linn@hp.com>
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> ---
> v4 -> v5:
>  * add the description when the bug can occur
> v3 -> v4:
>  * simplify backtrace
> v2 -> v3:
>  * simplify backtrace 
> v1 -> v2:
>  * fix subject line
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

