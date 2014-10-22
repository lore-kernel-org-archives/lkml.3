Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbaJVQ74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:59:56 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:61991 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752576AbaJVQ7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:59:54 -0400
Date: Wed, 22 Oct 2014 12:59:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: lockdep splat in CPU hotplug
Message-ID: <20141022125951.64fb1ed3@gandalf.local.home>
In-Reply-To: <alpine.LNX.2.00.1410221125280.22681@pobox.suse.cz>
References: <alpine.LNX.2.00.1410211255531.24255@pobox.suse.cz>
	<alpine.LNX.2.00.1410221125280.22681@pobox.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014 11:53:49 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:


> Still, the lockdep stacktrace is bogus and didn't really help 
> understanding this. Any idea why it's wrong?

Could possibly be from a tail call?

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

Where exactly does that address point to?

-- Steve

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
> >  
> > -> #0 (cpuidle_lock){+.+.+.}:
> >         [<ffffffff81099433>] __lock_acquire+0x1a03/0x1e30
> >         [<ffffffff81099fac>] lock_acquire+0xac/0x130
> >         [<ffffffff815b9f2c>] mutex_lock_nested+0x5c/0x3b0
> >         [<ffffffff814916c2>] cpuidle_pause_and_lock+0x12/0x20
> >         [<ffffffffc02e184c>] acpi_processor_hotplug+0x45/0x8a [processor]
> >         [<ffffffffc02df25a>] acpi_cpu_soft_notify+0xad/0xe3 [processor]
> >         [<ffffffff81071393>] notifier_call_chain+0x53/0xa0
> >         [<ffffffff810713e9>] __raw_notifier_call_chain+0x9/0x10
> >         [<ffffffff810521ce>] cpu_notify+0x1e/0x40
> >         [<ffffffff810524a8>] _cpu_up+0x148/0x160
> >         [<ffffffff815a7b99>] enable_nonboot_cpus+0xc9/0x1d0
> >         [<ffffffff810a0955>] hibernation_snapshot+0x265/0x370
> >         [<ffffffff810a1248>] hibernate+0x168/0x210
> >         [<ffffffff8109e9b4>] state_store+0xe4/0xf0
> >         [<ffffffff813003ef>] kobj_attr_store+0xf/0x20
> >         [<ffffffff8121e9a3>] sysfs_kf_write+0x43/0x60
> >         [<ffffffff8121e287>] kernfs_fop_write+0xe7/0x170
> >         [<ffffffff811a7342>] vfs_write+0xb2/0x1f0
> >         [<ffffffff811a7da4>] SyS_write+0x44/0xb0
> >         [<ffffffff815be856>] system_call_fastpath+0x16/0x1b
> >  
