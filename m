Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750942AbaKXUei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:34:38 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:55686 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaKXUeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:34:36 -0500
MIME-Version: 1.0
In-Reply-To: <12209.1416859494@warthog.procyon.org.uk>
References: <1416834210-61738-1-git-send-email-borntraeger@de.ibm.com>
	<1416834210-61738-8-git-send-email-borntraeger@de.ibm.com>
	<15567.1416835858@warthog.procyon.org.uk>
	<CAADnVQJQydX9OU_rem+BObR0eWc-jrrwirUYVKH9rnN=Z8LG6A@mail.gmail.com>
	<CA+55aFxc72VsGTw4yFdeC1Sq65RUjYLKPD1ORnXB2d18WBMzvg@mail.gmail.com>
	<547381D7.2070404@de.ibm.com>
	<12209.1416859494@warthog.procyon.org.uk>
Date: Mon, 24 Nov 2014 12:34:35 -0800
X-Google-Sender-Auth: VActRMrBy4irOfx9ZVi3KcHXGRQ
Message-ID: <CA+55aFwHJyyo1y=-u=t798PFTeZN796hnwd9-XzEnL=JaqVmDw@mail.gmail.com>
Subject: Re: [PATCH/RFC 7/7] kernel: Force ACCESS_ONCE to work only on scalar types
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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

On Mon, Nov 24, 2014 at 12:04 PM, David Howells <dhowells@redhat.com> wrote:
>
> Reserve ACCESS_ONCE() for reading and add an ASSIGN_ONCE() or something like
> that for writing?

I wouldn't mind that. We've had situations where reading and writing
isn't really similar - like alpha where reading a byte is atomic, but
writing one isn't.

Then we could also make it have the "get_user()/put_user()" kind of
semantics - .and then use the same "sizeopf()" tricks that we use for
get_user/put_user.

That would actually work around the gcc bug a completely different way:

  #define ACCESS_ONCE(p) \
      ({ typeof(*p) __val; __read_once_size(p, &__val, sizeof(__val)); __val; })

and then we can do things like this:

  static __always_inline void __read_once_size(volatile void *p, void
*res, int size)
  {
       switch (size) {
       case 1: *(u8 *)res = *(volatile u8 *)p; break;
       case 2: *(u16 *)res = *(volatile u16 *)p; break;
       case 4: *(u32 *)res = *(volatile u32 *)p; break;
#ifdef CONFIG_64BIT
       case 8: *(u64 *)res = *(volatile u64 *)p; break;
#endif
       }
  }

and same for ASSIGN_ONCE(val, p).

That also hopefully avoids the whole "oops, gcc has a bug", because
the actual volatile access is always done using a scalar type, even if
the type of "__val" may in fact be a structure.

Christian, how painful would that be? Sorry to try to make you do a
totally different approach..

                  Linus
