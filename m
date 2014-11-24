Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750866AbaKXUxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:53:16 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:39468 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaKXUxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:53:13 -0500
Message-ID: <54739AB2.8030002@de.ibm.com>
Date: Mon, 24 Nov 2014 21:53:06 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
CC: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        linux-mips <linux-mips@linux-mips.org>, linux-x86_64@vger.kernel.org,
        linux-s390 <linux-s390@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH/RFC 7/7] kernel: Force ACCESS_ONCE to work only on scalar
 types
References: <1416834210-61738-1-git-send-email-borntraeger@de.ibm.com> <1416834210-61738-8-git-send-email-borntraeger@de.ibm.com> <15567.1416835858@warthog.procyon.org.uk> <CAADnVQJQydX9OU_rem+BObR0eWc-jrrwirUYVKH9rnN=Z8LG6A@mail.gmail.com> <CA+55aFxc72VsGTw4yFdeC1Sq65RUjYLKPD1ORnXB2d18WBMzvg@mail.gmail.com> <547381D7.2070404@de.ibm.com>	<12209.1416859494@warthog.procyon.org.uk> <CA+55aFwHJyyo1y=-u=t798PFTeZN796hnwd9-XzEnL=JaqVmDw@mail.gmail.com>
In-Reply-To: <CA+55aFwHJyyo1y=-u=t798PFTeZN796hnwd9-XzEnL=JaqVmDw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112420-0025-0000-0000-0000028E3310
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.11.2014 um 21:34 schrieb Linus Torvalds:
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
> 
> Christian, how painful would that be? Sorry to try to make you do a
> totally different approach..

That looks like a lot of changes all over ACCESS_ONCE -> ASSIGN_ONCE:
git grep "ACCESS_ONCE.*=.*" 
gives me 200 placea not in Documentation.

Then there is still the 64bit accesses on 32bit via ACCESS_ONCE problem, which we could detect with a default cause in your code. We would need to audit and fix all places :-/


So the last proposal from Alexei, seems easier (for me at least :-) )

