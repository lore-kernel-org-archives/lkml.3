Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbaDUWUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 18:20:44 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:64627 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbaDUWUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 18:20:39 -0400
Date: Mon, 21 Apr 2014 18:20:35 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 V3] workqueue: substitute POOL_FREEZING with
 __WQ_FREEZING
Message-ID: <20140421222035.GA22730@htj.dyndns.org>
References: <1398081561-12618-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398081561-12618-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 07:59:20PM +0800, Lai Jiangshan wrote:
> Only workqueues have freezable or freezing attribution/state, not worker pools.
> But POOL_FREEZING adds a suspicious state and makes reviewers confused.
> 
> And it causes freeze_workqueues_begin() and thaw_workqueues() much complicated,
> they need to travel all the pools besides wqs.
> 
> Since freezable is workqueue instance's attribution, and freezing
> is workqueue instance's state, so we introduce __WQ_FREEZING
> to wq->flags instead and remove POOL_FREEZING.
> 
> It is different from POOL_FREEZING, POOL_FREEZING is simply set
> all over the world(all pools), while __WQ_FREEZING is only set for freezable wq.
> freeze_workqueues_begin()/thaw_workqueues() skip to handle non-freezable wqs
> and don't touch the non-freezable wqs' flags.

I was about to apply the patch and have updated the patch description.

  While freezing takes place globally, its execution is per-workqueue;
  however, the current implementation makes use of the per-worker_pool
  POOL_FREEZING flag.  While it's not broken, the flag makes the code
  more confusing and complicates freeze_workqueues_begin() and
  thaw_workqueues() by requiring them to walk through all pools.

  Since freezable is a workqueue's attribute, and freezing is a
  workqueue's state, let's introduce __WQ_FREEZING to wq->flags instead
  and remove POOL_FREEZING.

  It is different from POOL_FREEZING in that __WQ_FREEZING is only set
  for freezable workqueues while POOL_FREEZING is set globally over all
  pools.  freeze_workqueues_begin() and thaw_workqueues() now skip
  non-freezable workqueues.

But looking at the patch, why do we need __WQ_FREEZING at all?  We
should be able to test workqueue_freezing in pwq_adjust_max_active(),
right?  The only requirement there would be that
pwq_adjust_max_active(0 is invoked at least once after
workqueue_freezing is changed, which is already guaranteed.

Thanks.

-- 
tejun
