Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038Ab3BLKqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:46:13 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49294 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291Ab3BLKqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:46:11 -0500
Date: Tue, 12 Feb 2013 11:46:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Goswin von Brederlow <goswin-v-b@web.de>, Li Fei <fei.li@intel.com>,
        len.brown@intel.com, mingo@redhat.com, peterz@infradead.org,
        biao.wang@intel.com, linux-pm@vger.kernel.org,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Subject: Re: Getting rid of freezer for suspend [was Re: [fuse-devel]
 [PATCH] fuse: make fuse daemon frozen along with kernel threads]
Message-ID: <20130212104608.GA24042@amd.pavel.ucw.cz>
References: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <2964781.rPUOipNRNb@vostro.rjw.lan>
 <CAJfpegtNUr+AJXZcKmLEGBYqu20DVFwzg-OvOk_nS3fBS3wd=Q@mail.gmail.com>
 <1660768.prnx6s70rD@vostro.rjw.lan>
 <CAJfpegt2B3n-QNK_W7O2H0JVfS=4jcUOzV_+w8ELPq19RJPewQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegt2B3n-QNK_W7O2H0JVfS=4jcUOzV_+w8ELPq19RJPewQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

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

Yes please. If that is doable, that's the right solution.

(After all, with FUSE, filesystem clients are just doing IPC. In ideal
world, that would be freezeable and killable with -9).
 
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
