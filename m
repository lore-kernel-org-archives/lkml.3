Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273AbaEGPlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:41:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbaEGPle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:41:34 -0400
Date: Wed, 7 May 2014 10:41:14 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
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
Message-ID: <20140507154114.GA31555@treble.redhat.com>
References: <cover.1398958771.git.jpoimboe@redhat.com>
 <20140505085537.GA32196@gmail.com>
 <20140505132638.GA14432@treble.redhat.com>
 <20140505141038.GA27403@localhost.localdomain>
 <20140505184304.GA15137@gmail.com>
 <20140505214919.GE2099@localhost.localdomain>
 <20140506121211.GA4125@treble.redhat.com>
 <20140506140516.GF2099@localhost.localdomain>
 <20140506145010.GA6702@treble.redhat.com>
 <20140507122444.GB12234@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140507122444.GB12234@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 02:24:44PM +0200, Ingo Molnar wrote:
> 
> * Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> 
> > > Ah this reminds me when we chased kprobes dangerous spots and we 
> > > tried to declare __kprobes the functions which were too dangerous 
> > > to hot patch.
> > > 
> > > We eventually gave up because it was impossible to fix everything. 
> > > And that was only for kprobes!
> > > 
> > > So you can never tell if a given patch will impact a given 
> > > kthread.
> > 
> > If the user (or the person creating the patch for them) doesn't 
> > understand all impacts of the patch, they have no business patching 
> > their kernel with it.
> 
> I think what is being somewhat lost is this discussion is the 
> distinction between:
> 
>  1) is the patch safe
>  2) is the _live patching_ safe
> 
> It's really two different things. We should absolutely strive for live 
> patching to be safe under all circumstances, as long as the patch 
> being fed to it is safe in itself when building a new kernel the old 
> fashioned way.
> 
> I.e. it's natural that a kernel can be messed up via a patch, but this 
> subsystem should absolutely make sure that it will safely reject 
> totally fine patches that are unsafe to live patch.

Thanks, that's a very succinct way to put it.  They are indeed two
different things, but at the same time they're interrelated: determining
whether a patch is safe requires making assumptions about how it will be
applied.

Here's how kpatch draws the lines:

1) Is the patch safe?

   Determined by the user (and partially enforced by the kpatch-build
   tools).

   The user can assume that the old function(s) will not be in use by
   any task at the time of replacement, so there's no risk of unexpected
   interactions between the old and the new.  There is no guarantee that
   all tasks will be frozen.

2) Is the live patching safe?

   Determined by the kernel.  The kernel only needs to ensure that the
   old function(s) are not in use.  We do this with stop_machine() and
   backtrace checks of all tasks.

It's a very simple contract between user and kernel.

I think the proposal was that we change this contract such that the user
can additionally assume that all tasks will be frozen.  I could be
missing something but I don't see a real benefit from it.

-- 
Josh
