Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaAKQgM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 11:36:12 -0500
Received: from mail-qe0-f47.google.com ([209.85.128.47]:49784 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbaAKQgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 11:36:08 -0500
MIME-Version: 1.0
In-Reply-To: <20140111161404.GA7744@localhost>
References: <20140111161404.GA7744@localhost>
Date: Sun, 12 Jan 2014 00:36:07 +0800
Message-ID: <CACVXFVNiOB3KE71kEJtEmi5GQ6QEUoftht308mvgsts8VCP5HQ@mail.gmail.com>
Subject: Re: [percpu_counter] WARNING: CPU: 1 PID: 1 at kernel/locking/lockdep.c:3537
 check_flags()
From: Ming Lei <tom.leiming@gmail.com>
To: kernel test robot <fengguang.wu@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fengguang,

Thanks for your test and reporting.

On Sun, Jan 12, 2014 at 12:14 AM, kernel test robot
<fengguang.wu@intel.com> wrote:
> Greetings,
>
> I got the below dmesg and the first bad commit is
>
> commit 97e890b9c839c191a500c3a19bfb4539f65c70be
> Author:     Ming Lei <tom.leiming@gmail.com>
> AuthorDate: Fri Jan 10 12:41:46 2014 +1100
> Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
> CommitDate: Fri Jan 10 12:41:46 2014 +1100
>
>     lib/percpu_counter.c: disable local irq when updating percpu couter
>
>     __percpu_counter_add() may be called in softirq/hardirq handler (such as,
>     blk_mq_queue_exit() is typically called in hardirq/softirq handler), so we
>     need to disable local irq when updating the percpu counter, otherwise
>     counts may be lost.
>
>     The patch fixes problem that 'rmmod null_blk' may hang in blk_cleanup_queue()
>     because of miscounting of request_queue->mq_usage_counter.
>
>     Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>     Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
>     Cc: Andrew Morton <akpm@linux-foundation.org>
>     Cc: Shaohua Li <shli@fusionio.com>
>     Cc: Jens Axboe <axboe@kernel.dk>
>     Cc: Fan Du <fan.du@windriver.com>
>     Cc: Tejun Heo <tj@kernel.org>
>     Cc: <stable@vger.kernel.org>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>
> +-----------------------------------------------------------+----+
> |                                                           |    |
> +-----------------------------------------------------------+----+
> | boot_successes                                            | 0  |
> | boot_failures                                             | 19 |
> | WARNING:CPU:PID:at_kernel/locking/lockdep.c:check_flags() | 19 |
> +-----------------------------------------------------------+----+
>
> [    8.021637] Freeing unused kernel memory: 816K (ffff880001934000 - ffff880001a00000)
>
> [    8.093354] ------------[ cut here ]------------
> [    8.095469] WARNING: CPU: 1 PID: 1 at kernel/locking/lockdep.c:3537 check_flags+0x77/0x1ba()
> [    8.095469] DEBUG_LOCKS_WARN_ON(current->hardirqs_enabled)

The warning is caused by the added raw_local_irq_save(), which should
have been local_irq_save(flags). Actually, it is a false positive.

Andrew, considered that your approach may be more efficient than this
one since preempt_disable()/preempt_enable() can be removed too.

So could you prepare one patch for fixing the problem? Or if you are busy, I'd
like to do it.


Thanks,
-- 
Ming Lei
