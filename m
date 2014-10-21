Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbaJUPVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:21:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52085 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbaJUPVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:21:23 -0400
Date: Tue, 21 Oct 2014 17:21:21 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dave Jones <davej@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: lockdep splat in CPU hotplug
In-Reply-To: <20141021151043.GA11800@redhat.com>
Message-ID: <alpine.LNX.2.00.1410211717210.24255@pobox.suse.cz>
References: <alpine.LNX.2.00.1410211255531.24255@pobox.suse.cz> <20141021151043.GA11800@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2014, Dave Jones wrote:

>  > I am seeing the lockdep report below when resuming from suspend-to-disk 
>  > with current Linus' tree (c2661b80609).
>  > 
>  > The reason for CCing Ingo and Peter is that I can't make any sense of one 
>  > of the stacktraces lockdep is providing.
>  > 
>  > Please have a look at the very first stacktrace in the dump, where lockdep 
>  > is trying to explain where cpu_hotplug.lock#2 has been acquired. It seems 
>  > to imply that cpuidle_pause() is taking cpu_hotplug.lock, but that's not 
>  > the case at all.
> 
> Could inlining be confusing the trace here ?
> 
> You can get from cpuidle_pause to cpuidle_uninstall_idle_handler -> synchronize_rcu
>  -> synchronize_sched -> synchronize_sched_expedited which
> does a try_get_online_cpus which will take the cpu_hotplug.lock

Looks like this indeed is something that lockdep *should* report (*), 
although I would be suprised that stack unwinder would be so confused by 
this -- there is no way for synchronize_sched_expedited() to be inlined 
all the way to cpuidle_pause().

(*) there are multiple places where cpu_hotplug.lock -> cpuidle_lock lock 
    dependency is assumed. The patch that Dave pointed out adds 
    cpuidle_lock -> cpu_hotplug.lock dependency.

Still not clear whether this is what's happening here ... anyway, adding 
Paul to CC.

-- 
Jiri Kosina
SUSE Labs
