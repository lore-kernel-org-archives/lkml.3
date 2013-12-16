Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab3LPM4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:56:19 -0500
Received: from mail-qe0-f41.google.com ([209.85.128.41]:43446 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab3LPM4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:56:16 -0500
Date: Mon, 16 Dec 2013 07:56:04 -0500
From: Tejun Heo <tj@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        tomaz.solc@tablix.org, aaron.lu@intel.com,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: Writeback threads and freezable
Message-ID: <20131216125604.GD32509@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org>
 <20131214015343.GP31386@dastard>
 <20131214202324.GA4020@htj.dyndns.org>
 <20131216035652.GY31386@dastard>
 <20131216125124.GC32509@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216125124.GC32509@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 07:51:24AM -0500, Tejun Heo wrote:
> On Mon, Dec 16, 2013 at 02:56:52PM +1100, Dave Chinner wrote:
> > > What are you suggesting?  Implementing separate warm and hot unplug
> > > paths?  That makes no sense whatsoever.  Device hot unplug is just a
> > > sub operation of general device unplug which should be able to succeed
> > > whether the underlying device is failing IOs or not.
> > 
> > I don't care. Trying to issue IO from an an IO error handling path
> > where the device has just been removed is fundamentally broken.
> 
> What?  Have you even read the original message?  IO error handling
> path isn't issuing the IO here.  The hot unplug operation is
> completely asynchronous to the IO path.  What's dead locking is not
> the filesystem and IO path but device driver layer and hot unplug
> path.  IOs are not stalled.

In fact, this deadlock can be reproduced without hotunplug at all.  If
you initiate warm unplug and warm unplugging races with suspend/resume
cycle, it'll behave exactly the same - the IOs from flushing in that
scenario would succeed but IOs failing or not has *NOTHING* to do with
this deadlock.  It'd still happen.  It's freezer behaving as a giant
lock and other locks of course getting dragged into giant dependency
loop.  Can you please at least *try* to understand what's going on
before throwing strong assertions?

-- 
tejun
