Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343Ab3BKTWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:22:22 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:37241 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757820Ab3BKTWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:22:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Pavel Machek <pavel@ucw.cz>, Goswin von Brederlow <goswin-v-b@web.de>,
        Li Fei <fei.li@intel.com>, len.brown@intel.com, mingo@redhat.com,
        peterz@infradead.org, biao.wang@intel.com, linux-pm@vger.kernel.org,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Subject: Re: Getting rid of freezer for suspend [was Re: [fuse-devel] [PATCH] fuse: make fuse daemon frozen along with kernel threads]
Date: Mon, 11 Feb 2013 20:28:46 +0100
Message-ID: <2407765.5u9DGJxmKr@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAJfpegt2B3n-QNK_W7O2H0JVfS=4jcUOzV_+w8ELPq19RJPewQ@mail.gmail.com>
References: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC> <1660768.prnx6s70rD@vostro.rjw.lan> <CAJfpegt2B3n-QNK_W7O2H0JVfS=4jcUOzV_+w8ELPq19RJPewQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 11, 2013 02:59:56 PM Miklos Szeredi wrote:
> On Mon, Feb 11, 2013 at 1:08 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday, February 11, 2013 11:11:40 AM Miklos Szeredi wrote:
> >> On Mon, Feb 11, 2013 at 12:31 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > On Sunday, February 10, 2013 07:55:05 PM Pavel Machek wrote:
> >>
> >> >> Well, from freezer you need:
> >> >>
> >> >> 1) user process frozen.
> >> >>
> >> >> 2) essential locks _not_ held so that block devices are still functional.
> >> >>
> >> >> > > > mmap... what is problem with mmap? For suspend, memory is powered, so
> >> >> > > > you can permit people changing it.
> >> >> > >
> >> >> > > Suppose mmap is used to make the registers of some device available to user
> >> >> > > space.  Yes, that can happen.
> >> >>
> >> >> "Don't do it, then". Yes, can happen, but hopefully is not too common
> >> >> these days. [And... freezer doing 1) but not 2) would be enough to
> >> >> handle that. Freezer doing 1) but not 2) would also be simpler...]
> >> >
> >> > Again, I'm not sure what you mean.
> >> >
> >> > Are you trying to say that it would be OK to freeze user space tasks in
> >> > the D state?
> >>
> >> I think that's what Pavel is saying.   Processes in D state sleeping
> >> on non-device mutexes _are_ actually OK to freeze.  And that would
> >> nicely solve the fuse freeze problem.
> >
> > That's potentially deeadlock-prone, because a task waiting for mutex X may
> > very well be holding mutex Y, so if there's another task waiting for mutex Y,
> > it needs to be frozen at the same time.
> >
> >> The only little detail is how do we implement that...
> >
> > This means the only way I can see would be to hack the mutex code so that the
> > try_to_freeze() was called for user space tasks after the
> > sched_preempt_enable_no_resched() before schedule().
> >
> > That shouldn't be a big deal performance-wise, because we are in the slow
> > path anyway then.  I'm not sure if Peter Z will like it, though.
> >
> > Moreover, a task waiting for a mutex may be holding a semaphore or be
> > participating in some other mutual-exclusion mechanism, so we'd need to
> > address them all.  Plus, as noted by Pavel, freezing those things would make
> > it difficult to save hibernation images to us.
> 
> Well, as a first step I could cook up a patch that adds a flag to the
> mutex indicating that it's freezable.  Fuse would mark its mutexes
> (and the mutexes that VFS uses on its behalf) as freezable.  That way
> we don't interfere with hibernation, except if hibernation uses fuse
> but that's a very special case.

Yes, that may be worth a shot. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
