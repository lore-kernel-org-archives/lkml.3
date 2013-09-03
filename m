Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760523Ab3ICTT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 15:19:58 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52104 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760384Ab3ICTTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 15:19:54 -0400
Date: Tue, 3 Sep 2013 21:19:50 +0200
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
Message-ID: <20130903191950.GC30757@gmail.com>
References: <CA+55aFzkZi6Q1bwSZUJxyfqUgLS05icjrObdCxC+4S-3Tup9Ew@mail.gmail.com>
 <CA+55aFzsXwFkYsWY45ZNTaVFC+-1Yh9nxx=NLhv+NxGmQAKHTg@mail.gmail.com>
 <20130901233005.GX13318@ZenIV.linux.org.uk>
 <CA+55aFyzas75yYP+AiwOxsAg5sG3KU+KEmO+ny=dn0-jxqUt5Q@mail.gmail.com>
 <CA+55aFyodR650Y8yXXenH1XHo-__5avng1WSK=AiSJx4mYy25g@mail.gmail.com>
 <20130902070538.GA31639@gmail.com>
 <CA+55aFyCBoeqceQcxA3JZ-k8a4uLbHf3N4rNmTZ4oh9XA7akEA@mail.gmail.com>
 <20130903101522.GA22369@gmail.com>
 <CA+55aFzhbhYK27n9C7WOgf=0NcmewpE+J6giKQhjAgare52gFg@mail.gmail.com>
 <CA+55aFxGWKJwo1CfS3EJFagUb+JRtc+URJOu2yz2RztWWrkraA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxGWKJwo1CfS3EJFagUb+JRtc+URJOu2yz2RztWWrkraA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Sep 3, 2013 at 8:41 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I've done that, and it matches the PEBS runs, except obviously with
> > the instruction skew (so then depending on run it's 95% the
> > instruction after the xadd). So the PEBS profiles are entirely
> > consistent with other data.
> 
> So one thing that strikes me about our lg-locks is that they are 
> designed to be cheap, but they force this insane 3-deep memory access 
> chain to lock them.
> 
> That may be a large part of why lg_local_lock shows up so clearly on my 
> profiles: the single "lock xadd" instruction ends up not just being 
> serializing, but it is what actually consumes the previous memory reads.
> 
> The core of the lg_local_lock sequence ends up being this 
> four-instruction sequence:
> 
>     mov    (%rdi),%rdx
>     add    %gs:0xcd48,%rdx
>     mov    $0x100,%eax
>     lock   xadd   %ax,(%rdx)
> 
> and that's a nasty chain of dependent memory loads. First we load the 
> percpu address, then we add the percpu offset to that, and then we do 
> the xadd on the result.
> 
> It's kind of sad, because in *theory* we could get rid of that whole 
> thing entirely, and just do it as one single
> 
>     mov    $0x100,%eax
>     lock xadd %ax,%gs:vfsmount_lock
> 
> that only has one single memory access, not three dependent ones.
> 
> But the two extra memory accesses come from:
> 
>  - the lglock data structure isn't a percpu data structure, it's this 
> stupid global data structure that has a percpu pointer in it.  So that 
> first "mov (%rdi),%rdx" is purely to load what is effectively a constant 
> address (per lglock).
> 
>    And that's not because it wants to be, but because we associate 
> global lockdep data with it. Ugh. If it wasn't for that, we could just 
> make them percpu.

I don't think that's fundamental - the per CPU lock was percpu before:

 #define DEFINE_LGLOCK(name)                                            \
-                                                                       \
- DEFINE_SPINLOCK(name##_cpu_lock);                                     \
- DEFINE_PER_CPU(arch_spinlock_t, name##_lock);                         \
- DEFINE_LGLOCK_LOCKDEP(name);                                          \


but AFAICS got converted to a pointer via this commit:

 commit eea62f831b8030b0eeea8314eed73b6132d1de26
 Author: Andi Kleen <ak@linux.intel.com>
 Date:   Tue May 8 13:32:24 2012 +0930

    brlocks/lglocks: turn into functions
    
    lglocks and brlocks are currently generated with some complicated 
    macros in lglock.h.  But there's no reason to not just use common 
    utility functions and put all the data into a common data structure.
    
    Since there are at least two users it makes sense to share this code 
    in a library.  This is also easier maintainable than a macro forest.
    
    This will also make it later possible to dynamically allocate lglocks 
    and also use them in modules (this would both still need some 
    additional, but now straightforward, code)

Which was a rather misguided premise IMHO.

Thanks,

	Ingo
