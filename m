Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaLESFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 13:05:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaLESFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 13:05:40 -0500
Date: Fri, 5 Dec 2014 10:05:39 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anand Moon <moon.linux@yahoo.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernfs_fop_write: Use GFP_ATOMIC instead of GFP_KERNEL.
Message-ID: <20141205180539.GA11528@kroah.com>
References: <1417793827-5697-1-git-send-email-moon.linux@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417793827-5697-1-git-send-email-moon.linux@yahoo.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 09:07:07PM +0530, Anand Moon wrote:
> Use GFP_ATOMIC instead of GFP_KERNEL and update for kzalloc
> while we're here to fix this bug.
> 
> [   32.979662] ------------[ cut here ]------------
> [   32.982865] WARNING: CPU: 3 PID: 1933 at kernel/locking/lockdep.c:2744 lockdep_trace_alloc+0xc0/0xfc()
> [   32.983409] _cpu_up: attempt to bring up CPU 6 failed
> [   32.997141] DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))
> [   33.002511] Modules linked in:
> [   33.005697] CPU: 3 PID: 1933 Comm: systemd-udevd Not tainted 3.17.4-arm7 #11
> [   33.012783] [<c0013dc8>] (unwind_backtrace) from [<c0011210>] (show_stack+0x10/0x14)
> [   33.020492] [<c0011210>] (show_stack) from [<c05df5f0>] (dump_stack+0x80/0xac)
> [   33.027679] [<c05df5f0>] (dump_stack) from [<c0024594>] (warn_slowpath_common+0x60/0x84)
> [   33.035715] [<c0024594>] (warn_slowpath_common) from [<c00245e4>] (warn_slowpath_fmt+0x2c/0x3c)
> [   33.044408] [<c00245e4>] (warn_slowpath_fmt) from [<c006ca54>] (lockdep_trace_alloc+0xc0/0xfc)
> [   33.052983] [<c006ca54>] (lockdep_trace_alloc) from [<c01018d0>] (__kmalloc+0x50/0x1c0)
> [   33.060982] [<c01018d0>] (__kmalloc) from [<c016ca28>] (kernfs_fop_write+0x44/0x154)
> [   33.068674] [<c016ca28>] (kernfs_fop_write) from [<c01114fc>] (vfs_write+0xb8/0x170)
> [   33.076396] [<c01114fc>] (vfs_write) from [<c0111a38>] (SyS_write+0x40/0x80)
> [   33.083392] [<c0111a38>] (SyS_write) from [<c000dce0>] (ret_fast_syscall+0x0/0x48)
> [   33.090904] ---[ end trace 48da1fd0929e78f5 ]---
> [   33.095503] BUG: sleeping function called from invalid context at mm/slub.c:1250
> [   33.102878] in_atomic(): 0, irqs_disabled(): 128, pid: 1933, name: systemd-udevd
> [   33.110235] INFO: lockdep is turned off.
> [   33.114122] irq event stamp: 76128
> [   33.117484] hardirqs last  enabled at (76127): [<c05e5808>] _raw_spin_unlock_irq+0x24/0x44
> [   33.125723] hardirqs last disabled at (76128): [<c0010b20>] do_work_pending+0x6c/0xc4
> [   33.133532] softirqs last  enabled at (75542): [<c00283b0>] __do_softirq+0x1e8/0x270
> [   33.141244] softirqs last disabled at (75529): [<c00286f4>] irq_exit+0x84/0xf4
> [   33.148431] CPU: 3 PID: 1933 Comm: systemd-udevd Tainted: G        W      3.17.4-arm7 #11
> [   33.156626] [<c0013dc8>] (unwind_backtrace) from [<c0011210>] (show_stack+0x10/0x14)
> [   33.164334] [<c0011210>] (show_stack) from [<c05df5f0>] (dump_stack+0x80/0xac)
> [   33.171523] [<c05df5f0>] (dump_stack) from [<c01018e8>] (__kmalloc+0x68/0x1c0)
> [   33.178719] [<c01018e8>] (__kmalloc) from [<c016ca28>] (kernfs_fop_write+0x44/0x154)
> [   33.186432] [<c016ca28>] (kernfs_fop_write) from [<c01114fc>] (vfs_write+0xb8/0x170)
> [   33.194147] [<c01114fc>] (vfs_write) from [<c0111a38>] (SyS_write+0x40/0x80)
> [   33.201154] [<c0111a38>] (SyS_write) from [<c000dce0>] (ret_fast_syscall+0x0/0x48)
> [   33.209634] _cpu_up: attempt to bring up CPU 5 failed
> [   33.213702] ------------[ cut here ]------------

What sysfs file is being written to here in interrupt context?

> 
> Signed-off-by: Anand Moon <moon.linux@yahoo.com>
> ---
>  fs/kernfs/file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
> index 4429d6d..fa97883 100644
> --- a/fs/kernfs/file.c
> +++ b/fs/kernfs/file.c
> @@ -278,7 +278,7 @@ static ssize_t kernfs_fop_write(struct file *file, const char __user *user_buf,
>  		len = min_t(size_t, count, PAGE_SIZE);
>  	}
>  
> -	buf = kmalloc(len + 1, GFP_KERNEL);
> +	buf = kzalloc(len + 1, GFP_ATOMIC);

kzalloc makes no sense as we copy right over the data right after this
in a copy_from_user() call.  Why change it?

And, the fact that we can sleep in copy_from_user(), makes this change
to GFP_ATOMIC really suspect.  We need to find the root cause here...

thanks,

greg k-h
