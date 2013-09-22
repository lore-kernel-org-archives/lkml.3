Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab3IVJe2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 05:34:28 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:49969 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab3IVJeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 05:34:25 -0400
Message-ID: <523EB997.9090107@gmail.com>
Date: Sun, 22 Sep 2013 17:34:15 +0800
From: Jia He <jiakernel@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] ipc/sem.c: fix update sem_otime when calling sem_op in
 semaphore initialization
References: <1379815884-11035-1-git-send-email-jiakernel@gmail.com>	 <1379837823.5499.34.camel@marge.simpson.net> <1379838364.5499.39.camel@marge.simpson.net>
In-Reply-To: <1379838364.5499.39.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Thanks for the comments, but pls add my email as "from jiakernel@gmail.com"
if you have a better implementation.U know, it is my first kernel patch, maybe
will give me a brilliant memory in the future :)
  Anyway, your implementation looks not correct to me. Because from "man semop"
sem_otime will record the last sem operation time of semop. If you change the
otime in semget(), it changes the meanings in stardard, doesn't it?

On Sun, 22 Sep 2013 10:26:04 +0200 from bitbucket@online.de wrote:
> On Sun, 2013-09-22 at 10:17 +0200, Mike Galbraith wrote: 
>> On Sun, 2013-09-22 at 10:11 +0800, Jia He wrote: 
>>> In commit 0a2b9d4c,the update of semaphore's sem_otime(last semop time)
>>> was removed because he wanted to move setting sem->sem_otime to one
>>> place. But after that, the initial semop() will not set the otime
>>> because its sem_op value is 0(in semtimedop,will not change
>>> otime if alter == 1).
>>>
>>> the error case:
>>> process_a(server)       process_b(client)
>>> semget()
>>> semctl(SETVAL)
>>> semop()
>>>                         semget()
>>>                         setctl(IP_STAT)
>>>                         for(;;) {               <--not successful here
>>>                           check until sem_otime > 0
>>>                         }
>> Why not..
> (pokes evolution's don't-munge-me button)
>
> ipc,sem: Create semaphores with plausible sem_otime.
>
> Signed-off-by: Mike Galbraith <bitbucket@online.de>
>
> diff --git a/ipc/sem.c b/ipc/sem.c
> index 4108889..f2564d7 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -471,19 +471,20 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
>  	ns->used_sems += nsems;
>  
>  	sma->sem_base = (struct sem *) &sma[1];
> +	sma->complex_count = 0;
> +	INIT_LIST_HEAD(&sma->pending_alter);
> +	INIT_LIST_HEAD(&sma->pending_const);
> +	INIT_LIST_HEAD(&sma->list_id);
> +	sma->sem_nsems = nsems;
> +	sma->sem_ctime = get_seconds();
>  
>  	for (i = 0; i < nsems; i++) {
>  		INIT_LIST_HEAD(&sma->sem_base[i].pending_alter);
>  		INIT_LIST_HEAD(&sma->sem_base[i].pending_const);
>  		spin_lock_init(&sma->sem_base[i].lock);
> +		sma->sem_base[i].sem_otime = sma->sem_ctime;
>  	}
>  
> -	sma->complex_count = 0;
> -	INIT_LIST_HEAD(&sma->pending_alter);
> -	INIT_LIST_HEAD(&sma->pending_const);
> -	INIT_LIST_HEAD(&sma->list_id);
> -	sma->sem_nsems = nsems;
> -	sma->sem_ctime = get_seconds();
>  	sem_unlock(sma, -1);
>  	rcu_read_unlock();
>  
>
>
>

