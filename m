Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab3H1VNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 17:13:18 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:59459 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab3H1VNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 17:13:17 -0400
Date: Wed, 28 Aug 2013 17:13:12 -0400
From: Tejun Heo <tj@kernel.org>
To: Jamie Liu <jamieliu@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: defer to waiting stop_machine
Message-ID: <20130828211312.GB18971@mtj.dyndns.org>
References: <1377724032-12199-1-git-send-email-jamieliu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377724032-12199-1-git-send-email-jamieliu@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 02:07:12PM -0700, Jamie Liu wrote:
...
> @@ -734,7 +735,8 @@ static bool may_start_working(struct worker_pool *pool)
>  static bool keep_working(struct worker_pool *pool)
>  {
>  	return !list_empty(&pool->worklist) &&
> -		atomic_read(&pool->nr_running) <= 1;
> +		atomic_read(&pool->nr_running) <= 1 &&
> +		likely(!stop_machine_pending());

Isn't the problem that the kworker wouldn't yield to the higher
priority stopper task while a work item keeps requeueing itself if
preemption is not enabled?  If so, isn't the correct solution just
adding cond_resched() in the work item processing loop?  The analysis
and solution seem to have gone a bit stray....

Thanks.

-- 
tejun
