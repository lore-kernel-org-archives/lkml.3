Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbbATOMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:12:08 -0500
Received: from emvm-gh1-uea08.nsa.gov ([63.239.67.9]:56242 "EHLO
	emvm-gh1-uea08.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbbATOME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:12:04 -0500
X-TM-IMSS-Message-ID: <0e27e1630000e7c3@nsa.gov>
Message-ID: <54BE61F0.202@tycho.nsa.gov>
Date: Tue, 20 Jan 2015 09:10:56 -0500
From: Stephen Smalley <sds@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Ethan Zhao <ethan.zhao@oracle.com>, james.l.morris@oracle.com,
        serge@hallyn.com, eparis@parisplace.org, paul@paul-moore.com
CC: selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, ethan.kernel@gmail.conm,
        manfred@colorfullife.com
Subject: Re: [PATCH] Selinux/hooks.c: Fix a NULL pointer dereference caused
 by semop()
References: <1421745518-18790-1-git-send-email-ethan.zhao@oracle.com>
In-Reply-To: <1421745518-18790-1-git-send-email-ethan.zhao@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 04:18 AM, Ethan Zhao wrote:
> A NULL pointer dereference was observed as following panic:
> 
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<ffffffff812735eb>] ipc_has_perm+0x4b/0x60
> ...
> Process opcmon (pid: 30712, threadinfo ffff880237f2a000,
> task ffff88022ac70e40)
> Stack:
> ffff880237f2bc04 ffffffff01020953 ffff880237f2bce8
> ffffffff8125818e
> 0000000000000001 0000000037f78004 ffff880237f2bcd8
> ffffffff81273619
> ffff880237f2bce8 ffffffff8126e3e6 ffff880237f2bf68
> ffffffff8125c206
> Call Trace:
> [<ffffffff8125818e>] ? ipcperms+0xae/0x110
> [<ffffffff81273619>] selinux_sem_semop+0x19/0x20
> [<ffffffff8126e3e6>] security_sem_semop+0x16/0x20
> [<ffffffff8125c206>] sys_semtimedop+0x346/0x750
> [<ffffffff81188c0c>] ? handle_pte_fault+0x1dc/0x200
> [<ffffffff8161d830>] ? __do_page_fault+0x280/0x500
> [<ffffffff810d97d0>] ? __lock_release+0x90/0x1b0
> [<ffffffff8161d830>] ? __do_page_fault+0x280/0x500
> [<ffffffff8109a763>] ? up_read+0x23/0x40
> [<ffffffff8161d830>] ? __do_page_fault+0x280/0x500
> [<ffffffff81182f1c>] ? might_fault+0x5c/0xb0
> [<ffffffff81081f96>] ? sys_newuname+0x66/0xf0
> [<ffffffff810d97d0>] ? __lock_release+0x90/0x1b0
> [<ffffffff81081f96>] ? sys_newuname+0x66/0xf0
> [<ffffffff81622f45>] ? sysret_check+0x22/0x5d
> [<ffffffff8125c620>] sys_semop+0x10/0x20
> [<ffffffff81622f19>] system_call_fastpath+0x16/0x1b
> Code: b8 00 00 48 8b 80 48 06 00 00 41 8b 54 24 40 4c 8d
> 45 d0 89 d9 45 31 c9 48 8b 40 70 8b 78 04 49 8b 44 24 60 c6 45 d0 04 89 55 d8
> <0f> b7 10 8b 70 04 e8 0a dc ff ff 48 83 c4 20 5b 41 5c c9 c3 90
> RIP  [<ffffffff812735eb>] ipc_has_perm+0x4b/0x60
> RSP <ffff880237f2bc98>
> CR2: 0000000000000000
> 
> The root cause is semtimedop() was called after semget() without checking its
> return value in process opcmon. and semget() failed to check permission in
> function avc_has_perm() then sem_perm->security was freed shown as following:
> 
>      sys_semget()
>      ->newary()
> 	   ->security_sem_alloc()
> 	     ->sem_alloc_security()
> 		   selinux_sem_alloc_security()
> 		   ->ipc_alloc_security() {
> 		     ->rc = avc_has_perm()
> 				if (rc) {
> 					ipc_free_security(&sma->sem_perm);
> 					return rc;

We free the security structure here to avoid a memory leak on a
failed/denied semaphore set creation.  In this situation, we return an
error to the caller (ultimately to newary), it does an
ipc_rcu_putref(sma, ipc_rcu_free), and it returns an error to the
caller.  Thus, it never calls ipc_addid() and the semaphore set is not
created.  So how then can you call semtimedop() on it?

>      So ipc_perms->security was NULL, then semtimedop() was called as
>      following:
> 
> 	  sys_semtimedop() / semop()
> 	  ->selinux_sem_semop()
> 	   ->ipc_has_perm()
> 	     ->avc_has_perm(sid, isec->sid, isec->sclass, perms, &ad);
>   	                                    ^- NULL pointer dereference happens
> 
> The test kernel was running on VMware.
> This patch use to fix this serious security issue could be triggered by user space.
> This patch was tested with v3.19-rc5.
> 
> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
> ---
>  security/selinux/hooks.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 6da7532..bbe76f5 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -5129,6 +5129,8 @@ static int ipc_has_perm(struct kern_ipc_perm *ipc_perms,
>  	u32 sid = current_sid();
>  
>  	isec = ipc_perms->security;
> +	if (!isec)
> +		return -EACCES;
>  
>  	ad.type = LSM_AUDIT_DATA_IPC;
>  	ad.u.ipc_id = ipc_perms->key;
> 

That is not the correct fix; it just hides a bug.  If we reach
ipc_has_perm() with a NULL isec, it is a bug in the ipc code.

