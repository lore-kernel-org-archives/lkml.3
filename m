Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbaEOV2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:28:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57045 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704AbaEOV2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:28:51 -0400
Date: Thu, 15 May 2014 23:28:48 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 8/8] printk: Add config option for disabling printk
 offloading
Message-ID: <20140515212848.GA11025@quack.suse.cz>
References: <1395770101-24534-1-git-send-email-jack@suse.cz>
 <1395770101-24534-9-git-send-email-jack@suse.cz>
 <20140326172332.5f1e1bfb@alan.etchedpixels.co.uk>
 <20140326192815.GC18118@quack.suse.cz>
 <20140418115438.1e65e07af17e3ba6d7c554db@linux-foundation.org>
 <20140422112259.5f106a44@alan.etchedpixels.co.uk>
 <20140423110847.GB17824@quack.suse.cz>
 <20140423111750.88ad799bb271a1fe0bed119f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423111750.88ad799bb271a1fe0bed119f@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 23-04-14 11:17:50, Andrew Morton wrote:
> On Wed, 23 Apr 2014 13:08:47 +0200 Jan Kara <jack@suse.cz> wrote:
> 
> > > If you want reliable crash logging then we need to be able to set a
> > > printk level mask per console and just set the serial console for
> > > "crit/err" and the queue console for the rest, with a 'cat
> > > >/dev/ttywhatever' running if this feature was in use ?
> >   Ok, now I understand. Thanks for an interesting idea. IMO people
> > definitely need messages logged directly into serial console when e.g. oops
> > is happening because very likely they won't get logged to disk and even
> > userspace won't have a chance to run and copy messages to the serial
> > console. Plus for useful softlockup reports or oops messages you need also
> > the KERN_NOTICE and KERN_INFO messages - stack traces, cpu numbers, process
> > information - all this is printed with these levels.
> > 
> > These obvious places could be changed to print with lower log level I
> > assume but still I'm somewhat worried that some KERN_INFO messages that
> > would be useful for debugging a crash won't make it to console before the
> > crash happens.
> > 
> > But if both you and Andrew think that the above problems are smaller than
> > the complexity connected with printk offloading, I can give it a try.
> > Andrew?
> 
> I'm curious about the idea of writing a new(?) console driver which the
> problematic machines can use.
> 
> The problem of course will be in sizing the driver's queue.  Perhaps we
> can have a driver which uses a huge queue, temporarily use that driver
> during boot then switch over to a conventional console driver?
  I was for some time thinking about this and I have some questions:
1) How is this better than just stopping printing from kernel log buffer
   early (before we write everything)? It makes no difference whether the
   message sits in kernel log buffer or driver's buffer, does it?
2) Serial drivers usually write like:
   for each char
     poll until port ready
     write char

   Hooking up something like this to a buffering layer seems as a
non-trivial task. After all some CPU still has to do the polling and
printing all those driver buffers so we have just moved the problem from
console_unlock() to some drivers / another buffering layer.

  So does this approach really bring any advantage?

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
