Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab3H3Sxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 14:53:45 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:54227 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab3H3Sxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 14:53:43 -0400
MIME-Version: 1.0
In-Reply-To: <5220E56A.80603@hp.com>
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
	<5220E56A.80603@hp.com>
Date: Fri, 30 Aug 2013 11:53:42 -0700
X-Google-Sender-Auth: T5FfJaqKPQnVDaMyn9oKWgk-150
Message-ID: <CA+55aFzv9BZ2+B2NrNRRtTqnfgbH3LRSvSsUZVsy-g9OpM-8HA@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>,
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

On Fri, Aug 30, 2013 at 11:33 AM, Waiman Long <waiman.long@hp.com> wrote:
>
> I tested your patch on a 2-socket (12 cores, 24 threads) DL380 with 2.9GHz
> Westmere-EX CPUs, the test results of your test program (max threads
> increased to 24 to match the thread count) were:
>
> with patch = 68M
> w/o patch = 12M

Ok, that's certainly noticeable.

> I have reviewed the patch, and it looks good to me with the exception that I
> added a cpu_relax() call at the end of while loop in the CMPXCHG_LOOP macro.

Yeah, that's probably a good idea.

> I also got the perf data of the test runs with and without the patch.

So the perf data would be *much* more interesting for a more varied
load. I know pretty much exactly what happens with my silly
test-program, and as you can see it never really gets to the actual
spinlock, because that test program will only ever hit the fast-path
case.

It would be much more interesting to see another load that may trigger
the d_lock actually being taken. So:

> For the other test cases that I am interested in, like the AIM7 benchmark,
> your patch may not be as good as my original one. I got 1-3M JPM (varied
> quite a lot in different runs) in the short workloads on a 80-core system.
> My original one got 6M JPM. However, the test was done on 3.10 based kernel.
> So I need to do more test to see if that has an effect on the JPM results.

I'd really like to see a perf profile of that, particularly with some
call chain data for the relevant functions (ie "what it is that causes
us to get to spinlocks"). Because it may well be that you're hitting
some of the cases that I didn't see, and thus didn't notice.

In particular, I suspect AIM7 actually creates/deletes files and/or
renames them too. Or maybe I screwed up the dget_parent() special case
thing, which mattered because AIM7 did a lot of getcwd() calls or
someting odd like that.

                Linus
