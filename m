Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab3LRAV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 19:21:56 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58126 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751553Ab3LRAVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 19:21:55 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tejun Heo <tj@kernel.org>
Cc: Nigel Cunningham <nigel@nigelcunningham.com.au>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>, tomaz.solc@tablix.org,
        aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] libata, freezer: avoid block device removal while system is frozen
Date: Wed, 18 Dec 2013 01:35:13 +0100
Message-ID: <4108657.rimrPRbHDY@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131217123457.GD29989@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org> <8951916.gd5Uu6GpK1@vostro.rjw.lan> <20131217123457.GD29989@htj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 17, 2013 07:34:57 AM Tejun Heo wrote:
> Hello, Rafael.
> 
> On Tue, Dec 17, 2013 at 03:34:00AM +0100, Rafael J. Wysocki wrote:
> > No, it isn't.  [I guess it was originally, but it has not been the case
> > for a very long time.]  It is about getting user space interactions (all of
> 
> Heh... no wonder people are all so confused about this thing.
> 
> > the sysfs/ioctl/mmap/read/write/you-name-it thingies user space can do to
> > devices) when we're calling device suspend/resume routines.  The reason is
> > that otherwise all of them would have had to do a "oh, are we suspending by
> > the way?" check pretty much on every code path that can be triggered by
> > user space.
> 
> Freezing userland is fine.

OK

So do I understand correctly that you're talking about kernel threads/worqueues
freezing below?

> I have no problem with that but up until
> now the only use case that seems fundamentally valid to me is freezing
> IO processing kthread in a driver as a cheap way to implement
> suspend/resume.  At this point, given the general level of confusion,
> it seems to be costing more than benefiting.

There are corner cases like the runtime PM workqueue that's freezable by
design.

> > > Does that mean that it's safe to unfreeze before invoking resume?
> > 
> > No, it isn't.
> 
> So, are you saying it's really about giving device drivers easy way to
> implement suspend/resume?

Well, that's a side effect rather than a recommeded interface.  A *few* pieces
of code need to freeze kernel threads/workqueues, but they should know who they
are and they really really should know *why* they need that (the above-mentioned
runtime PM workqueue is one example).  The rest is just doing that because they
can, which may not be entirely reasonable (or because they did that in the past
and the original author is not responsive and everyone else does not dare to try
removing that).

> If that's the case, let's please make it
> *way* more specific and clear - ie. things like helpers to implement
> suspend/resume hooks trivially or whatnot.  Freezable kthreads (and
> now workqueues) have been becoming a giant mess for a while now.

They were a lot more of that to start with really.  We removed quite a number
of try_to_freeze() instances from the kernel a few years ago, but apparently
people are taking shortcuts.

The rule should be to require patch submitters to put in comments explaining
why they need their kernel threads/workqueues to be freezable and generally
there should be no such things in drivers.

Thanks,
Rafael

