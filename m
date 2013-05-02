Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761475Ab3EBSof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:44:35 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:57483 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653Ab3EBSod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:44:33 -0400
Date: Thu, 2 May 2013 11:44:26 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCHSET] blk-throttle: implement proper hierarchy support
Message-ID: <20130502184426.GO19814@mtj.dyndns.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
 <20130502173428.GA4771@redhat.com>
 <20130502180815.GG30020@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130502180815.GG30020@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Thu, May 02, 2013 at 02:08:15PM -0400, Vivek Goyal wrote:
> 			G1
> 		       /  \
> 	              T1  G2
> 			  |
> 			  T2
> 
> G1 and G2 are 2 groups and T1 and T2 are tasks in groups respectively.
> Assume both G1 and G2 are having 1MB/s IO rate limit. Assume T1 and
> T2 are doing enough IO to keep respective queues backlogged.

For the most part, I don't really care as long as the limits are
followed.  We can implement something better when dispatching from
child group into ->bio_lists[].  ->bio_lists[] could be organized in a
way that it round robins certain number of bios from different sources
- ie. it becomes FIFO lists of different sources of bios which is
fetched in round-robin.  We already have a similar logic in
select_dispatch() BTW.

> I was thinking that we should implement it something along the lines
> of what cpu scheduler has done. All parent groups get enqueued on 
> service tree when IO gets queued in any of child groups. Time slice
> accounting starts at each level. And at each level we do round robin
> for dispatch of bio from each eligible child group/queue.

Let's please not do something which is gonna take a lot of time and
effort.  If the fairness bothers you, please implement something
simple on top.  It really just comes down to doing RR when taking bios
from ->bio_lists[].  If you wanna reimplement the whole thing, that's
fine too but let's please do that after getting the basic hierarchy
support working because blkcg literally is the last subsystem with
.broken_hierarchy at this point.

Also, if you're actually thinking about reimplementing blk-throttle,
please do consider the followings.

* Currently, blk-throttle doesn't throttle the number of bios being
  queued.  Note that this breaks the basic back-pressure mechanism
  where IO pressure is propagated back to the issuer by throttling the
  issuing task.  blk-throttle breaks that link and converts it to a
  memory pressure.

* It's almost inherently unscalable with highops devices.  Given that
  IO limiting doesn't require very fine granularity, I think doing
  this per-cpu shouldn't be too hard.  e.g. build a per-cpu token
  distributing hierarchy with rebalancing across CPUs happening
  periodically.

In short, right now, the goal is getting the hierarchy support
acceptably working ASAP and yeap we wanna get the nested limits and at
least certain level of fairness, but let's please implement something
simple for now and strive for sophistification later because it's
holding back everyone else.

Thanks.

-- 
tejun
