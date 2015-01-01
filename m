Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbbAAVaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 16:30:06 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:61697 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbbAAVaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 16:30:04 -0500
Date: Thu, 1 Jan 2015 22:23:42 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] One more vdso fix for 3.19
Message-ID: <20150101212342.GA26239@gmail.com>
References: <CALCETrWHcme9hyROr-bDcutzGR7ZLFCo0iNp5j4tkDPuxt09Og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWHcme9hyROr-bDcutzGR7ZLFCo0iNp5j4tkDPuxt09Og@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@amacapital.net> wrote:

> Hi Ingo et al,
> 
> Please consider pulling for x86/urgent.
> 
> Thanks,
> Andy
> 
> 
> The following changes since commit 394f56fe480140877304d342dec46d50dc823d46:
> 
>   x86_64, vdso: Fix the vdso address randomization algorithm
> (2014-12-20 16:56:57 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git
> tags/pr-20141223-x86-vdso
> 
> for you to fetch changes up to 1ddf0b1b11aa8a90cef6706e935fc31c75c406ba:
> 
>   x86, vdso: Use asm volatile in __getcpu (2014-12-23 13:05:30 -0800)
> 
> ----------------------------------------------------------------
> This is hopefully the last vdso fix for 3.19.  It should be very
> safe (it just adds a volatile).
> 
> I don't think it fixes an actual bug (the __getcpu calls in the
> pvclock code may not have been needed in the first place), but
> discussion on that point is ongoing.
> 
> It also fixes a big performance issue in 3.18 and earlier in which
> the lsl instructions in vclock_gettime got hoisted so far up the
> function that they happened even when the function they were in was
> never called.  n 3.19, the performance issue seems to be gone due to
> the whims of my compiler and some interaction with a branch that's
> now gone.
> 
> I'll hopefully have a much bigger overhaul of the pvclock code
> for 3.20, but it needs careful review.
> 
> ----------------------------------------------------------------
> Andy Lutomirski (1):
>       x86, vdso: Use asm volatile in __getcpu
> 
>  arch/x86/include/asm/vgtod.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Pulled into tip:x86/urgent, thanks Andy!

I've attached the full commit below - I'm not sure it was sent to 
lkml.

Thanks,

	Ingo

====================>
>From 1ddf0b1b11aa8a90cef6706e935fc31c75c406ba Mon Sep 17 00:00:00 2001
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 21 Dec 2014 08:57:46 -0800
Subject: [PATCH] x86, vdso: Use asm volatile in __getcpu

In Linux 3.18 and below, GCC hoists the lsl instructions in the
pvclock code all the way to the beginning of __vdso_clock_gettime,
slowing the non-paravirt case significantly.  For unknown reasons,
presumably related to the removal of a branch, the performance issue
is gone as of

e76b027e6408 x86,vdso: Use LSL unconditionally for vgetcpu

but I don't trust GCC enough to expect the problem to stay fixed.

There should be no correctness issue, because the __getcpu calls in
__vdso_vlock_gettime were never necessary in the first place.

Note to stable maintainers: In 3.18 and below, depending on
configuration, gcc 4.9.2 generates code like this:

     9c3:       44 0f 03 e8             lsl    %ax,%r13d
     9c7:       45 89 eb                mov    %r13d,%r11d
     9ca:       0f 03 d8                lsl    %ax,%ebx

This patch won't apply as is to any released kernel, but I'll send a
trivial backported version if needed.

Fixes: 51c19b4f5927 x86: vdso: pvclock gettime support
Cc: stable@vger.kernel.org # 3.8+
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/vgtod.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index e7e9682a33e9..f556c4843aa1 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -80,9 +80,11 @@ static inline unsigned int __getcpu(void)
 
 	/*
 	 * Load per CPU data from GDT.  LSL is faster than RDTSCP and
-	 * works on all CPUs.
+	 * works on all CPUs.  This is volatile so that it orders
+	 * correctly wrt barrier() and to keep gcc from cleverly
+	 * hoisting it out of the calling function.
 	 */
-	asm("lsl %1,%0" : "=r" (p) : "r" (__PER_CPU_SEG));
+	asm volatile ("lsl %1,%0" : "=r" (p) : "r" (__PER_CPU_SEG));
 
 	return p;
 }
