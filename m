Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab3CEXLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 18:11:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab3CEXLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 18:11:42 -0500
Message-ID: <51367B88.7000908@redhat.com>
Date: Tue, 05 Mar 2013 18:11:04 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Emmanuel Benisty <benisty.e@gmail.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 4/4] ipc: sem: do not hold ipc lock more than necessary
References: <1362476179.2225.54.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1362476179.2225.54.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 04:36 AM, Davidlohr Bueso wrote:

> @@ -888,27 +924,34 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
>   {
>   	struct sem_array *sma;
>   	struct sem* curr;
> -	int err;
> +	int err, nsems;
>   	ushort fast_sem_io[SEMMSL_FAST];
>   	ushort* sem_io = fast_sem_io;
> -	int nsems;
>   	struct list_head tasks;
>
> -	sma = sem_lock_check(ns, semid);
> -	if (IS_ERR(sma))
> +	INIT_LIST_HEAD(&tasks);
> +
> +	rcu_read_lock();
> +	sma = sem_obtain_object_check(ns, semid);
> +	if (IS_ERR(sma)) {
> +		rcu_read_lock();

I assume this should be an rcu_read_unlock? :)

>   		return PTR_ERR(sma);
> +	}


-- 
All rights reversed
