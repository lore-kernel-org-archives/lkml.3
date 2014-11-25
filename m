Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaKYC2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 21:28:07 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:50700 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaKYC2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 21:28:05 -0500
MIME-Version: 1.0
Date: Mon, 24 Nov 2014 18:28:03 -0800
Message-ID: <CAADnVQJc-RO9EdBY2-Q0mONSLYxsryD3cP8+LPXTaKbjbqtvtg@mail.gmail.com>
Subject: Re: [PATCH/RFC 7/7] kernel: Force ACCESS_ONCE to work only on scalar types
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        linux-mips <linux-mips@linux-mips.org>, linux-x86_64@vger.kernel.org,
        linux-s390 <linux-s390@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 4:00 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Nov 24, 2014 at 2:58 PM, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>
>> I've changed gcc pr58145-1.c reproducer to use
>> __read_once_size() approach above
>
> I don't think you did.
>
>> modified reproducer:
>> struct S { unsigned int data; };
>> void bar(int val)
>> {
>>   struct S _s = { .data = val };
>>   *(volatile struct S *) 0x880000UL = ACCESS_ONCE(&_s);
>> }
>
> My approach never had "volatile struct S *". The only volatile
> pointers were the actual byte/word/etc pointers, and those generated

you're right. In my invalid snippet above the ACCESS_ONCE
to struct on stack gets optimized away and only 'volatile struct *'
in left hand side is triggering the bug.

Have tried the following which blends your proposal
with original code from Christian:
/* bad
#define ACCESS_ONCE(x) *((volatile typeof(x) *)&(x))
*/

/* good */
#define ACCESS_ONCE(p) \
      ({ typeof(*p) __val; __read_once_size(p, &__val, sizeof(__val)); __val; })

static __always_inline void __read_once_size(volatile void *p, void
*res, int size)
{
     switch (size) {
     case 1: *(u8 *)res = *(volatile u8 *)p; break;
     case 2: *(u16 *)res = *(volatile u16 *)p; break;
     case 4: *(u32 *)res = *(volatile u32 *)p; break;
     case 8: *(u64 *)res = *(volatile u64 *)p; break;
     }
}

union ipte_control {
        unsigned long val;
        struct {
                unsigned long k  : 1;
                unsigned long kh : 31;
                unsigned long kg : 32;
        };
};

struct kvm_vcpu {
        union ipte_control ic;
};

void ipte_unlock_siif(struct kvm_vcpu *vcpu)
{
        union ipte_control old, new, *ic;

        ic = &vcpu->ic;
        do {
                new = old = ACCESS_ONCE(ic);
                new.kh--;
                if (!new.kh)
                        new.k = 0;
        } while (cmpxchg(&ic->val, old.val, new.val) != old.val);
}

generated code looks correct with and without strict-aliasing
and volatile marking is preserved properly.
(to check for volatile marks add -fdump-tree-optimized
 and look for {v} in *.optimized)

> Pretty? No. But then, the standard C aliasing rules are so broken that
> "pretty" doesn't really come into play..

Agree. I don't see any warnings or code generation issues with and
without strict-aliasing with your original __read_once_size(), so no need
to play union tricks. Initially I was worried that extra always_inline
function will make generated code worse in critical paths where
ACCESS_ONCE is used, but after looking close enough, it seems
all should be fine.

Note, with unmodified ACCESS_ONCE all architectures (even x64)
are missing volatile markings with gcc 4.6.3, 4.7.2 for Christian's
use case.
