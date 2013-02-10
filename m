Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab3BJKdt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 05:33:49 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40376 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab3BJKdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 05:33:47 -0500
Date: Sun, 10 Feb 2013 11:33:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
        Miklos Szeredi <miklos@szeredi.hu>, Li Fei <fei.li@intel.com>,
        len.brown@intel.com, mingo@redhat.com, peterz@infradead.org,
        biao.wang@intel.com, linux-pm@vger.kernel.org,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Subject: Getting rid of freezer for suspend [was Re: [fuse-devel] [PATCH]
 fuse: make fuse daemon frozen along with kernel threads]
Message-ID: <20130210103344.GA8888@amd.pavel.ucw.cz>
References: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <20130208141123.GA29460@frosties>
 <20130209174910.GA28370@amd.pavel.ucw.cz>
 <1595169.zvx3Wi6SMv@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595169.zvx3Wi6SMv@vostro.rjw.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > For shutdown in userspace there is the sendsigs.omit.d/ to avoid the
> > > problem of halting/killing processes of the fuse filesystems (or other
> > > services) prematurely. I guess something similar needs to be done for
> > > freeze. The fuse filesystem has to tell the kernel what is up.
> > 
> > Would it be feasible to create some kind of fuse-stop-script.sh, and
> > run it before suspend (from userspace)? It should be pretty similar to
> > sendsigs.omit.d/ mechanism AFAICT.
> > 
> > I'm sorry, freezer is not too suitable for fuse.
> > 
> > (BTW: for suspend, we may be able to improve it so that it is possible
> > to remove freezer from it. For hibernation, it would be very hard.)
> 
> Well, this is so incorrect that it's not even funny. :-(
> 
> The whole memory shrinking we do for hibernation is now done by allocating
> memory, so the freezer is not necessary for *that* and there's *zero*
> difference between suspend and hibernation with respect to why the freezer is
> used.

Funny. Freezer was put there so that hibernation image was safe to
write out. You need disk subsystems in workable state for hibernation.

> And *the* reason why it's used is that intercepting all of the possible ways
> user space could interfere with the suspend process without the freezer is
> simply totally impractical.  System calls (including ioctls and
> fctls),

It is a lot of work, agreed. But runtime power management is already
moving in that direction. And I could imagine introducing "big suspend
lock" to be grabbed pretty much everywhere.

(And IIRC n900 pretty much suspends when idle.)

> sysfs accesses, /proc accesses, debugfs, to name a few, and mmap (I wonder how
> you would handle *that* alone).  And I'm sure there's more I didn't
> even

mmap... what is problem with mmap? For suspend, memory is powered, so
you can permit people changing it.

> So please don't tell people that something is doable while it practically
> realisticly isn't.

I can imagine doing that for suspend, and believe we are moving in
that direction with runtime suspend. For hibernation, we need to write
image the image to the disk (which is the important difference, not
memory shrinking), and "big suspend lock" would interfere with
that. I can not imagine reasonable solution for that.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
