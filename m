Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbaD0UIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 16:08:23 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:49068 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaD0UIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 16:08:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140427120820.GC22116@gmail.com>
References: <1398535818-14217-1-git-send-email-ryao@gentoo.org>
	<20140427120820.GC22116@gmail.com>
Date: Sun, 27 Apr 2014 13:08:20 -0700
X-Google-Sender-Auth: NyL85WwT-4SeDtNloB0w28rL0t8
Message-ID: <CA+55aFw39HcWMYsPXb=PMK6--bHCSWwrjucGK+4VswEZrWLbGA@mail.gmail.com>
Subject: Re: [PATCH] x86/dumpstack: Walk frames when built with frame pointers
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Richard Yao <ryao@gentoo.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, Jiri Slaby <jslaby@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel@gentoo.org, Brian Behlendorf <behlendorf1@llnl.gov>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 5:08 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> So it's useful information for hairy bugs and it would be sad to
> remove them.

I tend to agree. I've often found the left-overs to be good clues
about what just got called. Although equally often it's another kind
of clue entirely: that the stack frame of some of the functions
involved in the real call frame is much too big, leaving room for that
stale information to lay around.

> Having said that, your complaint that '?' entries can make reading of
> back traces more difficult is valid as well - so maybe we can do
> something about that.

Quite frankly, I'd much rather just remove the annoying hex numbers
that are imnsho *much* more distracting. Possibly even the "/0xsize"
part (although that is at least somewhat useful to judge where in the
function it is).

And while it would be horrible for readability, it might also be a
good idea to replace the newlines with something like " -> " instead,
because we are quite often vertically challenged. But that could
really make things pretty unreadable.

So to take your example, it might be something like this

arch_trigger_all_cpu_backtrace+0x3c -> do_raw_spin_lock+0xb7
 -> _raw_spin_lock_irqsave+0x35 -> ? prepare_to_wait+0x18
 -> prepare_to_wait+0x18 -> ? generic_make_request+0x80
 -> ? unmap_underlying_metadata+0x2e -> __wait_on_bit+0x20
 -> ? submit_bio+0xd2 -> out_of_line_wait_on_bit+0x54
 -> ? unmap_underlying_metadata+0x2e -> ? autoremove_wake_function+0x31
 -> __wait_on_buffer+0x1b -> __ext3_get_inode_loc+0x1ef -> ext3_iget+0x45
 -> ext3_lookup+0x97 -> lookup_real+0x20 -> __lookup_hash+0x2a
 -> lookup_slow+0x36 -> path_lookupat+0xf9 -> filename_lookup+0x1f
 -> user_path_at_empty+0x3f -> user_path_at+0xd -> vfs_fstatat+0x40
 -> ? lg_local_unlock+0x31 -> vfs_stat+0x13 -> sys_stat64+0x11
 -> ? __fput+0x187 -> ? restore_all+0xf -> ? trace_hardirqs_on_thunk+0xc
 -> syscall_call+0x7

which is admittedly complete line noise, but is just 13 lines rather
than 31. That can sometimes be a really big deal.

Also, we might want to cap the number of lines regardless. It is true
that sometimes the really deep call chains can be interesting, but
equally often they make other important stuff scroll off the screen
(oopses that don't get caught in /sys/log/messages because they kill
the machine are the worst to debug, and we still end up having people
send pictures taken with digital cameras of them), so it's a "win
some, lose some" kind of thing.

Of course, the questionable stale entries on the stack can (and do)
make the whole "scroll off the screen" thing worse. So I dunno.

              Linus
