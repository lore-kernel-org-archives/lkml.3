Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbaJXOeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:34:04 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50273 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbaJXOeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:34:02 -0400
Date: Fri, 24 Oct 2014 16:33:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Ingo Molnar <mingo@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: lockdep splat in CPU hotplug
Message-ID: <20141024143345.GL12706@worktop.programming.kicks-ass.net>
References: <alpine.LNX.2.00.1410211255531.24255@pobox.suse.cz>
 <alpine.LNX.2.00.1410221125280.22681@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1410221125280.22681@pobox.suse.cz>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 11:53:49AM +0200, Jiri Kosina wrote:
> > The reason for CCing Ingo and Peter is that I can't make any sense of one 
> > of the stacktraces lockdep is providing.
> > 
> > Please have a look at the very first stacktrace in the dump, where lockdep 
> > is trying to explain where cpu_hotplug.lock#2 has been acquired. It seems 
> > to imply that cpuidle_pause() is taking cpu_hotplug.lock, but that's not 
> > the case at all.
> > 
> > What am I missing?

> Still, the lockdep stacktrace is bogus and didn't really help 
> understanding this. Any idea why it's wrong?

> > -> #1 (cpu_hotplug.lock#2){+.+.+.}:
> >         [<ffffffff81099fac>] lock_acquire+0xac/0x130
> >         [<ffffffff815b9f2c>] mutex_lock_nested+0x5c/0x3b0
> >         [<ffffffff81491892>] cpuidle_pause+0x12/0x30
> >         [<ffffffff81402314>] dpm_suspend_noirq+0x44/0x340
> >         [<ffffffff81402958>] dpm_suspend_end+0x38/0x80
> >         [<ffffffff810a07bd>] hibernation_snapshot+0xcd/0x370
> >         [<ffffffff810a1248>] hibernate+0x168/0x210
> >         [<ffffffff8109e9b4>] state_store+0xe4/0xf0
> >         [<ffffffff813003ef>] kobj_attr_store+0xf/0x20
> >         [<ffffffff8121e9a3>] sysfs_kf_write+0x43/0x60
> >         [<ffffffff8121e287>] kernfs_fop_write+0xe7/0x170
> >         [<ffffffff811a7342>] vfs_write+0xb2/0x1f0
> >         [<ffffffff811a7da4>] SyS_write+0x44/0xb0
> >         [<ffffffff815be856>] system_call_fastpath+0x16/0x1b

Right, so I've seen it more often, and I'm not sure I can explain
either.

Lockdep uses save_stack_trace() with trace->skip=3, typically if you
get ->skip wrong you'd not even see the lock_acquire, so that can't be
it.

The only thing I can come up with is that for some reason the
intermediate entries are !reliable, save_stack_trace() skips those for
CONFIG_FRAME_POINTER=y, see
arch/x86/kernel/stacktrace.c:__save_stack_address().
