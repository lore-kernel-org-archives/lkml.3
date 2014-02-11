Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaBKS3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:29:33 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:53431 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaBKS33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:29:29 -0500
MIME-Version: 1.0
In-Reply-To: <1392101400-14550-1-git-send-email-jiel@marvell.com>
References: <1392101400-14550-1-git-send-email-jiel@marvell.com>
Date: Tue, 11 Feb 2014 10:29:28 -0800
X-Google-Sender-Auth: FWuM9S0WSjUi6IxUxauBAmuvQ_8
Message-ID: <CAGXu5jK22UDiz=U7yKPcJTv5FH8NU3oYBqy-t_6xUUipVqXUcQ@mail.gmail.com>
Subject: Re: [PATCH] printk: fix one circular lockdep warning about console_lock
From: Kees Cook <keescook@chromium.org>
To: jiel@marvell.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Tejun Heo <tj@kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 10:50 PM,  <jiel@marvell.com> wrote:
> From: Jane Li <jiel@marvell.com>
>
> This patch tries to fix a warning about possible circular locking
> dependency.
>
> If do in following sequence:
>     enter suspend ->  resume ->  plug-out CPUx (echo 0 > cpux/online)
> lockdep will show warning as following:
>
> ======================================================
> [ INFO: possible circular locking dependency detected ]
> 3.10.0 #2 Tainted: G           O
> -------------------------------------------------------
> sh/1271 is trying to acquire lock:
> (console_lock){+.+.+.}, at: [<c06ebf7c>] console_cpu_notify+0x20/0x2c
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
> [<c010ee00>] ret_fast_syscall+0x0/0x48
>
> Chain exists of:
>    console_lock --> cpu_add_remove_lock --> cpu_hotplug.lock
>
> Possible unsafe locking scenario:
>        CPU0                    CPU1
>        ----                    ----
> lock(cpu_hotplug.lock);
>                                lock(cpu_add_remove_lock);
>                                lock(cpu_hotplug.lock);
> lock(console_lock);
>   *** DEADLOCK ***
>
> There are three locks involved in two sequence:
> a) pm suspend:
>         console_lock (@suspend_console())
>         cpu_add_remove_lock (@disable_nonboot_cpus())
>         cpu_hotplug.lock (@_cpu_down())
> b) Plug-out CPUx:
>         cpu_add_remove_lock (@(cpu_down())
>         cpu_hotplug.lock (@_cpu_down())
>         console_lock (@console_cpu_notify()) => Lockdeps prints warning log.
>
> There should be not real deadlock, as flag of console_suspended can
> protect this.
>
> Printk registers cpu hotplug notify function. When CPUx is plug-out/in,
> always execute console_lock() and console_unlock(). This patch
> modifies that with console_trylock() and console_unlock(). Then use
> that instead of the unconditional console_lock/unlock pair to avoid the
> warning.
>
> Signed-off-by: Jane Li <jiel@marvell.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
>  kernel/printk/printk.c |   17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index b1d255f..e7a0525 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -1893,6 +1893,20 @@ void resume_console(void)
>  }
>
>  /**
> + * console_flush - flush dmesg if console isn't suspended
> + *
> + * console_unlock always flushes the dmesg buffer, so just try to
> + * grab&drop the console lock. If that fails we know that the current
> + * holder will eventually drop the console lock and so flush the dmesg
> + * buffers at the earliest possible time.
> + */
> +void console_flush(void)
> +{
> +       if (console_trylock())
> +               console_unlock();
> +}
> +
> +/**
>   * console_cpu_notify - print deferred console messages after CPU hotplug
>   * @self: notifier struct
>   * @action: CPU hotplug event
> @@ -1911,8 +1925,7 @@ static int console_cpu_notify(struct notifier_block *self,
>         case CPU_DEAD:
>         case CPU_DOWN_FAILED:
>         case CPU_UP_CANCELED:
> -               console_lock();
> -               console_unlock();
> +               console_flush();
>         }
>         return NOTIFY_OK;
>  }
> --
> 1.7.9.5
>

Seems reasonable to me.

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
