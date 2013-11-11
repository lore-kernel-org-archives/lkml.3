Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab3KKWSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 17:18:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375Ab3KKWR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 17:17:58 -0500
Date: Mon, 11 Nov 2013 23:17:55 +0100
From: Jan Kara <jack@suse.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jan Kara <jack@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/4] printk: Defer printing to irq work when we printed
 too much
Message-ID: <20131111221755.GA31266@quack.suse.cz>
References: <1383860919-1883-1-git-send-email-jack@suse.cz>
 <1383860919-1883-4-git-send-email-jack@suse.cz>
 <CAFTL4hw6wO+3Y8EpW3_swodfyV9UAaLF-KE6KC+u-5sKjKY7eA@mail.gmail.com>
 <20131107225733.GE2054@quack.suse.cz>
 <20131111215415.GA23331@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111215415.GA23331@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 11-11-13 22:54:15, Pavel Machek wrote:
> Hi!
> 
> > > > A CPU can be caught in console_unlock() for a long time (tens of seconds
> > > > are reported by our customers) when other CPUs are using printk heavily
> > > > and serial console makes printing slow. Despite serial console drivers
> > > > are calling touch_nmi_watchdog() this triggers softlockup warnings
> > > > because interrupts are disabled for the whole time console_unlock() runs
> > > > (e.g. vprintk() calls console_unlock() with interrupts disabled). Thus
> > > > IPIs cannot be processed and other CPUs get stuck spinning in calls like
> > > > smp_call_function_many(). Also RCU eventually starts reporting lockups.
> > > >
> > > > In my artifical testing I can also easily trigger a situation when disk
> > > > disappears from the system apparently because interrupt from it wasn't
> > > > served for too long. This is why just silencing watchdogs isn't a
> > > > reliable solution to the problem and we simply have to avoid spending
> > > > too long in console_unlock() with interrupts disabled.
> > > >
> > > > The solution this patch works toward is to postpone printing to a later
> > > > moment / different CPU when we already printed over X characters in
> > > > current console_unlock() invocation. This is a crude heuristic but
> > > > measuring time we spent printing doesn't seem to be really viable - we
> > > > cannot rely on high resolution time being available and with interrupts
> > > > disabled jiffies are not updated. User can tune the value X via
> > > > printk.offload_chars kernel parameter.
> > > >
> > > > Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> > > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > 
> > > When a message takes tens of seconds to be printed, it usually means
> > > we are in trouble somehow :)
> > > I wonder what printk source can trigger such a high volume.
> >   Machines with tens of processors and thousands of scsi devices. When
> > device discovery happens on boot, all processors are busily reporting new
> > scsi devices and one poor looser is bound to do the printing for ever and
> > ever until the machine dies...
> 
> Dunno. In these cases, would it make sense to:
> 
> 1) reduce amount of text printed
  I thought about this as well. But
a) It doesn't seem practical as you would have to modify lots of drivers
   and keep them rather silent. That seems rather fragile. Plus you will
   not display some potentially useful information.
b) It doesn't address the real underlying problem that the way printk() is
   currently implemented, there is no bound on the time CPU spends in the
   loop printing from buffer to console. And the fact that this loop
   sometimes happens with interrupts disabled makes the situation even
   worse.
 
> 2) just print [XXX characters lost] on overruns?
  We don't overrun the printk buffer so no characters are lost. It just
takes too long to feed the whole printk buffer through serial console...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
