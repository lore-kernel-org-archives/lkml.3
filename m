Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934447Ab3BMQqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:46:54 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:43357 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760019Ab3BMQqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:46:53 -0500
Date: Wed, 13 Feb 2013 17:46:42 +0100 (CET)
From: John Kacur <jkacur@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@gmail.com>,
        Clark Williams <clark@redhat.com>
Subject: Re: [RFC][PATCH RT] acpi/rt: Convert acpi lock back to a
 raw_spinlock_t
In-Reply-To: <1360765565.23152.5.camel@gandalf.local.home>
Message-ID: <alpine.LFD.2.03.1302131744590.13701@tycho>
References: <1360765565.23152.5.camel@gandalf.local.home>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Feb 2013, Steven Rostedt wrote:

> We hit the following bug with 3.6-rt:
> 
> [    5.898990] BUG: scheduling while atomic: swapper/3/0/0x00000002 
> [    5.898991] no locks held by swapper/3/0. 
> [    5.898993] Modules linked in: 
> [    5.898996] Pid: 0, comm: swapper/3 Not tainted 3.6.11-rt28.19.el6rt.x86_64.debug #1 
> [    5.898997] Call Trace: 
> [    5.899011]  [<ffffffff810804e7>] __schedule_bug+0x67/0x90 
> [    5.899028]  [<ffffffff81577923>] __schedule+0x793/0x7a0 
> [    5.899032]  [<ffffffff810b4e40>] ? debug_rt_mutex_print_deadlock+0x50/0x200 
> [    5.899034]  [<ffffffff81577b89>] schedule+0x29/0x70 
> [    5.899036] BUG: scheduling while atomic: swapper/7/0/0x00000002 
> [    5.899037] no locks held by swapper/7/0. 
> [    5.899039]  [<ffffffff81578525>] rt_spin_lock_slowlock+0xe5/0x2f0 
> [    5.899040] Modules linked in: 
> [    5.899041]  
> [    5.899045]  [<ffffffff81579a58>] ? _raw_spin_unlock_irqrestore+0x38/0x90 
> [    5.899046] Pid: 0, comm: swapper/7 Not tainted 3.6.11-rt28.19.el6rt.x86_64.debug #1 
> [    5.899047] Call Trace: 
> [    5.899049]  [<ffffffff81578bc6>] rt_spin_lock+0x16/0x40 
> [    5.899052]  [<ffffffff810804e7>] __schedule_bug+0x67/0x90 
> [    5.899054]  [<ffffffff8157d3f0>] ? notifier_call_chain+0x80/0x80 
> [    5.899056]  [<ffffffff81577923>] __schedule+0x793/0x7a0 
> [    5.899059]  [<ffffffff812f2034>] acpi_os_acquire_lock+0x1f/0x23 
> [    5.899062]  [<ffffffff810b4e40>] ? debug_rt_mutex_print_deadlock+0x50/0x200 
> [    5.899068]  [<ffffffff8130be64>] acpi_write_bit_register+0x33/0xb0 
> [    5.899071]  [<ffffffff81577b89>] schedule+0x29/0x70 
> [    5.899072]  [<ffffffff8130be13>] ? acpi_read_bit_register+0x33/0x51 
> [    5.899074]  [<ffffffff81578525>] rt_spin_lock_slowlock+0xe5/0x2f0 
> [    5.899077]  [<ffffffff8131d1fc>] acpi_idle_enter_bm+0x8a/0x28e 
> [    5.899079]  [<ffffffff81579a58>] ? _raw_spin_unlock_irqrestore+0x38/0x90 
> [    5.899081]  [<ffffffff8107e5da>] ? this_cpu_load+0x1a/0x30 
> [    5.899083]  [<ffffffff81578bc6>] rt_spin_lock+0x16/0x40 
> [    5.899087]  [<ffffffff8144c759>] cpuidle_enter+0x19/0x20 
> [    5.899088]  [<ffffffff8157d3f0>] ? notifier_call_chain+0x80/0x80 
> [    5.899090]  [<ffffffff8144c777>] cpuidle_enter_state+0x17/0x50 
> [    5.899092]  [<ffffffff812f2034>] acpi_os_acquire_lock+0x1f/0x23 
> [    5.899094]  [<ffffffff8144d1a1>] cpuidle899101]  [<ffffffff8130be13>] ? 
> 
> As the acpi code disables interrupts in acpi_idle_enter_bm, and calls
> code that grabs the acpi lock, it causes issues as the lock is currently
> in RT a sleeping lock.
> 
> The lock was converted from a raw to a sleeping lock due to some
> previous issues, and tests that showed it didn't seem to matter.
> Unfortunately, it did matter for one of our boxes.
> 
> This patch converts the lock back to a raw lock. I've run this code on a
> few of my own machines, one being my laptop that uses the acpi quite
> extensively. I've been able to suspend and resume without issues.
> 
> But as it may have issues still with other hardware, I'm posting this as
> an RFC.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 9eaf708..83d38ed 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -1432,7 +1432,7 @@ void acpi_os_delete_lock(acpi_spinlock handle)
>  acpi_cpu_flags acpi_os_acquire_lock(acpi_spinlock lockp)
>  {
>  	acpi_cpu_flags flags;
> -	spin_lock_irqsave(lockp, flags);
> +	raw_spin_lock_irqsave(lockp, flags);
>  	return flags;
>  }
>  
> @@ -1442,7 +1442,7 @@ acpi_cpu_flags acpi_os_acquire_lock(acpi_spinlock lockp)
>  
>  void acpi_os_release_lock(acpi_spinlock lockp, acpi_cpu_flags flags)
>  {
> -	spin_unlock_irqrestore(lockp, flags);
> +	raw_spin_unlock_irqrestore(lockp, flags);
>  }
>  
>  #ifndef ACPI_USE_LOCAL_CACHE
> diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
> index 7509be3..484cf8c 100644
> --- a/include/acpi/platform/aclinux.h
> +++ b/include/acpi/platform/aclinux.h
> @@ -71,7 +71,7 @@
>  #define strtoul                     simple_strtoul
>  
>  #define acpi_cache_t                        struct kmem_cache
> -#define acpi_spinlock                       spinlock_t *
> +#define acpi_spinlock                       raw_spinlock_t *
>  #define acpi_cpu_flags                      unsigned long
>  
>  #else /* !__KERNEL__ */
> @@ -170,7 +170,7 @@ static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
>  								\
>  	if (lock) {						\
>  		*(__handle) = lock;				\
> -		spin_lock_init(*(__handle));			\
> +		raw_spin_lock_init(*(__handle));		\
>  	}							\
>  	lock ? AE_OK : AE_NO_MEMORY;				\
>  })
> 
> 

Thanks Steven. That looks way better than the previous revert.
Applying to the latest RH testing queue, will let you know.

John
