Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaKXVCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:02:43 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:47532 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaKXVCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:02:41 -0500
MIME-Version: 1.0
In-Reply-To: <54739AB2.8030002@de.ibm.com>
References: <1416834210-61738-1-git-send-email-borntraeger@de.ibm.com>
	<1416834210-61738-8-git-send-email-borntraeger@de.ibm.com>
	<15567.1416835858@warthog.procyon.org.uk>
	<CAADnVQJQydX9OU_rem+BObR0eWc-jrrwirUYVKH9rnN=Z8LG6A@mail.gmail.com>
	<CA+55aFxc72VsGTw4yFdeC1Sq65RUjYLKPD1ORnXB2d18WBMzvg@mail.gmail.com>
	<547381D7.2070404@de.ibm.com>
	<12209.1416859494@warthog.procyon.org.uk>
	<CA+55aFwHJyyo1y=-u=t798PFTeZN796hnwd9-XzEnL=JaqVmDw@mail.gmail.com>
	<54739AB2.8030002@de.ibm.com>
Date: Mon, 24 Nov 2014 13:02:40 -0800
X-Google-Sender-Auth: iGAM9Dek7rCxZSQwaUfuyO9KGDY
Message-ID: <CA+55aFz2bCbhQP3d1bh48AcWTh9bkoMO07JjmwbApGCanJFEMQ@mail.gmail.com>
Subject: Re: [PATCH/RFC 7/7] kernel: Force ACCESS_ONCE to work only on scalar types
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Howells <dhowells@redhat.com>,
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

On Mon, Nov 24, 2014 at 12:53 PM, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
>
> That looks like a lot of changes all over ACCESS_ONCE -> ASSIGN_ONCE:
> git grep "ACCESS_ONCE.*=.*"
> gives me 200 placea not in Documentation.

Yeah, that's a bit annoying.

How about a combination of the two:

 - accept the fact that right now ACCESS_ONCE() is fairly widespread
(even for writing)

 - but also admit that we'd be better off with a nicer interface

and make the solution be:

 - make ACCESS_ONCE() only work on scalars, and deprecate it

 - add new "read_once()" and "write_once()" interfaces that *do* work
on (appropriately sized) structures and unions, and start migrating
things over. In particular, start with the ones that can no longer use
ACCESS_ONCE() because they aren't scalar..

That second point would make the conversion patches actually easier to
read. Instead of this:

 static inline int arch_spin_is_locked(arch_spinlock_t *lock)
 {
-       struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
+       arch_spinlock_t tmp = {};

-       return tmp.tail != tmp.head;
+       tmp.head_tail =ACCESS_ONCE(lock->head_tail);
+       return tmp.tickets.tail != tmp.tickets.head;
 }

which isn't *complex*, but is also not an obvious conversion, we'd have just

 static inline int arch_spin_is_locked(arch_spinlock_t *lock)
 {
-       struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
-       struct __raw_tickets tmp = read_once(lock->tickets);

        return tmp.tail != tmp.head;
 }

which is a much simpler and more obvious change.

And then we could slowly try to migrate existing ACCESS_ONCE() users
over (particularly writers).

Hmm? Too much?

                     Linus
