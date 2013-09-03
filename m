Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759736Ab3ICKP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 06:15:29 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:38793 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab3ICKP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 06:15:27 -0400
Date: Tue, 3 Sep 2013 12:15:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
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
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
Message-ID: <20130903101522.GA22369@gmail.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyCBoeqceQcxA3JZ-k8a4uLbHf3N4rNmTZ4oh9XA7akEA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Sep 2, 2013 at 12:05 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > The Haswell perf code isn't very widely tested yet as it took quite some
> > time to get it ready for upstream and thus got merged late, but on its
> > face this looks like a pretty good profile.
> 
> Yes. And everything else looks fine too. Profiles without locked
> instructions all look very reasonable, and have the expected patterns.
> 
> \> It still looks anomalous to me, on fresh Intel hardware. One suggestion:
> > could you, just for pure testing purposes, turn HT off and do a quick
> > profile that way?
> >
> > The XADD, even if it's all in the fast path, could be a pretty natural
> > point to 'yield' an SMT context on a given core, giving it artificially
> > high overhead.
> >
> > Note that to test HT off an intrusive reboot is probably not needed, if
> > the HT siblings are right after each other in the CPU enumeration sequence
> > then you can turn HT "off" effectively by running the workload only on 4
> > cores:
> >
> >   taskset 0x55 ./my-test
> >
> > and reducing the # of your workload threads to 4 or so.
> 
> Remember: I see the exact same profile for single-thread behavior.

Oh, indeed.

> Other things change (iow, lockref_get_or_lock() is either ~3% or ~30% - 
> the latter case is for when there are bouncing cachelines), but 
> lg_local_lock() stays pretty constant.
> 
> So it's not a HT artifact or anything like that.
> 
> I've timed "lock xadd" separately, and it's not a slow instruction. I 
> also tried (in user space, using thread-local storage) to see if it's 
> the combination of creating the address through a segment load and that 
> somehow causing a micro-exception or something (the P4 used to have 
> things like that), and that doesn't seem to account for it either.
> 
> It is entirely possible that it is just a "cycles:pp" oddity - because 
> the "lock xadd" is serializing, it can't retire until everything around 
> it has been sorted out, and maybe it just shows up in profiles more than 
> is really "fair" to the instruction itself, because it ends up being 
> that stable point for potentially hundreds of instructions around it.

One more thing to try would be a regular '-e cycles' non-PEBS run and see 
whether there's still largish overhead visible around that instruction.

That reintroduces skid, but it eliminates any PEBS and LBR funnies, as our 
cycles:pp event is a really tricky/complex beast internally.

Thanks,

	Ingo
