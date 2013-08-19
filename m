Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750903Ab3HSOKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 10:10:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab3HSOKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 10:10:44 -0400
Date: Mon, 19 Aug 2013 10:00:16 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Frank Mayhar <fmayhar@google.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: dm: Make MIN_IOS, et al, tunable via sysctl.
Message-ID: <20130819140016.GB27167@redhat.com>
References: <1376070533.26057.244.camel@bobble.lax.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376070533.26057.244.camel@bobble.lax.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16 2013 at  6:55pm -0400,
Frank Mayhar <fmayhar@google.com> wrote:

> The device mapper and some of its modules allocate memory pools at
> various points when setting up a device.  In some cases, these pools are
> fairly large, for example the multipath module allocates a 256-entry
> pool and the dm itself allocates three of that size.  In a
> memory-constrained environment where we're creating a lot of these
> devices, the memory use can quickly become significant.  Unfortunately,
> there's currently no way to change the size of the pools other than by
> changing a constant and rebuilding the kernel.
> 
> This patch fixes that by changing the hardcoded MIN_IOS (and certain
> other) #defines in dm-crypt, dm-io, dm-mpath, dm-snap and dm itself to
> sysctl-modifiable values.  This lets us change the size of these pools
> on the fly, we can reduce the size of the pools and reduce memory
> pressure.

These memory reserves are a long-standing issue with DM (made worse when
request-based mpath was introduced).  Two years ago, I assembled a patch
series that took one approach to trying to fix it:
http://people.redhat.com/msnitzer/patches/upstream/dm-rq-based-mempool-sharing/series.html

But in the end I wasn't convinced sharing the memory reserve would allow
for 100s of mpath devices to make forward progress if memory is
depleted.

All said, I think adding the ability to control the size of the memory
reserves is reasonable.  It allows for informed admins to establish
lower reserves (based on the awareness that rq-based mpath doesn't need
to support really large IOs, etc) without compromising the ability to
make forward progress.

But, as mentioned in my porevious mail, I'd like to see this implemnted
in terms of module_param_named().

> We tested performance of dm-mpath with smaller MIN_IOS sizes for both dm
> and dm-mpath, from a value of 32 all the way down to zero.

Bio-based can safely be reduced, as this older (uncommitted) patch did:
http://people.redhat.com/msnitzer/patches/upstream/dm-rq-based-mempool-sharing/0000-dm-lower-bio-based-reservation.patch

> Bearing in mind that the underlying devices were network-based, we saw
> essentially no performance degradation; if there was any, it was down
> in the noise.  One might wonder why these sizes are the way they are;
> I investigated and they've been unchanged since at least 2006.

Performance isn't the concern.  The concern is: does DM allow for
forward progress if the system's memory is completely exhausted?

This is why request-based has such an extensive reserve, because it
needs to account for cloning the largest possible request that comes in
(with multiple bios).
