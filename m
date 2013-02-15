Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab3BOWWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 17:22:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab3BOWWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:22:21 -0500
Date: Fri, 15 Feb 2013 14:22:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "kay.sievers" <kay.sievers@vrfy.org>
Subject: Re: [PATCH 3/3] printk: Avoid softlockups in console_unlock()
Message-Id: <20130215142219.01915825.akpm@linux-foundation.org>
In-Reply-To: <20130215165710.GB12734@quack.suse.cz>
References: <1360112748.2621.25.camel@gandalf.local.home>
	<20130206230220.GA18329@quack.suse.cz>
	<20130215165710.GB12734@quack.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2013 17:57:10 +0100
Jan Kara <jack@suse.cz> wrote:

> A CPU can be caught in console_unlock() for a long time (tens of seconds are
> reported by our customers) when other CPUs are using printk heavily and serial
> console makes printing slow. Despite serial console drivers are calling
> touch_nmi_watchdog() this triggers softlockup warnings because
> interrupts are disabled for the whole time console_unlock() runs (e.g.
> vprintk() calls console_unlock() with interrupts disabled). Thus IPIs
> cannot be processed and other CPUs get stuck spinning in calls like
> smp_call_function_many(). Also RCU eventually starts reporting lockups.
> 
> In my artifical testing I also managed to trigger a situation when disk
> disappeared from the system apparently because commands to / from it
> could not be delivered for long enough. This is why just silencing
> watchdogs isn't a reliable solution to the problem and we simply have to
> avoid spending too long in console_unlock().
> 
> We fix the issue by limiting the time we spend in console_unlock() to
> watchdog_thresh() / 4 (unless we are in an early boot stage or oops is
> happening). The rest of the buffer will be printed either by further
> callers to printk() or during next timer tick.
> 

It still gives me tummy ache :(

The patch adds additional tests of oops_in_progress.  Some description
of your thinking on that matter would be appropriate?

> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -1990,17 +1990,31 @@ int is_console_locked(void)
>  #define PRINTK_PENDING_OUTPUT	2
>  
>  static unsigned long printk_pending;
> +static int last_printing_cpu = -1;
> +
> +static bool __console_unlock(void);
>  
>  void printk_tick(void)

printk_tick() no longer exists in linux-next.

