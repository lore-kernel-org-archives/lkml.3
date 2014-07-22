Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaGVAuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 20:50:12 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:61220 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaGVAuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 20:50:10 -0400
Date: Mon, 21 Jul 2014 20:50:05 -0400
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH percpu/for-3.17 2/2] blk-throttle: replace custom async
 percpu alloc mechanism with percpu_pool
Message-ID: <20140722005005.GH12921@htj.dyndns.org>
References: <20140718200804.GG13012@htj.dyndns.org>
 <20140718200834.GH13012@htj.dyndns.org>
 <20140721172734.GA13577@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721172734.GA13577@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jul 21, 2014 at 01:27:34PM -0400, Vivek Goyal wrote:
> > +static bool tg_ensure_stats_cpu(struct throtl_grp *tg)
...
> > +	if (cmpxchg(&tg->stats_cpu, (struct tg_stats_cpu __percpu *)NULL,
> > +		    stats_cpu))
> > +		free_percpu(stats_cpu);
> > +
> 
> 
> So we are using atomic cmpxchg() so that we don't ask callers to hold queue
> lock during this call? One of the callers is throtl_update_dispatch_stats()
> and we don't want to grab queue lock while updating per cpu stat. In fact
> stats were made per cpu so that we don't have to grab the lock.

Yeah, pretty much.  We can grab queuelock in the cold path for
installation only but the original code already had cmpxchg, so I
thought why not.  It could be simpler to do the following tho.

	if (already populated)
		return;

	lock_queue;
	if (populated inbetween)
		unlock and return;
	alloc;
	install;
	unlock_queue;

I don't know.  I don't think it really matters.

Thanks.

-- 
tejun
