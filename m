Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab3CaNpt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 09:45:49 -0400
Received: from shelob.surriel.com ([74.92.59.67]:49690 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab3CaNpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 09:45:47 -0400
Message-ID: <51583E01.5030106@surriel.com>
Date: Sun, 31 Mar 2013 09:45:37 -0400
From: Rik van Riel <riel@surriel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
CC: Emmanuel Benisty <benisty.e@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: ipc,sem: sysv semaphore scalability
References: <1363809337-29718-1-git-send-email-riel@surriel.com>  <20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>  <20130326192852.GA25899@redhat.com>  <20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>  <20130329161746.GA8391@redhat.com>  <CA+55aFyKhgwYUMGs8MBLY5WDXhHwXP3dLWs40ayCYfgiwwncsQ@mail.gmail.com>  <CA+55aFyT6jxC=+jfORJkymo4Eagzpz-SajmnCO_PjGAPE6o25A@mail.gmail.com>  <CA+55aFygTH-tqhL1=FY32+HkjfqqpkX-nvb1c5f3V6S-iykS8A@mail.gmail.com>  <CA+i8gK+NTCK6OUzobvxPj+UaCO-iit-ww9VGNzmdqDfRC_+SuA@mail.gmail.com>  <1364609309.1818.8.camel@buesod1.americas.hpqcorp.net>  <CA+i8gK+LP_4SU8GwLMau0QvyGswZ5sKqOYnJVPZNWXZY_W9dEA@mail.gmail.com>  <CA+55aFzqzHa_6bHrqaa+6k3PZiibuJuDd1VwVD7jL047BjR=hA@mail.gmail.com>  <CA+i8gKL3PCBW_KxkYSOKE7-PHdHVsP6eLUBTuYRtunBheALJMg@mail.gmail.com> <1364706119.6239.6.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1364706119.6239.6.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2013 01:01 AM, Davidlohr Bueso wrote:

> diff --git a/ipc/sem.c b/ipc/sem.c
> index f257afe..74cedfe 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -1867,8 +1867,7 @@ void exit_sem(struct task_struct *tsk)
>   		struct sem_array *sma;
>   		struct sem_undo *un;
>   		struct list_head tasks;
> -		int semid;
> -		int i;
> +		int semid, i;
>
>   		rcu_read_lock();
>   		un = list_entry_rcu(ulp->list_proc.next,
> @@ -1884,12 +1883,13 @@ void exit_sem(struct task_struct *tsk)
>   		}
>
>   		sma = sem_obtain_object_check(tsk->nsproxy->ipc_ns, un->semid);

Should we use "semid" here, like Linus suggested, instead of "un->semid"?

> -		sem_lock(sma, NULL, -1);
> -
>   		/* exit_sem raced with IPC_RMID, nothing to do */
> -		if (IS_ERR(sma))
> +		if (IS_ERR(sma)) {
> +			rcu_read_unlock();
>   			continue;
> +		}
>
> +		sem_lock(sma, NULL, -1);
>   		un = __lookup_undo(ulp, semid);
>   		if (un == NULL) {
>   			/* exit_sem raced with IPC_RMID+semget() that created
>

-- 
All rights reversed.
