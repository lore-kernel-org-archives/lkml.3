Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab3FOF1W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 01:27:22 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55759 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3FOF1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 01:27:21 -0400
Message-ID: <51BBFB34.20206@colorfullife.com>
Date: Sat, 15 Jun 2013 07:27:16 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/6] ipc/sem.c: performance improvements, FIFO
References: <1370884611-3861-1-git-send-email-manfred@colorfullife.com> <51BB38FA.6080607@colorfullife.com> <1371236750.5796.54.camel@marge.simpson.net>
In-Reply-To: <1371236750.5796.54.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 09:05 PM, Mike Galbraith wrote:
> 32 of 64 cores DL980 without the -rt killing goto again loop removal I
> showed you.  Unstable, not wonderful throughput.
Unfortunately the -rt approach is defintively unstable:
> @@ -285,9 +274,29 @@ static inline int sem_lock(struct sem_ar
>                  * but have to wait for the global lock to be released.
>                  */
>                 if (unlikely(spin_is_locked(&sma->sem_perm.lock))) {
> -                       spin_unlock(&sem->lock);
> - spin_unlock_wait(&sma->sem_perm.lock);
> -                       goto again;
> +                       spin_lock(&sma->sem_perm.lock);
> +                       if (sma->complex_count)
> +                               goto wait_array;
> +
> +                       /*
> +                        * Acquiring our sem->lock under the global lock
> +                        * forces new complex operations to wait for us
> +                        * to exit our critical section.
> +                        */
> +                       spin_lock(&sem->lock);
> +                       spin_unlock(&sma->sem_perm.lock);

Assume there is one op (semctl(), whatever) that acquires the global 
lock - and a continuous stream of simple ops.
- spin_is_locked() returns true due to the semctl().
- then simple ops will switch to spin_lock(&sma->sem_perm.lock).
- since the spinlock is acquired, the next operation will get true from 
spin_is_locked().

It will stay that way around - as long as there is at least one op 
waiting for sma->sem_perm.lock.
With enough cpus, it will stay like this forever.

--
     Manfred
