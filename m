Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbaEGP6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:58:04 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:38222 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439AbaEGP6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:58:00 -0400
Date: Wed, 7 May 2014 17:57:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
Message-ID: <20140507155754.GA15221@gmail.com>
References: <20140505085537.GA32196@gmail.com>
 <20140505132638.GA14432@treble.redhat.com>
 <20140505141038.GA27403@localhost.localdomain>
 <20140505184304.GA15137@gmail.com>
 <20140505214919.GE2099@localhost.localdomain>
 <20140506121211.GA4125@treble.redhat.com>
 <20140506140516.GF2099@localhost.localdomain>
 <20140506145010.GA6702@treble.redhat.com>
 <20140507122444.GB12234@gmail.com>
 <20140507154114.GA31555@treble.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507154114.GA31555@treble.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> On Wed, May 07, 2014 at 02:24:44PM +0200, Ingo Molnar wrote:
> > 
> > * Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > 
> > > > Ah this reminds me when we chased kprobes dangerous spots and we 
> > > > tried to declare __kprobes the functions which were too dangerous 
> > > > to hot patch.
> > > > 
> > > > We eventually gave up because it was impossible to fix everything. 
> > > > And that was only for kprobes!
> > > > 
> > > > So you can never tell if a given patch will impact a given 
> > > > kthread.
> > > 
> > > If the user (or the person creating the patch for them) doesn't 
> > > understand all impacts of the patch, they have no business patching 
> > > their kernel with it.
> > 
> > I think what is being somewhat lost is this discussion is the 
> > distinction between:
> > 
> >  1) is the patch safe
> >  2) is the _live patching_ safe
> > 
> > It's really two different things. We should absolutely strive for live 
> > patching to be safe under all circumstances, as long as the patch 
> > being fed to it is safe in itself when building a new kernel the old 
> > fashioned way.
> > 
> > I.e. it's natural that a kernel can be messed up via a patch, but this 
> > subsystem should absolutely make sure that it will safely reject 
> > totally fine patches that are unsafe to live patch.
> 
> Thanks, that's a very succinct way to put it.  They are indeed two
> different things, but at the same time they're interrelated: determining
> whether a patch is safe requires making assumptions about how it will be
> applied.

No!

A patch to the kernel source is 'safe' if it results in a correctly 
patched kernel source. Full stop!

Live patching does not enter into this question, ever. The correctness 
of a patch to the source does not depend on 'live patching' 
considerations in any way, shape or form.

Any mechanism that tries to blur these lines is broken by design.

My claim is that if a patch is correct/safe in the old fashioned way, 
then a fundamental principle is that a live patching subsystem must 
either safely apply, or safely reject the live patching attempt, 
independently from any user input.

It's similar to how kprobes (or ftrace) will safely reject or perform 
a live patching of the kernel.

So for example, there's this recent upstream kernel fix:

  3ca9e5d36afb agp: info leak in agpioc_info_wrap()

which fixes an information leak. The 'patch' is Git commit 
3ca9e5d36afb (i.e. it patches a very specific incoming kernel source 
tree that results in a specific outgoing source tree), and we know 
it's safe and correct.

Any live patching subsystem must make sure that if this patch is 
live-patched, that this attempt is either rejected safely or performed 
safely.

"We think/hope it won't blow up in most cases and we automated some 
checks halfways" or "the user must know what he is doing" is really 
not something that I think is a good concept for something as fragile 
as live patching.

Thanks,

	Ingo
