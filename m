Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbbAUFab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 00:30:31 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:49752 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbbAUFa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 00:30:29 -0500
Message-ID: <54BF3971.2090003@colorfullife.com>
Date: Wed, 21 Jan 2015 06:30:25 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Ethan Zhao <ethan.kernel@gmail.com>, Stephen Smalley <sds@tycho.nsa.gov>
CC: Ethan Zhao <ethan.zhao@oracle.com>, james.l.morris@oracle.com,
        serge@hallyn.com, eparis@parisplace.org, paul@paul-moore.com,
        selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, ethan.kernel@gmail.conm
Subject: Re: [PATCH] Selinux/hooks.c: Fix a NULL pointer dereference caused
 by semop()
References: <1421745518-18790-1-git-send-email-ethan.zhao@oracle.com> <54BE61F0.202@tycho.nsa.gov> <CABawtvPrhVWV3bC-=wygqfHJzctvrmd1WxDD1ciuLE7F7-_yaQ@mail.gmail.com>
In-Reply-To: <CABawtvPrhVWV3bC-=wygqfHJzctvrmd1WxDD1ciuLE7F7-_yaQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2015 04:53 AM, Ethan Zhao wrote:
> On Tue, Jan 20, 2015 at 10:10 PM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
>> On 01/20/2015 04:18 AM, Ethan Zhao wrote:
>>>       sys_semget()
>>>       ->newary()
>>>           ->security_sem_alloc()
>>>             ->sem_alloc_security()
>>>                   selinux_sem_alloc_security()
>>>                   ->ipc_alloc_security() {
>>>                     ->rc = avc_has_perm()
>>>                                if (rc) {
>>>                                        ipc_free_security(&sma->sem_perm);
>>>                                        return rc;
>> We free the security structure here to avoid a memory leak on a
>> failed/denied semaphore set creation.  In this situation, we return an
>> error to the caller (ultimately to newary), it does an
>> ipc_rcu_putref(sma, ipc_rcu_free), and it returns an error to the
>> caller.  Thus, it never calls ipc_addid() and the semaphore set is not
>> created.  So how then can you call semtimedop() on it?
> Seems it wouldn't happen after commit e8577d1f0329d4842e8302e289fb2c22156abef4 ?
That was my first guess when I read the bug report - but it can't be the 
fix, because security_sem_alloc() is before the ipc_addid(), with or 
without the patch.

thread A:
             thread B:

semtimedop()
-> sem_obtain_object_check()
             semctl(IPC_RMID)
             -> freeary()
             -> ipc_rcu_putref()
             -> call_rcu()
-> somehow a grace period
             -> sem_rcu_free()
             -> security_sem_free()

Perhaps: modify ipc_free_security() to hexdump perm and a few more bytes 
if the pointer is NULL?

--
     Manfred

> Thanks,
> Ethan
>>>       So ipc_perms->security was NULL, then semtimedop() was called as
>>>       following:
>>>
>>>          sys_semtimedop() / semop()
>>>          ->selinux_sem_semop()
>>>           ->ipc_has_perm()
>>>             ->avc_has_perm(sid, isec->sid, isec->sclass, perms, &ad);
>>>                                            ^- NULL pointer dereference happens
>>>
>>> The test kernel was running on VMware.
>>> This patch use to fix this serious security issue could be triggered by user space.
>>> This patch was tested with v3.19-rc5.
>>>
>>> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
>>> ---
>>>   security/selinux/hooks.c | 2 ++
>>>   1 file changed, 2 insertions(+)
>>>
>>> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>>> index 6da7532..bbe76f5 100644
>>> --- a/security/selinux/hooks.c
>>> +++ b/security/selinux/hooks.c
>>> @@ -5129,6 +5129,8 @@ static int ipc_has_perm(struct kern_ipc_perm *ipc_perms,
>>>        u32 sid = current_sid();
>>>
>>>        isec = ipc_perms->security;
>>> +     if (!isec)
>>> +             return -EACCES;
>>>
>>>        ad.type = LSM_AUDIT_DATA_IPC;
>>>        ad.u.ipc_id = ipc_perms->key;
>>>
>> That is not the correct fix; it just hides a bug.  If we reach
>> ipc_has_perm() with a NULL isec, it is a bug in the ipc code.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

