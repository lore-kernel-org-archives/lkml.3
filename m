Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab3BFSwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 13:52:19 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:63824 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862Ab3BFSwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 13:52:18 -0500
Date: Wed, 6 Feb 2013 10:52:13 -0800
From: Tejun Heo <tj@kernel.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] stop_machine: wake up stopper thread lazily
Message-ID: <20130206185213.GC2875@htj.dyndns.org>
References: <CAJd=RBBp1-Q_xDzyUsLLJkh1BWb_X13JAOGxpOjt5Q48_7Q=Ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBBp1-Q_xDzyUsLLJkh1BWb_X13JAOGxpOjt5Q48_7Q=Ng@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 08:40:32PM +0800, Hillf Danton wrote:
> Ring no bell if the stopper thread is busy in handling enqueued works.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/kernel/stop_machine.c	Wed Feb  6 20:05:44 2013
> +++ b/kernel/stop_machine.c	Wed Feb  6 20:06:56 2013
> @@ -72,8 +72,10 @@ static void cpu_stop_queue_work(struct c
>  	spin_lock_irqsave(&stopper->lock, flags);
> 
>  	if (stopper->enabled) {
> +		int wakeup = list_empty(&stopper->works);
>  		list_add_tail(&work->list, &stopper->works);
> -		wake_up_process(stopper->thread);
> +		if (wakeup)
> +			wake_up_process(stopper->thread);

Why does this matter?  It shouldn't matter for correctness.  Is it
meant to be an optimization?  Is it something worth optimizing?  We
hardly ever have contention on cpu stoppers after all and we
shouldn't.

-- 
tejun
