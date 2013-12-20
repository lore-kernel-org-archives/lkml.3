Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3LTOv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:51:57 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:49310 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab3LTOvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:51:55 -0500
Date: Fri, 20 Dec 2013 09:51:51 -0500
From: Tejun Heo <tj@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        tomaz.solc@tablix.org, aaron.lu@intel.com,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: Writeback threads and freezable
Message-ID: <20131220145151.GD4298@htj.dyndns.org>
References: <20131214015343.GP31386@dastard>
 <20131214202324.GA4020@htj.dyndns.org>
 <20131216035652.GY31386@dastard>
 <20131216125124.GC32509@htj.dyndns.org>
 <20131216125604.GD32509@htj.dyndns.org>
 <20131218003510.GD20579@dastard>
 <20131218114343.GA4324@htj.dyndns.org>
 <20131219040821.GW31386@dastard>
 <20131219162411.GD16994@htj.dyndns.org>
 <20131220005114.GE31386@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131220005114.GE31386@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dave.

On Fri, Dec 20, 2013 at 11:51:14AM +1100, Dave Chinner wrote:
> > Please note that there's no real "immediacy" in that it's inherently
> > racy and that the extent of the usefulness of such notification can't
> > reach much further than suppressing error messages.
> 
> So says you. What about btrfs, which might use such a notification
> to start replicating metadata and data to other devices to maintain
> redundancy levels? Or even XFS, which might have a real-time device
> go away - that's not a fatal error for the filesystem, but we sure
> as hell want the user to know about it and be able to set a flag
> indicating access to data in real-time files need to be errored out
> at the .aio_write level rather than some time later when writeback
> fails with EIO and the application cannot capture the IO error.

Hmmm... but shouldn't such facilities also kick in on other fatal
failure conditions?  I have no fundamental objection against adding
someway to distinguish / notify hotunplug events but am a bit worried
that it has the potential to branch out the hotunplug path
unnecessarily and it seems that such tendency has been shown amply in
this thread too.

As I've pointed out multiple times in the thread, hotunplug path
serves very well as the continual testbed for catastrphic failure
cases for the whole stack from filesystems all the way down to
low-level drivers and can be attributed for high ratio of error
handling improvements / bugfixes we made over the years, so even if we
add something to distinguish hotunplug for upper layers, I think it
should be something which at least doesn't encourage implementing a
completely separate path and preferably something more generic.

> Seriously, Tejun, you need to stop focussing on tearing apart
> micro-examples and consider the wider context of the issue that the
> examples are being used to demonstrate.  The notifications being

Dear Dave, would you please drop the attitude?  You've been
consistently wrong in this thread.  Being aggressively assertive is
okay.  Being wrong is okay too.  Continuing the combination of the two
is not.  That's actively harmful, especially when the one doing so
commands respect in the community - it has high chance of derailing
the discussion and/or leading to the wrong conclusions.  Should I
reiterate the messed up confusions you showed at each turn of this
very thread?

Let's please stay technical.  You apparently didn't have much idea how
things work in the lower layers, which is completely fine.  Just don't
over-extend your asssertiveness without substance.  If you just made
your technical input from the get-go when viewed from your side of the
stack, we could have been a lot more productive.

I still think there's something to be extracted from this thread - how
we should handle catastrophic failure scenarios and the shortcomings
of the current shutdown procedure, both of which are far from perfect.
I'm not yet convinced with the idea of handling hot-unplug as
something completely special for the reasons I've stated multiple
times now and curious about the specifics of what you have on mind
because I don't really know what would be convenient from the
filesystem side.

> talked about here are already being delivered to userspace because
> there are OS management applications that need to know about devices
> going away. Filesystems are no different - there's all sorts of
> optimisations we can make if we get such a notification.

I'm not sure that analogy is too relevant.  The notifications
delivered to userland aren't different for hot or warm unplugs and
they don't participate in any of the exception handling details, which
is what I'm really worried about.  Again, I'm not necessarily against
the idea of flagging / notifying upper layers but please do keep in
mind that hotunplug handling shouldn't deviate much from other parts
of exception handling, which at least from the discussions we had in
this thread doesn't seem to be what you had on mind.  There are other
exception cases which share many, if not most, characteristics making
such approach a natural fit and hotunplug is one of the best tools we
have in ensuring those paths are in a healthy shape.

Thanks.

-- 
tejun
