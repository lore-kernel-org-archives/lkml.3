Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbaLHRk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:40:58 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:63643 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaLHRk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:40:57 -0500
Date: Mon, 8 Dec 2014 12:40:52 -0500
From: Tejun Heo <tj@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Jan Kara <jack@suse.cz>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dongsu Park <dongsu.park@profitbricks.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH workqueue/for-3.18-fixes 2/2] workqueue: allow rescuer
 thread to do more work
Message-ID: <20141208174052.GA12274@htj.dyndns.org>
References: <20141110162848.6f2246bb@notabene.brown>
 <20141110085250.GB15948@quack.suse.cz>
 <20141111090402.35fa0700@notabene.brown>
 <20141118152754.60b0c75e@notabene.brown>
 <20141202204304.GR10918@htj.dyndns.org>
 <20141203114011.5d02dc43@notabene.brown>
 <20141203172010.GC5013@htj.dyndns.org>
 <20141203180241.GD5013@htj.dyndns.org>
 <20141204151104.GD15219@htj.dyndns.org>
 <20141204151223.GE15219@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141204151223.GE15219@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 10:12:23AM -0500, Tejun Heo wrote:
> From: NeilBrown <neilb@suse.de>
> 
> When there is serious memory pressure, all workers in a pool could be
> blocked, and a new thread cannot be created because it requires memory
> allocation.
> 
> In this situation a WQ_MEM_RECLAIM workqueue will wake up the
> rescuer thread to do some work.
> 
> The rescuer will only handle requests that are already on ->worklist.
> If max_requests is 1, that means it will handle a single request.
> 
> The rescuer will be woken again in 100ms to handle another max_requests
> requests.
> 
> I've seen a machine (running a 3.0 based "enterprise" kernel) with
> thousands of requests queued for xfslogd, which has a max_requests of
> 1, and is needed for retiring all 'xfs' write requests.  When one of
> the worker pools gets into this state, it progresses extremely slowly
> and possibly never recovers (only waited an hour or two).
> 
> With this patch we leave a pool_workqueue on mayday list
> until it is clearly no longer in need of assistance.  This allows
> all requests to be handled in a timely fashion.
> 
> We keep each pool_workqueue on the mayday list until
> need_to_create_worker() is false, and no work for this workqueue is
> found in the pool.
> 
> I have tested this in combination with a (hackish) patch which forces
> all work items to be handled by the rescuer thread.  In that context
> it significantly improves performance.  A similar patch for a 3.0
> kernel significantly improved performance on a heavy work load.
> 
> Thanks to Jan Kara for some design ideas, and to Dongsu Park for
> some comments and testing.
> 
> tj: Inverted the lock order between wq_mayday_lock and pool->lock with
>     a preceding patch and simplified this patch.  Added comment and
>     updated changelog accordingly.  Dongsu spotted missing get_pwq()
>     in the simplified code.
> 
> Cc: Dongsu Park <dongsu.park@profitbricks.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: NeilBrown <neilb@suse.de>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Too late for for-3.18-fixes.  Applied the two patches to wq/for-3.19.

Thanks.

-- 
tejun
