Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaIWESa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 00:18:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56914 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbaIWES3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 00:18:29 -0400
Date: Mon, 22 Sep 2014 21:17:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Hui Zhu <zhuhui@xiaomi.com>
Cc: rientjes@google.com, vinayakm.list@gmail.com, weijie.yang@samsung.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        teawater@gmail.com
Subject: Re: [PATCH] Fix the issue that lowmemkiller fell into a cycle that
 try to kill a task
Message-ID: <20140923041738.GA6779@kroah.com>
References: <1411441029-8428-1-git-send-email-zhuhui@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411441029-8428-1-git-send-email-zhuhui@xiaomi.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 10:57:09AM +0800, Hui Zhu wrote:
> The cause of this issue is when free memroy size is low and a lot of task is
> trying to shrink the memory, the task that is killed by lowmemkiller cannot get
> CPU to exit itself.
> 
> Fix this issue with change the scheduling policy to SCHED_FIFO if a task's flag
> is TIF_MEMDIE in lowmemkiller.
> 
> Signed-off-by: Hui Zhu <zhuhui@xiaomi.com>
> ---
>  drivers/staging/android/lowmemorykiller.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
> index b545d3d..ca1ffac 100644
> --- a/drivers/staging/android/lowmemorykiller.c
> +++ b/drivers/staging/android/lowmemorykiller.c
> @@ -129,6 +129,10 @@ static unsigned long lowmem_scan(struct shrinker *s, struct shrink_control *sc)
>  
>  		if (test_tsk_thread_flag(p, TIF_MEMDIE) &&
>  		    time_before_eq(jiffies, lowmem_deathpending_timeout)) {
> +			struct sched_param param = { .sched_priority = 1 };
> +
> +			if (p->policy == SCHED_NORMAL)
> +				sched_setscheduler(p, SCHED_FIFO, &param);

This seems really specific to a specific scheduler pattern now.  Isn't
there some other way to resolve this?

thanks,

greg k-h
