Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960Ab3BNKue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:50:34 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:58255 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350Ab3BNKuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:50:32 -0500
Date: Thu, 14 Feb 2013 11:50:27 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, rostedt@goodmiss.org,
        aquini@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket
 lock out of line
Message-ID: <20130214105027.GB25282@gmail.com>
References: <20130206150403.006e5294@cuia.bos.redhat.com>
 <tip-4aef331850b637169ff036ed231f0d236874f310@git.kernel.org>
 <CA+55aFx6N6SaRN+w=CTXJ=ZSsOE6KeS2R9sT_uhAx9h2j+hjKg@mail.gmail.com>
 <CA+55aFwZ2wN=9qTNNmqjPfK=ZwS=kx6HAAFj_cWLnJDbK1M0_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwZ2wN=9qTNNmqjPfK=ZwS=kx6HAAFj_cWLnJDbK1M0_Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Feb 13, 2013 at 8:20 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Adding an external function call is *horrible*, and you 
> > might almost as well just uninline the spinlock entirely if 
> > you do this. It means that all the small callers now have 
> > their registers trashed, whether the unlikely function call 
> > is taken or not, and now leaf functions aren't leaves any 
> > more.
> 
> Btw, we've had things like this before, and I wonder if we 
> could perhaps introduce the notion of a "light-weight call" 
> for fastpath code that calls unlikely slow-path code..
> 
> In particular, see the out-of-line code used by the rwlocks 
> etc (see "arch_read_lock()" for an example in 
> arch/x86/include/asm/spinlock.h and arch/x86/lib/rwlock.S), 
> where we end up calling things from inline asm, with one big 
> reason being exactly the fact that a "normal" C call has such 
> horribly detrimental effects on the caller.
> 
> Sadly, gcc doesn't seem to allow specifying which registers 
> are clobbered any easy way, which means that both the caller 
> and the callee *both* tend to need to have some asm interface. 
> So we bothered to do this for __read_lock_failed, but we have 
> *not* bothered to do the same for the otherwise very similar 
> __mutex_fastpath_lock() case, for example.

At least on x86, how about saving *all* volatile registers in 
the slow out of line code path (to stack)?

That means we wouldn't have to do anything fancy with the called 
functions, and the caller would see minimal register impact. It 
would also be reasonably robust and straightforward assembly 
code.

It blows up the slow path somewhat, but it would allow us to 
keep the fast-path register impact even smaller - as the slow 
path would only have memory content side effects.

Am I missing something?

Thanks,

	Ingo
