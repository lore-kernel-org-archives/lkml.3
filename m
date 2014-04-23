Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaDWLIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:08:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59453 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbaDWLIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:08:51 -0400
Date: Wed, 23 Apr 2014 13:08:47 +0200
From: Jan Kara <jack@suse.cz>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 8/8] printk: Add config option for disabling printk
 offloading
Message-ID: <20140423110847.GB17824@quack.suse.cz>
References: <1395770101-24534-1-git-send-email-jack@suse.cz>
 <1395770101-24534-9-git-send-email-jack@suse.cz>
 <20140326172332.5f1e1bfb@alan.etchedpixels.co.uk>
 <20140326192815.GC18118@quack.suse.cz>
 <20140418115438.1e65e07af17e3ba6d7c554db@linux-foundation.org>
 <20140422112259.5f106a44@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422112259.5f106a44@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 22-04-14 11:22:59, One Thousand Gnomes wrote:
> On Fri, 18 Apr 2014 11:54:38 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 26 Mar 2014 20:28:15 +0100 Jan Kara <jack@suse.cz> wrote:
> > 
> > > > All the afflicted consoles are serial, all go via the uart layer as far
> > > > as I can see.
> > > > 
> > > > The uart layer has a queue mechanism that could be used
> > >   I'm sorry, I don't follow here - what can the uart queueing be used for?
> > 
> > Alan, I'm desperate to avoid adding all this complexity to core printk
> > code to solve such a rare problem.  It'd be great if you could flesh out
> > any alternative ideas please.
> 
> It's not worth adding for upstream anyway - not in that form. If it just
> used schedule_work it would be way way cleaner anyway.
  Alan, please stop complaining that the patches don't use schedule_work()
when you didn't bother to answer to me when I was explaining to you twice
what is the problem with using schedule_work().

> For the general buffering case we already have tty_write_message(). It's
> only really intended for use by the old quota code so it's currently
> assuming nul terminated string but thats a trivial detail.
> 
> For that matter I don't see why such systems can't implement a queuecon
> console which is a queue on the printk side and a fifo on the userspace
> side.
> 
> The implementation then becomes trivial.
> 
> If you want reliable crash logging then we need to be able to set a
> printk level mask per console and just set the serial console for
> "crit/err" and the queue console for the rest, with a 'cat
> >/dev/ttywhatever' running if this feature was in use ?
  Ok, now I understand. Thanks for an interesting idea. IMO people
definitely need messages logged directly into serial console when e.g. oops
is happening because very likely they won't get logged to disk and even
userspace won't have a chance to run and copy messages to the serial
console. Plus for useful softlockup reports or oops messages you need also
the KERN_NOTICE and KERN_INFO messages - stack traces, cpu numbers, process
information - all this is printed with these levels.

These obvious places could be changed to print with lower log level I
assume but still I'm somewhat worried that some KERN_INFO messages that
would be useful for debugging a crash won't make it to console before the
crash happens.

But if both you and Andrew think that the above problems are smaller than
the complexity connected with printk offloading, I can give it a try.
Andrew?

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
