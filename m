Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964830Ab3DJNku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:40:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab3DJNkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:40:49 -0400
Date: Wed, 10 Apr 2013 09:40:39 -0400
From: Don Zickus <dzickus@redhat.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Dave Young <dyoung@redhat.com>, linux-watchdog@vger.kernel.org,
        kexec@lists.infradead.org, wim@iguana.be,
        LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com
Subject: Re: [RFC PATCH] watchdog: Add hook for kicking in kdump path
Message-ID: <20130410134039.GV79013@redhat.com>
References: <1365192994-94850-1-git-send-email-dzickus@redhat.com>
 <516259D2.7000805@redhat.com>
 <20130408124858.GC79013@redhat.com>
 <20130408151509.GA20919@roeck-us.net>
 <20130409144431.GL79013@redhat.com>
 <20130409145228.GA1111@roeck-us.net>
 <20130409151423.GM79013@redhat.com>
 <20130409160757.GA27050@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409160757.GA27050@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 09:07:58AM -0700, Guenter Roeck wrote:
> > > Just look for the use of mod_timer in the watchdog directory.
> > 
> > So looking at the mod_timer logic in various drivers, it seems regardless
> > if the /dev/watchdog device is opened or not, if it is running, it will
> > automagically kick the watchdog.
> > 
> yes
> 
> > This seems that we can avoid pulling in userspace pieces for this.  Just
> > load the driver and the hardware starts getting kicked.
> > 
> Only if it is already running. Also, you don't want to rely on it, because you
> lose protection against user space issues.

IOW if something goes wrong with a runaway userspace app, the kernel
blindly continues to kick the watchdog, which masks the problem, right?

> 
> A second use is if the hw watchdog needs to be pinged more often than user
> space can provide. Some of the HW watchdogs need a ping in one-second intervals
> or even faster.
> 
> > Is that true?  And if so, do all drivers detect if the hardware is already
> > running during their init?  Or is it based on the first device open?
> > 
> It is usually done in the probe function.

Ok.  Thanks for the understanding of how the softdog stuff works.

However, we still have the problem that if the machine panics and we want
to jump into the kdump kernel, we need to 'kick' the watchdog one more
time.  This provides us a sane sync point for determining how long we have
to load the watchdog driver in the second kernel before the hardware
reboots us.  Otherwise the reboots are pretty random and nothing is
guaranteed.

Hence the need for some sort of patch resembling the one I posted.

Soooooooo, any thoughts about that patch and what changes I should make?
:-)

Cheers,
Don
