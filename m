Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab3KPLfM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 06:35:12 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47246 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab3KPLfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 06:35:08 -0500
Date: Sat, 16 Nov 2013 12:35:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jan Kara <jack@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/4] printk: Defer printing to irq work when we printed
 too much
Message-ID: <20131116113506.GA30605@amd.pavel.ucw.cz>
References: <1383860919-1883-1-git-send-email-jack@suse.cz>
 <1383860919-1883-4-git-send-email-jack@suse.cz>
 <CAFTL4hw6wO+3Y8EpW3_swodfyV9UAaLF-KE6KC+u-5sKjKY7eA@mail.gmail.com>
 <20131107225733.GE2054@quack.suse.cz>
 <20131111215415.GA23331@amd.pavel.ucw.cz>
 <20131111221755.GA31266@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111221755.GA31266@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> > > > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > > 
> > > > When a message takes tens of seconds to be printed, it usually means
> > > > we are in trouble somehow :)
> > > > I wonder what printk source can trigger such a high volume.
> > >   Machines with tens of processors and thousands of scsi devices. When
> > > device discovery happens on boot, all processors are busily reporting new
> > > scsi devices and one poor looser is bound to do the printing for ever and
> > > ever until the machine dies...
> > 
> > Dunno. In these cases, would it make sense to:
> > 
> > 1) reduce amount of text printed
>   I thought about this as well. But
> a) It doesn't seem practical as you would have to modify lots of drivers
>    and keep them rather silent. That seems rather fragile. Plus you will
>    not display some potentially useful information.
> b) It doesn't address the real underlying problem that the way printk() is
>    currently implemented, there is no bound on the time CPU spends in the
>    loop printing from buffer to console. And the fact that this loop
>    sometimes happens with interrupts disabled makes the situation even
>    worse.
>  
> > 2) just print [XXX characters lost] on overruns?
>   We don't overrun the printk buffer so no characters are lost. It just
> takes too long to feed the whole printk buffer through serial console...

Yes, I know. No characters are lost, but we spend seconds with
interrupts disabled, breaking the system. (SCSI timeouts? We do
keyboard autorepeat in software these days...)

Would it be better to just drop the characters?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
