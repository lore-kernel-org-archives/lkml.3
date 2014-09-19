Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbaISNYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 09:24:39 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:39475 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbaISNYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 09:24:38 -0400
Date: Fri, 19 Sep 2014 09:24:34 -0400
From: Tejun Heo <tj@kernel.org>
To: jun.zhang@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: give a protection when get_work_pwq return
 NULL.
Message-ID: <20140919132434.GA31015@mtj.dyndns.org>
References: <1411099924-11554-1-git-send-email-jun.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411099924-11554-1-git-send-email-jun.zhang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 19, 2014 at 12:12:04PM +0800, jun.zhang@intel.com wrote:
> From: zhang jun <jun.zhang@intel.com>
> 
> if pwq==NULL, system could panic. next is the panic log.
> [12973.660792] BUG: unable to handle kernel NULL pointer dereference at 00000004
> [12973.668787] IP: [<c125b8ab>] process_one_work+0x2b/0x3e0

Well, it shouldn't be NULL for a pending work_struct.

> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1947,9 +1947,19 @@ __acquires(&pool->lock)
>  {
>  	struct pool_workqueue *pwq = get_work_pwq(work);
>  	struct worker_pool *pool = worker->pool;
> -	bool cpu_intensive = pwq->wq->flags & WQ_CPU_INTENSIVE;
>  	int work_color;
>  	struct worker *collision;
> +
> +	if (pwq == NULL) {
> +		pr_err("BUG: pwq is NULL. data: 0x%08lx @ work: 0x%p\n",
> +			atomic_long_read(&work->data), work);
> +		WARN_ON(1);
> +		move_linked_works(work, &worker->scheduled, NULL);
> +		return;
> +	}
> +
> +	bool cpu_intensive = pwq->wq->flags & WQ_CPU_INTENSIVE;

Jesus, please don't do this.  The problem must be root-caused before
adding random workaround code.  This is most likely the queued
work_struct being corrupted somehow (e.g. being prematurely freed or
whatnot).  It makes zero sense to add random check in workqueue code
for that.

 Nacked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
