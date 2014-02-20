Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaBTALr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 19:11:47 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:47282 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbaBTALq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 19:11:46 -0500
Date: Wed, 19 Feb 2014 19:11:42 -0500
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: Fix possible unexpectedly worker wakeup
 before started
Message-ID: <20140220001142.GV10134@htj.dyndns.org>
References: <1392781678-31952-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392781678-31952-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Wed, Feb 19, 2014 at 11:47:58AM +0800, Lai Jiangshan wrote:
> If a worker is wokenup unexpectedly, it will start to work incorretly.
> Although it hardly happen, we should catch it and wait for being started
> if it does happen.

Can this actually happen?  If so, how?

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/workqueue.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 82ef9f3..bee5fe1 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2284,6 +2284,12 @@ static int worker_thread(void *__worker)
>  	struct worker *worker = __worker;
>  	struct worker_pool *pool = worker->pool;
>  
> +	if (WARN_ON_ONCE(!(worker->flags & WORKER_STARTED))) {

And if this is something which can legitimately happen, why are we
triggering WARN on it?

> +		/* The worker is wokenup unexpectedly before started */
> +		mutex_lock(&pool->manager_mutex);
> +		mutex_unlock(&pool->manager_mutex);

And what does these mutex cycling achieve (they need comment)?

Thanks.

-- 
tejun
