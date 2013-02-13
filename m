Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab3BMSaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:30:23 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:56904 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab3BMSaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:30:21 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFx6N6SaRN+w=CTXJ=ZSsOE6KeS2R9sT_uhAx9h2j+hjKg@mail.gmail.com>
References: <20130206150403.006e5294@cuia.bos.redhat.com> <tip-4aef331850b637169ff036ed231f0d236874f310@git.kernel.org>
 <CA+55aFx6N6SaRN+w=CTXJ=ZSsOE6KeS2R9sT_uhAx9h2j+hjKg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 13 Feb 2013 10:30:00 -0800
X-Google-Sender-Auth: cRr7r9VIv5hvkkcc70rw3fN2Pso
Message-ID: <CA+55aFwZ2wN=9qTNNmqjPfK=ZwS=kx6HAAFj_cWLnJDbK1M0_Q@mail.gmail.com>
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket lock
 out of line
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, rostedt@goodmiss.org,
        aquini@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 8:20 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Adding an external function call is *horrible*, and you might almost
> as well just uninline the spinlock entirely if you do this. It means
> that all the small callers now have their registers trashed, whether
> the unlikely function call is taken or not, and now leaf functions
> aren't leaves any more.

Btw, we've had things like this before, and I wonder if we could
perhaps introduce the notion of a "light-weight call" for fastpath
code that calls unlikely slow-path code..

In particular, see the out-of-line code used by the rwlocks etc (see
"arch_read_lock()" for an example in arch/x86/include/asm/spinlock.h
and arch/x86/lib/rwlock.S), where we end up calling things from inline
asm, with one big reason being exactly the fact that a "normal" C call
has such horribly detrimental effects on the caller.

Sadly, gcc doesn't seem to allow specifying which registers are
clobbered any easy way, which means that both the caller and the
callee *both* tend to need to have some asm interface. So we bothered
to do this for __read_lock_failed, but we have *not* bothered to do
the same for the otherwise very similar __mutex_fastpath_lock() case,
for example.

So for rwlocks, we actually get very nice code generation with small
leaf functions not necessarily needing stack frames, but for mutexes
we mark a lot of registers "unnecessarily" clobbered in the caller,
exactly because we do *not* do that asm interface for the callee. So
we have to clobber all the standard callee-clobbered registers, which
is really sad, and callers almost always need a stack frame, because
if they have any data live at all across the mutex, they have to save
it in some register that is callee-saved - which basically means that
the function has to have that stack frame in order to save its *own*
callee-saved registers.

So it means that we penalize the fastpath because the slow-path can't
be bothered to do the extra register saving, unless we go to the
lengths we went to for the rwlocks, and build a wrapper in asm to save
the extra registers in the cold path.

Maybe we could introduce some helpers to create these kinds of asm
wrappers to do this? Something that would allow us to say: "this
function only clobbers a minimal set of registers and you can call it
from asm and only mark %rax/rcx/rdx clobbered" and that allows leaf
functions to look like leaf functions for the fastpath?

Hmm? That would make my dislike of uninlining the slow case largely go
away. I still think that back-off tends to be a mistake (and is often
horrible for virtualization etc), but as long as the fastpath stays
close to optimal, I don't care *too* much.

                     Linus
