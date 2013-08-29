Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab3H2TZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 15:25:15 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:46885 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab3H2TZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 15:25:12 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	<1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	<1377751465.4028.20.camel@pasglop>
	<20130829070012.GC27322@gmail.com>
	<CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
Date: Thu, 29 Aug 2013 12:25:11 -0700
X-Google-Sender-Auth: o_zc_oKncYzMJ_0yd1MbBAZqROY
Message-ID: <CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Waiman Long <Waiman.Long@hp.com>,
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

On Thu, Aug 29, 2013 at 9:43 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> We'll see. The real problem is that I'm not sure if I can even see the
> scalability issue on any machine I actually personally want to use
> (read: silent). On my current  system I can only get up to 15%
> _raw_spin_lock by just stat'ing the same file over and over and over
> again from lots of threads.

Hmm. I can see it, but it turns out that for normal pathname walking,
one of the main stumbling blocks is the RCU case of complete_walk(),
which cannot be done with the lockless lockref model.

Why? It needs to check the sequence count too and cannot touch the
refcount unless it matches under the spinlock. We could use
lockref_get_non_zero(), but for the final path component (which this
is) the zero refcount is actually a common case.

Waiman worked around this by having some rather complex code to retry
and wait for the dentry lock to be released in his lockref code. But
that has a lot of tuning implications, and I wanted to see what it is
*without* that kind of tuning. And that's when you hit the "lockless
case fails all the time because the lock is actually held" case.

I'm going to play around with changing the semantics of
"lockref_get_non_zero()" to match the "lockless_put_or_lock()":
instead of failing when the count it zero, it gets the lock. That
won't generally get any contention, because if the count is zero,
there generally isn't anybody else playing with that dentry.

            Linus
