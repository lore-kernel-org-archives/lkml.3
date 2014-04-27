Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbaD0Ugv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 16:36:51 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49457 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbaD0Ugu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 16:36:50 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH] x86/dumpstack: Walk frames when built with frame pointers
From: Richard Yao <ryao@gentoo.org>
In-Reply-To: <CA+55aFw39HcWMYsPXb=PMK6--bHCSWwrjucGK+4VswEZrWLbGA@mail.gmail.com>
Date: Sun, 27 Apr 2014 16:36:39 -0400
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, Jiri Slaby <jslaby@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel@gentoo.org, Brian Behlendorf <behlendorf1@llnl.gov>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?windows-1252?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <8791C231-A0EB-4D95-970D-DD7E5E00FEAE@gentoo.org>
References: <1398535818-14217-1-git-send-email-ryao@gentoo.org> <20140427120820.GC22116@gmail.com> <CA+55aFw39HcWMYsPXb=PMK6--bHCSWwrjucGK+4VswEZrWLbGA@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 27, 2014, at 4:08 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, Apr 27, 2014 at 5:08 AM, Ingo Molnar <mingo@kernel.org> wrote:
>> 
>> So it's useful information for hairy bugs and it would be sad to
>> remove them.
> 
> I tend to agree. I've often found the left-overs to be good clues
> about what just got called. Although equally often it's another kind
> of clue entirely: that the stack frame of some of the functions
> involved in the real call frame is much too big, leaving room for that
> stale information to lay around.

Getting information about the frames being too big is a useful side effect. I don’t think the omission of historical frames from the stack traces needs to eliminate that. In particular, we could print the stack depth, frame size and number of possible pointers to kernel code spotted in the frame alongside the stack frames that we obtain from unwinding the stack.

>> Having said that, your complaint that '?' entries can make reading of
>> back traces more difficult is valid as well - so maybe we can do
>> something about that.
> 
> Quite frankly, I'd much rather just remove the annoying hex numbers
> that are imnsho *much* more distracting. Possibly even the "/0xsize"
> part (although that is at least somewhat useful to judge where in the
> function it is).
> 
> And while it would be horrible for readability, it might also be a
> good idea to replace the newlines with something like " -> " instead,
> because we are quite often vertically challenged. But that could
> really make things pretty unreadable.
> 
> So to take your example, it might be something like this
> 
> arch_trigger_all_cpu_backtrace+0x3c -> do_raw_spin_lock+0xb7
> -> _raw_spin_lock_irqsave+0x35 -> ? prepare_to_wait+0x18
> -> prepare_to_wait+0x18 -> ? generic_make_request+0x80
> -> ? unmap_underlying_metadata+0x2e -> __wait_on_bit+0x20
> -> ? submit_bio+0xd2 -> out_of_line_wait_on_bit+0x54
> -> ? unmap_underlying_metadata+0x2e -> ? autoremove_wake_function+0x31
> -> __wait_on_buffer+0x1b -> __ext3_get_inode_loc+0x1ef -> ext3_iget+0x45
> -> ext3_lookup+0x97 -> lookup_real+0x20 -> __lookup_hash+0x2a
> -> lookup_slow+0x36 -> path_lookupat+0xf9 -> filename_lookup+0x1f
> -> user_path_at_empty+0x3f -> user_path_at+0xd -> vfs_fstatat+0x40
> -> ? lg_local_unlock+0x31 -> vfs_stat+0x13 -> sys_stat64+0x11
> -> ? __fput+0x187 -> ? restore_all+0xf -> ? trace_hardirqs_on_thunk+0xc
> -> syscall_call+0x7
> 
> which is admittedly complete line noise, but is just 13 lines rather
> than 31. That can sometimes be a really big deal.
> 
> Also, we might want to cap the number of lines regardless. It is true
> that sometimes the really deep call chains can be interesting, but
> equally often they make other important stuff scroll off the screen
> (oopses that don't get caught in /sys/log/messages because they kill
> the machine are the worst to debug, and we still end up having people
> send pictures taken with digital cameras of them), so it's a "win
> some, lose some" kind of thing.
> 
> Of course, the questionable stale entries on the stack can (and do)
> make the whole "scroll off the screen" thing worse. So I dunno.
> 
>              Linus

I suppose one option would be to write a patch to make this configurable via sysctl, throw it into staging so only kernel developers have access to it (I hope) and then try out each of these variations on our own machines to see which one we like best. The patch I submitted to the list is one that I am using myself and I have come to really like having only stack frames described by frame pointers printed. I think others who try more condensed stacks will come to like them too.

If you are interested in doing that experiment, I could put a patch together to do it.