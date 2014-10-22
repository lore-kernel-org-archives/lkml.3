Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254AbaJVLkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:40:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37452 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932977AbaJVLj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:39:58 -0400
Date: Wed, 22 Oct 2014 13:39:56 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Pitre <nico@linaro.org>
cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: lockdep splat in CPU hotplug
In-Reply-To: <alpine.LNX.2.00.1410221125280.22681@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1410221336070.22681@pobox.suse.cz>
References: <alpine.LNX.2.00.1410211255531.24255@pobox.suse.cz> <alpine.LNX.2.00.1410221125280.22681@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014, Jiri Kosina wrote:

> Still, the lockdep stacktrace is bogus and didn't really help 
> understanding this. Any idea why it's wrong?
> 
> >  ======================================================
> >  [ INFO: possible circular locking dependency detected ]
> >  3.18.0-rc1-00069-gc2661b8 #1 Not tainted
> >  -------------------------------------------------------
> >  do_s2disk/2367 is trying to acquire lock:
> >   (cpuidle_lock){+.+.+.}, at: [<ffffffff814916c2>] cpuidle_pause_and_lock+0x12/0x20
> >  
> > but task is already holding lock:
> >   (cpu_hotplug.lock#2){+.+.+.}, at: [<ffffffff810522ea>] cpu_hotplug_begin+0x4a/0x80
> >  
> > which lock already depends on the new lock.
> > 
> > the existing dependency chain (in reverse order) is:
> > 
> > -> #1 (cpu_hotplug.lock#2){+.+.+.}:
> >         [<ffffffff81099fac>] lock_acquire+0xac/0x130
> >         [<ffffffff815b9f2c>] mutex_lock_nested+0x5c/0x3b0
> >         [<ffffffff81491892>] cpuidle_pause+0x12/0x30

And the report is clearly bogus here. See:

$ addr2line -a ffffffff81491892 -e vmlinux-3.18.0-rc1-00068-gc2661b8
0xffffffff81491892
/dev/shm/jikos/BUILD/kernel-3.18.0_rc1_00068_gc2661b8/drivers/cpuidle/cpuidle.c:262

where the corresponding lines are

	259	void cpuidle_pause(void)
	260	{
	261		mutex_lock(&cpuidle_lock);
	262		cpuidle_uninstall_idle_handler();
	263		mutex_unlock(&cpuidle_lock);
	264	}

i.e. the RIP saved on stack clearly indicates that we are currently inside 
cpuidle_uninstall_idle_handler().

So it's clearly the case that part of the stack (which would probably 
point to synchronize_rcu_expedited()) is missing for some reason.

-- 
Jiri Kosina
SUSE Labs
