Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab3LRMLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 07:11:35 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:59508 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab3LRMLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 07:11:33 -0500
Message-ID: <52B190F1.9050505@colorfullife.com>
Date: Wed, 18 Dec 2013 13:11:29 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>, linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Rik van Riel <riel@redhat.com>,
        Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH v2] ipc: introduce ipc_valid_object() helper to sort out
 IPC_RMID races
References: <e70c06876f986f0ac7f2f104bab50edff4a524a0.1387302999.git.aquini@redhat.com> <9710122c2aa978165609c0940e2087b074cd26ea.1387322182.git.aquini@redhat.com>
In-Reply-To: <9710122c2aa978165609c0940e2087b074cd26ea.1387322182.git.aquini@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 12:28 AM, Rafael Aquini wrote:
> After the locking semantics for the SysV IPC API got improved, a couple of
> IPC_RMID race windows were opened because we ended up dropping the
> 'kern_ipc_perm.deleted' check performed way down in ipc_lock().
> The spotted races got sorted out by re-introducing the old test within
> the racy critical sections.
>
> This patch introduces ipc_valid_object() to consolidate the way we cope with
> IPC_RMID races by using the same abstraction across the API implementation.
>
> Signed-off-by: Rafael Aquini <aquini@redhat.com>
> Acked-by: Rik van Riel <riel@redhat.com>
> Acked-by: Greg Thelen <gthelen@google.com>
> ---
> Changelog:
> * v2:
>   - drop assert_spin_locked() from ipc_valid_object() for less overhead
a) sysv ipc is lockless whereever possible, without writing to any 
shared cachelines.
Therefore my first reaction was: No, please leave the assert in. It will 
help us to catch bugs.

b) then I noticed: the assert would be a bug, the comment in front of 
ipc_valid_object() that the caller must hold _perm.lock is wrong:
> @@ -1846,7 +1846,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
>   
>   	error = -EIDRM;
>   	locknum = sem_lock(sma, sops, nsops);
> -	if (sma->sem_perm.deleted)
> +	if (!ipc_valid_object(&sma->sem_perm))
>   		goto out_unlock_free;
simple semtimedop() operation do not acquire sem_perm.lock, they only 
acquire the per-semaphore lock and check that sem_perm.lock is not held. 
This is sufficient to prevent races with RMID.

Could you update the comment?
[...]
> @@ -1116,7 +1116,7 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr,
>   	ipc_lock_object(&shp->shm_perm);
>   
>   	/* check if shm_destroy() is tearing down shp */
> -	if (shp->shm_file == NULL) {
> +	if (!ipc_valid_object(&shp->shm_perm)) {
>   		ipc_unlock_object(&shp->shm_perm);
>   		err = -EIDRM;
>   		goto out_unlock;
Please mention the change from "shm_file == NULL" to perm.deleted in the 
changelog.
With regards to the impact of this change: No idea, I've never worked on 
the shm code.

--
     Manfred
