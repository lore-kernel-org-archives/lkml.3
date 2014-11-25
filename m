Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbaKYMWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:22:19 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:38812 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbaKYMWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:22:16 -0500
Date: Tue, 25 Nov 2014 12:22:17 +0000
From: Will Deacon <will.deacon@arm.com>
To: Dave Jones <davej@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141125122217.GA15280@arm.com>
References: <20141118023930.GA2871@redhat.com>
 <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
 <20141118145234.GA7487@redhat.com>
 <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com>
 <20141119021902.GA14216@redhat.com>
 <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
 <20141119145902.GA13387@redhat.com>
 <546D0530.8040800@mit.edu>
 <20141120152509.GA5412@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120152509.GA5412@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Thu, Nov 20, 2014 at 10:25:09AM -0500, Dave Jones wrote:
> On Wed, Nov 19, 2014 at 01:01:36PM -0800, Andy Lutomirski wrote:
>  
>  > TIF_NOHZ is not the same thing as NOHZ.  Can you try a kernel with
>  > CONFIG_CONTEXT_TRACKING=n?  Doing that may involve fiddling with RCU
>  > settings a bit.  The normal no HZ idle stuff has nothing to do with
>  > TIF_NOHZ, and you either have TIF_NOHZ set or you have some kind of
>  > thread_info corruption going on here.
> 
> Disabling CONTEXT_TRACKING didn't change the problem.
> Unfortunatly the full trace didn't make it over usb-serial this time. Grr.
> 
> Here's what came over serial..
> 
> NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [trinity-c35:11634]
> CPU: 2 PID: 11634 Comm: trinity-c35 Not tainted 3.18.0-rc5+ #94 [loadavg: 164.79 157.30 155.90 37/409 11893]
> task: ffff88014e0d96f0 ti: ffff880220eb4000 task.ti: ffff880220eb4000
> RIP: 0010:[<ffffffff88379605>]  [<ffffffff88379605>] copy_user_enhanced_fast_string+0x5/0x10
> RSP: 0018:ffff880220eb7ef0  EFLAGS: 00010283
> RAX: ffff880220eb4000 RBX: ffffffff887dac64 RCX: 0000000000006a18
> RDX: 000000000000e02f RSI: 00007f766f466620 RDI: ffff88016f6a7617
> RBP: ffff880220eb7f78 R08: 8000000000000063 R09: 0000000000000004
> R10: 0000000000000010 R11: 0000000000000000 R12: ffffffff880bf50d
> R13: 0000000000000001 R14: ffff880220eb4000 R15: 0000000000000001
> FS:  00007f766f459740(0000) GS:ffff880244400000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f766f461000 CR3: 000000018b00e000 CR4: 00000000001407e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> Stack:
>  ffffffff882f4225 ffff880183db5a00 0000000001743440 00007f766f0fb000
>  fffffffffffffeff 0000000000000000 0000000000008d79 00007f766f45f000
>  ffffffff8837adae 00ff880220eb7f38 000000003203f1ac 0000000000000001
> Call Trace:
>  [<ffffffff882f4225>] ? SyS_add_key+0xd5/0x240
>  [<ffffffff8837adae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff887da092>] system_call_fastpath+0x12/0x17
> Code: 48 ff c6 48 ff c7 ff c9 75 f2 89 d1 c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 31 c0 0f 1f 00 c3 0f 1f 80 00 00 00 00 0f 1f 00 89 d1 <f3> a4 31 c0 0f 1f 00 c3 90 90 90 0f 1f 00 83 fa 08 0f 82 95 00 
> sending NMI to other CPUs:
> 
> 
> Here's a crappy phonecam pic of the screen. 
> http://codemonkey.org.uk/junk/IMG_4311.jpg
> There's a bit of trace missing between the above and what was on
> the screen, so we missed some CPUs.

I'm not sure if this is useful, but I've been seeing trinity lockups
on arm64 as well. Sometimes they happen a few times a day, sometimes it
takes a few days (I just saw my first one on -rc6, for example).

However, I have a little bit more trace than you do and *every single time*
the lockup has involved an execve to a virtual file system.

E.g.:

[child1:10700] [212] execve(name="/sys/fs/ext4/features/batched_discard", argv=0x91796a0, envp=0x911a9c0)

(I've seen cases with /proc too)

The child doing the execve then doesn't return an error from the syscall,
and instead seems to disappear from the face of the planet, sometimes with
the tasklist_lock held for write, which causes a lockup shortly afterwards.

I'm running under KVM with two virtual CPUs. When the machine is wedged,
one CPU is sitting in idle and the other seems to be kicking around do_wait
and pid_vnr, but it's difficult to really see what's going on.

I tried increasing the likelihood of execve syscalls in trinity, but it
didn't seem to help with reproducing this issue.

Will
