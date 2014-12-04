Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaLDUmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 15:42:38 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:32861 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbaLDUmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 15:42:37 -0500
Date: Thu, 4 Dec 2014 15:42:33 -0500
From: Tejun Heo <tj@kernel.org>
To: Leonard Crestez <lcrestez@ixiacom.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Sorin Dumitru <sdumitru@ixiacom.com>
Subject: Re: [RFC v2] percpu: Add a separate function to merge free areas
Message-ID: <20141204204233.GD4080@htj.dyndns.org>
References: <547E3E57.3040908@ixiacom.com>
 <20141204175713.GE2995@htj.dyndns.org>
 <5480BFAA.2020106@ixiacom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5480BFAA.2020106@ixiacom.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 10:10:18PM +0200, Leonard Crestez wrote:
> Yes, we are actually experiencing issues with this. We create lots of virtual
> net_devices and routes, which means lots of percpu counters/pointers. In particular
> we are getting worse performance than in older kernels because the net_device refcnt
> is now a percpu counter. We could turn that back into a single integer but this
> would negate an upstream optimization.
> 
> We are working on top of linux_3.10. We already pulled some allocation optimizations.
> At least for simple allocation patterns pcpu_alloc does not appear to be unreasonably
> slow.

Yeah, it got better for simpler patterns with Al's recent
optimizations.  Is your use case suffering heavily from percpu
allocator overhead even with the recent optimizations?

> Having a "properly scalable" percpu allocator would be quite nice indeed.

Yeah, at the beginning, the expected (and existing at the time) use
cases were fairly static and limited and the dumb scanning allocator
worked fine.  The usages grew a lot over the years, so, yeah, we
prolly want something more scalable.  I haven't seriously thought
about the details yet tho.  The space overhead is a lot higher than
usual memory allocators, so we do want something which can pack things
tighter.  Given that there are a lot of smaller allocations anyway,
maybe just converting the current implementation to bitmap based one
is enough.  If we set the min alignment at 4 bytes which should be
fine, the bitmap overhead is slightly over 3% of the chunk size which
should be fine.  My hunch is that the current allocator is already
using more than that on average.  Are you interested in pursuing it?

Thanks.

-- 
tejun
