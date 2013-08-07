Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933831Ab3HGV4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:56:32 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:41942 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757107Ab3HGV41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:56:27 -0400
MIME-Version: 1.0
In-Reply-To: <5202BE17.9010408@akamai.com>
References: <20130807173606.872055511@goodmis.org>
	<1375898048.6848.18.camel@gandalf.local.home>
	<CA+55aFwo4iFk4_6cSoK=NjCWjVgdPgKy0YfKpZd2zSGn_RXHYg@mail.gmail.com>
	<5202ABEF.10107@akamai.com>
	<CA+55aFyu+3fRrsGUZkH6y5yND3oV9K+jCzrJyCWqwHQreFELOw@mail.gmail.com>
	<5202BE17.9010408@akamai.com>
Date: Wed, 7 Aug 2013 14:56:26 -0700
X-Google-Sender-Auth: 5KIbtH0GT1lFrD_Yr11wBU2E1Mk
Message-ID: <CA+55aFykSZb-XmGU0WjZDuiSUXQ6RbRhV3ZH5BUFCRifaoLUGA@mail.gmail.com>
Subject: Re: [RFC][PATCH 3/2] x86/jump labels: Count and display the short
 jumps used
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jason Baron <jbaron@akamai.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 7, 2013 at 2:37 PM, Jason Baron <jbaron@akamai.com> wrote:
>
> ok - I can see 2 variants here as you mentioned:
>
> 1) 'Unbiased' - we want to treat both branches equally but don't want
> the load/test/jmp sequence. For things like the scheduler stats.
>
> 2) 'Biased' - where the unlikely path is moved completely out-of-line.
> And we have a strong 'bias' to optimize the default path.

Actually, personally I'd much rather see *three* cases, and for the
static keys usually only two are relevant:

 - truly unbiased: a normal conditional that we don't really know
which one is the likely or unlikely path

   This is likely *not* the normal case for a static key, since almost
always we have a lightweight case, and a heavy one. Most of the static
keys are about things like statistics, which are inherently more
expensive than not having statistics, so they aren't really
"unbiased". There's a bias introduced by one side being more costly
than the other. You want the light (non-statistics) case to be a
fall-through, while the heavy case is going to be much more expensive
and update global variables etc.

 - "slightly biased". The normal kind of "unlikely()", where you want
to have one side of the branch be the fall-through and common case
that doesn't interrupt the I$ prefetch etc. This is the likely case
for most static key use, I think.

 - "strongly biased": a "very unlikely" kind of thing, which is either
a major exception case (ie an assertion on BUG_ON() or other basically
fatal thing), or is something like the tracing code that is uncommon
and where we want basically minimal impact when it is not enabled, but
when it's on, the impact is so big that the conditional branch no
longer even matters.

The first one really doesn't care which way a branch goes. The second
one prefers a fall-through case for the common case. And the third one
is basically a "get this code away from me".

Both of the biased cases *might* also want things like "save register
state in the unlikely path so that the *likely* path doesn't have to".
Think things like "it's a leaf function, and the likely path doesn't
need any temporaries, but the unlikely path ends up doing function
calls and needs a stack frame". If the compiler can make likely path
avoid the stack frame generation and be straight-line, that would be
really nice.

                Linus
