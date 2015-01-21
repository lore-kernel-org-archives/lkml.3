Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbbAUDxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 22:53:12 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:36587 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbbAUDxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 22:53:10 -0500
MIME-Version: 1.0
In-Reply-To: <54BE61F0.202@tycho.nsa.gov>
References: <1421745518-18790-1-git-send-email-ethan.zhao@oracle.com>
	<54BE61F0.202@tycho.nsa.gov>
Date: Wed, 21 Jan 2015 11:53:09 +0800
Message-ID: <CABawtvPrhVWV3bC-=wygqfHJzctvrmd1WxDD1ciuLE7F7-_yaQ@mail.gmail.com>
Subject: Re: [PATCH] Selinux/hooks.c: Fix a NULL pointer dereference caused by semop()
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Ethan Zhao <ethan.zhao@oracle.com>, james.l.morris@oracle.com,
        serge@hallyn.com, eparis@parisplace.org, paul@paul-moore.com,
        selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, ethan.kernel@gmail.conm,
        manfred@colorfullife.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 10:10 PM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> On 01/20/2015 04:18 AM, Ethan Zhao wrote:
>> A NULL pointer dereference was observed as following panic:
>>
>> BUG: unable to handle kernel NULL pointer dereference at (null)
>> IP: [<ffffffff812735eb>] ipc_has_perm+0x4b/0x60
>> ...
>> Process opcmon (pid: 30712, threadinfo ffff880237f2a000,
>> task ffff88022ac70e40)
>> Stack:
>> ffff880237f2bc04 ffffffff01020953 ffff880237f2bce8
>> ffffffff8125818e
>> 0000000000000001 0000000037f78004 ffff880237f2bcd8
>> ffffffff81273619
>> ffff880237f2bce8 ffffffff8126e3e6 ffff880237f2bf68
>> ffffffff8125c206
>> Call Trace:
>> [<ffffffff8125818e>] ? ipcperms+0xae/0x110
>> [<ffffffff81273619>] selinux_sem_semop+0x19/0x20
>> [<ffffffff8126e3e6>] security_sem_semop+0x16/0x20
>> [<ffffffff8125c206>] sys_semtimedop+0x346/0x750
>> [<ffffffff81188c0c>] ? handle_pte_fault+0x1dc/0x200
>> [<ffffffff8161d830>] ? __do_page_fault+0x280/0x500
>> [<ffffffff810d97d0>] ? __lock_release+0x90/0x1b0
>> [<ffffffff8161d830>] ? __do_page_fault+0x280/0x500
>> [<ffffffff8109a763>] ? up_read+0x23/0x40
>> [<ffffffff8161d830>] ? __do_page_fault+0x280/0x500
>> [<ffffffff81182f1c>] ? might_fault+0x5c/0xb0
>> [<ffffffff81081f96>] ? sys_newuname+0x66/0xf0
>> [<ffffffff810d97d0>] ? __lock_release+0x90/0x1b0
>> [<ffffffff81081f96>] ? sys_newuname+0x66/0xf0
>> [<ffffffff81622f45>] ? sysret_check+0x22/0x5d
>> [<ffffffff8125c620>] sys_semop+0x10/0x20
>> [<ffffffff81622f19>] system_call_fastpath+0x16/0x1b
>> Code: b8 00 00 48 8b 80 48 06 00 00 41 8b 54 24 40 4c 8d
>> 45 d0 89 d9 45 31 c9 48 8b 40 70 8b 78 04 49 8b 44 24 60 c6 45 d0 04 89 55 d8
>> <0f> b7 10 8b 70 04 e8 0a dc ff ff 48 83 c4 20 5b 41 5c c9 c3 90
>> RIP  [<ffffffff812735eb>] ipc_has_perm+0x4b/0x60
>> RSP <ffff880237f2bc98>
>> CR2: 0000000000000000
>>
>> The root cause is semtimedop() was called after semget() without checking its
>> return value in process opcmon. and semget() failed to check permission in
>> function avc_has_perm() then sem_perm->security was freed shown as following:
>>
>>      sys_semget()
>>      ->newary()
>>          ->security_sem_alloc()
>>            ->sem_alloc_security()
>>                  selinux_sem_alloc_security()
>>                  ->ipc_alloc_security() {
>>                    ->rc = avc_has_perm()
>>                               if (rc) {
>>                                       ipc_free_security(&sma->sem_perm);
>>                                       return rc;
>
> We free the security structure here to avoid a memory leak on a
> failed/denied semaphore set creation.  In this situation, we return an
> error to the caller (ultimately to newary), it does an
> ipc_rcu_putref(sma, ipc_rcu_free), and it returns an error to the
> caller.  Thus, it never calls ipc_addid() and the semaphore set is not
> created.  So how then can you call semtimedop() on it?

Seems it wouldn't happen after commit e8577d1f0329d4842e8302e289fb2c22156abef4 ?

Thanks,
Ethan
>
>>      So ipc_perms->security was NULL, then semtimedop() was called as
>>      following:
>>
>>         sys_semtimedop() / semop()
>>         ->selinux_sem_semop()
>>          ->ipc_has_perm()
>>            ->avc_has_perm(sid, isec->sid, isec->sclass, perms, &ad);
>>                                           ^- NULL pointer dereference happens
>>
>> The test kernel was running on VMware.
>> This patch use to fix this serious security issue could be triggered by user space.
>> This patch was tested with v3.19-rc5.
>>
>> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
>> ---
>>  security/selinux/hooks.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>> index 6da7532..bbe76f5 100644
>> --- a/security/selinux/hooks.c
>> +++ b/security/selinux/hooks.c
>> @@ -5129,6 +5129,8 @@ static int ipc_has_perm(struct kern_ipc_perm *ipc_perms,
>>       u32 sid = current_sid();
>>
>>       isec = ipc_perms->security;
>> +     if (!isec)
>> +             return -EACCES;
>>
>>       ad.type = LSM_AUDIT_DATA_IPC;
>>       ad.u.ipc_id = ipc_perms->key;
>>
>
> That is not the correct fix; it just hides a bug.  If we reach
> ipc_has_perm() with a NULL isec, it is a bug in the ipc code.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
