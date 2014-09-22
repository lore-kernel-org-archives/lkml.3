Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaIVDjv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 23:39:51 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:46161 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaIVDju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 23:39:50 -0400
Date: Sun, 21 Sep 2014 23:39:46 -0400
From: Tejun Heo <tj@kernel.org>
To: Yifan Zhang <zhangyf@marvell.com>
Cc: Jing Xiang <jxiang@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: fix a workqueue kernel panic issue.
Message-ID: <20140922033946.GA23583@htj.dyndns.org>
References: <1410941884-26034-1-git-send-email-zhangyf@marvell.com>
 <4737A960563B524DA805CA602BE04B307EEE6C2694@SC-VEXCH2.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4737A960563B524DA805CA602BE04B307EEE6C2694@SC-VEXCH2.marvell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2014 at 08:30:32PM -0700, Yifan Zhang wrote:
> Hi Tejun,
> 
> What's do you think of this patch ? Any concern ?

Hmmm?  Haven't I already responded to this patch?

> -----Original Message-----
> From: Yifan Zhang [mailto:zhangyf@marvell.com] 
> Sent: 2014年9月17日 16:18
> To: Tejun Heo; Jing Xiang; linux-kernel@vger.kernel.org
> Cc: Yifan Zhang
> Subject: [PATCH] workqueue: fix a workqueue kernel panic issue.
> 
> if created workqueue in multi-thread unsynchronized,

Can you please elaborate?

> get_work_pwq() may return NULL, which cause kernel panic. Judge get_work_pwq() return value before use
> pwq->wq->flags.
> 
> Signed-off-by: Yifan Zhang <zhangyf@marvell.com>
> ---
>  kernel/workqueue.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c index 5dbe22a..d3ac87f 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1947,9 +1947,19 @@ __acquires(&pool->lock)  {
>  	struct pool_workqueue *pwq = get_work_pwq(work);
>  	struct worker_pool *pool = worker->pool;
> -	bool cpu_intensive = pwq->wq->flags & WQ_CPU_INTENSIVE;
> +	bool cpu_intensive;
>  	int work_color;
>  	struct worker *collision;
> +
> +	if (pwq == NULL) {
> +		pr_err("BUG: invalid struct work_struct.data %lu\n",
> +				atomic_long_read(&work->data));
> +		dump_stack();
> +		return;

I have difficult time seeing how the above piece of code would be
acceptable but maybe the situation you're trying to explain is weird
enough to justify it.

Thanks.

-- 
tejun
