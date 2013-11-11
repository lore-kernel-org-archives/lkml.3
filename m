Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab3KKVyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 16:54:24 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42079 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab3KKVyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 16:54:17 -0500
Date: Mon, 11 Nov 2013 22:54:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jan Kara <jack@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/4] printk: Defer printing to irq work when we printed
 too much
Message-ID: <20131111215415.GA23331@amd.pavel.ucw.cz>
References: <1383860919-1883-1-git-send-email-jack@suse.cz>
 <1383860919-1883-4-git-send-email-jack@suse.cz>
 <CAFTL4hw6wO+3Y8EpW3_swodfyV9UAaLF-KE6KC+u-5sKjKY7eA@mail.gmail.com>
 <20131107225733.GE2054@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107225733.GE2054@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > A CPU can be caught in console_unlock() for a long time (tens of seconds
> > > are reported by our customers) when other CPUs are using printk heavily
> > > and serial console makes printing slow. Despite serial console drivers
> > > are calling touch_nmi_watchdog() this triggers softlockup warnings
> > > because interrupts are disabled for the whole time console_unlock() runs
> > > (e.g. vprintk() calls console_unlock() with interrupts disabled). Thus
> > > IPIs cannot be processed and other CPUs get stuck spinning in calls like
> > > smp_call_function_many(). Also RCU eventually starts reporting lockups.
> > >
> > > In my artifical testing I can also easily trigger a situation when disk
> > > disappears from the system apparently because interrupt from it wasn't
> > > served for too long. This is why just silencing watchdogs isn't a
> > > reliable solution to the problem and we simply have to avoid spending
> > > too long in console_unlock() with interrupts disabled.
> > >
> > > The solution this patch works toward is to postpone printing to a later
> > > moment / different CPU when we already printed over X characters in
> > > current console_unlock() invocation. This is a crude heuristic but
> > > measuring time we spent printing doesn't seem to be really viable - we
> > > cannot rely on high resolution time being available and with interrupts
> > > disabled jiffies are not updated. User can tune the value X via
> > > printk.offload_chars kernel parameter.
> > >
> > > Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > 
> > When a message takes tens of seconds to be printed, it usually means
> > we are in trouble somehow :)
> > I wonder what printk source can trigger such a high volume.
>   Machines with tens of processors and thousands of scsi devices. When
> device discovery happens on boot, all processors are busily reporting new
> scsi devices and one poor looser is bound to do the printing for ever and
> ever until the machine dies...

Dunno. In these cases, would it make sense to:

1) reduce amount of text printed

2) just print [XXX characters lost] on overruns?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
