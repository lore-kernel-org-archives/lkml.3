Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbaFQDCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 23:02:16 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:35516 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbaFQDCO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 23:02:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140617025805.29539.22007.stgit@zurg>
References: <20140617025805.29539.22007.stgit@zurg>
Date: Tue, 17 Jun 2014 07:02:13 +0400
Message-ID: <CALYGNiNpGUtgu13FdTEOSRVfVtrGzuZtgii+V=sbzhMC03sxpA@mail.gmail.com>
Subject: Re: [PATCH] epoll: fix use-after-free in eventpoll_release_file
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Sasha Levin <sasha.levin@oracle.com>, Jason Baron <jbaron@akamai.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 6:58 AM, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
> This fixes use-after-free of epi->fllink.next inside list loop macro.
> This loop actually releases elements in the body. List is rcu-protected
> but here we cannot hold rcu_read_lock because we need to lock mutex inside.
>
> Obvious solution is to use list_for_each_entry_safe(). RCU-ness isn't essential
> because nobody can change this list under us, it's final fput for this file.
>
> Bug is here since ae10b2b4eb01bedc91d29d5c5bb9e416fd806c40
> ("epoll: optimize EPOLL_CTL_DEL using rcu")
>
> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
> Reported-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Stable <stable@vger.kernel.org> # 3.13+
> Cc: Sasha Levin <sasha.levin@oracle.com>
> Cc: Jason Baron <jbaron@akamai.com>
> ---

oops from Cyrill's report
https://plus.google.com/+CyrillGorcunov/posts/RPGi1ECc3Tk

[   14.448483] general protection fault: 0000 [#1] [   14.448483]
general protection fault: 0000 [#1] PREEMPT PREEMPT SMP SMP

[   14.448533] Modules linked in:[   14.448533] Modules linked in:

[   14.448533] CPU: 0 PID: 1153 Comm: plymouthd Not tainted 3.16.0-rc1 #463
[   14.448533] CPU: 0 PID: 1153 Comm: plymouthd Not tainted 3.16.0-rc1 #463
[   14.448533] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   14.448533] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   14.448533] task: ffff880037a28f50 ti: ffff880037a2c000 task.ti:
ffff880037a2c000
[   14.448533] task: ffff880037a28f50 ti: ffff880037a2c000 task.ti:
ffff880037a2c000
[   14.448533] RIP: 0010:[<ffffffff810abee9>] [   14.448533] RIP:
0010:[<ffffffff810abee9>]  [<ffffffff810abee9>]
__lock_acquire+0xeb/0xf07
 [<ffffffff810abee9>] __lock_acquire+0xeb/0xf07
[   14.448533] RSP: 0018:ffff880037a2fcf0  EFLAGS: 00010002
[   14.448533] RSP: 0018:ffff880037a2fcf0  EFLAGS: 00010002
[   14.448533] RAX: 6b6b6b6b6b6b6b6b RBX: ffff880037a28f50 RCX: 0000000000000000
[   14.448533] RAX: 6b6b6b6b6b6b6b6b RBX: ffff880037a28f50 RCX: 0000000000000000
[   14.448533] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88003b960200
[   14.448533] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88003b960200
[   14.448533] RBP: ffff880037a2fd88 R08: 0000000000000001 R09: 0000000000000000
[   14.448533] RBP: ffff880037a2fd88 R08: 0000000000000001 R09: 0000000000000000
[   14.448533] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880037a28f50
[   14.448533] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880037a28f50
[   14.448533] R13: 0000000000000000 R14: 0000000000000001 R15: ffff88003b960200
[   14.448533] R13: 0000000000000000 R14: 0000000000000001 R15: ffff88003b960200
[   14.448533] FS:  00007fafb700d740(0000) GS:ffff88003fc00000(0000)
knlGS:0000000000000000
[   14.448533] FS:  00007fafb700d740(0000) GS:ffff88003fc00000(0000)
knlGS:0000000000000000
[   14.448533] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   14.448533] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   14.448533] CR2: 00007fd6cc054414 CR3: 00000000378ee000 CR4: 00000000000006f0
[   14.448533] CR2: 00007fd6cc054414 CR3: 00000000378ee000 CR4: 00000000000006f0
[   14.448533] Stack:
[   14.448533] Stack:
[   14.448533]  ffff880000000000[   14.448533]  ffff880000000000
ffff880000000001 ffff880000000001 ffffffff00000000 ffffffff00000000
ffff880000000000 ffff880000000000

[   14.448533]  ffffffff00000000[   14.448533]  ffffffff00000000
ffff88003fdcd2b0 ffff88003fdcd2b0 ffffffff81c41d80 ffffffff81c41d80
ffff880037a2fe30 ffff880037a2fe30

[   14.448533]  ffffffff81303a7e[   14.448533]  ffffffff81303a7e
0000000000000000 0000000000000000 0000000000000000 0000000000000000
00000000009c0496 00000000009c0496

