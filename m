Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab3H3Pes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 11:34:48 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:50579 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab3H3Per (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 11:34:47 -0400
MIME-Version: 1.0
In-Reply-To: <CA+icZUUDKExRW3iNXj6jTs8A4DwQNaWvPuUfV5_ExXNPzq=+rA@mail.gmail.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	<1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	<1377751465.4028.20.camel@pasglop>
	<20130829070012.GC27322@gmail.com>
	<CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
	<CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	<CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
	<52200DAE.2020303@hp.com>
	<CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com>
	<CA+icZUX3zQEWDoaXk0RMKmbQhDRo0Z7jGZ=9tJu1gZWvGodMkg@mail.gmail.com>
	<CA+icZUUDKExRW3iNXj6jTs8A4DwQNaWvPuUfV5_ExXNPzq=+rA@mail.gmail.com>
Date: Fri, 30 Aug 2013 08:34:46 -0700
X-Google-Sender-Auth: vDaXpXhKL9JR0uyhcSKE6bmaUNQ
Message-ID: <CA+55aFxvEjdEFK0dXn783eVN0PEXVhb5k8OnrbxSWDpXgyTwWw@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Waiman Long <waiman.long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 2:27 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> Here on Ubuntu/precise v12.04.3 AMD64 I get these numbers for total loops:
>
> lockref:  w/o patch | w/ patch
> ======================
> Run #1: 2.688.094 | 2.643.004
> Run #2: 2.678.884 | 2.652.787
> Run #3: 2.686.450 | 2.650.142
> Run #4: 2.688.435 | 2.648.409
> Run #5: 2.693.770 | 2.651.514

Yes, so this is pretty much expected.

If you don't have a very high core count (you don't mention your
system, but that's pretty - I get ~65 million repetitions in 10
seconds on my i5-670), the cmpxchg will not help - because you don't
actually see the bad "wait on spinlock" behavior in the first place.

And a "cmpxchg" is slightly slower than the very optimized spinlocks,
and has that annoying "read original value" first issue too. So the
patch can make things a bit slower, although it will depends on the
microarchitecture (and as mentioned elsewhere, there are other things
that can make a bigger difference boot-to-boot - dentry allocation
details etc can have "sticky" performance impact).

So we may take a small hit in order to then *not* have horrible
scalability at the high end.

               Linus
