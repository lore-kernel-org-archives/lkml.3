Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab3I3WxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 18:53:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:39860 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420Ab3I3WxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 18:53:14 -0400
Message-ID: <1380581522.6396.20.camel@pasglop>
Subject: Re: Avoiding the dentry d_lock on final dput(), part deux:
 transactional memory
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Michael Neuling <michael.neuling@au1.ibm.com>
Date: Tue, 01 Oct 2013 08:52:02 +1000
In-Reply-To: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com>
References: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-30 at 12:29 -0700, Linus Torvalds wrote:
> 
> But I'm cc'ing the POWER people, because I don't know the POWER8
> interfaces, and I don't want to necessarily call this "xbegin"/"xend"
> when I actually wrap it in some helper functions.

The main problem with powerpc TM is that we need to handle interrupts
happening while in transactional state. We currently only handle that
for userspace.

Mikey, how hard would it be to detect the in-kernel TM case and just
simulate an abort in the exception entry ? (return to tbegin basically)

Transactions in kernel make me nervous because of the PC jumping around
on aborts and how easy we can get that stuff wrong :-) They also have
interesting ordering semantics vs. locks, we need to be a tad careful
(as long as we don't access a lock variable transactionally we should be
ok. If we do, then spin_unlock needs a stronger barrier).

The basic semantic for us is tbegin. [...] tend instructions. If the
transaction fails, control returns to tbegin. (can happen at any point)
which returns a CC code indicating success or failure.

Things get really complicated if you take an interrupt however, the
transaction gets into some special "suspended" state, it doesn't just
die so we need to handle things in our interrupt entry (even if it's
just to make the transaction abort cleanly) and right now we don't when
coming from kernel space.

Cheers,
Ben.


