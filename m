Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbaKSVs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:48:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756174AbaKSVsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:48:22 -0500
Date: Wed, 19 Nov 2014 16:47:43 -0500
From: Dave Jones <davej@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141119214743.GA18883@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Don Zickus <dzickus@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	the arch/x86 maintainers <x86@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
References: <CA+55aFy65SmGXFeosNqvrgx+P6JQLrzpEYuwXdyeWtZwZsKxZg@mail.gmail.com>
 <20141118023930.GA2871@redhat.com>
 <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
 <20141118145234.GA7487@redhat.com>
 <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com>
 <20141119021902.GA14216@redhat.com>
 <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
 <20141119145902.GA13387@redhat.com>
 <546D0530.8040800@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546D0530.8040800@mit.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 01:01:36PM -0800, Andy Lutomirski wrote:
 
 > TIF_NOHZ is not the same thing as NOHZ.  Can you try a kernel with
 > CONFIG_CONTEXT_TRACKING=n?  Doing that may involve fiddling with RCU
 > settings a bit.  The normal no HZ idle stuff has nothing to do with
 > TIF_NOHZ, and you either have TIF_NOHZ set or you have some kind of
 > thread_info corruption going on here.

I'll try that next.

 > > RSP: 0018:ffff880192d2fee8  EFLAGS: 00000246
 > > RAX: 0000000000000000 RBX: 0000000100000046 RCX: 000000336ee35b47
 > 
 >                                     ^^^^^^^^^
 > 
 > That is a strange coincidence.  Where did 0x46 | (1<<32) come from?
 > That's a sensible interrupts-disabled flags value with the high part set
 > to 0x1.  Those high bits are undefined, but they ought to all be zero.

This box is usually pretty solid, but it's been in service as a 24/7
fuzzing box for over a year now, so it's not outside the realm of
possibility that this could all be a hardware fault if some memory
has gone bad or the like.  Unless we find something obvious in the
next few days, I'll try running memtest over the weekend (though
I've seen situations where that doesn't stress hardware enough to
manifest a problem, so it might not be entirely conclusive unless
it actually finds a fault).

I wish I had a second identical box to see if it would be reproducible.

 > >  [<ffffffff941689c6>] perf_read+0x226/0x370
 > >  [<ffffffff942fbfb7>] ? security_file_permission+0x87/0xa0
 > >  [<ffffffff941eafff>] vfs_read+0x9f/0x180
 > >  [<ffffffff941ebbd8>] SyS_read+0x58/0xd0
 > >  [<ffffffff947d42c9>] tracesys_phase2+0xd4/0xd9
 > 
 > Riddle me this: what are we doing in tracesys_phase2?  This is a full
 > slow-path syscall.  TIF_NOHZ doesn't cause that, I think.  I'd love to
 > see the value of ti->flags here.  Is trinity using ptrace?
 
That's one of the few syscalls we actually blacklist (mostly because it
requires some more thinking: just passing it crap can get the fuzzer
into a confused state where it thinks child processes are dead, when
they aren't etc).  So it shouldn't be calling ptrace ever.

	Dave

