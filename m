Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283Ab3EBSIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:08:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761264Ab3EBSI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:08:27 -0400
Date: Thu, 2 May 2013 14:08:15 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCHSET] blk-throttle: implement proper hierarchy support
Message-ID: <20130502180815.GG30020@redhat.com>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
 <20130502173428.GA4771@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130502173428.GA4771@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 01:34:28PM -0400, Vivek Goyal wrote:
> On Wed, May 01, 2013 at 05:39:18PM -0700, Tejun Heo wrote:
> 
> [..]
> > While this patchset contains many patches, the implementation is
> > pretty straight-forward.  throtl_grp's form a tree anchored at
> > throtl_data and bios climb the tree as they get dispatched at each
> > level.  The bios which reach the top of the tree - throl_data - are
> > issued. 
> 
> Have a question here. Looks like when bio climbs from child group
> to parent group, then parent group slice starts fresh if parent
> was empty. So if we have a parent with 1MB/s limit and a child with
> 1MB/s limit and a bio gets queued in child, then looks like effective
> IO rate would be .5MB/s and not 1MB/s?
> 
> IOW, when child gets queued, we should start time accounting for
> all parents in the hiearchy too.

Hi Tejun,

Also, IIUC, there might be bandwidth sharing problems. Once a bio
climbs up the ladder, it gets queued at the end of the parent queue. And
that can lead to unfair distribution of available bandwidth. For
example,

			G1
		       /  \
	              T1  G2
			  |
			  T2

G1 and G2 are 2 groups and T1 and T2 are tasks in groups respectively.
Assume both G1 and G2 are having 1MB/s IO rate limit. Assume T1 and
T2 are doing enough IO to keep respective queues backlogged.

Now While T2 is backlogged in in G2, T1 can queue up multiple 1MB
size bio and all these bio's will be served first and then one bio
from T2. And this can repeat for long time and problem only worsens
with hierarchy depth.

Ideally both T1 and G2 should share 1MB/s link equally (That is .5MB/sec)
each but in this case, T1 can run away with lot more than fair share.

Can't think how to get fair distribution of available bandwidth with
bio climbing the tree model.

I was thinking that we should implement it something along the lines
of what cpu scheduler has done. All parent groups get enqueued on 
service tree when IO gets queued in any of child groups. Time slice
accounting starts at each level. And at each level we do round robin
for dispatch of bio from each eligible child group/queue.

Thanks
Vivek
