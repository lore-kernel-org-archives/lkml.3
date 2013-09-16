Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab3IPJXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 05:23:19 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:54916 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757307Ab3IPJXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 05:23:18 -0400
Message-ID: <5236CE01.8010906@colorfullife.com>
Date: Mon, 16 Sep 2013 11:23:13 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        sedat.dilek@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] ipc,shm: fix race with selinux
References: <1379300677-24188-1-git-send-email-davidlohr@hp.com> <1379300677-24188-2-git-send-email-davidlohr@hp.com>
In-Reply-To: <1379300677-24188-2-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2013 05:04 AM, Davidlohr Bueso wrote:
> Currently, we check shm security only under RCU. Since selinux
> can free the security structure, through selinux_sem_free_security(),
> we can run into a use-after-free condition. This bug affects both
> shmctl and shmat syscalls.
>
> The fix is obvious, make sure we hold the kern_ipc_perm.lock while
> performing these security checks.
Actually: either kern_ipc_perm or down_xx(&shm_ids(ns).rwsem) is sufficient.

>
> Reported-by: Manfred Spraul <manfred@colorfullife.com>
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> ---
>   ipc/shm.c | 23 ++++++++++++++---------
>   1 file changed, 14 insertions(+), 9 deletions(-)
>
> diff --git a/ipc/shm.c b/ipc/shm.c
> index 2821cdf..bc3e897 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -781,18 +781,17 @@ static int shmctl_down(struct ipc_namespace *ns, int shmid, int cmd,
>   
>   	shp = container_of(ipcp, struct shmid_kernel, shm_perm);
>   
> +	ipc_lock_object(&shp->shm_perm);
>   	err = security_shm_shmctl(shp, cmd);
>   	if (err)
> -		goto out_unlock1;
> +		goto out_unlock0;
This change is not necessary: down_write(shm_ids(ns).rwsem) already 
synchronizes against another IPC_RMID.
But it doesn't hurt.

> @@ -960,11 +962,12 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
>   		}
>   
>   		audit_ipc_obj(&(shp->shm_perm));
> +
> +		ipc_lock_object(&shp->shm_perm);
>   		err = security_shm_shmctl(shp, cmd);
What about audit_ipc_obj()?
calls __audit_ipc_obj
calls security_ipc_getsecid
calls security_ops->ipc_getsecid, which can be selinux_ipc_getsecid
selinux_ipc_getsecid dereferences ipcp->security

Please: Restart from 3.0.9 (i.e. before the scalability improvement 
project was started)
Every function that is moved from "synchronization with ipc_lock()" to 
"only rcu_read_lock() held" must be checked.

--
     Manfred
