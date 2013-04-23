Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab3DWRg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 13:36:59 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:28072 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861Ab3DWRg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 13:36:58 -0400
Message-ID: <1366738610.1802.9.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH -mm] ipc,sem: fix locking in semctl_main
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Rik van Riel <riel@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, sedat.dilek@gmail.com,
        Emmanuel Benisty <benisty.e@gmail.com>
Date: Tue, 23 Apr 2013 10:36:50 -0700
In-Reply-To: <20130423122905.33ac0d3c@annuminas.surriel.com>
References: <20130423122905.33ac0d3c@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-23 at 12:29 -0400, Rik van Riel wrote:
> Andrew, here is the patch I promised :)
> 
> Everywhere else in the code, we check sma->sem_perm.deleted under
> the semaphore array lock, so we should do teh same here.
> The easy fix is to simply not drop and re-take the lock, but keep
> it locked.
> 

CCing Linus, Sedat and Emmanuel.

This looks very much like a patch I asked Sedat to test during the
weekend, which according to him didn't solve his issue. The patch is
correct in any case.

> This patch can be folded into ipcsem-fine-grained-locking-for-semtimedop.patch
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>

Acked-by: Davidlohr Bueso <davidlohr.bueso@hp.com>

> ---
>  ipc/sem.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/ipc/sem.c b/ipc/sem.c
> index 5711616..efdaee6 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -1243,10 +1243,9 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
>  				err = -EIDRM;
>  				goto out_free;
>  			}
> -			sem_unlock(sma, -1);
> -		}
> +		} else
> +			sem_lock(sma, NULL, -1);
>  
> -		sem_lock(sma, NULL, -1);
>  		for (i = 0; i < sma->sem_nsems; i++)
>  			sem_io[i] = sma->sem_base[i].semval;
>  		sem_unlock(sma, -1);


