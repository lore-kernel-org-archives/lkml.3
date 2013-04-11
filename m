Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab3DKTg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 15:36:56 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58716 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab3DKTgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 15:36:54 -0400
Date: Thu, 11 Apr 2013 14:35:34 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Konrad Wilk <konrad.wilk@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Bob Liu <bob.liu@oracle.com>, Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: zsmalloc zbud hybrid design discussion?
Message-ID: <20130411193534.GB28296@cerebellum>
References: <ef105888-1996-4c78-829a-36b84973ce65@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef105888-1996-4c78-829a-36b84973ce65@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041119-7182-0000-0000-000006326ECD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 01:04:25PM -0700, Dan Magenheimer wrote:
> Seth and all zproject folks --
> 
> I've been giving some deep thought as to how a zpage
> allocator might be designed that would incorporate the
> best of both zsmalloc and zbud.
> 
> Rather than dive into coding, it occurs to me that the
> best chance of success would be if all interested parties
> could first discuss (on-list) and converge on a design
> that we can all agree on.  If we achieve that, I don't
> care who writes the code and/or gets the credit or
> chooses the name.  If we can't achieve consensus, at
> least it will be much clearer where our differences lie.
> 
> Any thoughts?

I'll put some thoughts, keeping in mind that I'm not throwing zsmalloc under
the bus here.  Just what I would do starting from scratch given all that has
happened.

Simplicity - the simpler the better

High density - LZO best case is ~40 bytes. That's around 1/100th of a page.
I'd say it should support up to at least 64 object per page in the best case.
(see Reclaim effectiveness before responding here)

No slab - the slab approach limits LRU and swap slot locality within the pool
pages.  Also swap slots have a tendency to be freed in clusters.  If we improve
locality within each pool page, it is more likely that page will be freed
sooner as the zpages it contains will likely be invalidated all together.
Also, take a note out of the zbud playbook at track LRU based on pool pages,
not zpages.  One would fill allocation requests from the most recently used
pool page.

Reclaim effectiveness - conflicts with density. As the number of zpages per
page increases, the odds decrease that all of those objects will be
invalidated, which is necessary to free up the underlying page, since moving
objects out of sparely used pages would involve compaction (see next).  One
solution is to lower the density, but I think that is self-defeating as we lose
much the compression benefit though fragmentation. I think the better solution
is to improve the likelihood that the zpages in the page are likely to be freed
together through increased locality.

Not a requirement:

Compaction - compaction would basically involve creating a virtual address
space of sorts, which zsmalloc is capable of through its API with handles,
not pointer.  However, as Dan points out this requires a structure the maintain
the mappings and adds to complexity.  Additionally, the need for compaction
diminishes as the allocations are short-lived with frontswap backends doing
writeback and cleancache backends shrinking.

So just some thoughts to start some specific discussion.  Any thoughts?

Thanks,
Seth

> 
> Thanks,
> Dan
> 

