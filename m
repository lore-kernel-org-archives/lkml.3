Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab3DMREc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 13:04:32 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:56200 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab3DMREb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 13:04:31 -0400
Message-ID: <51698F4D.2000604@linux.vnet.ibm.com>
Date: Sat, 13 Apr 2013 22:31:01 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>, Shawn Guo <shawn.guo@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Michel Lespinasse <walken@google.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>,
        Fenghua Yu <fenghua.yu@intel.com>, lkml@rtr.ca
Subject: Re: Bulk CPU Hotplug (Was Re: [PATCH] Do not force shutdown/reboot
 to boot cpu.)
References: <20130408155701.GB19974@gmail.com> <5162EC1A.4050204@zytor.com> <20130408165916.GA3672@sgi.com> <20130410111620.GB29752@gmail.com> <CA+55aFw8bRwMRm8cWtTGRvd1AEP-LR7pYL-pEoBkHqJUuJrjSg@mail.gmail.com> <20130411053106.GA9042@drongo> <5166B05E.8010904@linux.vnet.ibm.com> <20130411134837.GE3672@sgi.com> <20130412053718.GC3887@gmail.com> <5167A52F.6020503@linux.vnet.ibm.com> <20130412093149.GT3658@sgi.com>
In-Reply-To: <20130412093149.GT3658@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 13041316-0260-0000-0000-000002CD9658
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 03:01 PM, Robin Holt wrote:
>  kernel/sys.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 0da73cf..4d1047d 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -357,6 +357,19 @@ int unregister_reboot_notifier(struct notifier_block *nb)
>  }
>  EXPORT_SYMBOL(unregister_reboot_notifier);
> 
> +void migrate_to_boot_cpu(void)
> +{
> +	/* The boot cpu is always logical cpu 0 */
> +	int reboot_cpu_id = 0;
> +
> +	/* Make certain the cpu I'm about to reboot on is online */
> +	if (!cpu_online(reboot_cpu_id))
> +		reboot_cpu_id = smp_processor_id();
> +

If CPU 0 is offline, there is no point in binding, right?

[Fenghua (in CC) added the support to offline CPU0 on x86 Intel platforms.
So its possible that CPU0 is offline when you try a reboot.]

> +	/* Make certain I only run on the appropriate processor */
> +	set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu_id));
> +}
> +
>  /**
>   *	kernel_restart - reboot the system
>   *	@cmd: pointer to buffer containing command to execute for restart
> @@ -368,7 +381,7 @@ EXPORT_SYMBOL(unregister_reboot_notifier);
>  void kernel_restart(char *cmd)
>  {
>  	kernel_restart_prepare(cmd);
> -	disable_nonboot_cpus();
> +	migrate_to_boot_cpu();
>  	syscore_shutdown();
>  	if (!cmd)
>  		printk(KERN_EMERG "Restarting system.\n");
> @@ -414,7 +427,7 @@ void kernel_power_off(void)
>  	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
>  	if (pm_power_off_prepare)
>  		pm_power_off_prepare();
> -	disable_nonboot_cpus();
> +	migrate_to_boot_cpu();

Okay, so you are touching poweroff also. Restart was only recently altered
by Shawn, so we can assume that his fix was necessary only to his platform.
However, for poweroff, I see the commit below in the git log, which added
the disable_nonboot_cpus() call.

commit 4047727e5ae33f9b8d2b7766d1994ea6e5ec2991
Author: Mark Lord <lkml@rtr.ca>
Date:   Mon Oct 1 01:20:10 2007 -0700

    Fix SMP poweroff hangs

Its an old commit, so perhaps the issue no longer holds good, but I thought
I should bring this to notice, just in case.

>  	syscore_shutdown();
>  	printk(KERN_EMERG "Power down.\n");
>  	kmsg_dump(KMSG_DUMP_POWEROFF);
> 

Regards,
Srivatsa S. Bhat

