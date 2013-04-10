Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936186Ab3DJNvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:51:17 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57137 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab3DJNvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:51:15 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 10 Apr 2013 06:51:23 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Don Zickus <dzickus@redhat.com>
Cc: Dave Young <dyoung@redhat.com>, linux-watchdog@vger.kernel.org,
        kexec@lists.infradead.org, wim@iguana.be,
        LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com
Subject: Re: [RFC PATCH] watchdog: Add hook for kicking in kdump path
Message-ID: <20130410135123.GB15456@roeck-us.net>
References: <1365192994-94850-1-git-send-email-dzickus@redhat.com>
 <516259D2.7000805@redhat.com>
 <20130408124858.GC79013@redhat.com>
 <20130408151509.GA20919@roeck-us.net>
 <20130409144431.GL79013@redhat.com>
 <20130409145228.GA1111@roeck-us.net>
 <20130409151423.GM79013@redhat.com>
 <20130409160757.GA27050@roeck-us.net>
 <20130410134039.GV79013@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410134039.GV79013@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 09:40:39AM -0400, Don Zickus wrote:
> On Tue, Apr 09, 2013 at 09:07:58AM -0700, Guenter Roeck wrote:
> > > > Just look for the use of mod_timer in the watchdog directory.
> > > 
> > > So looking at the mod_timer logic in various drivers, it seems regardless
> > > if the /dev/watchdog device is opened or not, if it is running, it will
> > > automagically kick the watchdog.
> > > 
> > yes
> > 
> > > This seems that we can avoid pulling in userspace pieces for this.  Just
> > > load the driver and the hardware starts getting kicked.
> > > 
> > Only if it is already running. Also, you don't want to rely on it, because you
> > lose protection against user space issues.
> 
> IOW if something goes wrong with a runaway userspace app, the kernel
> blindly continues to kick the watchdog, which masks the problem, right?
> 
That would be wrong if any of the drivers does that. The kernel should stop
kicking after the software timeout expires.

For example, if the HW needs to be kicked every second, and the high level
timeout is set to one minute, the driver should keep kicking the hardware
watchdog for one minute and then stop doing it if /dev/watchdog was opened
and userspace is silent. 

> > 
> > A second use is if the hw watchdog needs to be pinged more often than user
> > space can provide. Some of the HW watchdogs need a ping in one-second intervals
> > or even faster.
> > 
> > > Is that true?  And if so, do all drivers detect if the hardware is already
> > > running during their init?  Or is it based on the first device open?
> > > 
> > It is usually done in the probe function.
> 
> Ok.  Thanks for the understanding of how the softdog stuff works.
> 
> However, we still have the problem that if the machine panics and we want
> to jump into the kdump kernel, we need to 'kick' the watchdog one more
> time.  This provides us a sane sync point for determining how long we have
> to load the watchdog driver in the second kernel before the hardware
> reboots us.  Otherwise the reboots are pretty random and nothing is
> guaranteed.
> 
> Hence the need for some sort of patch resembling the one I posted.
> 
> Soooooooo, any thoughts about that patch and what changes I should make?
> :-)
> 
The FIXME is a problem, and I think the name and scope would have to be
more generic (watchdog_kick ?). Also, it doesn't solve the problem
of having multiple open watchdogs (my system has three, for example),
and it doesn't check if the watchdog is running.

Guenter
