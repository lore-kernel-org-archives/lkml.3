Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbaKXW6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:58:15 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:63154 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaKXW6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:58:11 -0500
MIME-Version: 1.0
Date: Mon, 24 Nov 2014 14:58:08 -0800
Message-ID: <CAADnVQ+8d0GC5OwQTdJKkmG8=vshUVqK1pPou1GCGa_iuU2v-g@mail.gmail.com>
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

On Mon, Nov 24, 2014 at 12:34 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Nov 24, 2014 at 12:04 PM, David Howells <dhowells@redhat.com> wrote:
>>
>> Reserve ACCESS_ONCE() for reading and add an ASSIGN_ONCE() or something like
>> that for writing?
>
> I wouldn't mind that. We've had situations where reading and writing
> isn't really similar - like alpha where reading a byte is atomic, but
> writing one isn't.
>
> Then we could also make it have the "get_user()/put_user()" kind of
> semantics - .and then use the same "sizeopf()" tricks that we use for
> get_user/put_user.
>
> That would actually work around the gcc bug a completely different way:
>
>   #define ACCESS_ONCE(p) \
>       ({ typeof(*p) __val; __read_once_size(p, &__val, sizeof(__val)); __val; })
>
> and then we can do things like this:
>
>   static __always_inline void __read_once_size(volatile void *p, void
> *res, int size)
>   {
>        switch (size) {
>        case 1: *(u8 *)res = *(volatile u8 *)p; break;
>        case 2: *(u16 *)res = *(volatile u16 *)p; break;
>        case 4: *(u32 *)res = *(volatile u32 *)p; break;
> #ifdef CONFIG_64BIT
>        case 8: *(u64 *)res = *(volatile u64 *)p; break;
> #endif
>        }
>   }
>
> and same for ASSIGN_ONCE(val, p).
>
> That also hopefully avoids the whole "oops, gcc has a bug", because
> the actual volatile access is always done using a scalar type, even if
> the type of "__val" may in fact be a structure.

I've changed gcc pr58145-1.c reproducer to use
__read_once_size() approach above, but it
didn't help to workaround the bug.
gcc 'sra' pass still lost 'volatile' modifier.

modified reproducer:
struct S { unsigned int data; };
void bar(int val)
{
  struct S _s = { .data = val };
  *(volatile struct S *) 0x880000UL = ACCESS_ONCE(&_s);
}
assembler code looks as expected, but
internal gcc state after 'sra' pass is
missing volatile...
