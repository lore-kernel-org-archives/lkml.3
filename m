Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaEESnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 14:43:11 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:36776 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaEESnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 14:43:09 -0400
Date: Mon, 5 May 2014 20:43:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
Message-ID: <20140505184304.GA15137@gmail.com>
References: <cover.1398958771.git.jpoimboe@redhat.com>
 <20140505085537.GA32196@gmail.com>
 <20140505132638.GA14432@treble.redhat.com>
 <20140505141038.GA27403@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505141038.GA27403@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Mon, May 05, 2014 at 08:26:38AM -0500, Josh Poimboeuf wrote:
> > On Mon, May 05, 2014 at 10:55:37AM +0200, Ingo Molnar wrote:
> > > 
> > > * Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > > 
> > > > [...]
> > > > 
> > > > kpatch checks the backtraces of all tasks in stop_machine() to 
> > > > ensure that no instances of the old function are running when the 
> > > > new function is applied.  I think the biggest downside of this 
> > > > approach is that stop_machine() has to idle all other CPUs during 
> > > > the patching process, so it inserts a small amount of latency (a few 
> > > > ms on an idle system).
> > > 
> > > When live patching the kernel, how about achieving an even 'cleaner' 
> > > state for all tasks in the system: to freeze all tasks, as the suspend 
> > > and hibernation code (and kexec) does, via freeze_processes()?
> > > 
> > > That means no tasks in the system have any real kernel execution 
> > > state, and there's also no problem with long-sleeping tasks, as 
> > > freeze_processes() is supposed to be fast as well.
> > > 
> > > I.e. go for the most conservative live patching state first, and relax 
> > > it only once the initial model is upstream and is working robustly.
> > 
> > I had considered doing this before, but the problem I found is 
> > that many kernel threads are unfreezable.  So we wouldn't be able 
> > to check whether its safe to replace any functions in use by those 
> > kernel threads.
> 
> OTOH many kernel threads are parkable. Which achieves kind of 
> similar desired behaviour: the kernel threads then aren't running.
> 
> And in fact we could implement freezing on top of park for kthreads.
> 
> But unfortunately there are still quite some of them which don't 
> support parking.

Well, if distros are moving towards live patching (and they are!), 
then it looks rather necessary to me that something scary as flipping 
out live kernel instructions with substantially different code should 
be as safe as possible, and only then fast.

If a kernel refuses to patch with certain threads running, that will 
drive those kernel threads being fixed and such. It's a deterministic, 
recoverable, reportable bug situation, so fixing it should be fast.

We learned these robustness lessons the hard way with kprobes and 
ftrace dynamic code patching... which are utterly simple compared to 
live kernel patching!

Thanks,

	Ingo
