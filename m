Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386AbaD2IlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:41:20 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:59159 "EHLO
	cdptpa-queue01.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932329AbaD2IlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:41:18 -0400
Date: Mon, 28 Apr 2014 13:43:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: lockdep warning after recent cleanup in console code
Message-ID: <20140428134331.68771bf7@gandalf.local.home>
In-Reply-To: <1398702925.11914.292.camel@smile.fi.intel.com>
References: <1398702925.11914.292.camel@smile.fi.intel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Peter,

Things have changed with regard to printk() in linux-next. Now it
appears that lockdep is going haywire over it. I don't understand the
exact reason for the lockdep_off() and lockdep_on() logic that is in
printk(), but it obviously seems to be causing issues with the new
changes.

Care to take a look?

-- Steve


On Mon, 28 Apr 2014 16:35:26 +0000
"Shevchenko, Andriy" <andriy.shevchenko@intel.com> wrote:

> Hei!
> 
> During weekend the linux-next was being broken by introducing a lockdep
> warning in the console code
> 
> [    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000ffffffff]
> reserved
> [    0.000000]
> [    0.000000] =============================================
> [    0.000000] [ INFO: possible recursive locking detected ]
> [    0.000000] 3.15.0-rc2-next-20140428-00030-gd3550d8 #38 Not tainted
> [    0.000000] ---------------------------------------------
> [    0.000000] swapper/0 is trying to acquire lock:
> [    0.000000]  (console_lock){......}, at: [<c10728cc>]
> register_console+0x15e/0x295
> [    0.000000]
> [    0.000000] but task is already holding lock:
> [    0.000000]  (console_lock){......}, at: [<c1071e7a>] vprintk_emit
> +0x381/0x3ea
> [    0.000000]
> [    0.000000] other info that might help us debug this:
> [    0.000000]  Possible unsafe locking scenario:
> [    0.000000]
> [    0.000000]        CPU0
> [    0.000000]        ----
> [    0.000000]   lock(console_lock);
> [    0.000000]   lock(console_lock);
> [    0.000000]
> [    0.000000]  *** DEADLOCK ***
> [    0.000000]
> [    0.000000]  May be due to missing lock nesting notation
> [    0.000000]
> [    0.000000] 3 locks held by swapper/0:
> [    0.000000]  #0:  (console_lock){......}, at: [<c1071e7a>]
> vprintk_emit+0x381/0x3ea
> [    0.000000]  #1:  (console_lock){......}, at: [<c1071e7a>]
> vprintk_emit+0x381/0x3ea
> [    0.000000]  #2:  (console_lock){......}, at: [<c1071e7a>]
> vprintk_emit+0x381/0x3ea
> [    0.000000]
> [    0.000000] stack backtrace:
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted
> 3.15.0-rc2-next-20140428-00030-gd3550d8 #38
> [    0.000000]  00000000 00000000 c186de1c c15878ae c1daf840 c186de88
> c106c154 c1794d9d
> [    0.000000]  c17958f7 c1794c9c 0000002a 00000000 00000000 c1daf840
> c1983700 00000080
> [    0.000000]  04002001 c187a0b0 00000000 c1879ba0 c1879b40 c1879b40
> 00200046 00000000
> [    0.000000] Call Trace:
> [    0.000000]  [<c15878ae>] dump_stack+0x49/0x73
> [    0.000000]  [<c106c154>] __lock_acquire+0xb31/0xc7c
> [    0.000000]  [<c106c33b>] lock_acquire+0x9c/0x111
> [    0.000000]  [<c10728cc>] ? register_console+0x15e/0x295
> [    0.000000]  [<c10707dd>] console_lock+0x41/0x46
> [    0.000000]  [<c10728cc>] ? register_console+0x15e/0x295
> [    0.000000]  [<c10728cc>] register_console+0x15e/0x295
> [    0.000000]  [<c1582f80>] early_console_register+0x33/0x35
> [    0.000000]  [<c1910411>] setup_early_printk+0x144/0x151
> [    0.000000]  [<c19013f6>] do_early_param+0x41/0x73
> [    0.000000]  [<c19013b5>] ? loglevel+0x2c/0x2c
> [    0.000000]  [<c104c766>] parse_args+0x24f/0x307
> [    0.000000]  [<c19013b5>] ? loglevel+0x2c/0x2c
> [    0.000000]  [<c190169d>] parse_early_options+0x1c/0x21
> [    0.000000]  [<c190169d>] ? parse_early_options+0x1c/0x21
> [    0.000000]  [<c19013b5>] ? loglevel+0x2c/0x2c
> [    0.000000]  [<c19016cc>] parse_early_param+0x2a/0x36
> [    0.000000]  [<c19042c0>] setup_arch+0x3c9/0xc55
> [    0.000000]  [<c1071ebe>] ? vprintk_emit+0x3c5/0x3ea
> [    0.000000]  [<c1584869>] ? printk+0x28/0x2d
> [    0.000000]  [<c1901754>] start_kernel+0x72/0x305
> [    0.000000]  [<c19012b4>] i386_start_kernel+0x82/0x86
> [    0.000000] bootconsole [earlyhsu0] enabled
> 
> Bisecting shows the culprit (which I guessed before), namely commit
> 5dc90cb49691755faaad2a395d297d0162075eca ("printk: enable interrupts 
> before calling console_trylock_for_printk()").
> 
> Following patch helps me, but I'm not familiar with console locking
> scheme, I believe there is a better solution.
> 
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -1700,8 +1700,10 @@ asmlinkage int vprintk_emit(int facility, int
> level,
>          * The release will print out buffers and wake up /dev/kmsg and
> syslog()
>          * users.
>          */
> +       lockdep_off();
>         if (console_trylock_for_printk())
>                 console_unlock();
> +       lockdep_on();
>         preempt_enable();
>  
>         return printed_len;
> 
> 

