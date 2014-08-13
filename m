Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaHMQA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 12:00:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852AbaHMQAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:00:25 -0400
Date: Wed, 13 Aug 2014 17:58:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] fix sighand use after free
Message-ID: <20140813155802.GA2695@redhat.com>
References: <20140813115000.73da6136@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813115000.73da6136@cuia.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13, Rik van Riel wrote:
>
> Subject: fix sighand use after free
>
> __lock_task_sighand carefully takes the rcu_read_lock, gets
> tsk->sighand with rcu_dereference, and verifies that the task
> is still using the sighand_struct after taking the spinlock.
>
> This works much better if the sighand struct is actually rcu
> freed.

I promise, I'll send the doc patch soon ;)

> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1017,7 +1017,7 @@ void __cleanup_sighand(struct sighand_struct *sighand)
>  {
>  	if (atomic_dec_and_test(&sighand->count)) {
>  		signalfd_cleanup(sighand);
> -		kmem_cache_free(sighand_cachep, sighand);
> +		rcu_free(sighand_cachep, sighand);

Please note that sighand_cachep is SLAB_DESTROY_BY_RCU.

Hmm. and what is rcu_free() ?

Oleg.

