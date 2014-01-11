Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbaAKETI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 23:19:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59800 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbaAKETF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 23:19:05 -0500
Message-ID: <1389413931.6068.5.camel@marge.simpson.net>
Subject: Re: [PATCH 7/7] ipc,msg: document barriers
From: Mike Galbraith <bitbucket@online.de>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: akpm@linux-foundation.org, manfred@colorfullife.com, riel@redhat.com,
        aswin@hp.com, linux-kernel@vger.kernel.org
Date: Sat, 11 Jan 2014 05:18:51 +0100
In-Reply-To: <1389379707-20298-8-git-send-email-davidlohr@hp.com>
References: <1389379707-20298-1-git-send-email-davidlohr@hp.com>
	 <1389379707-20298-8-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:UJr45Yu3VmJhknRJyvOoj5SR02WBrFEsKnYDbN0lFeP
 Njxq0V8Eg0kS3JNwrrwa/5r5f9y1pqzvb1wU/KiNZPtRnCy/Ul
 oE5kEJWp1+Ldh6heCsfv4dNMCQgUqVhrmYAlvh7ctuWc6xx1Ps
 5DAj+J22EJ/jJ1+kWNjZC5bZGvt2nWwa/ExywaA1Nd+xrDP69F
 y7TwUBJDzvK5JPDTztzoVampljJbXND8jzAdlo9AqcJMo3QgRD
 z5PBAWtluLe/Xer3n9AXZhLfoOidDJDdL3ilug+iNBeFt56tuL
 2SH0fOMZ93q/dDNHILgy5parrYyBtVYi3lv/8cwux2I7e4T2lK
 ezWT3xYNQ6xFugiUt3FE8jZHSg3sukE3HhLLi44FQOZxWxiB+l
 P2fTJP8QkTV7g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-10 at 10:48 -0800, Davidlohr Bueso wrote: 
> Both expunge_all() and pipeline_send() rely on both a nil msg value and a
> full barrier to guarantee the correct ordering when waking up a task. While
> its counter part at the receiving end is well documented for the lockless
> recv algorithm, we still need to document these specific smp_mb() calls.
> 
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> ---
>  ipc/msg.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/ipc/msg.c b/ipc/msg.c
> index 4377f4a..8c1cc76 100644
> --- a/ipc/msg.c
> +++ b/ipc/msg.c
> @@ -253,8 +253,14 @@ static void expunge_all(struct msg_queue *msq, int res)
>  	struct msg_receiver *msr, *t;
>  
>  	list_for_each_entry_safe(msr, t, &msq->q_receivers, r_list) {
> -		msr->r_msg = NULL;
> +		msr->r_msg = NULL; /* initialize expunge ordering */
>  		wake_up_process(msr->r_tsk);
> +		/*
> +		 * Ensure that the wakeup is visible before setting r_msg as
> +		 * the receiving end depends on it: either spinning on a nil,
> +		 * or dealing with -EAGAIN cases. See lockless reveice part 1
                                                                 ^^^^^^^ lysdexic fingers

> +		 * and 2 in do_msgrcv().
> +		 */
>  		smp_mb();
>  		msr->r_msg = ERR_PTR(res);
>  	}
> @@ -638,15 +644,22 @@ static inline int pipelined_send(struct msg_queue *msq, struct msg_msg *msg)
>  
>  			list_del(&msr->r_list);
>  			if (msr->r_maxsize < msg->m_ts) {
> +				/* initialize pipelined send ordering */
>  				msr->r_msg = NULL;
>  				wake_up_process(msr->r_tsk);
> -				smp_mb();
> +				smp_mb(); /* see barrier comment below */
>  				msr->r_msg = ERR_PTR(-E2BIG);
>  			} else {
>  				msr->r_msg = NULL;
>  				msq->q_lrpid = task_pid_vnr(msr->r_tsk);
>  				msq->q_rtime = get_seconds();
>  				wake_up_process(msr->r_tsk);
> +				/*
> +				 * Ensure that the wakeup is visible before
> +				 * setting r_msg, as the receiving end depends
> +				 * on it. See lockless reveice part 1 and 2 in
                                                         ^^^^^^^ ditto



