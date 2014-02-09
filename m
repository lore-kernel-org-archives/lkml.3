Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbaBIPpd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 10:45:33 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:48039 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaBIPpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 10:45:31 -0500
Date: Sun, 9 Feb 2014 16:45:25 +0100
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Jane Li <jiel@marvell.com>
Cc: tianxf@marvell.com, fswu@marvell.com, Toshi Kani <toshi.kani@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>
Subject: Re: Question about console_lock lockdep after involving
 console_lock_dep_map
Message-ID: <20140209154525.GI17001@phenom.ffwll.local>
Mail-Followup-To: Jane Li <jiel@marvell.com>, tianxf@marvell.com,
	fswu@marvell.com, Toshi Kani <toshi.kani@hp.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>
References: <52F5BFA3.2000306@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F5BFA3.2000306@marvell.com>
X-Originating-IP: [84.73.67.144]
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding many more people and lkml to the cc list. Please don't poke people
in private, but always cc a relevant mailing list.

On Sat, Feb 8, 2014 at 6:24 AM, Jane Li <jiel@marvell.com> wrote:
> Hi Danial Vetter,
>
> I found you had added console_lock_dep_map in commit daee7797 (console:
> implement lockdep support for console_lock). I encounter another circular
> lock warning related to it.
>
> Sequence:
>
>         enter suspend ->  resume ->  plug-out CPUx (echo 0 > cpux/online)
>
> Then, lockdep will show warning as following:
>
> ======================================================
> [ INFO: possible circular locking dependency detected ]
> 3.10.0 #2 Tainted: G           O
> -------------------------------------------------------
> sh/1271 is trying to acquire lock:
>  (console_lock){+.+.+.}, at: [<c06ebf7c>] console_cpu_notify+0x20/0x2c
> but task is already holding lock:
> (cpu_hotplug.lock){+.+.+.}, at: [<c012b4e8>] cpu_hotplug_begin+0x2c/0x58
> which lock already depends on the new lock.
>
> the existing dependency chain (in reverse order) is:
> -> #2 (cpu_hotplug.lock){+.+.+.}:
> [<c017bb7c>] lock_acquire+0x98/0x12c
> [<c06f5014>] mutex_lock_nested+0x50/0x3d8
> [<c012b4e8>] cpu_hotplug_begin+0x2c/0x58
> [<c06ebfac>] _cpu_up+0x24/0x154
> [<c06ec140>] cpu_up+0x64/0x84
> [<c0981834>] smp_init+0x9c/0xd4
> [<c0973880>] kernel_init_freeable+0x78/0x1c8
> [<c06e7f40>] kernel_init+0x8/0xe4
> [<c010eec8>] ret_from_fork+0x14/0x2c
>
> -> #1 (cpu_add_remove_lock){+.+.+.}:
> [<c017bb7c>] lock_acquire+0x98/0x12c
> [<c06f5014>] mutex_lock_nested+0x50/0x3d8
> [<c012b758>] disable_nonboot_cpus+0x8/0xe8
> [<c016b83c>] suspend_devices_and_enter+0x214/0x448
> [<c016bc54>] pm_suspend+0x1e4/0x284
> [<c016bdcc>] try_to_suspend+0xa4/0xbc
> [<c0143848>] process_one_work+0x1c4/0x4fc
> [<c0143f80>] worker_thread+0x138/0x37c
> [<c014aaf8>] kthread+0xa4/0xb0
> [<c010eec8>] ret_from_fork+0x14/0x2c
>
> -> #0 (console_lock){+.+.+.}:
> [<c017b5d0>] __lock_acquire+0x1b38/0x1b80
> [<c017bb7c>] lock_acquire+0x98/0x12c
> [<c01288c4>] console_lock+0x54/0x68
> [<c06ebf7c>] console_cpu_notify+0x20/0x2c
> [<c01501d4>] notifier_call_chain+0x44/0x84
> [<c012b448>] __cpu_notify+0x2c/0x48
> [<c012b5b0>] cpu_notify_nofail+0x8/0x14
> [<c06e81bc>] _cpu_down+0xf4/0x258
> [<c06e8344>] cpu_down+0x24/0x40
> [<c06e921c>] store_online+0x30/0x74
> [<c03b7298>] dev_attr_store+0x18/0x24
> [<c025fc5c>] sysfs_write_file+0x16c/0x19c
> [<c0207a98>] vfs_write+0xb4/0x190
> [<c0207e58>] SyS_write+0x3c/0x70
> [<c010ee00>] ret_fastChain exists of:
>   console_lock --> cpu_add_remove_lock --> cpu_hotplug.lock
>
> Possible unsafe locking scenario:
>       CPU0                    CPU1
>       ----                    ----
> lock(cpu_hotplug.lock);
>                               lock(cpu_add_remove_lock);
>                               lock(cpu_hotplug.lock);
> lock(console_lock);
>  *** DEADLOCK ***
>
>
>
> Analyze this information, there are three locks involved in two sequence:
>
>         pm suspend: console_lock (@suspend_console()) -> cpu_add_remove_lock
> (@disable_nonboot_cpus()) -> cpu_hotplug.lock (@_cpu_down())
>
>         Plug-out CPUx: cpu_add_remove_lock (@(cpu_down()) ->
> cpu_hotplug.lock (@_cpu_down()) -> console_lock (@console_cpu_notify()) =>
> Lockdeps prints warning log.
>
>
> I check code and there should be not real deadlock, as flag of
> console_suspended can protect this.
>
> Do you know how to avoid this warning?

I think the right approach here is to add a new function to do the console
flushing:

/**
 * console_flush - flush dmesg if console isn't suspended
 *
 * console_unlock always flushes the dmesg buffer, so just try to
 * grab&drop the console lock. If that fails we know that the current
 * holder will eventually drop the console lock and so flush the dmesg
 * buffers at the earliest possible time.
 */
void console_flush(void)
{
	if (console_trylock())
		console_unlock();
}

Then use that instead of the unconditional console_lock/unlock pair int
the console_cpu_notitifier. Since that's practically the patch already
feel free to smash a Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
on top if it works.

Cheers, Daniel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
