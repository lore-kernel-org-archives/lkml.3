Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaJPH5C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:57:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:50169 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaJPH5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:57:00 -0400
Date: Thu, 16 Oct 2014 09:56:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH RFC] sched: Revert delayed_put_task_struct() and fix use
 after free
Message-ID: <20141016075650.GB7369@worktop.fdxtended.com>
References: <1413376300.24793.55.camel@tkhai>
 <20141015150641.GA2755@redhat.com>
 <20141015194044.GA4557@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141015194044.GA4557@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 09:40:44PM +0200, Oleg Nesterov wrote:
> What do you think?
> 
> Oleg.
> 
> --- x/kernel/sched/fair.c
> +++ x/kernel/sched/fair.c
> @@ -1165,7 +1165,7 @@ static void task_numa_compare(struct tas
>  
>  	rcu_read_lock();
>  	cur = ACCESS_ONCE(dst_rq->curr);
> -	if (cur->pid == 0) /* idle */
> +	if (is_idle_task(cur) || (curr->flags & PF_EXITING))
>  		cur = NULL;
>  
>  	/*

That makes sense, is_idle_task() is indeed the right function there, and
PF_EXITING avoids doing work where it doesn't make sense.