[   14.448533] Call Trace:
[   14.448533] Call Trace:
[   14.448533]  [<ffffffff81303a7e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   14.448533]  [<ffffffff81303a7e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   14.448533]  [<ffffffff810ace03>] lock_acquire+0xfe/0x146
[   14.448533]  [<ffffffff810ace03>] lock_acquire+0xfe/0x146
[   14.448533]  [<ffffffff811a97c5>] ? eventpoll_release_file+0x68/0xc1
[   14.448533]  [<ffffffff811a97c5>] ? eventpoll_release_file+0x68/0xc1
[   14.448533]  [<ffffffff811a97c5>] ? eventpoll_release_file+0x68/0xc1
[   14.448533]  [<ffffffff811a97c5>] ? eventpoll_release_file+0x68/0xc1
[   14.448533]  [<ffffffff81639ffa>] mutex_lock_nested+0x77/0x3f0
[   14.448533]  [<ffffffff81639ffa>] mutex_lock_nested+0x77/0x3f0
[   14.448533]  [<ffffffff811a97c5>] ? eventpoll_release_file+0x68/0xc1
[   14.448533]  [<ffffffff811a97c5>] ? eventpoll_release_file+0x68/0xc1
[   14.448533]  [<ffffffff811a97c5>] ? eventpoll_release_file+0x68/0xc1
[   14.448533]  [<ffffffff811a97c5>] ? eventpoll_release_file+0x68/0xc1
[   14.448533]  [<ffffffff811a97c5>] eventpoll_release_file+0x68/0xc1
[   14.448533]  [<ffffffff811a97c5>] eventpoll_release_file+0x68/0xc1
[   14.448533]  [<ffffffff8117451c>] __fput+0xc5/0x1b6
[   14.448533]  [<ffffffff8117451c>] __fput+0xc5/0x1b6
[   14.448533]  [<ffffffff81174643>] ____fput+0xe/0x10
[   14.448533]  [<ffffffff81174643>] ____fput+0xe/0x10
[   14.448533]  [<ffffffff81085643>] task_work_run+0x7d/0xa6
[   14.448533]  [<ffffffff81085643>] task_work_run+0x7d/0xa6
[   14.448533]  [<ffffffff81002799>] do_notify_resume+0x63/0x68
[   14.448533]  [<ffffffff81002799>] do_notify_resume+0x63/0x68
[   14.448533]  [<ffffffff8163df1a>] int_signal+0x12/0x17
[   14.448533]  [<ffffffff8163df1a>] int_signal+0x12/0x17
[   14.448533] Code: [   14.448533] Code: 85 85 c0 c0 75 75 27 27 31
31 d2 d2 4c 4c 89 89 ff ff 44 44 89 89 4c 4c 24 24 08 08 44 44 89 89
44 44 24 24 10 10 e8 e8 10 10 f7 f7 ff ff ff ff 48 48 85 85 c0 c0 44
44 8b 8b 44 44 24 24 10 10 44 44 8b 8b 4c 4c 24 24 08 08 0f 0f 84 84
1b 1b 0d 0d 00 00 00 00 <3e> <3e> ff ff 80 80 98 98 01 01 00 00 00 00
83 83 3d 3d 91 91 1e 1e cb cb 01 01 00 00 45 45 8b 8b b4 b4 24 24 50
50 08 08 00 00

[   14.448533] RIP [   14.448533] RIP  [<ffffffff810abee9>]
__lock_acquire+0xeb/0xf07
 [<ffffffff810abee9>] __lock_acquire+0xeb/0xf07
[   14.448533]  RSP <ffff880037a2fcf0>
[   14.448533]  RSP <ffff880037a2fcf0>
[   14.448533] ---[ end trace b64669d4daf5e235 ]---
[   14.448533] -[ end trace b64669d4daf5e235 ]-
[   14.448533] Kernel panic - not syncing: Fatal exception
[   14.448533] Kernel panic - not syncing: Fatal exception
[   14.448533] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation
range: 0xffffffff80000000-0xffffffff9fffffff)
[   14.448533] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation
range: 0xffffffff80000000-0xffffffff9fffffff)
[   14.448533] -[ end Kernel panic - not syncing: Fatal exception
[   14.448533] -[ end Kernel panic - not syncing: Fatal exception﻿


>  fs/eventpoll.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index b73e062..b10b48c 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -910,7 +910,7 @@ static const struct file_operations eventpoll_fops = {
>  void eventpoll_release_file(struct file *file)
>  {
>         struct eventpoll *ep;
> -       struct epitem *epi;
> +       struct epitem *epi, *next;
>
>         /*
>          * We don't want to get "file->f_lock" because it is not
> @@ -926,7 +926,7 @@ void eventpoll_release_file(struct file *file)
>          * Besides, ep_remove() acquires the lock, so we can't hold it here.
>          */
>         mutex_lock(&epmutex);
> -       list_for_each_entry_rcu(epi, &file->f_ep_links, fllink) {
> +       list_for_each_entry_safe(epi, next, &file->f_ep_links, fllink) {
>                 ep = epi->ep;
>                 mutex_lock_nested(&ep->mtx, 0);
>                 ep_remove(ep, epi);
>
