Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab3AQVEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 16:04:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140Ab3AQVEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 16:04:47 -0500
Date: Thu, 17 Jan 2013 22:04:42 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, jslaby@suse.cz
Subject: Re: [PATCH] printk: Avoid softlockups in console_unlock()
Message-ID: <20130117210442.GA23984@quack.suse.cz>
References: <1358272714-23375-1-git-send-email-jack@suse.cz>
 <20130115233742.e8571f92.akpm@linux-foundation.org>
 <20130116101644.GA29162@quack.suse.cz>
 <20130116145005.e20f4e53.akpm@linux-foundation.org>
 <20130116235529.GA10251@quack.suse.cz>
 <20130116161118.f6e2e6a4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116161118.f6e2e6a4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 16-01-13 16:11:18, Andrew Morton wrote:
> On Thu, 17 Jan 2013 00:55:29 +0100
> Jan Kara <jack@suse.cz> wrote:
> > > If this is all a problem then the calling code should stop doing so
> > > much printing!
> >   It's mostly a device discovery that triggers the issues in practice. They
> > have over thousand of SCSI disks attached (multipath in use) and when each
> > disk prints ~400 bytes of messages (just check your dmesg) you end up with
> > ~30s worth of printing over 115200 console.
> 
> OK.
> 
> If they're using 110 baud (nobody remembers what this word means) then
  Heh, I remember times when I was connecting to internet with 2400 baud
modem via dialup. So I do remember what baud means from those times ;).

> the 1000 chars will be too much.  More seriously, what happens if
> they're using hardware flow control and someone kicks the cable out? 
> Some people are going to want the kernel to just sit there waiting,
> until the cable gets plugged in again.
> 
> > > And punting the operation to a kernel thread is a pretty radical change
> > > - it surely adds significant risk that output will be lost.
> >   I agree there is a higher chance the output will be lost.
> > 
> > > So hrm, I dunno.  Can we just put the touch_nmi_watchdog() in there
> > > intially, see if it fixes things?  If people continue to hit problems
> > > then we can take a second look?
> >   OK, I'll see if I can get this tested on one of those machines...
> 
> Thanks.
  So I played a bit with this. To make things easier for me I added
artificial mdelay(len*10) (effectively simulating console able to print 100
characters per second) just after call_console_drivers() so that I can
trigger issues even on a machine easily available to me. Booting actually
doesn't trigger any problems because there aren't enough things happening
in parallel on common machine during boot but
  echo t >/proc/sysrq-trigger &
  for i in /lib/modules/3.8.0-rc3-0-default/kernel/fs/*/*.ko; do 
    name=`basename $i`; name=${name%.ko}; modprobe $name
  done
easily triggers the problem (as modprobe uses both RCU & IPIs to signal all
CPUs).

  Adding
	touch_nmi_watchdog();
	touch_all_softlockup_watchdogs();
	rcu_cpu_stall_reset();
  into the printk loop did stop all the warnings and the machine eventually
came alive again after finishing printing sysrq-t output (while printing
the machine was responding to ping but ssh stopped working after a while -
not sure what was happening but apparently some IO requests weren't
completing and maybe networking started dropping packets because it
accumulated too much RCU work).

So your suggestion seems certainly plausible. I was just wondering
  a) Above three lines can be pretty expensive on big machines as they
iterate over all CPUs. So we should probably limit it to once per jiffy or
something like that?
  b) Above three lines can make softlockup detection pretty useless if
there's enough printk traffic (it would be enough to printk() something
every 10s or so which can happen with netfilter logging packets or so).
But if we touch the watchdogs only if we spend more than 1 jiffy in the
console_unlock() we should hopefully touch those watchdogs only in rare
cases of heavy printk traffic.

  Thoughts?

								Honza

PS: sysrq-t was ~200 KB on that freshly booted machine so on a busy machine
that would trigger softlockups with 115200 serial console as well (I
actually do remember seeing it in some customer's reports). So it's not
just boot. 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
