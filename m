Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab3IEPqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 11:46:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901Ab3IEPqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 11:46:16 -0400
Date: Thu, 5 Sep 2013 17:46:12 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, mhocko@suse.cz, hare@suse.de,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/4 v6] Avoid softlockups in console_unlock()
Message-ID: <20130905154612.GD19782@quack.suse.cz>
References: <1377072512-7986-1-git-send-email-jack@suse.cz>
 <20130821142723.5fd8c0b0062b35ee83a68dcc@linux-foundation.org>
 <20130821225915.GA16653@quack.suse.cz>
 <20130822124913.c6de8fe61e9fd601bd83ff63@linux-foundation.org>
 <alpine.LNX.2.00.1308232146250.25124@deuxcents.site>
 <20130823125822.b3f5b946ef1e86c52834d0c3@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130823125822.b3f5b946ef1e86c52834d0c3@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Sorry for a delayed reply. I was on vacation...

On Fri 23-08-13 12:58:22, Andrew Morton wrote:
> On Fri, 23 Aug 2013 21:48:36 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wrote:
> 
> > > >   We have customers (quite a few of them actually) which have machines with
> > > > lots of SCSI disks attached (due to multipath etc.) and during boot when
> > > > these disks are discovered and partitions set up quite some printing
> > > > happens - multiplied by the number of devices (1000+) it is too much for a
> > > > serial console to handle quickly enough. So these machines aren't able to
> > > > boot with serial console enabled.
> > > 
> > > It sounds like rather a corner case, not worth mucking up the critical
> > > core logging code.
> > 
> > Andrew, I have to admit I don't understand this argument at all.
> 
> Of course you do.  print should be simple, robust and have minimum
> dependency on other kernel parts.
> 
> I suppose that if you make the proposed
> /proc/sys/kernel/max_printk_chars settable from the boot command line
> and default to zero, any risks are minimized.
  That's easy enough to do so if it makes you happy I'll go for that.
During my vacation I was also thinking how I could address some of your
concerns. The only idea I found plausible was a scheme where CPU that
wants to stop printing would raise some flag but still keep printing
releasing and reacquiring the console_sem from time to time. In
console_trylock_for_printk() we would block waiting for console_sem
if we see the flag raised.

This way we would be guaranteed someone has really taken over printing
before we leave console_unlock(). We would still need to use irq_work so
that we have someone to take over printing in case printk storm has filled
our dmesg buffer and we are now slowly getting it out to the console.

So all in all this would be a bit more complex than my current solution
(additional flag and some logic around it). The advantage is that we would
rely on irq_work only to achieve reasonable irq latency but it won't be
necessary for getting printk out to console. If this addresses your
concerns better I could try implementing that. Thoughts?

> Baling out if oops_in_progress was a good thing also.
  That's what's happening already now yes.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
