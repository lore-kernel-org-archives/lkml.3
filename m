Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaKUUHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:07:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbaKUUH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:07:27 -0500
Date: Fri, 21 Nov 2014 15:07:18 -0500
From: Rafael Aquini <aquini@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: [PATCH] ipc,sem block sem_lock on sma->lock during sma
 initialization
Message-ID: <20141121200717.GB26651@t510.redhat.com>
References: <20141121145226.2ac598af@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141121145226.2ac598af@annuminas.surriel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 02:52:26PM -0500, Rik van Riel wrote:
> When manipulating just one semaphore with semop, sem_lock only takes that
> single semaphore's lock. This creates a problem during initialization of
> the semaphore array, when the data structures used by sem_lock have not
> been set up yet. The sma->lock is already held by newary, and we just
> have to make sure everything else waits on that lock during initialization.
> 
> Luckily it is easy to make sem_lock wait on the sma->lock, by pretending
> there is a complex operation in progress while the sma is being initialized.
> 
> The newary function already zeroes sma->complex_count before unlocking
> the sma->lock.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>  ipc/sem.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/ipc/sem.c b/ipc/sem.c
> index 454f6c6..1823160 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -507,6 +507,9 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
>  		return retval;
>  	}
>  
> +	/* Ensures sem_lock waits on &sma->lock until sma is ready. */
> +	sma->complex_count = 1;
> +
>  	id = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni);
>  	if (id < 0) {
>  		ipc_rcu_putref(sma, sem_rcu_free);

Acked-by: Rafael Aquini <aquini@redhat.com>
