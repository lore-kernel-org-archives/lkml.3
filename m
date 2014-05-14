Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbaENOwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:52:44 -0400
Received: from g6t1526.atlanta.hp.com ([15.193.200.69]:13359 "EHLO
	g6t1526.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771AbaENOwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:52:43 -0400
Message-ID: <1400079158.9356.10.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 6/6] ipc/sem.c: make semctl(,,{GETNCNT,GETZCNT})
 standard compliant
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, 1vier1@web.de
Date: Wed, 14 May 2014 07:52:38 -0700
In-Reply-To: <1399716199-26776-7-git-send-email-manfred@colorfullife.com>
References: <1399716199-26776-1-git-send-email-manfred@colorfullife.com>
	 <1399716199-26776-2-git-send-email-manfred@colorfullife.com>
	 <1399716199-26776-3-git-send-email-manfred@colorfullife.com>
	 <1399716199-26776-4-git-send-email-manfred@colorfullife.com>
	 <1399716199-26776-5-git-send-email-manfred@colorfullife.com>
	 <1399716199-26776-6-git-send-email-manfred@colorfullife.com>
	 <1399716199-26776-7-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-05-10 at 12:03 +0200, Manfred Spraul wrote:
> Per definition, a task waits on exactly one semaphore:
> The semaphore from the first operation in the sop array that cannot proceed.
> 
> The Linux implementation never followed the standard, it tried to count all
> semaphores that might be the reason why a task sleeps.
> 
> This patch fixes that.
> 
> Note:
> The implementation assumes that GETNCNT and GETZCNT are rare operations,
> therefore the code counts them only on demand.
> (If they wouldn't be rare, then the non-compliance would have
> been found earlier)
> 
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> ---
>  ipc/sem.c | 37 ++++++++++++++++---------------------
>  1 file changed, 16 insertions(+), 21 deletions(-)
> 
> diff --git a/ipc/sem.c b/ipc/sem.c
> index 22a4c12..5e8bcde 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -993,38 +993,33 @@ static void do_smart_update(struct sem_array *sma, struct sembuf *sops, int nsop
>  }
>  
>  /*
> - * check_qop: Test how often a queued operation sleeps on the semaphore semnum
> + * check_qop: Test if a queued operation sleeps on the semaphore semnum
>   */
>  static int check_qop(struct sem_array *sma, int semnum, struct sem_queue *q,
>  			bool count_zero)
>  {
> -	struct sembuf *sops = q->sops;
> -	int nsops = q->nsops;
> -	int i, semcnt;
> +	struct sembuf *sop = q->blocking;
>  
> -	semcnt = 0;
> +	BUG_ON(sop->sem_flg & IPC_NOWAIT);
> +	BUG_ON(sop->sem_op > 0);

Hmm in light of Linus' recent criticism about randomly sprinkling
BUG_ONs in the kernel I'm not sure we want this. Yes, all those calls
are correct from a logical pov and should never occur, however, would
WARN be more suitable instead? I don't know. 

Andrew, any thoughts?

Thanks.

