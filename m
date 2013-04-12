Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab3DLL0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 07:26:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47224 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938Ab3DLL0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 07:26:34 -0400
Date: Fri, 12 Apr 2013 13:26:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86, FPU: Fix FPU initialization
Message-ID: <20130412112628.GB2368@pd.tnic>
References: <20130410133251.GC6857@pd.tnic>
 <516586CF.90909@zytor.com>
 <20130410161122.GI6857@pd.tnic>
 <20130410212950.GA6899@pd.tnic>
 <20130411120952.GA18879@gmail.com>
 <51670E51.6020106@zytor.com>
 <20130411202328.GA15955@pd.tnic>
 <20130412053234.GB3887@gmail.com>
 <f3a4fce2-090e-4a08-b05c-0281a95e8943@email.android.com>
 <20130412094724.GA2368@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130412094724.GA2368@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 11:47:24AM +0200, Borislav Petkov wrote:
> On Thu, Apr 11, 2013 at 10:34:48PM -0700, H. Peter Anvin wrote:
> > >The lockup went away after excluding x86/cpu. I'll try more testing
> > >as time permits.
> 
> Right,
> 
> so tip:x86/cpu has all in all 11 patches. Maybe a quick bisect?

Ok, some more info. decodecoding your "Code:" section gives this (yep,
all the instruction bytes were repeated so I could've made a mistake
there while removing the duplicates):

[ 15.921486] Code: 00 83 3d c0 14 d0 41 00 0f 85 18 05 00 00 ba 34 03 00 00 b8 cb e0 4e 41 e8 ee 74 fb ff e9 04 05 00 00 85 db 0f 84 fc 04 00 00 90 <3e> ff 83 04 01 00 00 a1 48 48 77 41 8b b7 5c 03 00 00 85 c0 0f
All code
========
   0:   00 83 3d c0 14 d0       add    %al,-0x2feb3fc3(%rbx)
   6:   41 00 0f                add    %cl,(%r15)
   9:   85 18                   test   %ebx,(%rax)
   b:   05 00 00 ba 34          add    $0x34ba0000,%eax
  10:   03 00                   add    (%rax),%eax
  12:   00 b8 cb e0 4e 41       add    %bh,0x414ee0cb(%rax)
  18:   e8 ee 74 fb ff          callq  0xfffffffffffb750b
  1d:   e9 04 05 00 00          jmpq   0x526
  22:   85 db                   test   %ebx,%ebx
  24:   0f 84 fc 04 00 00       je     0x526
  2a:   90                      nop
  2b:*  3e ff 83 04 01 00 00    incl   %ds:0x104(%rbx)     <-- trapping instruction
  32:   a1 48 48 77 41 8b b7    movabs 0x35cb78b41774848,%eax
  39:   5c 03 
  3b:   00 00                   add    %al,(%rax)
  3d:   85 c0                   test   %eax,%eax
  3f:

Now, if I look at __lock_acquire objdump here, I get:

    2688:       31 c0                   xor    %eax,%eax
    268a:       e9 49 0b 00 00          jmp    31d8 <__lock_acquire+0xba6>
    268f:       8b 4d c4                mov    -0x3c(%ebp),%ecx
    2692:       8b 44 91 04             mov    0x4(%ecx,%edx,4),%eax
    2696:       85 c0                   test   %eax,%eax
    2698:       75 0e                   jne    26a8 <__lock_acquire+0x76>
    269a:       8b 45 c4                mov    -0x3c(%ebp),%eax
    269d:       31 c9                   xor    %ecx,%ecx
    269f:       e8 12 e5 ff ff          call   bb6 <register_lock_class>
    26a4:       85 c0                   test   %eax,%eax
    26a6:       74 e0                   je     2688 <__lock_acquire+0x56>
    26a8:       ff 80 04 01 00 00       incl   0x104(%eax)			<---
    26ae:       8b 96 68 03 00 00       mov    0x368(%esi),%edx

which can be correlated with a lot of fuzz but the INC seems to look
the same and the offset within __lock_acquire is almost in the same
vicinity.

Which looks like this snippet here:

.L752:
        movl    -60(%ebp), %eax # %sfp,
        xorl    %ecx, %ecx      #
        call    register_lock_class     #
        testl   %eax, %eax      # class
        je      .L970   #,
.L753:
#APP
# 95 "/w/kernel/linux-2.6/arch/x86/include/asm/atomic.h" 1
        incl 260(%eax)  # MEM[(struct atomic_t *)D.29327_54].counter		<---
# 0 "" 2
#NO_APP

and this has to be:

	/*
	 * Not cached?
	 */
	if (unlikely(!class)) {
		class = register_lock_class(lock, subclass, 0);
		if (!class)
			return 0;
	}
	atomic_inc((atomic_t *)&class->ops);					<---


So looking at the decode above, we have the class pointer in %ebx
(decodecode somehow can't differentiate between 32- and 64-bit code
dump, probably needs a flag or so) and it is 0x00003f76. Which doesn't
look like a valid kernel pointer to me.

And 0x00003f76 + 0x104 gives exactly 0x0000407a which is the address at
which we #PF:

[   15.921486] BUG: unable to handle kernel paging request at 0000407a
[   15.921486] IP: [<41071ab0>] __lock_acquire.isra.19+0x3e0/0xb00

More hmmm...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
