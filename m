Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbbAVTFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:05:47 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38290 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbbAVTFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:05:44 -0500
MIME-Version: 1.0
In-Reply-To: <CABawtvO3PdKhmeH_H1v_tQxmgOBQrnLGNayTE1=EbcxJbtwAzQ@mail.gmail.com>
References: <1421745518-18790-1-git-send-email-ethan.zhao@oracle.com>
	<54BE61F0.202@tycho.nsa.gov>
	<CABawtvPrhVWV3bC-=wygqfHJzctvrmd1WxDD1ciuLE7F7-_yaQ@mail.gmail.com>
	<54BF3971.2090003@colorfullife.com>
	<CABawtvO3PdKhmeH_H1v_tQxmgOBQrnLGNayTE1=EbcxJbtwAzQ@mail.gmail.com>
Date: Thu, 22 Jan 2015 14:05:43 -0500
Message-ID: <CAB9W1A3kabX9qMm56k=FJ1jcL8ou4APqt8teT38oFCiu=g1wNg@mail.gmail.com>
Subject: Re: [PATCH] Selinux/hooks.c: Fix a NULL pointer dereference caused by semop()
From: Stephen Smalley <stephen.smalley@gmail.com>
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Ethan Zhao <ethan.zhao@oracle.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Eric Paris <eparis@parisplace.org>, Paul Moore <paul@paul-moore.com>,
        selinux <selinux@tycho.nsa.gov>, linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, ethan.kernel@gmail.conm
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 9:44 PM, Ethan Zhao <ethan.kernel@gmail.com> wrote:
> On Wed, Jan 21, 2015 at 1:30 PM, Manfred Spraul
> <manfred@colorfullife.com> wrote:
>> On 01/21/2015 04:53 AM, Ethan Zhao wrote:
>>>
>>> On Tue, Jan 20, 2015 at 10:10 PM, Stephen Smalley <sds@tycho.nsa.gov>
>>> wrote:
>>>>
>>>> On 01/20/2015 04:18 AM, Ethan Zhao wrote:
>>>>>
>>>>>       sys_semget()
>>>>>       ->newary()
>>>>>           ->security_sem_alloc()
>>>>>             ->sem_alloc_security()
>>>>>                   selinux_sem_alloc_security()
>>>>>                   ->ipc_alloc_security() {
>>>>>                     ->rc = avc_has_perm()
>>>>>                                if (rc) {
>>>>>
>>>>> ipc_free_security(&sma->sem_perm);
>>>>>                                        return rc;
>>>>
>>>> We free the security structure here to avoid a memory leak on a
>>>> failed/denied semaphore set creation.  In this situation, we return an
>>>> error to the caller (ultimately to newary), it does an
>>>> ipc_rcu_putref(sma, ipc_rcu_free), and it returns an error to the
>>>> caller.  Thus, it never calls ipc_addid() and the semaphore set is not
>>>> created.  So how then can you call semtimedop() on it?
>>>
>>> Seems it wouldn't happen after commit
>>> e8577d1f0329d4842e8302e289fb2c22156abef4 ?
>>
>> That was my first guess when I read the bug report - but it can't be the
>> fix, because security_sem_alloc() is before the ipc_addid(), with or without
>> the patch.
>>
>> thread A:
>>             thread B:
>>
>> semtimedop()
>> -> sem_obtain_object_check()
>>             semctl(IPC_RMID)
>>             -> freeary()
>>             -> ipc_rcu_putref()
>>             -> call_rcu()
>> -> somehow a grace period
>>             -> sem_rcu_free()
>>             -> security_sem_free()
>>
>> Perhaps: modify ipc_free_security() to hexdump perm and a few more bytes if
>> the pointer is NULL?
>
> I tried to ask for vmcore and do more analysis, basically, the race condition
> still exists and open a hole to be DoS.

You said the patch was tested with 3.19-rc5.  But did you reproduce
the bug on that kernel version before the patch?  If not, what kernel
version were you running when you triggered the bug?
