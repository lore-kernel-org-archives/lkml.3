Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760531Ab3ICSeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 14:34:13 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:47887 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760397Ab3ICSeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 14:34:11 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzhbhYK27n9C7WOgf=0NcmewpE+J6giKQhjAgare52gFg@mail.gmail.com>
References: <CA+55aFwU054C+zC+G+JrF4ngWvVmvD9WPGWaT_2=nF2j7bpHxA@mail.gmail.com>
	<CA+55aFyc17miqwhncAKsanPQ9fHX_czQx+g-a9At_S1-XNpyKA@mail.gmail.com>
	<20130901212355.GU13318@ZenIV.linux.org.uk>
	<CA+55aFzkZi6Q1bwSZUJxyfqUgLS05icjrObdCxC+4S-3Tup9Ew@mail.gmail.com>
	<CA+55aFzsXwFkYsWY45ZNTaVFC+-1Yh9nxx=NLhv+NxGmQAKHTg@mail.gmail.com>
	<20130901233005.GX13318@ZenIV.linux.org.uk>
	<CA+55aFyzas75yYP+AiwOxsAg5sG3KU+KEmO+ny=dn0-jxqUt5Q@mail.gmail.com>
	<CA+55aFyodR650Y8yXXenH1XHo-__5avng1WSK=AiSJx4mYy25g@mail.gmail.com>
	<20130902070538.GA31639@gmail.com>
	<CA+55aFyCBoeqceQcxA3JZ-k8a4uLbHf3N4rNmTZ4oh9XA7akEA@mail.gmail.com>
	<20130903101522.GA22369@gmail.com>
	<CA+55aFzhbhYK27n9C7WOgf=0NcmewpE+J6giKQhjAgare52gFg@mail.gmail.com>
Date: Tue, 3 Sep 2013 11:34:10 -0700
X-Google-Sender-Auth: gtV8YM9WHgFkZztgevHj8rAKtDM
Message-ID: <CA+55aFxGWKJwo1CfS3EJFagUb+JRtc+URJOu2yz2RztWWrkraA@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Sedat Dilek <sedat.dilek@gmail.com>,
        Waiman Long <waiman.long@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 3, 2013 at 8:41 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I've done that, and it matches the PEBS runs, except obviously with
> the instruction skew (so then depending on run it's 95% the
> instruction after the xadd). So the PEBS profiles are entirely
> consistent with other data.

So one thing that strikes me about our lg-locks is that they are
designed to be cheap, but they force this insane 3-deep memory access
chain to lock them.

That may be a large part of why lg_local_lock shows up so clearly on
my profiles: the single "lock xadd" instruction ends up not just being
serializing, but it is what actually consumes the previous memory
reads.

The core of the lg_local_lock sequence ends up being this
four-instruction sequence:

    mov    (%rdi),%rdx
    add    %gs:0xcd48,%rdx
    mov    $0x100,%eax
    lock   xadd   %ax,(%rdx)

and that's a nasty chain of dependent memory loads. First we load the
percpu address, then we add the percpu offset to that, and then we do
the xadd on the result.

It's kind of sad, because in *theory* we could get rid of that whole
thing entirely, and just do it as one single

    mov    $0x100,%eax
    lock xadd %ax,%gs:vfsmount_lock

that only has one single memory access, not three dependent ones.

But the two extra memory accesses come from:

 - the lglock data structure isn't a percpu data structure, it's this
stupid global data structure that has a percpu pointer in it.  So that
first "mov (%rdi),%rdx" is purely to load what is effectively a
constant address (per lglock).

   And that's not because it wants to be, but because we associate
global lockdep data with it. Ugh. If it wasn't for that, we could just
make them percpu.

 - we don't have a percpu spinlock accessor, so we always need to turn
the percpu address into a global address by adding the percpu base
(and that's the "add %gsL...,%rdx" part).

Oh well. This whole "lg_local_lock" is really noticeable on my
test-case mainly because my test-case only stat's a pathname with a
single path component, so the whole lookup really is dominated by all
the "setup/teardown" code. Real loads tend to look up much longer
pathnames, so the setup/teardown isn't so dominant, and actually
looking up the dentries from the hash chain is where most of the time
goes. But it's annoying to have that one big spike in the profile and
not being able to do anything about it.

           Linus
