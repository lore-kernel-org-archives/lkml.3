Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab3BFUTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:19:20 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:41282 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab3BFUTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:19:17 -0500
Date: Wed, 6 Feb 2013 12:19:19 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Jan Kara <jack@suse.cz>
cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2] printk: Avoid softlockups in console_unlock()
In-Reply-To: <20130206185205.GA11254@quack.suse.cz>
Message-ID: <alpine.LNX.2.00.1302061149580.1080@eggly.anvils>
References: <1360016230-26696-1-git-send-email-jack@suse.cz> <20130205123838.146a5371.akpm@linux-foundation.org> <20130206142346.GF6330@quack.suse.cz> <alpine.DEB.2.02.1302060958150.26828@chino.kir.corp.google.com> <20130206185205.GA11254@quack.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2013, Jan Kara wrote:
> On Wed 06-02-13 09:58:48, David Rientjes wrote:
> > On Wed, 6 Feb 2013, Jan Kara wrote:
> > 
> > >   Yes, I noticed that thread just yesterday and also though that using
> > > similar trick might be viable. I'll experiment if we could use the same
> > > method for handling lockup problems I hit. Steven seems to have already
> > > tweaked PRINTK_PENDING stuff to be usable more easily...
> > > 
> > 
> > Are these new build failures in linux-next coming from this patch?
> > 
> > kernel/printk.c: In function 'console_unlock':
> > kernel/printk.c:2156:18: error: 'printk_work' undeclared (first use in this function)
> > kernel/printk.c:2156:18: note: each undeclared identifier is reported only once for each function it appears in
> > kernel/printk.c: At top level:
> > kernel/printk.c:2167:13: warning: 'printk_worker' defined but not used [-Wunused-function]
>   Yes, I already sent a patch to fix these (attached if you need it).
> Thanks for notice.

Is the console_unlock patch actually intended to be a console load test?
Could we just revert it until it's baked?

This little hunk from __console_unlock():

 	console_may_schedule = 0;
+	cur_cpu = smp_processor_id();

I have CONFIG_PREEMPT=y CONFIG_DEBUG_PREEMPT=y,
so that fills the console with messages:

BUG: using smp_processor_id() in preemptible [00000000] code: systemd/1
caller is __console_unlock+0x3c/0x39c
Pid: 1, comm: systemd Tainted: G        W    3.8.0-rc6-mm1 #1
Call Trace:
 [<ffffffff81223ee2>] debug_smp_processor_id+0xbe/0xd8
 [<ffffffff810615d8>] __console_unlock+0x3c/0x39c
 [<ffffffff810a6a38>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff8154a997>] ? _raw_spin_unlock_irqrestore+0x46/0x64
 [<ffffffff81061941>] console_unlock+0x9/0x1b
 [<ffffffff812955ab>] con_shutdown+0x29/0x2d
 [<ffffffff81295582>] ? visual_init+0x10d/0x10d
 [<ffffffff812857ed>] release_tty+0x4d/0x91
 [<ffffffff8128644f>] tty_release+0x421/0x460
 [<ffffffff81120c57>] __fput+0x104/0x1e9
 [<ffffffff81120d45>] ____fput+0x9/0xb
 [<ffffffff8107a6c3>] task_work_run+0x79/0xa6
 [<ffffffff8102f4a6>] do_notify_resume+0x55/0x66
 [<ffffffff8121e29e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8154b898>] int_signal+0x12/0x17

As a quick and obviously wrong hack, I replace the call to
smp_processor_id() by call to raw_smp_processor_id() and then:

+	/*
+	 * We give us some headroom because we check the time only after
+	 * printing the whole message
+	 */
+	end_time = sched_clock_cpu(cur_cpu) +
+				max_interrupt_disabled_duration() / 2;

Oh, sched_clock_cpu() is also giving me such BUGs,
but also (phew, it's a WARN_ON_ONCE):
 
00000] WARNING: at kernel/sched/clock.c:219 sched_clock_cpu+0x2e/0xcf()
00000] Hardware name: 4174AY9
00000] Modules linked in:
00000] Pid: 0, comm: swapper/0 Not tainted 3.8.0-rc6-mm1 #2
00000] Call Trace:
00000]  [<ffffffff8106018b>] warn_slowpath_common+0x7e/0x99
00000]  [<ffffffff810601bb>] warn_slowpath_null+0x15/0x17
00000]  [<ffffffff8108a683>] sched_clock_cpu+0x2e/0xcf
00000]  [<ffffffff810615e4>] __console_unlock+0x48/0x39e
00000]  [<ffffffff8153e648>] ? printk+0x48/0x4a
00000]  [<ffffffff81061943>] console_unlock+0x9/0x1b
00000]  [<ffffffff818f7ebc>] con_init+0x252/0x27d
00000]  [<ffffffff818f75b4>] console_init+0x16/0x27
00000]  [<ffffffff818d4c34>] start_kernel+0x243/0x322
00000]  [<ffffffff818d476b>] ? repair_env_string+0x5a/0x5a
00000]  [<ffffffff818d4485>] x86_64_start_reservations+0x2a/0x2c
00000]  [<ffffffff818d454f>] x86_64_start_kernel+0xc8/0xcc

Please fix or revert; though whether yesterday's mmotm then becomes usable,
I'm not so sure (iwlwifi broken? characters dropped from i915 screen? oops
in find_pid_ns? I'd better move on to something else).

Hugh
