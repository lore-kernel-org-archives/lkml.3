Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaBNGrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 01:47:18 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:60343 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaBNGrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 01:47:17 -0500
Message-ID: <52FDBBE8.2040709@linux.vnet.ibm.com>
Date: Fri, 14 Feb 2014 12:17:04 +0530
From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, paulus@samba.org,
        oleg@redhat.com, rusty@rustcorp.com.au, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org
CC: mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Olof Johansson <olof@lixom.net>,
        Wang Dongsheng <dongsheng.wang@freescale.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 13/51] powerpc, sysfs: Fix CPU hotplug callback registration
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205220654.19080.11341.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140205220654.19080.11341.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021406-5816-0000-0000-00000C450E9D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 February 2014 03:36 AM, Srivatsa S. Bhat wrote:
> Subsystems that want to register CPU hotplug callbacks, as well as perform
> initialization for the CPUs that are already online, often do it as shown
> below:
> 
> 	get_online_cpus();
> 
> 	for_each_online_cpu(cpu)
> 		init_cpu(cpu);
> 
> 	register_cpu_notifier(&foobar_cpu_notifier);
> 
> 	put_online_cpus();
> 
> This is wrong, since it is prone to ABBA deadlocks involving the
> cpu_add_remove_lock and the cpu_hotplug.lock (when running concurrently
> with CPU hotplug operations).
> 
> Instead, the correct and race-free way of performing the callback
> registration is:
> 
> 	cpu_maps_update_begin();
> 
> 	for_each_online_cpu(cpu)
> 		init_cpu(cpu);
> 
> 	/* Note the use of the double underscored version of the API */
> 	__register_cpu_notifier(&foobar_cpu_notifier);
> 
> 	cpu_maps_update_done();
> 
> 
> Fix the sysfs code in powerpc by using this latter form of callback
> registration.

Acked-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>

> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Wang Dongsheng <dongsheng.wang@freescale.com>
> Cc: linuxppc-dev@lists.ozlabs.org
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 
>  arch/powerpc/kernel/sysfs.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kernel/sysfs.c b/arch/powerpc/kernel/sysfs.c
> index 97e1dc9..c29ad44 100644
> --- a/arch/powerpc/kernel/sysfs.c
> +++ b/arch/powerpc/kernel/sysfs.c
> @@ -975,7 +975,8 @@ static int __init topology_init(void)
>  	int cpu;
> 
>  	register_nodes();
> -	register_cpu_notifier(&sysfs_cpu_nb);
> +
> +	cpu_maps_update_begin();
> 
>  	for_each_possible_cpu(cpu) {
>  		struct cpu *c = &per_cpu(cpu_devices, cpu);
> @@ -999,6 +1000,11 @@ static int __init topology_init(void)
>  		if (cpu_online(cpu))
>  			register_cpu_online(cpu);
>  	}
> +
> +	__register_cpu_notifier(&sysfs_cpu_nb);
> +
> +	cpu_maps_update_done();
> +
>  #ifdef CONFIG_PPC64
>  	sysfs_create_dscr_default();
>  #endif /* CONFIG_PPC64 */
> 

