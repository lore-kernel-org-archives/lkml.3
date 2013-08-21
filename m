Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab3HUW7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:59:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35497 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644Ab3HUW7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:59:19 -0400
Date: Thu, 22 Aug 2013 00:59:15 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        mhocko@suse.cz, hare@suse.de, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/4 v6] Avoid softlockups in console_unlock()
Message-ID: <20130821225915.GA16653@quack.suse.cz>
References: <1377072512-7986-1-git-send-email-jack@suse.cz>
 <20130821142723.5fd8c0b0062b35ee83a68dcc@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821142723.5fd8c0b0062b35ee83a68dcc@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 21-08-13 14:27:23, Andrew Morton wrote:
> On Wed, 21 Aug 2013 10:08:28 +0200 Jan Kara <jack@suse.cz> wrote:
> 
> > These patches avoid softlockups when a CPU gets caught in console_unlock() for
> > a long time during heavy printing from other CPU. As is discussed in patch 3/4
> > it isn't enough to just silence the watchdog because if CPU spends too long in
> > console_unlock() also RCU will complain, other CPUs can be blocked waiting for
> > printing CPU to process IPI, and even disk can be offlined because commands
> > couldn't be delivered to it for too long.
> > 
> > This patch series solves the problem by stopping printing in console_unlock()
> > after 1000 characters and the printing is postponed to irq work. To avoid
> > hogging a single CPU (irq work gets processed on the same CPU where it was
> > queued so it doesn't really help to reduce the printing load on that CPU) we
> > introduce a new type of lazy irq work - IRQ_WORK_UNBOUND - which can be
> > processed by any CPU.
> 
> I still hate the patchset :(
> 
> Remind us why we need this?  Whose kernel is spewing so much logging and
> why?
  We have customers (quite a few of them actually) which have machines with
lots of SCSI disks attached (due to multipath etc.) and during boot when
these disks are discovered and partitions set up quite some printing
happens - multiplied by the number of devices (1000+) it is too much for a
serial console to handle quickly enough. So these machines aren't able to
boot with serial console enabled.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
