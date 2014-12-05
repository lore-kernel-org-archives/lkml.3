Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaLETbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:31:14 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:35168 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaLETbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:31:12 -0500
MIME-Version: 1.0
In-Reply-To: <20141205184808.GA2753@redhat.com>
References: <547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
	<20141201230339.GA20487@ret.masoncoding.com>
	<1417529606.3924.26.camel@maggy.simpson.net>
	<CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
	<1417540493.21136.3@mail.thefacebook.com>
	<20141203184111.GA32005@redhat.com>
	<CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
	<20141205171501.GA1320@redhat.com>
	<CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
	<20141205184808.GA2753@redhat.com>
Date: Fri, 5 Dec 2014 11:31:11 -0800
X-Google-Sender-Auth: xZzv54qy3pdVIxMF1x3ulpMSvlo
Message-ID: <CA+55aFwhdbcvvimPx0F7Q-BYDUSYDUODo5k5xeJuRCAtGB2dwg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2014 at 10:48 AM, Dave Jones <davej@redhat.com> wrote:
>
> In the meantime, I rebooted into the same kernel, and ran trinity
> solely doing the lsetxattr syscalls.

Any particular reason for the lsetxattr guess? Just the last call
chain? I don't recognize it from the other traces, but maybe I just
didn't notice.

>   The load was a bit lower, so I
> cranked up the number of child processes to 512, and then this
> happened..

Ugh. "dump_trace()" being broken and looping forever? I don't actually
believe it, because this isn't even on the exception stack (well, the
NMI dumper is, but that one worked fine - this is the "nested" dumping
of just the allocation call chain)

Smells like more random callchains to me. Unless this one is repeatable.

Limiting trinity to just lsetxattr is interesting. Did it make things
fail faster?

                     Linus

> [ 1611.747053] WARNING: CPU: 0 PID: 14810 at kernel/watchdog.c:265 watchdog_overflow_callback+0xd5/0x120()
> [ 1611.747083] Watchdog detected hard LOCKUP on cpu 0
> [ 1611.747389] CPU: 0 PID: 14810 Comm: trinity-c304 Not tainted 3.16.0+ #114
> [ 1611.747544] Call Trace:
>    [ remnoved NMI perf event stack trace ]
> [ 1611.753861]  [<ffffffff810fee07>] is_module_text_address+0x17/0x50
> [ 1611.754734]  [<ffffffff81092ab8>] __kernel_text_address+0x58/0x80
> [ 1611.755575]  [<ffffffff81006b5f>] print_context_stack+0x8f/0x100
> [ 1611.756410]  [<ffffffff81005540>] dump_trace+0x140/0x370
> [ 1611.758895]  [<ffffffff810137cb>] save_stack_trace+0x2b/0x50
> [ 1611.759720]  [<ffffffff811c29a0>] set_track+0x70/0x140
> [ 1611.760541]  [<ffffffff8178d993>] alloc_debug_processing+0x92/0x118
> [ 1611.761366]  [<ffffffff8178e5d6>] __slab_alloc+0x45f/0x56f
> [ 1611.765539]  [<ffffffff811c6b26>] kmem_cache_alloc+0x1f6/0x270
> [ 1611.767183]  [<ffffffff811e797f>] getname_flags+0x4f/0x1a0
> [ 1611.768004]  [<ffffffff811ed7e5>] user_path_at_empty+0x45/0xc0
> [ 1611.772129]  [<ffffffff811ed871>] user_path_at+0x11/0x20
> [ 1611.772959]  [<ffffffff812040cb>] SyS_lsetxattr+0x4b/0xf0
> [ 1611.773783]  [<ffffffff8179bc92>] system_call_fastpath+0x16/0x1b
