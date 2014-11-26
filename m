Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaKZBsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 20:48:17 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:53034 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbaKZBsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 20:48:16 -0500
MIME-Version: 1.0
In-Reply-To: <20141126002501.GA11752@redhat.com>
References: <20141114213124.GB3344@redhat.com>
	<CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
	<20141115213405.GA31971@redhat.com>
	<20141116014006.GA5016@redhat.com>
	<CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
	<20141126002501.GA11752@redhat.com>
Date: Tue, 25 Nov 2014 17:48:15 -0800
X-Google-Sender-Auth: fRnxX3CSZRUgCpi9xa1c7olX6SE
Message-ID: <CA+55aFy9c2FY2gDw14VU537QJoLHAbf+q_75VUwU33_HLz+F0w@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 4:25 PM, Dave Jones <davej@redhat.com> wrote:
>
> The reason I'm checking in at this point, is that I'm starting to see different
> bugs at this point, so I don't know if I can call this good or bad, unless
> someone has a fix for what I'm seeing now.

Hmm. The three last "bad" biisects are all just 3.17-rc1 plus staging fixes.

> Reminiscent of a bug a couple releases ago. Processes about to exit, but stuck
> in the kernel continuously faulting..
> http://codemonkey.org.uk/junk/weird-hang.txt
> The one I'm thinking of got fixed way before 3.17 though.

Well, the staging tree was based on that 3.17-rc1 tree, so it may well
have the bug without the fix.

You have also marked 3.18-rc1 bad *twice*, along with the network
merge, and the tty merge. That's just odd. But it doesn't make the
bisect wrong, it just means that you fat-fingered thing and marked the
same thing bad a couple of times.

Nothing to worry about, unless it's a sign of early Parkinsons...

> Does that trace ring a bell of something else I could try on top of
> each bisection point ?

Hmm.

Smells somewhat like the "pipe/page fault oddness" bug you reported.

That one caused endless page faults on fault_in_pages_writeable()
because of a page table entry that the VM thought was present, but the
CPU thought was missing.

That caused the whole "pte_protnone()" thing, and trying to get rid of
the PTE_NUMA bit, but those patches have *not* been merged. And you
were ever able to reproduce it., so we left it as pending.

But if you actually really think that the bisect log you posted is
real and true and actually is the bug you're chasing, I have bad news
for you: do a "gitk --bisect", and you'll see that all the remaining
commits are just to staging drivers.

So that would either imply you have some staging driver (unlikely), or
more likely that 3.17 really already has the problem, it's just that
it needs some particular code alignment or phase of the moon or
something to trigger.

                 Linus
