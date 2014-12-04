Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbaLDUwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 15:52:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50392 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbaLDUwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 15:52:10 -0500
Date: Thu, 4 Dec 2014 20:52:02 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Lameter <cl@linux.com>
Cc: Leonard Crestez <lcrestez@ixiacom.com>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sorin Dumitru <sdumitru@ixiacom.com>
Subject: Re: [RFC v2] percpu: Add a separate function to merge free areas
Message-ID: <20141204205202.GP29748@ZenIV.linux.org.uk>
References: <547E3E57.3040908@ixiacom.com>
 <20141204175713.GE2995@htj.dyndns.org>
 <5480BFAA.2020106@ixiacom.com>
 <alpine.DEB.2.11.1412041426230.14577@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1412041426230.14577@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 02:28:10PM -0600, Christoph Lameter wrote:
> On Thu, 4 Dec 2014, Leonard Crestez wrote:
> 
> > Yes, we are actually experiencing issues with this. We create lots of virtual
> > net_devices and routes, which means lots of percpu counters/pointers. In particular
> > we are getting worse performance than in older kernels because the net_device refcnt
> > is now a percpu counter. We could turn that back into a single integer but this
> > would negate an upstream optimization.
> 
> Well this is not a common use case and that is not what the per cpu
> allocator was designed for. There is bound to be signifcant fragmentation
> with the current design. The design was for rare allocations when
> structures are initialized.

... except that somebody has not known that and took refcounts on e.g.
vfsmounts into percpu.  With massive amounts of hilarity once docker folks
started to test the workloads that created/destroyed those in large amounts.

> > Having a "properly scalable" percpu allocator would be quite nice indeed.
> 
> I guess we would be looking at a redesign of the allocator then.

FWIW, I think I've already dealt with most of the crap, but I've no idea
if networking-related callers end up with similar use patterns.  For vfsmounts
it seems to suffice...
