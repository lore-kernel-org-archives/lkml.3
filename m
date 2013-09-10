Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab3IJQpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:45:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51835 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab3IJQpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:45:34 -0400
Date: Tue, 10 Sep 2013 18:45:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Peter Anvin <hpa@zytor.com>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 0/7] preempt_count rework -v2
Message-ID: <20130910164519.GL31370@twins.programming.kicks-ass.net>
References: <20130910130811.507933095@infradead.org>
 <20130910135152.GD7537@gmail.com>
 <20130910135636.GA8268@gmail.com>
 <CA+55aFwmEQeF+PtM7cuaQ8OkuTS=R4JJ61Wwfv8u-Svo-V3KwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwmEQeF+PtM7cuaQ8OkuTS=R4JJ61Wwfv8u-Svo-V3KwQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 09:34:52AM -0700, Linus Torvalds wrote:
> On Tue, Sep 10, 2013 at 6:56 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > +static __always_inline bool __preempt_count_dec_and_test(void)
> > +{
> > +       unsigned char c;
> > +
> > +       asm ("decl " __percpu_arg(0) "; sete %1"
> > +                       : "+m" (__preempt_count), "=qm" (c));
> > +
> > +       return c != 0;
> > +}
> >
> > And that's where the sete and test originates from.
> 
> We could make this use "asm goto" instead.
> 
> An "asm goto" cannot have outputs, but this particular one doesn't
> _need_ outputs. You could mark the preempt_count memory as an input,
> and then have a memory clobber. I think you need the memory clobber
> anyway for that preempt-count thing.
> 
> So I _think_ something like
> 
> static __always_inline bool __preempt_count_dec_and_test(void)
> {
>        asm goto("decl " __percpu_arg(0) "\n\t"
>                 "je %l[became_zero]"
>                        : :"m" (__preempt_count):"memory":became_zero);
>        return 0;
> became_zero:
>        return 1;
> }

The usage site:

#define preempt_enable() \
do { \
	barrier(); \
	if (unlikely(preempt_count_dec_and_test())) \
		__preempt_schedule(); \
} while (0)

Already includes the barrier explicitly, so do we still need the memory
clobber in that asm goto thing?

That said, your change results in:

  ffffffff8106f420 <kick_process>:
  ffffffff8106f420:       55                      push   %rbp
  ffffffff8106f421:       65 ff 04 25 e0 b7 00    incl   %gs:0xb7e0
  ffffffff8106f428:       00 
  ffffffff8106f429:       48 89 e5                mov    %rsp,%rbp
  ffffffff8106f42c:       48 8b 47 08             mov    0x8(%rdi),%rax
  ffffffff8106f430:       8b 50 18                mov    0x18(%rax),%edx
  ffffffff8106f433:       65 8b 04 25 1c b0 00    mov    %gs:0xb01c,%eax
  ffffffff8106f43a:       00 
  ffffffff8106f43b:       39 c2                   cmp    %eax,%edx
  ffffffff8106f43d:       74 1b                   je     ffffffff8106f45a <kick_process+0x3a>
  ffffffff8106f43f:       89 d1                   mov    %edx,%ecx
  ffffffff8106f441:       48 c7 c0 00 2c 01 00    mov    $0x12c00,%rax
  ffffffff8106f448:       48 8b 0c cd a0 bc cb    mov    -0x7e344360(,%rcx,8),%rcx
  ffffffff8106f44f:       81 
  ffffffff8106f450:       48 3b bc 08 00 08 00    cmp    0x800(%rax,%rcx,1),%rdi
  ffffffff8106f457:       00 
  ffffffff8106f458:       74 26                   je     ffffffff8106f480 <kick_process+0x60>
* ffffffff8106f45a:       65 ff 0c 25 e0 b7 00    decl   %gs:0xb7e0
  ffffffff8106f461:       00 
* ffffffff8106f462:       74 0c                   je     ffffffff8106f470 <kick_process+0x50>
  ffffffff8106f464:       5d                      pop    %rbp
  ffffffff8106f465:       c3                      retq   
  ffffffff8106f466:       66 2e 0f 1f 84 00 00    nopw   %cs:0x0(%rax,%rax,1)
  ffffffff8106f46d:       00 00 00 
* ffffffff8106f470:       e8 9b b6 f9 ff          callq  ffffffff8100ab10 <___preempt_schedule>
  ffffffff8106f475:       5d                      pop    %rbp
  ffffffff8106f476:       c3                      retq   
  ffffffff8106f477:       66 0f 1f 84 00 00 00    nopw   0x0(%rax,%rax,1)
  ffffffff8106f47e:       00 00 
  ffffffff8106f480:       89 d7                   mov    %edx,%edi
  ffffffff8106f482:       ff 15 b8 e0 ba 00       callq  *0xbae0b8(%rip)        # ffffffff81c1d540 <smp_ops+0x20>
  ffffffff8106f488:       eb d0                   jmp    ffffffff8106f45a <kick_process+0x3a>
  ffffffff8106f48a:       66 0f 1f 44 00 00       nopw   0x0(%rax,%rax,1)


Which is indeed perfect. So should I go 'fix' the other _and_test()
functions we have to do this same thing?
