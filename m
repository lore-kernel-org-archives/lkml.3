Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaHIIzT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 04:55:19 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:40068 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaHIIzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 04:55:16 -0400
Date: Sat, 9 Aug 2014 01:55:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Cong Wang <xiyou.wangcong@gmail.com>
cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch] freezer: check OOM kill signal while being frozen
In-Reply-To: <1407545198-9009-1-git-send-email-xiyou.wangcong@gmail.com>
Message-ID: <alpine.DEB.2.02.1408090152240.11855@chino.kir.corp.google.com>
References: <1407545198-9009-1-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2014, Cong Wang wrote:

> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index aa6a8aa..c6d189d 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -68,7 +68,9 @@ bool __refrigerator(bool check_kthr_stop)
>  		spin_lock_irq(&freezer_lock);
>  		current->flags |= PF_FROZEN;
>  		if (!freezing(current) ||
> -		    (check_kthr_stop && kthread_should_stop()))
> +		    (check_kthr_stop && kthread_should_stop()) ||
> +		    (test_tsk_thread_flag(current, TIF_MEMDIE) &&
> +			 fatal_signal_pending(current)))
>  			current->flags &= ~PF_FROZEN;
>  		spin_unlock_irq(&freezer_lock);
>  

All threads with TIF_MEMDIE set would have been killed, why is the check 
for fatal_signal_pending(current) needed?

You can also use test_thread_flag(TIF_MEMDIE) instead since you're only 
concerned with current.

Furthermore, that conditional is getting difficult to read.  Maybe it 
would help to have a helper function that returns bool that determines 
whether PF_FROZEN should be cleared?
