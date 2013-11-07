Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab3KGW5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 17:57:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45794 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479Ab3KGW5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 17:57:36 -0500
Date: Thu, 7 Nov 2013 23:57:33 +0100
From: Jan Kara <jack@suse.cz>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/4] printk: Defer printing to irq work when we printed
 too much
Message-ID: <20131107225733.GE2054@quack.suse.cz>
References: <1383860919-1883-1-git-send-email-jack@suse.cz>
 <1383860919-1883-4-git-send-email-jack@suse.cz>
 <CAFTL4hw6wO+3Y8EpW3_swodfyV9UAaLF-KE6KC+u-5sKjKY7eA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hw6wO+3Y8EpW3_swodfyV9UAaLF-KE6KC+u-5sKjKY7eA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 07-11-13 23:43:52, Frederic Weisbecker wrote:
> 2013/11/7 Jan Kara <jack@suse.cz>:
> > A CPU can be caught in console_unlock() for a long time (tens of seconds
> > are reported by our customers) when other CPUs are using printk heavily
> > and serial console makes printing slow. Despite serial console drivers
> > are calling touch_nmi_watchdog() this triggers softlockup warnings
> > because interrupts are disabled for the whole time console_unlock() runs
> > (e.g. vprintk() calls console_unlock() with interrupts disabled). Thus
> > IPIs cannot be processed and other CPUs get stuck spinning in calls like
> > smp_call_function_many(). Also RCU eventually starts reporting lockups.
> >
> > In my artifical testing I can also easily trigger a situation when disk
> > disappears from the system apparently because interrupt from it wasn't
> > served for too long. This is why just silencing watchdogs isn't a
> > reliable solution to the problem and we simply have to avoid spending
> > too long in console_unlock() with interrupts disabled.
> >
> > The solution this patch works toward is to postpone printing to a later
> > moment / different CPU when we already printed over X characters in
> > current console_unlock() invocation. This is a crude heuristic but
> > measuring time we spent printing doesn't seem to be really viable - we
> > cannot rely on high resolution time being available and with interrupts
> > disabled jiffies are not updated. User can tune the value X via
> > printk.offload_chars kernel parameter.
> >
> > Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> When a message takes tens of seconds to be printed, it usually means
> we are in trouble somehow :)
> I wonder what printk source can trigger such a high volume.
  Machines with tens of processors and thousands of scsi devices. When
device discovery happens on boot, all processors are busily reporting new
scsi devices and one poor looser is bound to do the printing for ever and
ever until the machine dies...

Or try running sysrq-t on a large machine with serial console connected. The
machine will die because of lockups (although in this case I agree it is more
of a problem of sysrq-t doing lots of printing in interrupt-disabled
context).

> May be cutting some huge message into smaller chunks could help? That
> would re enable interrupts between each call.
> 
> It's hard to tell without the context, but using other CPUs for
> rescuing doesn't look like a good solution. What if the issue happens
> in UP to begin with?
  The real trouble in practice is that while one cpu is doing printing,
other cpus are appending to the printk buffer. So the cpu can be printing
for a *long* time. So offloading the work to other cpus which are also
appending messages seems as a fair thing to do.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
