Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497Ab3BFVaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:30:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59558 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758351Ab3BFVaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:30:03 -0500
Date: Wed, 6 Feb 2013 22:29:49 +0100
From: Jan Kara <jack@suse.cz>
To: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2] printk: Avoid softlockups in console_unlock()
Message-ID: <20130206212949.GA16931@quack.suse.cz>
References: <1360016230-26696-1-git-send-email-jack@suse.cz>
 <20130205123838.146a5371.akpm@linux-foundation.org>
 <20130206142346.GF6330@quack.suse.cz>
 <alpine.DEB.2.02.1302060958150.26828@chino.kir.corp.google.com>
 <20130206185205.GA11254@quack.suse.cz>
 <alpine.LNX.2.00.1302061149580.1080@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1302061149580.1080@eggly.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 06-02-13 12:19:19, Hugh Dickins wrote:
> On Wed, 6 Feb 2013, Jan Kara wrote:
> > On Wed 06-02-13 09:58:48, David Rientjes wrote:
> > > On Wed, 6 Feb 2013, Jan Kara wrote:
> > > 
> > > >   Yes, I noticed that thread just yesterday and also though that using
> > > > similar trick might be viable. I'll experiment if we could use the same
> > > > method for handling lockup problems I hit. Steven seems to have already
> > > > tweaked PRINTK_PENDING stuff to be usable more easily...
> > > > 
> > > 
> > > Are these new build failures in linux-next coming from this patch?
> > > 
> > > kernel/printk.c: In function 'console_unlock':
> > > kernel/printk.c:2156:18: error: 'printk_work' undeclared (first use in this function)
> > > kernel/printk.c:2156:18: note: each undeclared identifier is reported only once for each function it appears in
> > > kernel/printk.c: At top level:
> > > kernel/printk.c:2167:13: warning: 'printk_worker' defined but not used [-Wunused-function]
> >   Yes, I already sent a patch to fix these (attached if you need it).
> > Thanks for notice.
> 
> Is the console_unlock patch actually intended to be a console load test?
> Could we just revert it until it's baked?
  Yeah, agreed. I'll probably go sligthly different route anyway.

> This little hunk from __console_unlock():
> 
>  	console_may_schedule = 0;
> +	cur_cpu = smp_processor_id();
> 
> I have CONFIG_PREEMPT=y CONFIG_DEBUG_PREEMPT=y,
> so that fills the console with messages:
  Thanks for report, I'll take this in consideration when working on the next
version of the patch. Somehow console_unlock() was never called from the
context you show below in my testing.

> BUG: using smp_processor_id() in preemptible [00000000] code: systemd/1
> caller is __console_unlock+0x3c/0x39c
> Pid: 1, comm: systemd Tainted: G        W    3.8.0-rc6-mm1 #1
> Call Trace:
>  [<ffffffff81223ee2>] debug_smp_processor_id+0xbe/0xd8
>  [<ffffffff810615d8>] __console_unlock+0x3c/0x39c
>  [<ffffffff810a6a38>] ? trace_hardirqs_on+0xd/0xf
>  [<ffffffff8154a997>] ? _raw_spin_unlock_irqrestore+0x46/0x64
>  [<ffffffff81061941>] console_unlock+0x9/0x1b
>  [<ffffffff812955ab>] con_shutdown+0x29/0x2d
>  [<ffffffff81295582>] ? visual_init+0x10d/0x10d
>  [<ffffffff812857ed>] release_tty+0x4d/0x91
>  [<ffffffff8128644f>] tty_release+0x421/0x460
>  [<ffffffff81120c57>] __fput+0x104/0x1e9
>  [<ffffffff81120d45>] ____fput+0x9/0xb
>  [<ffffffff8107a6c3>] task_work_run+0x79/0xa6
>  [<ffffffff8102f4a6>] do_notify_resume+0x55/0x66
>  [<ffffffff8121e29e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff8154b898>] int_signal+0x12/0x17

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
