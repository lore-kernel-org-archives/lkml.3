Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab3JNRbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 13:31:17 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:52245 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839Ab3JNRbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 13:31:15 -0400
MIME-Version: 1.0
In-Reply-To: <20131014154627.GA9525@redhat.com>
References: <20131014154627.GA9525@redhat.com>
Date: Mon, 14 Oct 2013 10:31:14 -0700
X-Google-Sender-Auth: 6LHOuLf3ne7O1g94ebj6Rbi_3rY
Message-ID: <CA+55aFw64xTR7LXjo5OfUvRwDb9UF8EcfjguAbF0C3VsUXCecg@mail.gmail.com>
Subject: Re: epoll oops.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Davide Libenzi <davidel@xmailserver.org>,
        Eric Wong <normalperson@yhbt.net>, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 8:46 AM, Dave Jones <davej@redhat.com> wrote:
> Machine is wedged and I can't get to it until tomorrow, but this is what was on serial console.
> kernel running was from some time last Friday, I can get exact info tomorrow, though
> I don't think there's anything epoll related recently that could explain this.

It looks like it is the access to "lock->key" that takes a page fault.
The pointer looks good (%r13=ffff8801654cec98), so I'm pretty sure
this is due to DEBUG_PAGEALLOC and a free'd page.

So it looks like ep_unregister_pollwait() calls remove_wait_queue() on
a wait-queue head that has already been free'd.

I have this dim memory of us having fought this before. But maybe I'm
just remembering some of the old signalfd-vs-epoll races.

Oleg, does this trigger any memory for you? Commit 971316f0503a
("epoll: ep_unregister_pollwait() can use the freed pwq->whead") just
makes me go "Hmm, this is *exactly* that that commit is talking
about.."

                      Linus

---
> Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> CPU: 3 PID: 449 Comm: trinity-main Not tainted 3.12.0-rc4+ #98
> task: ffff88023e239560 ti: ffff880083082000 task.ti: ffff880083082000
> RIP: 0010:[<ffffffff810c9f98>]  [<ffffffff810c9f98>] __lock_acquire+0x58/0x1be0
> Call Trace:
>  [<ffffffff810cc2d3>] lock_acquire+0x93/0x200
>  [<ffffffff81732c3b>] _raw_spin_lock_irqsave+0x4b/0x90
>  [<ffffffff810848d9>] remove_wait_queue+0x19/0x40
>  [<ffffffff812120eb>] ep_unregister_pollwait.isra.14+0x5b/0x1e0
>  [<ffffffff81212786>] ep_remove+0x26/0x140
>  [<ffffffff81213391>] eventpoll_release_file+0x71/0xa0
>  [<ffffffff811c4faa>] __fput+0x2aa/0x2d0
>  [<ffffffff811c501e>] ____fput+0xe/0x10
>  [<ffffffff8107d67c>] task_work_run+0xac/0xe0
>  [<ffffffff81056bd7>] do_exit+0x2c7/0xcc0
>  [<ffffffff810589cc>] do_group_exit+0x4c/0xc0
>  [<ffffffff81058a54>] SyS_exit_group+0x14/0x20
>  [<ffffffff8173bf64>] tracesys+0xdd/0xe2
> Code: 85 c0 8b 05 4b d6 bc 00 45 0f 45 e0 85 c0 0f 84 07 01 00 00 8b 05 31 af 00 01 49 89 fd 41 89 f7 41 89 d3 85 c0 0f 84 08 01 00 00 <49> 8b 45 00 ba 01 00 00 00 48 3d 60 6a 13 82 44 0f 44 e2 41 83
> RIP  [<ffffffff810c9f98>] __lock_acquire+0x58/0x1be0
>  RSP <ffff880083083c18>
> CR2: ffff8801654cec98
> ---[ end trace 044e98c2d3aab216 ]---
>
