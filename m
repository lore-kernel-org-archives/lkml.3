Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937078Ab3DJQat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:30:49 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60938 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936994Ab3DJQas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:30:48 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 10 Apr 2013 09:30:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Don Zickus <dzickus@redhat.com>
Cc: Dave Young <dyoung@redhat.com>, linux-watchdog@vger.kernel.org,
        kexec@lists.infradead.org, wim@iguana.be,
        LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com
Subject: Re: [RFC PATCH] watchdog: Add hook for kicking in kdump path
Message-ID: <20130410163056.GB23891@roeck-us.net>
References: <20130408151509.GA20919@roeck-us.net>
 <20130409144431.GL79013@redhat.com>
 <20130409145228.GA1111@roeck-us.net>
 <20130409151423.GM79013@redhat.com>
 <20130409160757.GA27050@roeck-us.net>
 <20130410134039.GV79013@redhat.com>
 <20130410135123.GB15456@roeck-us.net>
 <20130410142055.GW79013@redhat.com>
 <20130410151041.GA6670@roeck-us.net>
 <20130410161739.GY79013@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410161739.GY79013@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 12:17:39PM -0400, Don Zickus wrote:
> On Wed, Apr 10, 2013 at 08:10:41AM -0700, Guenter Roeck wrote:
> > On Wed, Apr 10, 2013 at 10:20:55AM -0400, Don Zickus wrote:
> > > On Wed, Apr 10, 2013 at 06:51:23AM -0700, Guenter Roeck wrote:
> > > > On Wed, Apr 10, 2013 at 09:40:39AM -0400, Don Zickus wrote:
> > > > > On Tue, Apr 09, 2013 at 09:07:58AM -0700, Guenter Roeck wrote:
> > > > > > > > Just look for the use of mod_timer in the watchdog directory.
> > > > > > > 
> > > > > > > So looking at the mod_timer logic in various drivers, it seems regardless
> > > > > > > if the /dev/watchdog device is opened or not, if it is running, it will
> > > > > > > automagically kick the watchdog.
> > > > > > > 
> > > > > > yes
> > > > > > 
> > > > > > > This seems that we can avoid pulling in userspace pieces for this.  Just
> > > > > > > load the driver and the hardware starts getting kicked.
> > > > > > > 
> > > > > > Only if it is already running. Also, you don't want to rely on it, because you
> > > > > > lose protection against user space issues.
> > > > > 
> > > > > IOW if something goes wrong with a runaway userspace app, the kernel
> > > > > blindly continues to kick the watchdog, which masks the problem, right?
> > > > > 
> > > > That would be wrong if any of the drivers does that. The kernel should stop
> > > > kicking after the software timeout expires.
> > > > 
> > > > For example, if the HW needs to be kicked every second, and the high level
> > > > timeout is set to one minute, the driver should keep kicking the hardware
> > > > watchdog for one minute and then stop doing it if /dev/watchdog was opened
> > > > and userspace is silent. 
> > > 
> > > Ah ok.
> > > 
> > > > 
> > > > > > 
> > > > > > A second use is if the hw watchdog needs to be pinged more often than user
> > > > > > space can provide. Some of the HW watchdogs need a ping in one-second intervals
> > > > > > or even faster.
> > > > > > 
> > > > > > > Is that true?  And if so, do all drivers detect if the hardware is already
> > > > > > > running during their init?  Or is it based on the first device open?
> > > > > > > 
> > > > > > It is usually done in the probe function.
> > > > > 
> > > > > Ok.  Thanks for the understanding of how the softdog stuff works.
> > > > > 
> > > > > However, we still have the problem that if the machine panics and we want
> > > > > to jump into the kdump kernel, we need to 'kick' the watchdog one more
> > > > > time.  This provides us a sane sync point for determining how long we have
> > > > > to load the watchdog driver in the second kernel before the hardware
> > > > > reboots us.  Otherwise the reboots are pretty random and nothing is
> > > > > guaranteed.
> > > > > 
> > > > > Hence the need for some sort of patch resembling the one I posted.
> > > > > 
> > > > > Soooooooo, any thoughts about that patch and what changes I should make?
> > > > > :-)
> > > > > 
> > > > The FIXME is a problem, and I think the name and scope would have to be
> > > > more generic (watchdog_kick ?). Also, it doesn't solve the problem
> > > > of having multiple open watchdogs (my system has three, for example),
> > > > and it doesn't check if the watchdog is running.
> > > 
> > > Ok.  I didn't know the watchdog subsystem well enough, so I just took
> > > stabs in the dark about how things should work.  I appreciate the
> > > feedback.
> > > 
> > > I could make the name more generic.  I wasn't sure if the watchdog
> > > community would frown on that.  The FIXME is a problem, I am not sure how
> > 
> > I don't know what others think, but I would prefer a more generic name.
> > That its current use is for kdump is besides the point; there could be
> > other valid uses.
> 
> Ok.
> 
> > 
> > > to handle the 'fail' scenario (can't get the mutex with trylock).  And I
> > 
> > I would just return without doing anything. After all, if the mutex is held,
> > it is possible if not likely that the code crashed _in_ the watchdog code,
> > so it might be better to just let it crash and burn in that case.
> 
> Hmm. Interesting point.  So you are implying most watchdog mutex locks surround
> quickly executed code that are not called often.  And if we do catch the
> mutex being held it is either because the watchdog code has failed (bad)
> or just bad timing :-).
> 
Hopefully all locks are for short periods of time ;).

Since the lock is per device, it would either mean that the code has crashed
there, or that some other entity is busy dealing with the device, presumably
trying to ping it. Either case, I think the best (safest) way to deal with
the situation would be to ignore it.

> For now I can just do the trylock and return on failure, printing a big
> fat warning for post-debug purposes.  If it becomes a bigger problem, we
> can refine the approach later I guess.
> 
Ok.

> > 
> > > have no idea how to even find out if multiple watchdogs are open on the
> > > system.  Is there a list I could walk?  And with regard to 'watchdog is
> > 
> > /* the dev_t structure to store the dynamically allocated watchdog devices */
> > static dev_t watchdog_devt;
> > 
> > One way to look up the allocated watchdogs might be to loop through all kobj
> > instances for the major device using kobj_lookup. Don't know if there is a
> > better way.
> 
> I can poke at that to see if I can get something to work.  Thanks.
> 
> > 
> > > running', I thought 'watchdog_active' would do that.  But again, I could
> > > be misreading the code.
> > > 
> > You are right. Missed that part, sorry.
> 
> No problem, just wanted to make sure I was understanding things correctly.
> 
> Again thanks for the feedback.  I'll spin a V2.
> 
Make sure you add the kexec maintainer to Cc and get an Ack.

Guenter
