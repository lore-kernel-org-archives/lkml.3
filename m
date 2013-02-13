Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133Ab3BMQ7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:59:48 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:47244 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759808Ab3BMQ7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:59:47 -0500
MIME-Version: 1.0
In-Reply-To: <20130213111007.GA11367@gmail.com>
References: <CA+55aFz50VvnMjoDCbg01N+rMu5vscu88kr0SV3tWLjaiL0TeA@mail.gmail.com>
 <20130213111007.GA11367@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 13 Feb 2013 08:59:23 -0800
X-Google-Sender-Auth: nkEqYdwRiggjVmDrqbfQMsELJ9I
Message-ID: <CA+55aFxrjsVkBwUdjmc4MYvEsjEyCJZ7AFpGrWvbbQFB3EVtHA@mail.gmail.com>
Subject: Re: [-rc7 regression] Block IO/VFS/ext3/timer spinlock lockup?
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Thomas Gleixner <tglx@linutronix.de>,
        Alexander Viro <viro@ftp.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 3:10 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
>
> Setting up Logical Volume Management: [   13.140000] BUG: spinlock lockup suspected on CPU#1, lvm.static/139
> [   13.140000] BUG: spinlock lockup suspected on CPU#1, lvm.static/139
> [   13.140000]  lock: 0x97fe9fc0, .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
> [   13.140000] Pid: 139, comm: lvm.static Not tainted 3.8.0-rc7 #216702
> [   13.140000] Call Trace:
> [   13.140000]  [<792b5e66>] spin_dump+0x73/0x7d
> [   13.140000]  [<7916a347>] do_raw_spin_lock+0xb2/0xe8
> [   13.140000]  [<792b9412>] _raw_spin_lock_irqsave+0x35/0x3e
> [   13.140000]  [<790391e8>] prepare_to_wait+0x18/0x57

The wait-queue spinlock? That sounds *very* unlikely to deadlock due
to any bugs in block layer or filesystems. There are never any
downcalls to those from within that spinlock or any other locks taken
inside of it.

The waitqueue function would be the only thing that does anything
inside the lock, and very few things use that. In this case, it's the
bitwait stuff, so that function does get used, but it doesn't have any
locking except for when it then calls down to the standard
autoremove_wake_function -> default_wake_function -> try_to_wake_up.

So the *only* thing inside that wait-queue spinlock would seem to be
the scheduler (pi_lock in particular, and the "while (p->on_cpu)"
thing).

Of course, those kinds of locks are also something lockdep can't check, so...

> It turns out that in this particular case the randomized boot
> parameters appear to make a difference:
>
> CONFIG_CMDLINE="nmi_watchdog=0 nolapic_timer hpet=disable idle=poll highmem=512m acpi=off"

Is it repeatable enough with those flags that you could try removing
them one at a time and seeing if one or two of them don't matter?

                     Linus
