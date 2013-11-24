Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab3KXHIZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 02:08:25 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:63528 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab3KXHIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 02:08:21 -0500
Message-ID: <1385276864.5320.14.camel@marge.simpson.net>
Subject: Re: [PATCH] ipc,shm: Correct error return value in shmctl
 (SHM_UNLOCK)
From: Mike Galbraith <bitbucket@online.de>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Date: Sun, 24 Nov 2013 08:07:44 +0100
In-Reply-To: <20131120104411.GA15831@axis.com>
References: <20131120104411.GA15831@axis.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:hOWc1kdGiuL1ar7T/C8N7Jypxn2drjzTTa0fPrEnllP
 KExJDwZ85X+zD7wyrA33hSoNre7K53GB7aXVOdLLDZ7xR+8OQD
 rMGlENVqeIC0ASpOtX5hNKxwH/8BSiGT+0zXdhk2NBZ/11NZgP
 fsg4DvGKFu7JWcAiP5DA0FZuYL3PHl3ieRBW17e4xK34T7Ll/p
 hD1GD4s9Qbisv5JCd6Zp8lOSKpk47XXSoJbYQ/l7VQBc2urP7l
 fQC9aV96Tn78XMYz311rDlyq4MYXTKWTU9MjHK/iFKL8vcZFm/
 IVsJSE5sY5y6ZHcIm7SyhUWNlTFcQF/3AElSpwwLithhpIWuVM
 YD0OrEJ0495URaDweUNd75xQQFc1HHi5KhnV/aROzj4rPXlm4V
 FMVMsyLzTC2QQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (commit: 3a72660b07) is only slated for stable 3.12, but
should go to 3.10/11 as well, no?

On Wed, 2013-11-20 at 11:44 +0100, Jesper Nilsson wrote: 
> Commit 2caacaa82a51b78fc0c800e206473874094287ed restructured
> the ipc shm to shorten critical region, but introduced a path
> where the return value could be -EPERM, even if the operation
> actually was performed.
> 
> Before the commit, the err return value was reset by the return value
> from security_shm_shmctl() after the if (!ns_capable(...)) statement.
> 
> Now, we still exit the if statement with err set to -EPERM,
> and in the case of SHM_UNLOCK, it is not reset at all,
> and used as the return value from shmctl.
> 
> To fix this, we only set err when errors occur, leaving the
> fallthrough case alone.
> 
> Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Davidlohr Bueso <davidlohr@hp.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Michel Lespinasse <walken@google.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: stable@vger.kernel.org
> ---
>  ipc/shm.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/ipc/shm.c b/ipc/shm.c
> index d697396..4076f9e 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -974,12 +974,15 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
>  		ipc_lock_object(&shp->shm_perm);
>  		if (!ns_capable(ns->user_ns, CAP_IPC_LOCK)) {
>  			kuid_t euid = current_euid();
> -			err = -EPERM;
>  			if (!uid_eq(euid, shp->shm_perm.uid) &&
> -			    !uid_eq(euid, shp->shm_perm.cuid))
> +			    !uid_eq(euid, shp->shm_perm.cuid)) {
> +				err = -EPERM;
>  				goto out_unlock0;
> -			if (cmd == SHM_LOCK && !rlimit(RLIMIT_MEMLOCK))
> +			}
> +			if (cmd == SHM_LOCK && !rlimit(RLIMIT_MEMLOCK)) {
> +				err = -EPERM;
>  				goto out_unlock0;
> +			}
>  		}
>  
>  		shm_file = shp->shm_file;
> -- 
> 1.8.4
> 
> 
> /^JN - Jesper Nilsson


