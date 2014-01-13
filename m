Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbaAMH2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 02:28:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53571 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbaAMH2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 02:28:30 -0500
Date: Mon, 13 Jan 2014 08:28:27 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, pmladek@suse.cz,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/9] printk: Hand over printing to console if printing
 too long
Message-ID: <20140113072827.GF3837@quack.suse.cz>
References: <1387831171-5264-1-git-send-email-jack@suse.cz>
 <1387831171-5264-10-git-send-email-jack@suse.cz>
 <20140104235743.e6714e29.akpm@linux-foundation.org>
 <20140106094608.GA3312@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140106094608.GA3312@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 06-01-14 10:46:08, Jan Kara wrote:
> On Sat 04-01-14 23:57:43, Andrew Morton wrote:
> > On Mon, 23 Dec 2013 21:39:30 +0100 Jan Kara <jack@suse.cz> wrote:
> > 
> > > Currently, console_unlock() prints messages from kernel printk buffer to
> > > console while the buffer is non-empty. When serial console is attached,
> > > printing is slow and thus other CPUs in the system have plenty of time
> > > to append new messages to the buffer while one CPU is printing. Thus the
> > > CPU can spend unbounded amount of time doing printing in console_unlock().
> > > This is especially serious problem if the printk() calling
> > > console_unlock() was called with interrupts disabled.
> > > 
> > > In practice users have observed a CPU can spend tens of seconds printing
> > > in console_unlock() (usually during boot when hundreds of SCSI devices
> > > are discovered) resulting in RCU stalls (CPU doing printing doesn't
> > > reach quiescent state for a long time), softlockup reports (IPIs for the
> > > printing CPU don't get served and thus other CPUs are spinning waiting
> > > for the printing CPU to process IPIs), and eventually a machine death
> > > (as messages from stalls and lockups append to printk buffer faster than
> > > we are able to print). So these machines are unable to boot with serial
> > > console attached. Also during artificial stress testing SATA disk
> > > disappears from the system because its interrupts aren't served for too
> > > long.
> > > 
> > > This patch implements a mechanism where after printing specified number
> > > of characters (tunable as a kernel parameter printk.offload_chars), CPU
> > > doing printing asks for help by setting a 'hand over' state. The CPU
> > > still keeps printing until another CPU running printk() or a CPU being
> > > pinged by an IPI comes and takes over printing.  This way no CPU should
> > > spend printing too long if there is heavy printk traffic.
> > 
> > It all seems to rely on luck?  If there are 100k characters queued and
> > all the other CPUs stop calling printk(), the CPU which is left in
> > printk is screwed, isn't it?  If so, perhaps it can send an async IPI
> > to ask for help?
>   Let me cite a sentence from the changelog:
> "... until another CPU running printk() or a CPU being pinged by an IPI
> comes and takes over printing."
> 
>   So sending IPI (async one) to another CPU to come and take over printing
> is already implemented :). Do you have a better suggestion how to make that
> more obvious in the changelog?
  Ping Andrew, did you have a look at the patch?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
