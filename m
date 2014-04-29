Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212AbaD2IiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:38:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:37170 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbaD2IiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:38:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,949,1389772800"; 
   d="scan'208";a="530317561"
Message-ID: <1398760684.23470.1.camel@smile.fi.intel.com>
Subject: Re: lockdep warning after recent cleanup in console code
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Date: Tue, 29 Apr 2014 11:38:04 +0300
In-Reply-To: <20140428192416.GE9091@quack.suse.cz>
References: <1398702925.11914.292.camel@smile.fi.intel.com>
	 <20140428134331.68771bf7@gandalf.local.home>
	 <20140428175139.GD9091@quack.suse.cz>
	 <20140428141439.3580dce9@gandalf.local.home>
	 <20140428192416.GE9091@quack.suse.cz>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 21:24 +0200, Jan Kara wrote:
> On Mon 28-04-14 14:14:39, Steven Rostedt wrote:
> > On Mon, 28 Apr 2014 19:51:39 +0200
> > Jan Kara <jack@suse.cz> wrote:
> > 
> > > On Mon 28-04-14 13:43:31, Steven Rostedt wrote:
> > > > Things have changed with regard to printk() in linux-next. Now it
> > > > appears that lockdep is going haywire over it. I don't understand the
> > > > exact reason for the lockdep_off() and lockdep_on() logic that is in
> > > > printk(), but it obviously seems to be causing issues with the new
> > > > changes.
> > > > 
> > > > Care to take a look?
> > >   The obvious cause is that I moved lockdep_on() somewhat earlier in
> > > vprintk_emit() so lockdep now covers more of printk code. And apparently
> > > something is wrong there...
> > > 
> > 
> > Exactly, and I rather know *exactly* what is wrong before we just start
> > throwing patches at the problem and hope it goes away. That's not how
> > to solve a software bug.
>   So I had a look and we are missing mutex_release() in
> console_trylock_for_printk() if we don't have a console to print to.
> Attached patch should fix the problem.

Besides it doesn't apply clearly on top of today's linux-next, it
doesn't fix the issue, but modifies it a bit.


[    0.000000] =============================================
[    0.000000] [ INFO: possible recursive locking detected ]
[    0.000000] 3.15.0-rc3-next-20140429-00031-gb91b421 #54 Not tainted
[    0.000000] ---------------------------------------------
[    0.000000] swapper/0 is trying to acquire lock:
[    0.000000]  (console_lock){......}, at: [<c107078b>] console_lock
+0x8/0x27
[    0.000000] 
[    0.000000] but task is already holding lock:
[    0.000000]  (console_lock){......}, at: [<c1070be5>] console_trylock
+0x1b/0x50
[    0.000000] 
[    0.000000] other info that might help us debug this:
[    0.000000]  Possible unsafe locking scenario:
[    0.000000] 
[    0.000000]        CPU0
[    0.000000]        ----
[    0.000000]   lock(console_lock);
[    0.000000]   lock(console_lock);
[    0.000000] 
[    0.000000]  *** DEADLOCK ***
[    0.000000] 
[    0.000000]  May be due to missing lock nesting notation
[    0.000000] 
[    0.000000] 3 locks held by swapper/0:
[    0.000000]  #0:  (console_lock){......}, at: [<c1070be5>]
console_trylock+0x1b/0x50
[    0.000000]  #1:  (console_lock){......}, at: [<c1070be5>]
console_trylock+0x1b/0x50
[    0.000000]  #2:  (console_lock){......}, at: [<c1070be5>]
console_trylock+0x1b/0x50
[    0.000000] 
[    0.000000] stack backtrace:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted
3.15.0-rc3-next-20140429-00031-gb91b421 #54
[    0.000000]  00000000 00000000 c186de14 c15879ea c1daf840 c186de80
c106c188 c1794dff
[    0.000000]  c1795959 c1794cfe 0000002a 00000000 00000000 c1daf840
c1983700 00000080
[    0.000000]  04002001 c187a0b0 00000000 00000000 c1879b40 c1879b40
00200046 00000000
[    0.000000] Call Trace:
[    0.000000]  [<c15879ea>] dump_stack+0x49/0x73
[    0.000000]  [<c106c188>] __lock_acquire+0xb31/0xc7c
[    0.000000]  [<c106c36f>] lock_acquire+0x9c/0x111
[    0.000000]  [<c107078b>] ? console_lock+0x8/0x27
[    0.000000]  [<c107077e>] down_console_sem+0x24/0x29
[    0.000000]  [<c107078b>] ? console_lock+0x8/0x27
[    0.000000]  [<c107078b>] console_lock+0x8/0x27
[    0.000000]  [<c10728e9>] register_console+0x15e/0x295
[    0.000000]  [<c15830bc>] early_console_register+0x33/0x35
[    0.000000]  [<c191047a>] setup_early_printk+0x144/0x151
[    0.000000]  [<c19013f6>] do_early_param+0x41/0x73
[    0.000000]  [<c19013b5>] ? loglevel+0x2c/0x2c
[    0.000000]  [<c104c788>] parse_args+0x271/0x33b
[    0.000000]  [<c19013b5>] ? loglevel+0x2c/0x2c
[    0.000000]  [<c19016e6>] parse_early_options+0x1c/0x21
[    0.000000]  [<c19016e6>] ? parse_early_options+0x1c/0x21
[    0.000000]  [<c19013b5>] ? loglevel+0x2c/0x2c
[    0.000000]  [<c1901715>] parse_early_param+0x2a/0x36
[    0.000000]  [<c1904329>] setup_arch+0x3c9/0xc55
[    0.000000]  [<c1071f08>] ? vprintk_emit+0x3c5/0x3ea
[    0.000000]  [<c15849a5>] ? printk+0x28/0x2d
[    0.000000]  [<c190179d>] start_kernel+0x72/0x325
[    0.000000]  [<c19012b4>] i386_start_kernel+0x82/0x86
[    0.000000] bootconsole [earlyhsu0] enabled




-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

