Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbaCNNaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 09:30:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927AbaCNNaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 09:30:24 -0400
Date: Fri, 14 Mar 2014 14:30:21 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        pmladek@suse.cz, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 5/6] printk: Hand over printing to console if printing
 too long
Message-ID: <20140314133021.GE18583@quack.suse.cz>
References: <1394726318-2757-1-git-send-email-jack@suse.cz>
 <1394726318-2757-6-git-send-email-jack@suse.cz>
 <20140313160625.1c62ca6bba080286194aa868@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140313160625.1c62ca6bba080286194aa868@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 13-03-14 16:06:25, Andrew Morton wrote:
> On Thu, 13 Mar 2014 16:58:37 +0100 Jan Kara <jack@suse.cz> wrote:
> 
> > Currently, console_unlock() prints messages from kernel printk buffer to
> > console while the buffer is non-empty. When serial console is attached,
> > printing is slow and thus other CPUs in the system have plenty of time
> > to append new messages to the buffer while one CPU is printing. Thus the
> > CPU can spend unbounded amount of time doing printing in console_unlock().
> > This is especially serious problem if the printk() calling
> > console_unlock() was called with interrupts disabled.
> > 
> > In practice users have observed a CPU can spend tens of seconds printing
> > in console_unlock() (usually during boot when hundreds of SCSI devices
> > are discovered) resulting in RCU stalls (CPU doing printing doesn't
> > reach quiescent state for a long time), softlockup reports (IPIs for the
> > printing CPU don't get served and thus other CPUs are spinning waiting
> > for the printing CPU to process IPIs), and eventually a machine death
> > (as messages from stalls and lockups append to printk buffer faster than
> > we are able to print). So these machines are unable to boot with serial
> > console attached. Also during artificial stress testing SATA disk
> > disappears from the system because its interrupts aren't served for too
> > long.
> > 
> > This patch implements a mechanism where after printing specified number
> > of characters (tunable as a kernel parameter printk.offload_chars), CPU
> > doing printing asks for help by setting PRINTK_HANDOVER_B bit in
> > printk_handover_state variable and wakes up one of dedicated kthreads.
> > As soon as the printing CPU notices kthread got scheduled and is
> > spinning on console_sem, it drops console_sem and exits
> > console_unlock(). kthread then takes over printing instead.  This way no
> > CPU should spend printing too long even if there is heavy printk
> > traffic.
> 
> Sigh ;)
> 
> Creating yet more kernel threads to solve this problem is a bit sad. 
> Is there no way in which we can borrow one of the existing threads?
  I realized I didn't react to the above. I've checked which kernel threads
are running on my system and I can see:
rcu related threads, ksoftirqd, various fs threads, kauditd - nothing
really seems as a good fit. Then there are various workqueue related
threads - these aren't really suitable either. Finally I can see migration
threads (from kernel/stop_machine.c) - I'm not sure I want to mess with
these - especially since they can run any function somebody passes to them
and when that function calls printk() things might get interesting.

So I would go for starting the threads only if printk.offload_chars ever
gets set to value > 0.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
