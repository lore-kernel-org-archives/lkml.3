Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab3LRTAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:00:42 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:62060 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab3LRTAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:00:41 -0500
Message-ID: <52B1F0D4.3040502@colorfullife.com>
Date: Wed, 18 Dec 2013 20:00:36 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>, Davidlohr Bueso <davidlohr@hp.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH v2] ipc: introduce ipc_valid_object() helper to sort out
 IPC_RMID races
References: <e70c06876f986f0ac7f2f104bab50edff4a524a0.1387302999.git.aquini@redhat.com> <9710122c2aa978165609c0940e2087b074cd26ea.1387322182.git.aquini@redhat.com> <52B190F1.9050505@colorfullife.com> <20131218125059.GF19025@localhost.localdomain> <1387381587.2797.33.camel@buesod1.americas.hpqcorp.net> <20131218173442.GA16621@localhost.localdomain>
In-Reply-To: <20131218173442.GA16621@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On 12/18/2013 06:34 PM, Rafael Aquini wrote:
> Folks,
>
> Before I re-submit the v3 with the commentary changes requested, I'm pasting
> here what I'm planning to amend to v2 patch:
> ---
> diff --git a/ipc/sem.c b/ipc/sem.c
> index ed0057a..23379b6 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -1846,6 +1846,14 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __u
>   
>          error = -EIDRM;
>          locknum = sem_lock(sma, sops, nsops);
> +       /*
> +        * We eventually might perform the following check in a lockless
> +        * fashion here, considering ipc_valid_object() locking constraints.
> +        * If nsops == 1 and there's no contention for sem_perm.lock, then
> +        * only a per-semaphore lock is held and it's OK to go on the check
> +        * below. More details on the fine grained locking scheme entangled
> +        * here, and why it's RMID race safe on comments at sem_lock()
> +        */
>          if (!ipc_valid_object(&sma->sem_perm))
>                  goto out_unlock_free;
>          /*
> diff --git a/ipc/util.h b/ipc/util.h
> index 071ed58..d05b708 100644
> --- a/ipc/util.h
> +++ b/ipc/util.h
> @@ -190,7 +190,8 @@ static inline void ipc_unlock(struct kern_ipc_perm *perm)
>    * where the respective ipc_ids.rwsem is not being held down.
>    * Checks whether the ipc object is still around or if it's gone already, as
>    * ipc_rmid() may have already freed the ID while the ipc lock was spinning.
> - * Needs to be called with kern_ipc_perm.lock held.
> + * Needs to be called with kern_ipc_perm.lock held -- exception made for one
> + * checkpoint case at sys_semtimedop() as noted in code commentary.
>    */
>   static inline bool ipc_valid_object(struct kern_ipc_perm *perm)
>   {
> ---
>
> Do we need to change somthing else?
> Looking forward your thoughts!
Acked-by: Manfred Spraul <manfred@colorfullife.com>

--
     Manfred
