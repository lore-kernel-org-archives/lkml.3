Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaDSNBV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 09:01:21 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:65275 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaDSNBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 09:01:16 -0400
Date: Sat, 19 Apr 2014 09:01:12 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH 6/8] idr: avoid ping-pong
Message-ID: <20140419130112.GB3277@htj.dyndns.org>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
 <1397825404-12039-7-git-send-email-laijs@cn.fujitsu.com>
 <20140418171717.GE23576@htj.dyndns.org>
 <5352535D.8030407@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5352535D.8030407@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Apr 19, 2014 at 06:43:41PM +0800, Lai Jiangshan wrote:
> On 04/19/2014 01:17 AM, Tejun Heo wrote:
> It only frees one layer. And the ida_pre_get() for the next ida_get_new*()
> will allocation it back again. The aim "Throw away extra resources one by one"
> can't be achieved. It can't keep its memory footprint minimal.

Isn't the point not keeping the memory around per-ida between
allocations which can be arbitrarily long?  Why isn't it achieved?

> > I think the right
> > thing to do is implementing ida_preload() which is simliar to
> > idr_preload() and do away with per-ida layer cache.
> 
> Yes and no.
> 
> We need a static private ida_preload() for ida_simple_get() only.
> 
> Because the IDA doesn't have any query-function, so IDA's own synchronization
> is enough for all use cases, IDA should off-loads the caller's
> synchronization burden.

Hmmm?  And why can't that use preload on its own?

> In my todo-list, IDA only needs the following functions. other functions
> will be deprecated and scheduled to be removed:
> 	void ida_destroy(struct ida *ida);
> 	void ida_init(struct ida *ida);
> 	int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
> 			   gfp_t gfp_mask);
> 	void ida_simple_remove(struct ida *ida, unsigned int id);
> 
> (I don't think we need any query-function, But...)
> If in the future we need some query-functions such as:
> 	ida_is_this_id_allocated()
> 	ida_find_next_[un]allocated_id(),
> In this case, we can expose the ida_preload() and ida_alloc() at the same time that
> we introduce the query-functions.

Regardless of interface, we can still switch to per-cpu layer caching
which would make this per-ida allocation issue go away.  I'd much
prefer to see that than debating the (dis)merits of this patch.

Thanks.

-- 
tejun
