Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbbAWCTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 21:19:45 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38128 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbbAWCTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 21:19:41 -0500
Message-ID: <54C1AFA2.8040900@oracle.com>
Date: Fri, 23 Jan 2015 10:19:14 +0800
From: ethan zhao <ethan.zhao@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Smalley <stephen.smalley@gmail.com>
CC: Ethan Zhao <ethan.kernel@gmail.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Eric Paris <eparis@parisplace.org>, Paul Moore <paul@paul-moore.com>,
        selinux <selinux@tycho.nsa.gov>, linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, ethan.kernel@gmail.conm
Subject: Re: [PATCH] Selinux/hooks.c: Fix a NULL pointer dereference caused
 by semop()
References: <1421745518-18790-1-git-send-email-ethan.zhao@oracle.com> <54BE61F0.202@tycho.nsa.gov> <CABawtvPrhVWV3bC-=wygqfHJzctvrmd1WxDD1ciuLE7F7-_yaQ@mail.gmail.com> <54BF3971.2090003@colorfullife.com> <CABawtvO3PdKhmeH_H1v_tQxmgOBQrnLGNayTE1=EbcxJbtwAzQ@mail.gmail.com> <CAB9W1A3kabX9qMm56k=FJ1jcL8ou4APqt8teT38oFCiu=g1wNg@mail.gmail.com>
In-Reply-To: <CAB9W1A3kabX9qMm56k=FJ1jcL8ou4APqt8teT38oFCiu=g1wNg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

On 2015/1/23 3:05, Stephen Smalley wrote:
> On Wed, Jan 21, 2015 at 9:44 PM, Ethan Zhao <ethan.kernel@gmail.com> wrote:
>> On Wed, Jan 21, 2015 at 1:30 PM, Manfred Spraul
>> <manfred@colorfullife.com> wrote:
>>> On 01/21/2015 04:53 AM, Ethan Zhao wrote:
>>>> On Tue, Jan 20, 2015 at 10:10 PM, Stephen Smalley <sds@tycho.nsa.gov>
>>>> wrote:
>>>>> On 01/20/2015 04:18 AM, Ethan Zhao wrote:
>>>>>>        sys_semget()
>>>>>>        ->newary()
>>>>>>            ->security_sem_alloc()
>>>>>>              ->sem_alloc_security()
>>>>>>                    selinux_sem_alloc_security()
>>>>>>                    ->ipc_alloc_security() {
>>>>>>                      ->rc = avc_has_perm()
>>>>>>                                 if (rc) {
>>>>>>
>>>>>> ipc_free_security(&sma->sem_perm);
>>>>>>                                         return rc;
>>>>> We free the security structure here to avoid a memory leak on a
>>>>> failed/denied semaphore set creation.  In this situation, we return an
>>>>> error to the caller (ultimately to newary), it does an
>>>>> ipc_rcu_putref(sma, ipc_rcu_free), and it returns an error to the
>>>>> caller.  Thus, it never calls ipc_addid() and the semaphore set is not
>>>>> created.  So how then can you call semtimedop() on it?
>>>> Seems it wouldn't happen after commit
>>>> e8577d1f0329d4842e8302e289fb2c22156abef4 ?
>>> That was my first guess when I read the bug report - but it can't be the
>>> fix, because security_sem_alloc() is before the ipc_addid(), with or without
>>> the patch.
>>>
>>> thread A:
>>>              thread B:
>>>
>>> semtimedop()
>>> -> sem_obtain_object_check()
>>>              semctl(IPC_RMID)
>>>              -> freeary()
>>>              -> ipc_rcu_putref()
>>>              -> call_rcu()
>>> -> somehow a grace period
>>>              -> sem_rcu_free()
>>>              -> security_sem_free()
>>>
>>> Perhaps: modify ipc_free_security() to hexdump perm and a few more bytes if
>>> the pointer is NULL?
>> I tried to ask for vmcore and do more analysis, basically, the race condition
>> still exists and open a hole to be DoS.
> You said the patch was tested with 3.19-rc5.
  I just threw the 3.19-rc5 with my test patch to the 'user', he said he
  doesn't hit. maybe he didn't hit or occasionally failed to reproduce it.
>   But did you reproduce
> the bug on that kernel version before the patch?
  Good news is not hit yet.

>   If not, what kernel
> version were you running when you triggered the bug?
  To be honest, a kernel from distro, but not released, but before we 
get it clear, we wouldn't public more.

  Thanks,
  Ethan


