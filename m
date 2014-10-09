Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaJIXHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 19:07:54 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:45298 "EHLO
	homiemail-a6.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918AbaJIXHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 19:07:52 -0400
Message-ID: <1412896054.8874.6.camel@linux-t7sj.site>
Subject: Re: [PATCH 1/3] ipc/sem.c: Chance memory barrier in sem_lock() to
 smp_rmb()
From: Davidlohr Bueso <dave@stgolabs.net>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Rafael Aquini <aquini@redhat.com>, Rik van Riel <riel@redhat.com>,
        1vier1@web.de
Date: Thu, 09 Oct 2014 16:07:34 -0700
In-Reply-To: <1412620363-2759-2-git-send-email-manfred@colorfullife.com>
References: <1412620363-2759-1-git-send-email-manfred@colorfullife.com>
	 <1412620363-2759-2-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-06 at 20:32 +0200, Manfred Spraul wrote:
> When I fixed bugs in the sem_lock() logic, I was more conservative than
> necessary.
> Therefore it is safe to replace the smp_mb() with smp_rmb().
> And: With smp_rmb(), semop() syscalls are up to 10% faster.
> 
> The race we must protect against is:
> 
> 	sem->lock is free
> 	sma->complex_count = 0
> 	sma->sem_perm.lock held by thread B
> 
> thread A:
> 
> A: spin_lock(&sem->lock)
> 
> 			B: sma->complex_count++; (now 1)
> 			B: spin_unlock(&sma->sem_perm.lock);
> 
> A: spin_is_locked(&sma->sem_perm.lock);
> A: XXXXX memory barrier
> A: if (sma->complex_count == 0)
> 
> Thread A must read the increased complex_count value, i.e. the read must
> not be reordered with the read of sem_perm.lock done by spin_is_locked().
> 
> Since it's about ordering of reads, smp_rmb() is sufficient.
> 
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>

With a suggestion below.

> ---
>  ipc/sem.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/ipc/sem.c b/ipc/sem.c
> index 454f6c6..ffc71de 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -326,10 +326,16 @@ static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
>  
>  		/* Then check that the global lock is free */
>  		if (!spin_is_locked(&sma->sem_perm.lock)) {
> -			/* spin_is_locked() is not a memory barrier */
> -			smp_mb();
> +			/*
> +			 * The next test must happen after the test for
> +			 * sem_perm.lock, otherwise we can race with another
> +			 * thread that does
> +			 *	complex_count++;spin_unlock(sem_perm.lock);
> +			 */

How about this comment instead:

	/*
	 * The ipc object lock check must be visible on all cores before
	 * rechecking the complex count. Otherwise we can race with 
	 * another thread that does:
	 * 	complex_count++++;
	 * 	spin_unlock(sem_perm.lock);
	 */

