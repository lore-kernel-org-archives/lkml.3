Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab3CaBaa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 21:30:30 -0400
Received: from shelob.surriel.com ([74.92.59.67]:43255 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab3CaBa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 21:30:27 -0400
Message-ID: <515791A8.7010904@surriel.com>
Date: Sat, 30 Mar 2013 21:30:16 -0400
From: Rik van Riel <riel@surriel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: torvalds@linux-foundation.org, davidlohr.bueso@hp.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hhuang@redhat.com, jason.low2@hp.com, walken@google.com,
        lwoodman@redhat.com, chegu_vinod@hp.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH -mm -next] ipc,sem: untangle RCU locking with find_alloc_undo
References: <1363809337-29718-1-git-send-email-riel@surriel.com> <5151DBD3.6080201@oracle.com> <20130328113222.194bbfe8@cuia.bos.redhat.com> <5156EA36.8050109@oracle.com>
In-Reply-To: <5156EA36.8050109@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2013 09:35 AM, Sasha Levin wrote:

> I'm thinking that the solution is as simple as:

Your patch is absolutely correct.  All it needs now is your
signed-off-by, so Andrew can merge it into -mm :)

Reviewed-by: Rik van Riel <riel@redhat.com>

> diff --git a/ipc/sem.c b/ipc/sem.c
> index 6e109ef..ac36671 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -1333,8 +1333,10 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
>          /* GETVAL, GETPID, GETNCTN, GETZCNT: fall-through */
>          }
>          err = -EINVAL;
> -       if(semnum < 0 || semnum >= nsems)
> -               goto out_unlock;
> +       if(semnum < 0 || semnum >= nsems) {
> +               rcu_read_unlock();
> +               goto out_wakeup;
> +       }
>
>          sem_lock(sma, NULL, -1);
>          curr = &sma->sem_base[semnum];
>
> But I'm not 100% sure if I don't mess up anything else.

I checked the surrounding code, it all looks fine.

-- 
All rights reversed.
