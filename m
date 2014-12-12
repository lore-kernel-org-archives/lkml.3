Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031068AbaLLRZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:25:51 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:55491 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030832AbaLLRZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:25:50 -0500
Date: Fri, 12 Dec 2014 12:25:46 -0500
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 3/5] workqueue: fixup existing pool->node
Message-ID: <20141212172546.GC20020@htj.dyndns.org>
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com>
 <1418379595-6281-4-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418379595-6281-4-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 06:19:53PM +0800, Lai Jiangshan wrote:
> Yasuaki Ishimatsu hit a bug when the numa mapping between CPU and node
> is changed.  And the previous path fixup wq_numa_possible_cpumask.
> (See more information form the changelog of that patch)
> 
> After wq_numa_possible_cpumask was updated, the new pool->node will be
> correct, but the existing pools (and workers) are still running, some of
> them are running with the wrong pool->node, or even worse, with pool->node
> which is quitted node, they create_worker() on wrong pool->node.
> These create_worker() may create workers on wrong node or failed without
> any progress (when with pool->node which is quitted node).
> 
> So we need to update the pool->node when the numa mapping is changed.
> 
> We simply re-calc the pool->node when the numa mapping changed. It reuses
> the code from get_unbound_pool() for unbound pool.

I don't get this patch.  If a node is gone, all its cpus would be gone
and the pool should be discarded.  If a new node comes online with
different mappings, new sets of pools should serve them instead of
recycling the old ones.  Wouldn't it make a lot more sense to make
sure we don't reuse the pools w/ old mappings for new pwqs?

Thanks.

-- 
tejun
