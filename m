Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbaIAKCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 06:02:19 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:39759 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbaIAKCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 06:02:18 -0400
Message-ID: <540443DA.7030502@huawei.com>
Date: Mon, 1 Sep 2014 18:00:58 +0800
From: "long.wanglong" <long.wanglong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Wang Long <long.wanglong@huawei.com>, <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <santosh.shilimkar@ti.com>,
        <victor.kamensky@linaro.org>, <nico@linaro.org>,
        <ben.dooks@codethink.co.uk>, <cov@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [SMP BUG?] the return value of is_smp() is bug?
References: <1409550563-92081-1-git-send-email-long.wanglong@huawei.com>
In-Reply-To: <1409550563-92081-1-git-send-email-long.wanglong@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.88.174]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.540443EE.0060,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 0e34727ccfe9845b9ebc6300ba5ca814
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/1 13:49, Wang Long wrote:
> 
> Hi,all
> 
> In kernel 3.17-rc2, when i set CONFIG_HAVE_SMP = y and CONFIG_SMP_ON_UP = y 
> in .config file. the secondary core can not boot.
> 
> when i set CONFIG_HAVE_SMP = y and CONFIG_SMP_ON_UP = n in .config file,
> the secondary core can boot.
> 
> But this does not happen in kernel 3.10 lts kernel, Whether the 
> CONFIG_SMP_ON_UP is set yes or no ,the secondary core can boot.
> 
> Does the meaning of CONFIG_SMP_ON_UP changed or this is a bug in kernel 3.17-rc2 ? 
> 
> 

hi Arnd

In above two cases, i also set  CONFIG_SMP = y. in addtion,
the CONFIG_SMP_ON_UP depends on CONFIG_SMP. when set
CONFIG_SMP_ON_UP = y, the value of CONFIG_SMP must be y.



> I write the following patch to test the return value of is_smp().
> 
> ----------------------------------------
> 
> Signed-off-by: Wang Long <long.wanglong@huawei.com>
> ---
>  arch/arm/kernel/setup.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index 84db893d..fbeb67f 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -925,6 +925,11 @@ void __init setup_arch(char **cmdline_p)
>  	arm_dt_init_cpu_maps();
>  	psci_init();
>  #ifdef CONFIG_SMP
> +	
> +	if (is_smp() == 1)
> +		printk("is_smp() return true;\n");
> +	else if (is_smp() == 0)
> +		printk("is_smp() return false;\n");
>  	if (is_smp()) {
>  		if (!mdesc->smp_init || !mdesc->smp_init()) {
>  			if (psci_smp_available())
> 
> kernel version: 3.17-rc2
> 
> config:     set CONFIG_HAVE_SMP = y and CONFIG_SMP_ON_UP = y
> command:    # qemu-system-arm -M vexpress-a9 -smp 2  -m 128M -kernel arch/arm/boot/zImage -nographic
> The output:
> 
> ..........
> is_smp() return false;
> CPU: Testing write buffer coherency: ok
> missing device node for CPU 0
> CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
> Setting up static identity map for 0x604643d8 - 0x60464430
> Brought up 1 CPUs
> SMP: Total of 1 processors activated.
> CPU: All CPU(s) started in SVC mode.
> ...........
> 
> config:     set CONFIG_HAVE_SMP = y and not set CONFIG_SMP_ON_UP 
> command:    # qemu-system-arm -M vexpress-a9 -smp 2  -m 128M -kernel arch/arm/boot/zImage -nographic
> The output:
> 
> .....
>  Memory policy: Data cache writealloc
> is_smp() return true;
> sched_clock: 32 bits at 24MHz, resolution 41ns, wraps every 178956969942ns
> ......
> ......
> CPU: Testing write buffer coherency: ok
> missing device node for CPU 0
> missing device node for CPU 1
> CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
> Setting up static identity map for 0x60463ef8 - 0x60463f50
> CPU1: Booted secondary processor
> CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
> Brought up 2 CPUs
> SMP: Total of 2 processors activated.
> CPU: All CPU(s) started in SVC mode.
> devtmpfs: initialized
> .......
> 
> Any ideas?
> 
> 


