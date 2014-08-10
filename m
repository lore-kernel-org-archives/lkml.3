Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093AbaHJDSV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 23:18:21 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:62600 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaHJDSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 23:18:20 -0400
MIME-Version: 1.0
In-Reply-To: <53E6CF2B.6090709@roeck-us.net>
References: <53E6CF2B.6090709@roeck-us.net>
Date: Sat, 9 Aug 2014 20:18:19 -0700
X-Google-Sender-Auth: JBuMBbL6FNZJvqWUci13-FlQ8_s
Message-ID: <CAGXu5jLsbCpqG2cAxZWG+ZC=wdvhQ_9GPqXUb6p9pSvsqrXpOA@mail.gmail.com>
Subject: Re: Runtime trouble with commit dbd952127d (seccomp: introduce writer locking)
From: Kees Cook <keescook@chromium.org>
To: Guenter Roeck <private@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 9, 2014 at 6:47 PM, Guenter Roeck <private@roeck-us.net> wrote:
> Hi folks,
>
> I am having some trouble with commit dbd952127d (seccomp: introduce
> writer locking) when running my qemu tests on the upstream kernel.

Eek, sorry this is causing you trouble!

> With powerpc, I get the following crash.
>
> ftrace: allocating 20093 entries in 59 pages
> ------------[ cut here ]------------
> kernel BUG at kernel/fork.c:1108!

For your tree, does this resolve to copy_seccomp()'s

        BUG_ON(!spin_is_locked(&current->sighand->siglock));

line?

> Oops: Exception in kernel mode, sig: 5 [#1]
> PREEMPT PowerMac
> Modules linked in:
> CPU: 0 PID: 0 Comm: swapper Not tainted 3.16.0-yocto-standard+ #1
> task: c08a03d0 ti: c08e4000 task.ti: c08e4000
> NIP: c002b98c LR: c002b988 CTR: c03837ec
> REGS: c08e5e30 TRAP: 0700   Not tainted  (3.16.0-yocto-standard+)
> MSR: 00021032 <ME,IR,DR,RI>  CR: 22282048  XER: 20000000
>
> GPR00: c002b988 c08e5ee0 c08a03d0 00000001 c0a9b878 00000800 c783603c
> 00000020
> GPR08: c783603c 00000003 00000001 c08f61fc 22222044 00000000 07c5ac10
> 00800300
> GPR16: c7870000 00000010 00000000 07de7fa4 00000000 c08f594c c08f0000
> c78702d0
> GPR24: 00000000 c08f0000 c08f5940 c000422c c08a8ea0 c7870310 00000000
> c7808400
> NIP [c002b98c] copy_process.part.52+0x794/0x13e4
> LR [c002b988] copy_process.part.52+0x790/0x13e4
> Call Trace:
> [c08e5ee0] [c002b988] copy_process.part.52+0x790/0x13e4 (unreliable)
> [c08e5f60] [c002c768] do_fork+0xb8/0x3bc
> [c08e5fa0] [c00041c8] rest_init+0x30/0x94
> [c08e5fb0] [c083cf98] start_kernel+0x368/0x37c
> [c08e5ff0] [00003438] 0x3438
> Instruction dump:
> 7d400124 38600001 48027e95 55e903e1 41820b84 80e202c0 90f002c0 81420570
> 91500570 38600001 48027e75 39400001 <0f0a0000> 81420568 8162056c 91500568
> ---[ end trace dc8fa200cb88537f ]---
>
> With  mips (both 32 bit and 64 bit), I get
>
> NR_IRQS:256
> CPU frequency 200.00 MHz
> Console: colour dummy device 80x25
> console [tty0] enabled
> bootconsole [uart0] disabled
>
> [ and then there is silence ]
>
> In all cases I bisected the problem to the above mentioned commit.
>
> Failures are seen in both linux-next and the tip of Linus' tree.
> Test results are on http://server.roeck-us.net:8010/builders
> (look for qwmu results). Build and test scripts are in the mips,
> mips64, and powerpc subdirectories of
> https://github.com/groeck/linux-build-test/tree/master/rootfs.
>
> Any idea, anyone, what might be going on, or how I could do to
> help tracking this down ?

Can you send me your .config for the powerpc case? There must be
something going on here with the spinlock, but I don't see how, since
the lines immediately before the copy_seccomp call take the lock...

Is there something special going on here for the "pid 0" case?

-Kees

-- 
Kees Cook
Chrome OS Security
