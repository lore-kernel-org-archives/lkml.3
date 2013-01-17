Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab3AQXuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 18:50:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab3AQXub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 18:50:31 -0500
Date: Thu, 17 Jan 2013 15:50:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, jslaby@suse.cz
Subject: Re: [PATCH] printk: Avoid softlockups in console_unlock()
Message-Id: <20130117155029.cb70ec95.akpm@linux-foundation.org>
In-Reply-To: <20130117234614.GB10127@quack.suse.cz>
References: <1358272714-23375-1-git-send-email-jack@suse.cz>
	<20130115233742.e8571f92.akpm@linux-foundation.org>
	<20130116101644.GA29162@quack.suse.cz>
	<20130116145005.e20f4e53.akpm@linux-foundation.org>
	<20130116235529.GA10251@quack.suse.cz>
	<20130116161118.f6e2e6a4.akpm@linux-foundation.org>
	<20130117210442.GA23984@quack.suse.cz>
	<20130117133917.0f75728e.akpm@linux-foundation.org>
	<20130117234614.GB10127@quack.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2013 00:46:14 +0100
Jan Kara <jack@suse.cz> wrote:

> On Thu 17-01-13 13:39:17, Andrew Morton wrote:
> > On Thu, 17 Jan 2013 22:04:42 +0100
> > Jan Kara <jack@suse.cz> wrote:
> > 
> > > ...
> > >
> > >   So I played a bit with this. To make things easier for me I added
> > > artificial mdelay(len*10) (effectively simulating console able to print 100
> > > characters per second) just after call_console_drivers() so that I can
> > > trigger issues even on a machine easily available to me. Booting actually
> > > doesn't trigger any problems because there aren't enough things happening
> > > in parallel on common machine during boot but
> > >   echo t >/proc/sysrq-trigger &
> > >   for i in /lib/modules/3.8.0-rc3-0-default/kernel/fs/*/*.ko; do 
> > >     name=`basename $i`; name=${name%.ko}; modprobe $name
> > >   done
> > > easily triggers the problem (as modprobe uses both RCU & IPIs to signal all
> > > CPUs).
> > > 
> > >   Adding
> > > 	touch_nmi_watchdog();
> > > 	touch_all_softlockup_watchdogs();
> > > 	rcu_cpu_stall_reset();
> > 
> > I'm not sure that touch_all_softlockup_watchdogs() is needed? 
> > touch_nmi_watchdog() itself calls touch_softlockup_watchdog().
>   It is. I've tried without it and the machine died a horrible death
> because softlockup reports added to already too heavy printk traffic. The
> problem is that CPU doing printing cannot handle IPIs thus if someone calls
> e.g. smp_call_function_many() that function will spin waiting for IPIs on
> all CPUs to finish. And that doesn't happen until printing is done so
> CPU doing smp_call_function_many() gets locked up as well.

erk.  I trust we'll have a nice comment explaining this mechanism ;)


