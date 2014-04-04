Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaDDE4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 00:56:37 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:52192 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaDDE4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 00:56:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140404031928.GC11828@localhost>
References: <20140404031928.GC11828@localhost>
Date: Fri, 4 Apr 2014 10:26:32 +0530
Message-ID: <CAKohponbGFFo+W7X24e4h3ub2L8Tkb89eP6_F17CRYELk0yeRQ@mail.gmail.com>
Subject: Re: WARNING: CPU: 0 PID: 1935 at kernel/timer.c:1621 migrate_timer_list()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Fengguang Wu <fengguang.wu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jet Chen <jet.chen@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Fengguang,

On 4 April 2014 08:49, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Greetings,
>
> I got the below dmesg and the first bad commit is
>
> git://git.linaro.org/people/vireshk/linux timer-cleanup-for-tglx
>
> commit 6378cb51af5f4743db0dcb3cbcf862eac5908754
> Author:     Viresh Kumar <viresh.kumar@linaro.org>
> AuthorDate: Thu Mar 20 14:29:02 2014 +0530
> Commit:     Viresh Kumar <viresh.kumar@linaro.org>
> CommitDate: Wed Apr 2 14:54:57 2014 +0530
>
>     timer: don't migrate pinned timers
>
>     migrate_timer() is called when a CPU goes down and its timers are required to be
>     migrated to some other CPU. Its the responsibility of the users of the timer to
>     remove it before control reaches to migrate_timers().
>
>     As these were the pinned timers, the best we can do is: don't migrate these and
>     report to the user as well.
>
>     That's all this patch does.
>
>     Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> ===================================================
> PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
> ===================================================
> Attached one more dmesg for the NULL pointer bug in parent commit.
>
> +--------------------------------------------------------+------------+------------+------------+
> |                                                        | 5a8530b7c3 | 6378cb51af | 7caf71f403 |
> +--------------------------------------------------------+------------+------------+------------+
> | boot_successes                                         | 103        | 14         | 10         |
> | boot_failures                                          | 17         | 18         | 13         |
> | BUG:unable_to_handle_kernel_NULL_pointer_dereference   | 16         |            |            |
> | Oops:SMP                                               | 16         |            |            |
> | Kernel_panic-not_syncing:Fatal_exception               | 16         |            |            |
> | backtrace:vfs_read                                     | 16         |            |            |
> | backtrace:SyS_read                                     | 16         |            |            |
> | BUG:kernel_test_crashed                                | 1          |            |            |
> | WARNING:CPU:PID:at_kernel/timer.c:migrate_timer_list() | 0          | 17         | 12         |
> | backtrace:vfs_write                                    | 0          | 17         | 12         |
> | backtrace:SyS_write                                    | 0          | 17         | 12         |
> | BUG:kernel_early_hang_without_any_printk_output        | 0          | 1          | 1          |
> +--------------------------------------------------------+------------+------------+------------+
>
> [   74.242293] Unregister pv shared memory for cpu 1
> [   74.273280] smpboot: CPU 1 is now offline
> [   74.274685] ------------[ cut here ]------------
> [   74.275524] WARNING: CPU: 0 PID: 1935 at kernel/timer.c:1621 migrate_timer_list+0xd6/0xf0()
> [   74.275524] migrate_timer_list: can't migrate pinned timer: ffffffff81f06a60, deactivating it

Hmm, nice. So, my patch hasn't created a bug, but just highlighted it.
I have added this piece of code while migrating timers away:

if (unlikely(WARN(is_pinned,
    "%s: can't migrate pinned timer: %p, deactivating it\n",
    __func__, timer)))

Which means, migrate all timers to other CPUs when a CPU is going down.
But obviously we can't migrate the pinned timers. And it looks like we
actually were doing that before this commit and things went unnoticed.

But just due to this print, we are highlighting an existing issue here.
@Thomas: So, in a sense my patch is doing some good work now :)

Now, we need to fix the code which queued this pinned timer.
@Fengguang: As I don't have the facilities to reproduce this, can you
help me debugging this? Probably just change this print message to
print the address of timer->function as well and then we can find
the name of routine with help of objdump..

What we need to do finally is to remove this timer before CPU is
going down. I can fix the driver in question once we know which
driver it is.

--
viresh
