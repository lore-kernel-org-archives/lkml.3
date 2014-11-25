Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100AbaKYABA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 19:01:00 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:34041 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaKYAA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 19:00:56 -0500
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+8d0GC5OwQTdJKkmG8=vshUVqK1pPou1GCGa_iuU2v-g@mail.gmail.com>
References: <CAADnVQ+8d0GC5OwQTdJKkmG8=vshUVqK1pPou1GCGa_iuU2v-g@mail.gmail.com>
Date: Mon, 24 Nov 2014 16:00:55 -0800
X-Google-Sender-Auth: cuY7Gag83mM6hOzeo1qXLwUmmC0
Message-ID: <CA+55aFyktcMZnQHqoaCePgJVXmbi=9pTS_jz7j+j=QDuSoSFoA@mail.gmail.com>
Subject: Re: [PATCH/RFC 7/7] kernel: Force ACCESS_ONCE to work only on scalar types
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
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

On Mon, Nov 24, 2014 at 2:58 PM, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> I've changed gcc pr58145-1.c reproducer to use
> __read_once_size() approach above

I don't think you did.

> modified reproducer:
> struct S { unsigned int data; };
> void bar(int val)
> {
>   struct S _s = { .data = val };
>   *(volatile struct S *) 0x880000UL = ACCESS_ONCE(&_s);
> }

My approach never had "volatile struct S *". The only volatile
pointers were the actual byte/word/etc pointers, and those generated
temporary values that were then assigned to the final type through a
cast.

Also, note that the kernel is compiled without strict aliasing, so the
casting to 'void *' and various smaller types is "safe" - even if the
C standard doesn't like it.

With strict aliasing, you'd need to make the read_once() macro not
just pass in the size, there would have to be some kind of union of
the type, and that would effectively mean that you can't use an inline
function, you'd have to do it in a big macro (because the type would
be per-site).

So with strict aliasing, you'd have to make it something like

        #define ACCESS_ONCE(p) \
      ({ union { typeof(*p) __val; char __array[sizeof(*p)]} __u;
__read_once_size(p, __u.__array, sizeof(__u)); __u.__val; })

Pretty? No. But then, the standard C aliasing rules are so broken that
"pretty" doesn't really come into play..

                  Linus
