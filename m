Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaJ0C1t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 22:27:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51146 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbaJ0C1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 22:27:48 -0400
Date: Mon, 27 Oct 2014 10:26:37 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Neil Zhang <zhangwm@marvell.com>
Cc: Dan Streetman <ddstreet@ieee.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: base: update cpu offline info when do hotplug
Message-ID: <20141027022637.GC5540@kroah.com>
References: <1413775748-22478-1-git-send-email-zhangwm@marvell.com>
 <20141020044340.GA9589@kroah.com>
 <9034CBD80F070943B59700D7F8149ED9024EB81CAF@SC-VEXCH4.marvell.com>
 <20141020064826.GA4064@kroah.com>
 <9034CBD80F070943B59700D7F8149ED9024EB81CC6@SC-VEXCH4.marvell.com>
 <CALZtONDEdFbx+zTWYdmz3HsfCnV+RtTPAuY4p-RK1DN3g2CwrQ@mail.gmail.com>
 <9034CBD80F070943B59700D7F8149ED9024ED2A134@SC-VEXCH4.marvell.com>
 <20141027015836.GA27978@kroah.com>
 <9034CBD80F070943B59700D7F8149ED9024ED2A13D@SC-VEXCH4.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9034CBD80F070943B59700D7F8149ED9024ED2A13D@SC-VEXCH4.marvell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2014 at 07:17:14PM -0700, Neil Zhang wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: 2014年10月27日 9:59
> > To: Neil Zhang
> > Cc: Dan Streetman; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] drivers: base: update cpu offline info when do hotplug
> > 
> > On Sun, Oct 26, 2014 at 06:43:11PM -0700, Neil Zhang wrote:
> > > Greg,
> > >
> > >
> > > > -----Original Message-----
> > > > From: ddstreet@gmail.com [mailto:ddstreet@gmail.com] On Behalf Of
> > > > Dan Streetman
> > > > Sent: 2014年10月21日 1:03
> > > > To: Neil Zhang
> > > > Cc: Greg KH; linux-kernel@vger.kernel.org
> > > > Subject: Re: [PATCH] drivers: base: update cpu offline info when do
> > > > hotplug
> > > >
> > > > On Mon, Oct 20, 2014 at 3:40 AM, Neil Zhang <zhangwm@marvell.com> wrote:
> > > > > Greg,
> > > > >
> > > > >
> > > > > -----Original Message-----
> > > > > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > > > > Sent: 2014年10月20日 14:48
> > > > > To: Neil Zhang
> > > > > Cc: linux-kernel@vger.kernel.org
> > > > > Subject: Re: [PATCH] drivers: base: update cpu offline info when
> > > > > do hotplug
> > > > >
> > > > > On Sun, Oct 19, 2014 at 11:39:23PM -0700, Neil Zhang wrote:
> > > > >>> How much noise is this going to cause on a big/little system
> > > > >>> that constantly hot unplug/plugs processors all of the time?
> > > > >>
> > > > >> Can you explain more what kind of noise will be introduced on a
> > > > >> big/little
> > > > system?
> > > > >
> > > > > Have you tested this on such a machine?
> > > > >
> > > > > I didn't have such kind of machine on hand.
> > > > > Can anyone has such machine to verify it?
> > > > > Thanks!
> > > >
> > > > I tested this on a ppc PowerVM system, using dlpar operations to
> > > > remove/add cpus.
> > > >
> > > > Without this patch the cpu online nodes get out of sync with the
> > > > main online node (and the actual state of the cpus), because they
> > > > aren't updated as the cpus are brought up/down:
> > > >
> > > > [root@br10p02 cpu]$ pwd
> > > > /sys/devices/system/cpu
> > > > [root@br10p02 cpu]$ cat online
> > > > 0-39
> > > > [root@br10p02 cpu]$ for n in {0..47} ; do test $( cat cpu$n/online )
> > > > -eq 1 && echo -n "$n " ; done ; echo ""
> > > > 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
> > > > 26
> > > > 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
> > > >
> > > >
> > > > While with the patch, the cpu online nodes are kept up to date as
> > > > the cpus are brought up/down:
> > > >
> > > > [root@br10p02 cpu]$ pwd
> > > > /sys/devices/system/cpu
> > > > [root@br10p02 cpu]$ cat online
> > > > 0-39
> > > > [root@br10p02 cpu]$ for n in {0..47} ; do test $( cat cpu$n/online )
> > > > -eq 1 && echo -n "$n " ; done ; echo ""
> > > > 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
> > > > 26
> > > > 27 28 29 30 31 32 33 34 35 36 37 38 39
> > > >
> > > >
> > > > Feel free to add
> > > >
> > > > Tested-by: Dan Streetman <ddstreet@ieee.org>
> > > >
> > >
> > > It's a real bug in the kernel.
> > 
> > As this has been this way for many years, I tend to think it's not all that
> > important...
> 
> Actually this bug was introduced by the following patch.
> 
> commit 0902a9044fa5b7a0456ea4daacec2c2b3189ba8c
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Fri May 3 00:25:49 2013 +0200
> 
>     Driver core: Use generic offline/online for CPU offline/online
> 
> So seems not that long :)

Ok, over a year.

Any reason why this information wasn't in this patch?  Also, why not cc:
the authors of that patch as well?  Surely they would want to know about
this, right?

greg k-h
