Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbaDWO3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:29:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbaDWO3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:29:39 -0400
Date: Wed, 23 Apr 2014 16:29:35 +0200
From: Jan Kara <jack@suse.cz>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 8/8] printk: Add config option for disabling printk
 offloading
Message-ID: <20140423142935.GG17824@quack.suse.cz>
References: <1395770101-24534-1-git-send-email-jack@suse.cz>
 <1395770101-24534-9-git-send-email-jack@suse.cz>
 <20140326172332.5f1e1bfb@alan.etchedpixels.co.uk>
 <20140326192815.GC18118@quack.suse.cz>
 <20140418115438.1e65e07af17e3ba6d7c554db@linux-foundation.org>
 <20140422112259.5f106a44@alan.etchedpixels.co.uk>
 <20140423110847.GB17824@quack.suse.cz>
 <20140423133544.5598c18a@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423133544.5598c18a@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 23-04-14 13:35:44, One Thousand Gnomes wrote:
> > > It's not worth adding for upstream anyway - not in that form. If it just
> > > used schedule_work it would be way way cleaner anyway.
> >   Alan, please stop complaining that the patches don't use schedule_work()
> > when you didn't bother to answer to me when I was explaining to you twice
> > what is the problem with using schedule_work().
> 
> I have not seen any response to the schedule_work() comment. If the
> filters ate it then I apologize.
  Ah, OK. I'm quoting my older email:
Yes, I know about schedule_work() and I've used it about an year (and ~10
patchset iterations) ago when first trying to solve this problem. The
problem with using workqueues is that if workqueue code ever does printk()
while holding some workqueue lock, we could deadlock when trying to do
schedule_work() from printk which might need the same lock. And people were
objecting to restricting workqueue code to not call printk(). That's why
I've chosen dedicated kthreads were we have tight control over what they
do.

> > console. Plus for useful softlockup reports or oops messages you need also
> > the KERN_NOTICE and KERN_INFO messages - stack traces, cpu numbers, process
> > information - all this is printed with these levels.
> 
> If there is softlockup and oops trace data being printed at KERN_INFO
> that could be fixed by changing the level.
  Agreed.

> > These obvious places could be changed to print with lower log level I
> > assume but still I'm somewhat worried that some KERN_INFO messages that
> > would be useful for debugging a crash won't make it to console before the
> > crash happens.
> 
> That's true whatever you do. Either your output is synchronous and makes
> it out because it is physically output before the box is permitted to go
> bang, or its asynchronous in which case be it work queue, thread or
> anything else it may not get out.
  Well, my patches make sure that while there is something to print, there
is also a cpu feeding messages to console (which is what we have now but
with my patches the role of printing cpu could be handed over among cpus).
So unless you are heavily screwed (like machine instantly rebooting), all
the messages will appear on serial console. Just queueing less important
messages for printing by userspace is a regression from this state.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
