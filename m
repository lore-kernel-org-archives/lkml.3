Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751028Ab3LJG3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 01:29:21 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:56786 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3LJG3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 01:29:20 -0500
MIME-Version: 1.0
X-Originating-IP: [218.164.103.91]
In-Reply-To: <1385349629.21903.4.camel@phoenix>
References: <1385349629.21903.4.camel@phoenix>
Date: Tue, 10 Dec 2013 14:29:20 +0800
Message-ID: <CAFRkauArs5iB_z2EF=Q4JZ+D86GB=vjR+Kt4pnYcnvGFf3bH4A@mail.gmail.com>
Subject: Re: ARM: nommu: DEBUG_LOCKS_WARN_ON(!depth)
From: Axel Lin <axel.lin@ingics.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/25 Axel Lin <axel.lin@ingics.com>:
> I'm testing on a nommu platform (arm7tdmi SoC).
> Using current Linus' tree + out-of-tree patches for this SoC.
> I got below hang while executing ls (busybox) after boot.
>
> / # ls
> [   51.036191] ------------[ cut here ]------------
> [   51.042242] WARNING: CPU: 0 PID: 1 at kernel/locking/lockdep.c:3312 lock_set_class+0x5c8/0x660()
> [   51.051426] DEBUG_LOCKS_WARN_ON(!depth)
> [   51.055842] CPU: 0 PID: 1 Comm:  Not tainted 3.13.0-rc1-00100-g4b061f7-dirty #1917
> [   51.065415] [<0000c430>] (unwind_backtrace+0x0/0xe0) from [<0000ae58>] (show_stack+0x10/0x14)
> [   51.075781] [<0000ae58>] (show_stack+0x10/0x14) from [<0000f7b0>] (warn_slowpath_common+0x58/0x78)
> [   51.086549] [<0000f7b0>] (warn_slowpath_common+0x58/0x78) from [<0000f814>] (warn_slowpath_fmt+0x2c/0x3c)
> [   51.098162] [<0000f814>] (warn_slowpath_fmt+0x2c/0x3c) from [<00036d9c>] (lock_set_class+0x5c8/0x660)
> [   50.934805] [<00036d9c>] (lock_set_class+0x5c8/0x660) from [<000367d4>] (lock_set_class+0x0/0x660)
> [   50.945255] [<000367d4>] (lock_set_class+0x0/0x660) from [<00000000>] (  (null))
> [   50.953242] ---[ end trace 7d1e4eb800000001 ]---
>

Now test on top of linux-3.13-rc3.
I found I can hit this lockdep warning only when CONFIG_PREEMPT_NONE=y

1) With CONFIG_PREEMPT_NONE=y
        executing ls (busybox) hang with above lockdep warning.
2) With CONFIG_PREEMPT_VOLUNTARY=y:
        have "[sched_delayed] sched: RT throttling activated" in boot message.
        executing ls (busybox) hang silently.
3) With CONFIG_PREEMPT=y:
        executing ls (busybox) successfully and it's ok to execute other binary.

all the test with below configs:
CONFIG_PREEMPT_COUNT=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_BUGVERBOSE=y
