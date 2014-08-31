Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaHaUON (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 16:14:13 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:37320 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaHaUOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 16:14:11 -0400
Date: Sun, 31 Aug 2014 13:14:07 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, falcon@meizu.com,
        tiwai@suse.de, tj@kernel.org, linux-kernel@vger.kernel.org,
        oleg@redhat.com, akpm@linux-foundation.org,
        penguin-kernel@i-love.sakura.ne.jp, joseph.salisbury@canonical.com,
        bpoirier@suse.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC v1 0/3] driver-core: add asynch module loading support
Message-ID: <20140831201407.GB19881@core.coreip.homeip.net>
References: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com>
 <540334B2.7000009@linux.intel.com>
 <20140831175040.GA17827@core.coreip.homeip.net>
 <5403767E.1020107@linux.intel.com>
 <20140831193140.GA12678@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140831193140.GA12678@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2014 at 12:31:40PM -0700, Greg KH wrote:
> On Sun, Aug 31, 2014 at 12:24:46PM -0700, Arjan van de Ven wrote:
> > >>before we added the current async approach the approach of async init calls was tried
> > >>At the time, Linus hated it and he was right, it was not the right thing.
> > >>
> > >>What is different this time to make this the right thing to do ?
> > >
> > >Because otherwise drivers still have to do this, but open code it. Let's say I
> > >have a long operations (i.e. for some touchpads it takes about 2 secs to reset
> > >and configure it). I can offload that part into async_schedule() so it does not
> > >stop initialization of the rest of the system (why would I want to delay
> > >initializing of USB or storage system until touchpad is ready?) but if that
> > >initialization fails we end up with partially bound driver and device that is
> > >not really operable. I would very much prefer async and sync cases be the same
> > >- if probe() fails the driver is not bound to the device.
> > >
> > >I think it is wrong to make async probing system-wide, but driver opt-in shoudl
> > >be fine and right thing to do.
> > >
> > 
> > I am completely fine if we make basically an async wrapper for
> > pci_register_driver() and friends.. that would be convenient I suppose.
> > 
> > (but then again, in reality very few drivers take real time to init... most already
> > do the heavy work in open(). Not all can, sure, but if you look at a bootgraph.pl
> > graph of a typical boot it's only a few that matter).

Input devices normally can't as we need to publish their capabilities before
users start opening them.

> > And many drivers need to register with a subsystem, and there's some ordering around that,
> > and that's why we ended up with the async cookie stuff, so that you can do the
> > heavy work in parallel, but order near the end at registeration-with-the-subsystem time.
> > 
> > But doing this on an initcall level was wrong back then, and I have yet to hear
> > a reason why it would be right this time.
> 
> It's still wrong, it's not what I was thinking about when talking this
> over with Luis and Dmitry, I think something got lost in the
> translation...

Right, all (well almost all) I wanted is for individual drivers to declare
their probe() functions asynchronous and driver core scheduling async attach
and properly handle failures from it.

As I mentioned, resume has similar issues...

Thanks.

-- 
Dmitry
