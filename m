Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab3A3VwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 16:52:25 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59421 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab3A3VwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 16:52:23 -0500
Date: Wed, 30 Jan 2013 21:52:11 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: BUG: circular locking dependency detected
Message-ID: <20130130215211.GA28418@flint.arm.linux.org.uk>
References: <20130130200648.GA13298@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130130200648.GA13298@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also adding Greg and Daniel to this as Daniel introduced the lockdep
checking.

This looks extremely horrid to be to solve - the paths are rather deep
where the dependency occurs.  The two paths between the locks are:

console_lock+0x5c/0x70
register_con_driver+0x44/0x150
take_over_console+0x24/0x3b4
fbcon_takeover+0x70/0xd4
fbcon_event_notify+0x7c8/0x818
notifier_call_chain+0x4c/0x8c
__blocking_notifier_call_chain+0x50/0x68
blocking_notifier_call_chain+0x20/0x28

and

__blocking_notifier_call_chain+0x34/0x68
blocking_notifier_call_chain+0x20/0x28
fb_notifier_call_chain+0x20/0x28
fb_blank+0x40/0xac
fbcon_blank+0x1f4/0x29c
do_blank_screen+0x1b8/0x270
console_callback+0x74/0x138

On Wed, Jan 30, 2013 at 08:06:48PM +0000, Russell King wrote:
> This looks like a bug in the framebuffer/console layers.  Looks like
> we have one path where we call the notifier list, and a called
> function takes the console lock, and another path where we hold the
> console lock while calling the notifier list.
> 
> ======================================================
> [ INFO: possible circular locking dependency detected ]
> 3.8.0-rc4+ #656 Not tainted
> -------------------------------------------------------
> kworker/0:1/442 is trying to acquire lock:
>  ((fb_notifier_list).rwsem){.+.+.+}, at: [<c004ea48>] __blocking_notifier_call_chain+0x34/0x68
> 
> but task is already holding lock:
>  (console_lock){+.+.+.}, at: [<c01c2b48>] console_callback+0x14/0x138
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (console_lock){+.+.+.}:
>        [<c006f36c>] __lock_acquire+0x1d20/0x1e80
>        [<c006fa04>] lock_acquire+0x68/0x7c
>        [<c002a894>] console_lock+0x5c/0x70
>        [<c01c0adc>] register_con_driver+0x44/0x150
>        [<c01c1158>] take_over_console+0x24/0x3b4
>        [<c019d778>] fbcon_takeover+0x70/0xd4
>        [<c01a3108>] fbcon_event_notify+0x7c8/0x818
>        [<c004e538>] notifier_call_chain+0x4c/0x8c
>        [<c004ea64>] __blocking_notifier_call_chain+0x50/0x68
>        [<c004ea9c>] blocking_notifier_call_chain+0x20/0x28
>        [<c0196e70>] fb_notifier_call_chain+0x20/0x28
>        [<c0198194>] register_framebuffer+0x18c/0x238
>        [<c01a6148>] clcdfb_probe+0x2b0/0x3c0
>        [<c01a6da4>] amba_probe+0x88/0xa0
>        [<c01d1730>] driver_probe_device+0x84/0x218
>        [<c01d1960>] __driver_attach+0x9c/0xa0
>        [<c01cfe5c>] bus_for_each_dev+0x5c/0x88
>        [<c01d1398>] driver_attach+0x20/0x28
>        [<c01d0ddc>] bus_add_driver+0xa4/0x244
>        [<c01d1ed4>] driver_register+0x80/0x14c
>        [<c01a6848>] amba_driver_register+0x48/0x5c
>        [<c043aae0>] amba_clcdfb_init+0x28/0x3c
>        [<c000868c>] do_one_initcall+0x44/0x1ac
>        [<c0425928>] kernel_init_freeable+0x104/0x1c8
>        [<c03242ec>] kernel_init+0x10/0xec
>        [<c0014510>] ret_from_fork+0x14/0x24
> 
> -> #0 ((fb_notifier_list).rwsem){.+.+.+}:
>        [<c006bc44>] print_circular_bug+0x84/0x2f0
>        [<c006f458>] __lock_acquire+0x1e0c/0x1e80
>        [<c006fa04>] lock_acquire+0x68/0x7c
>        [<c032b3a0>] down_read+0x34/0x44
>        [<c004ea48>] __blocking_notifier_call_chain+0x34/0x68
>        [<c004ea9c>] blocking_notifier_call_chain+0x20/0x28
>        [<c0196e70>] fb_notifier_call_chain+0x20/0x28
>        [<c0197690>] fb_blank+0x40/0xac
>        [<c019f874>] fbcon_blank+0x1f4/0x29c
>        [<c01c09e0>] do_blank_screen+0x1b8/0x270
>        [<c01c2ba8>] console_callback+0x74/0x138
>        [<c00408c8>] process_one_work+0x1b4/0x4ec
>        [<c0043610>] worker_thread+0x17c/0x4bc
>        [<c004891c>] kthread+0xb0/0xbc
>        [<c0014510>] ret_from_fork+0x14/0x24
> 
> other info that might help us debug this:
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(console_lock);
>                                lock((fb_notifier_list).rwsem);
>                                lock(console_lock);
>   lock((fb_notifier_list).rwsem);
> 
>  *** DEADLOCK ***
> 
> 3 locks held by kworker/0:1/442:
>  #0:  (events){.+.+..}, at: [<c0040854>] process_one_work+0x140/0x4ec
>  #1:  (console_work){+.+...}, at: [<c0040854>] process_one_work+0x140/0x4ec
>  #2:  (console_lock){+.+.+.}, at: [<c01c2b48>] console_callback+0x14/0x138
> 
> stack backtrace:
> Backtrace:
> [<c00185d8>] (dump_backtrace+0x0/0x10c) from [<c03294c8>] (dump_stack+0x18/0x1c)
>  r6:c05323f0 r5:c0524800 r4:c05323f0 r3:cf8f6b80
> [<c03294b0>] (dump_stack+0x0/0x1c) from [<c006bda4>] (print_circular_bug+0x1e4/0x2f0)
> [<c006bbc0>] (print_circular_bug+0x0/0x2f0) from [<c006f458>] (__lock_acquire+0x1e0c/0x1e80)
> [<c006d64c>] (__lock_acquire+0x0/0x1e80) from [<c006fa04>] (lock_acquire+0x68/0x7c)
> [<c006f99c>] (lock_acquire+0x0/0x7c) from [<c032b3a0>] (down_read+0x34/0x44)
>  r7:00000010 r6:cfb7dd20 r5:00000002 r4:c04715cc
> [<c032b36c>] (down_read+0x0/0x44) from [<c004ea48>] (__blocking_notifier_call_chain+0x34/0x68)
>  r5:ffffffff r4:c04715cc
> [<c004ea14>] (__blocking_notifier_call_chain+0x0/0x68) from [<c004ea9c>] (blocking_notifier_call_chain+0x20/0x28)
>  r7:cf0ffc00 r6:00000001 r5:cfb7dd20 r4:cfb5f800
> [<c004ea7c>] (blocking_notifier_call_chain+0x0/0x28) from [<c0196e70>] (fb_notifier_call_chain+0x20/0x28)
> [<c0196e50>] (fb_notifier_call_chain+0x0/0x28) from [<c0197690>] (fb_blank+0x40/0xac)
> [<c0197650>] (fb_blank+0x0/0xac) from [<c019f874>] (fbcon_blank+0x1f4/0x29c)
>  r6:00000001 r5:cf80a000 r4:cfb5f800
> [<c019f680>] (fbcon_blank+0x0/0x29c) from [<c01c09e0>] (do_blank_screen+0x1b8/0x270)
> [<c01c0828>] (do_blank_screen+0x0/0x270) from [<c01c2ba8>] (console_callback+0x74/0x138)
>  r7:c0ba8640 r6:c0bac300 r5:c099a51c r4:c099a51c
> [<c01c2b34>] (console_callback+0x0/0x138) from [<c00408c8>] (process_one_work+0x1b4/0x4ec)
>  r6:c0bac300 r5:cf9489c0 r4:c0472e3c r3:c01c2b34
> [<c0040714>] (process_one_work+0x0/0x4ec) from [<c0043610>] (worker_thread+0x17c/0x4bc)
> [<c0043494>] (worker_thread+0x0/0x4bc) from [<c004891c>] (kthread+0xb0/0xbc)
> [<c004886c>] (kthread+0x0/0xbc) from [<c0014510>] (ret_from_fork+0x14/0x24)
>  r8:00000000 r7:00000000 r6:00000000 r5:c004886c r4:cf84dde8
> 
> -- 
> Russell King
>  Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
>  maintainer of:

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
