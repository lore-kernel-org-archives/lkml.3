Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbaFBUWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:22:13 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:61248 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaFBUWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:22:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140602200525.GD13930@laptop.programming.kicks-ass.net>
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com>
	<20140602162525.GH16155@laptop.programming.kicks-ass.net>
	<20140602163032.GI16155@laptop.programming.kicks-ass.net>
	<538CB56E.5010709@hp.com>
	<20140602200525.GD13930@laptop.programming.kicks-ass.net>
Date: Mon, 2 Jun 2014 13:22:10 -0700
X-Google-Sender-Auth: 1saDjUgmCrLlGSNKjIjEgZ29nmc
Message-ID: <CA+55aFwJwVf_MbcwNNWg-KrLdoOaV2xse2jzvBZTJHJgC_Htvg@mail.gmail.com>
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <waiman.long@hp.com>, Mikulas Patocka <mpatocka@redhat.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, John David Anglin <dave.anglin@bell.net>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, Jason Low <jason.low2@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2014 at 1:05 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> So the question is, do you prefer subtly broken code or hard compile
> fails? Me, I go for the compile fail.

The thing is, parisc has a perfectly fine "cmpxchg" implementation in
practice, and ACCESS_ONCE() and friends work fine too for reading.

What the "use a spinlock" approach cannot generally do is:

 - ACCESS_ONCE() to _write_ things doesn't work well. You really
should use "atomic_set()".

 - you may not necessarily be able to mix partial updates (ie
differently sized updates to the same thing) depending on just how the
spinlock hashing works

but both of those are really rare issues and don't affect normal code.

I would not necessarily be opposed to splitting up ACCESS_ONCE() for
reading and for writing, and maybe we could do something special for
the writing path (which tends to be less ctitical). It's really mixing
"ACCESS_ONCE(x)" to _set_ a value, together with atomic ops to update
it, that ends up being problematic.

Maybe there are other issues I can't think of right now. But
basically, parisc _can_ do cmpxchg, it's just that the code needs to
be somewhat sanitized.

Side note: some of the RCU code uses "ACCESS_ONCE()" for
read-modify-write code, which is just f*cking crazy. The semantics are
dubious, and it generally makes gcc create bad code too.

                 Linus
