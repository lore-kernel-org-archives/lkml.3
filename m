Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361Ab3HMW15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 18:27:57 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:46608 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759191Ab3HMW14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 18:27:56 -0400
Date: Tue, 13 Aug 2013 15:27:59 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] idr: Document ida tree sections
Message-ID: <20130813222759.GA12069@kmo-pixel>
References: <1375896905-6074-1-git-send-email-kmo@daterainc.com>
 <1375896905-6074-4-git-send-email-kmo@daterainc.com>
 <20130807202201.GA28039@mtj.dyndns.org>
 <20130807205117.GC11612@kmo-pixel>
 <20130809145756.GL20515@mtj.dyndns.org>
 <20130813221308.GA11980@kmo-pixel>
 <20130813221928.GE28996@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813221928.GE28996@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 06:19:28PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Tue, Aug 13, 2013 at 03:13:08PM -0700, Kent Overstreet wrote:
> > If you're convinced this is a real issue though - how about
> 
> It is a real issue.  Large order allocation is fine for optimization
> but shouldn't be depended upon.  It does fail easily without
> compaction and compaction is heavy-ass operation which will blow up
> any minute performance advantage you might get from avoiding proper
> radix tree implementation.
> 
> > IDA_SECTION_SIZE conditional on CONFIG_COMPACTION, so we use order 2 or
> > 3 allocations if CONFIG_COMPACTION=n?
> > 
> > Then the max size toplevel array of pointers to segments would be
> > bigger, but that's only an issue when we're allocating up to near
> > INT_MAX ids, so it's difficult to see how _that_ would be an issue on a
> > small/embedded system... and we could even use vmalloc for that
> > allocation when the size of that array is > IDA_SECTION_SIZE.
> 
> What about cyclic allocations then?  This is natrually a radix tree
> problem.  I don't know why you're resisting radix tree so much here.

It's only naturally a radix tree problem _if_ you require sparseness.
Otherwise, radix trees require pointer chasing, which we can avoid -
which saves us both the cost of chasing pointers (which is significant)
and the overhead of storing them.

The patch handles cyclic allocation by limiting sparseness - we talked
about this and I thought you were ok with this solution, though it was
awhile ago and I could be misremembering your comments.

To recap, here's the code that implements that sparseness limiting, it's
documented in ida_alloc_cyclic()'s docs:

static int __ida_alloc_cyclic(struct ida *ida, unsigned start, unsigned end,
			      gfp_t gfp, unsigned long *flags)
	__releases(&ida->lock)
	__acquires(&ida->lock)
{
	int ret;
	unsigned id;

	ret = __ida_alloc_range_multiple(ida, &id, 1,
					 max(start, ida->cur_id),
					 end, gfp, flags);

	if (ret < 0)
		ret = __ida_alloc_range_multiple(ida, &id, 1, start,
						 end, gfp, flags);
	if (ret == 1) {
		ida->cur_id = id + 1;
		if ((ida->cur_id - start) / 2 > max(1024U, ida->allocated_ids))
			ida->cur_id = 0;

		return id;
	}

	return ret;
}
