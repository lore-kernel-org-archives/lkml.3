Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbaIDVV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:21:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38092 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755594AbaIDVVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:21:23 -0400
Date: Thu, 4 Sep 2014 23:21:18 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, falcon@meizu.com,
        tiwai@suse.de, tj@kernel.org, linux-kernel@vger.kernel.org,
        oleg@redhat.com, akpm@linux-foundation.org,
        penguin-kernel@i-love.sakura.ne.jp, joseph.salisbury@canonical.com,
        bpoirier@suse.de, Mel Gorman <mgorman@suse.de>
Subject: Re: [RFC v1 0/3] driver-core: add asynch module loading support
Message-ID: <20140904212118.GB3347@wotan.suse.de>
References: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com> <540334B2.7000009@linux.intel.com> <20140831175040.GA17827@core.coreip.homeip.net> <5403767E.1020107@linux.intel.com> <20140831193140.GA12678@kroah.com> <20140831201407.GB19881@core.coreip.homeip.net> <20140831204035.GA4793@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140831204035.GA4793@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2014 at 01:40:35PM -0700, Greg KH wrote:
> On Sun, Aug 31, 2014 at 01:14:07PM -0700, Dmitry Torokhov wrote:
> > On Sun, Aug 31, 2014 at 12:31:40PM -0700, Greg KH wrote:
> > > On Sun, Aug 31, 2014 at 12:24:46PM -0700, Arjan van de Ven wrote:
> > > > >>before we added the current async approach the approach of async init calls was tried
> > > > >>At the time, Linus hated it and he was right, it was not the right thing.
> > > > >>
> > > > >>What is different this time to make this the right thing to do ?
> > > > >
> > > > >Because otherwise drivers still have to do this, but open code it. Let's say I
> > > > >have a long operations (i.e. for some touchpads it takes about 2 secs to reset
> > > > >and configure it). I can offload that part into async_schedule() so it does not
> > > > >stop initialization of the rest of the system (why would I want to delay
> > > > >initializing of USB or storage system until touchpad is ready?) but if that
> > > > >initialization fails we end up with partially bound driver and device that is
> > > > >not really operable. I would very much prefer async and sync cases be the same
> > > > >- if probe() fails the driver is not bound to the device.
> > > > >
> > > > >I think it is wrong to make async probing system-wide, but driver opt-in shoudl
> > > > >be fine and right thing to do.
> > > > >
> > > > 
> > > > I am completely fine if we make basically an async wrapper for
> > > > pci_register_driver() and friends.. that would be convenient I suppose.
> > > > 
> > > > (but then again, in reality very few drivers take real time to init... most already
> > > > do the heavy work in open(). Not all can, sure, but if you look at a bootgraph.pl
> > > > graph of a typical boot it's only a few that matter).
> > 
> > Input devices normally can't as we need to publish their capabilities before
> > users start opening them.
> > 
> > > > And many drivers need to register with a subsystem, and there's some ordering around that,
> > > > and that's why we ended up with the async cookie stuff, so that you can do the
> > > > heavy work in parallel, but order near the end at registeration-with-the-subsystem time.
> > > > 
> > > > But doing this on an initcall level was wrong back then, and I have yet to hear
> > > > a reason why it would be right this time.
> > > 
> > > It's still wrong, it's not what I was thinking about when talking this
> > > over with Luis and Dmitry, I think something got lost in the
> > > translation...
> > 
> > Right, all (well almost all) I wanted is for individual drivers to declare
> > their probe() functions asynchronous and driver core scheduling async attach
> > and properly handle failures from it.
> 
> Yes, that's what I want as well.
> 
> Luis, care to redo the patches in this way?  It should be a lot simpler
> (no messing around with init levels and linker fun...)

Sure, when we spoke the requirement was indeed clear but as I noted on
the description on this cover letter as I reviewed Wu Zhangjin's RFC
which used async_schedule() he ran into the issue of eventually grouping
things. I went with this approach as a first shot given that we have a long
tested set of groupings already done by the kernel so this tried to take
advantage of that should we try to scale on asynchronous probing.

I still believe its a good approach if we wanted to scale it but that
would require the desire to do so, I obviously considered it worthwhile
as I shaved off at least ~1 second off kernel boot time when doing an
original proof of concept and only doing drivers, and taking into
consideration my kenrel takes ~5 seconds before userspace is reached.
I'll toss this in the bin for now though and send something based on
Tejun's approach shortly!

  Luis
