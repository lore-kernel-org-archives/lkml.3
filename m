Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaEVPml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:42:41 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:34350 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaEVPmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:42:39 -0400
Date: Thu, 22 May 2014 11:42:36 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: remove the confusing POOL_FREEZING
Message-ID: <20140522154236.GF5065@htj.dyndns.org>
References: <1400756486-12089-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400756486-12089-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 22, 2014 at 07:01:16PM +0800, Lai Jiangshan wrote:
> While freezing takes place globally, its execution is per-workqueue;
> however, the current implementation makes use of the per-worker_pool
> POOL_FREEZING flag.  While it's not broken, the flag makes the code
> more confusing and complicates freeze_workqueues_begin() and
> thaw_workqueues() by requiring them to walk through all pools.
> 
> So we remove the POOL_FREEZING and use workqueue_freezing instead.

Misses the part which explains how the middle step is unnecessary.  I
used the following text instead.

    workqueue: remove the confusing POOL_FREEZING
    
    Currently, the global freezing state is propagated to worker_pools via
    POOL_FREEZING and then to each workqueue; however, the middle step -
    propagation through worker_pools - can be skipped as long as one or
    more max_active adjustments happens for each workqueue after the
    update to the global state is visible.  The global workqueue freezing
    state and the max_active adjustments during workqueue creation and
    [un]freezing are serialized with wq_pool_mutex, so it's trivial to
    guarantee that max_actives stay in sync with global freezing state.
    
    POOL_FREEZING is unnecessary and makes the code more confusing and
    complicates freeze_workqueues_begin() and thaw_workqueues() by
    requiring them to walk through all pools.
    
    Remove POOL_FREEZING and use workqueue_freezing directly instead.


Applied to wq/for-3.16.

Thanks.

-- 
tejun
