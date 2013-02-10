Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab3BJOPq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 09:15:46 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36790 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090Ab3BJOPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 09:15:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Li Fei <fei.li@intel.com>,
        len.brown@intel.com, mingo@redhat.com, peterz@infradead.org,
        biao.wang@intel.com, linux-pm@vger.kernel.org,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Subject: Re: Getting rid of freezer for suspend [was Re: [fuse-devel] [PATCH] fuse: make fuse daemon frozen along with kernel threads]
Date: Sun, 10 Feb 2013 15:22:07 +0100
Message-ID: <3938124.8eafYb16IB@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3538583.NDAkGLdQOZ@vostro.rjw.lan>
References: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC> <20130210103344.GA8888@amd.pavel.ucw.cz> <3538583.NDAkGLdQOZ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 10, 2013 02:51:22 PM Rafael J. Wysocki wrote:
> On Sunday, February 10, 2013 11:33:45 AM Pavel Machek wrote:
> > Hi!
> > 
> > > > > For shutdown in userspace there is the sendsigs.omit.d/ to avoid the
> > > > > problem of halting/killing processes of the fuse filesystems (or other
> > > > > services) prematurely. I guess something similar needs to be done for
> > > > > freeze. The fuse filesystem has to tell the kernel what is up.
> > > > 
> > > > Would it be feasible to create some kind of fuse-stop-script.sh, and
> > > > run it before suspend (from userspace)? It should be pretty similar to
> > > > sendsigs.omit.d/ mechanism AFAICT.
> > > > 
> > > > I'm sorry, freezer is not too suitable for fuse.
> > > > 
> > > > (BTW: for suspend, we may be able to improve it so that it is possible
> > > > to remove freezer from it. For hibernation, it would be very hard.)
> > > 
> > > Well, this is so incorrect that it's not even funny. :-(
> > > 
> > > The whole memory shrinking we do for hibernation is now done by allocating
> > > memory, so the freezer is not necessary for *that* and there's *zero*
> > > difference between suspend and hibernation with respect to why the freezer is
> > > used.
> > 
> > Funny. Freezer was put there so that hibernation image was safe to
> > write out. You need disk subsystems in workable state for hibernation.
> 
> I'm not really sure what you're talking about.  Why do you think the freezer is
> necessary for that?
> 
> > > And *the* reason why it's used is that intercepting all of the possible ways
> > > user space could interfere with the suspend process without the freezer is
> > > simply totally impractical.  System calls (including ioctls and
> > > fctls),
> > 
> > It is a lot of work, agreed. But runtime power management is already
> > moving in that direction.
> 
> Runtime PM is a different thing.  It works on the "this device is not in use
> right now, so it can be suspended" basis, while the system suspend's principle
> is "I want everything to quiesce now and go low-power".  So system suspend can
> trigger while devices are still in use and there are good reasons for that to
> happen sometimes.
> 
> > And I could imagine introducing "big suspend lock" to be grabbed pretty much
> > everywhere.
> 
> Sorry, I can't imagine *that*.
> 
> > (And IIRC n900 pretty much suspends when idle.)
> >
> > > sysfs accesses, /proc accesses, debugfs, to name a few, and mmap (I wonder how
> > > you would handle *that* alone).  And I'm sure there's more I didn't
> > > even
> > 
> > mmap... what is problem with mmap? For suspend, memory is powered, so
> > you can permit people changing it.
> 
> Suppose mmap is used to make the registers of some device available to user
> space.  Yes, that can happen.
> 
> > > So please don't tell people that something is doable while it practically
> > > realisticly isn't.
> > 
> > I can imagine doing that for suspend, and believe we are moving in
> > that direction with runtime suspend. For hibernation, we need to write
> > image the image to the disk (which is the important difference, not
> > memory shrinking), and "big suspend lock" would interfere with
> > that. I can not imagine reasonable solution for that.
> 
> Again, I'm not sure what you're talking about.  Once the image has been
> created, it can be saved while user space is running just fine.

Of course, we don't want random changes to be made to persistent storage after
the image has been created, because those changes might not be consistent with
the memory contents stored in the image, and that's why user space is still
frozen when we're saving the image.

> And that "big suspend lock" would be pretty much the same as the BKL that
> people spent quite some time an effort to remove, so I don't think your idea
> to reintroduce something similar just for suspend purposes would be popular.
> 
> And since the freezer is now used for other things beyond suspend and
> hibernation, introducing such a lock wouldn't even address the Fuse problem.

BTW, Miklos, wouldn't that help if the kernel notified user space somehow
before starting to freeze processes?  Perhaps the Fuse's user space part could
subscribe to such notifications and do something before the freezing kicks in?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
