Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab3IJVnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:43:10 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:64308 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3IJVnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:43:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130910212509.GA18147@laptop.programming.kicks-ass.net>
References: <20130910130811.507933095@infradead.org>
	<20130910135152.GD7537@gmail.com>
	<20130910135636.GA8268@gmail.com>
	<CA+55aFwmEQeF+PtM7cuaQ8OkuTS=R4JJ61Wwfv8u-Svo-V3KwQ@mail.gmail.com>
	<20130910164519.GL31370@twins.programming.kicks-ass.net>
	<CA+55aFz7WtcdkwKEGoqCzmC9HsY0LPK-oVK_oATYhRnbGq=2GA@mail.gmail.com>
	<20130910212509.GA18147@laptop.programming.kicks-ass.net>
Date: Tue, 10 Sep 2013 14:43:06 -0700
X-Google-Sender-Auth: RgOamvfRq3eOlMWe57j2B87vgCk
Message-ID: <CA+55aFxsEYQPXnoxNXAeSPEkk3uT8iq-_KJVe2M2qZZbtL=cbA@mail.gmail.com>
Subject: Re: [PATCH 0/7] preempt_count rework -v2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Peter Anvin <hpa@zytor.com>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 2:25 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> Here's one that builds and boots on kvm until wanting to mount root.
>
> I'm not entirely sure on the "ir" vs "er" thing and atomic64_t and
> local_t are inconsistent wrt that so I'm too.

"i" is "any constant", while "e" is "32-bit signed constant".

And I think all of the 64-bit ones should probably be "e", because
afaik there is no way to add a 64-bit constant directly to memory (you
have to load it into a register first).

Of course, in reality, the constant is always just 1 or -1 or
something like that, so nobody will ever notice the incorrect case...

And it doesn't matter for the 32-bit cases, obviously, but we could
just make them all be "e" for simplicity.

That said, looking at your patch, I get the *very* strong feeling that
we could make a macro that does all the repetitions for us, and then
have a

  GENERATE_RMW(atomic_sub_and_test, LOCK_PREFIX "subl", "e", "")
  GENERATE_RMW(atomic_dec_and_test, LOCK_PREFIX "decl", "e", "")
  ..
  GENERATE_RMW(atomic_add_negative, LOCK_PREFIX "addl", "s", "")

  GENERATE_RMW(local_sub_and_test, "subl", "e", __percpu_prefix)
  ...

etc.

I'm sure the macro would be nasty as hell (and I bet it needs a few
more arguments), but then we'd avoid the repetition..

                Linus
