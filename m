Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab3GSTs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 15:48:28 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:40833 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab3GSTs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 15:48:27 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1307192139140.4089@ionos.tec.linutronix.de>
References: <20130719183101.GA20909@twins.programming.kicks-ass.net>
	<51E98EB4.3080307@hp.com>
	<alpine.DEB.2.02.1307192139140.4089@ionos.tec.linutronix.de>
Date: Fri, 19 Jul 2013 12:48:26 -0700
X-Google-Sender-Auth: LcOMPo5qWoDKFO5a-S9QW0bDNvQ
Message-ID: <CA+55aFzL+HDsK2kky0Vpy-+YdomBw=OipE6a5CjmXW7xyW6tTA@mail.gmail.com>
Subject: Re: [PATCH] mutex: Fix mutex_can_spin_on_owner
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Waiman Long <waiman.long@hp.com>, Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 12:41 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> That's true for your particular compiler, but it's not guaranteed at
> all. So it matters even when your compiler generates the same
> code. Others might not. There is a world outside of x8664.

Well, in this case, I think we can pretty safely say that a compiler
has to be seriously buggered to not just doit as a single load. If
there are reloads in that sequence, the compiler is past bad.

That said, I'm absolutely not arguing against the fix, and it needs to
be done. Not so much because of "a compiler might screw it up" as
simply because it's (a) the right thing to do and (b) documentation
about the fact that we're doing special things that aren't really
locked.

In particular, I could imagine us some day checking that ACCESS_ONCE()
accesses are never cacheline crossers or multiword accesses, neither
of which may be atomic. A 64-bit ACCESS_ONCE on a 32-bit machine would
be a bug, for example. Not that I think we do that, but the point is
that ACCESS_ONCE() is about more than just compiler code generation.
It's documentation, and it's a possible venue for sanity-checking.

               Linus
