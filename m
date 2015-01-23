Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbbAWCiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 21:38:51 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:42789 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbbAWCit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 21:38:49 -0500
Message-ID: <54C1B423.6080103@oracle.com>
Date: Fri, 23 Jan 2015 10:38:27 +0800
From: ethan zhao <ethan.zhao@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Davidlohr Bueso <dave@stgolabs.net>
CC: Stephen Smalley <stephen.smalley@gmail.com>,
        Ethan Zhao <ethan.kernel@gmail.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Eric Paris <eparis@parisplace.org>, Paul Moore <paul@paul-moore.com>,
        selinux <selinux@tycho.nsa.gov>, linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, ethan.kernel@gmail.conm
Subject: Re: [PATCH] Selinux/hooks.c: Fix a NULL pointer dereference caused
 by semop()
References: <1421745518-18790-1-git-send-email-ethan.zhao@oracle.com>  <54BE61F0.202@tycho.nsa.gov>  <CABawtvPrhVWV3bC-=wygqfHJzctvrmd1WxDD1ciuLE7F7-_yaQ@mail.gmail.com>  <54BF3971.2090003@colorfullife.com>  <CABawtvO3PdKhmeH_H1v_tQxmgOBQrnLGNayTE1=EbcxJbtwAzQ@mail.gmail.com>  <CAB9W1A3kabX9qMm56k=FJ1jcL8ou4APqt8teT38oFCiu=g1wNg@mail.gmail.com> <1421959704.4903.29.camel@stgolabs.net>
In-Reply-To: <1421959704.4903.29.camel@stgolabs.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davidlohr,

On 2015/1/23 4:48, Davidlohr Bueso wrote:
> On Thu, 2015-01-22 at 14:05 -0500, Stephen Smalley wrote:
>> On Wed, Jan 21, 2015 at 9:44 PM, Ethan Zhao <ethan.kernel@gmail.com> wrote:
>>> On Wed, Jan 21, 2015 at 1:30 PM, Manfred Spraul
>>> <manfred@colorfullife.com> wrote:
>>>> On 01/21/2015 04:53 AM, Ethan Zhao wrote:
>>>>> On Tue, Jan 20, 2015 at 10:10 PM, Stephen Smalley <sds@tycho.nsa.gov>
>>>>> wrote:
>>>>>> On 01/20/2015 04:18 AM, Ethan Zhao wrote:
>>>>>>>        sys_semget()
>>>>>>>        ->newary()
>>>>>>>            ->security_sem_alloc()
>>>>>>>              ->sem_alloc_security()
>>>>>>>                    selinux_sem_alloc_security()
>>>>>>>                    ->ipc_alloc_security() {
>>>>>>>                      ->rc = avc_has_perm()
>>>>>>>                                 if (rc) {
>>>>>>>
>>>>>>> ipc_free_security(&sma->sem_perm);
>>>>>>>                                         return rc;
>>>>>> We free the security structure here to avoid a memory leak on a
>>>>>> failed/denied semaphore set creation.  In this situation, we return an
>>>>>> error to the caller (ultimately to newary), it does an
>>>>>> ipc_rcu_putref(sma, ipc_rcu_free), and it returns an error to the
>>>>>> caller.  Thus, it never calls ipc_addid() and the semaphore set is not
>>>>>> created.  So how then can you call semtimedop() on it?
>>>>> Seems it wouldn't happen after commit
>>>>> e8577d1f0329d4842e8302e289fb2c22156abef4 ?
>>>> That was my first guess when I read the bug report - but it can't be the
>>>> fix, because security_sem_alloc() is before the ipc_addid(), with or without
>>>> the patch.
>>>>
>>>> thread A:
>>>>              thread B:
>>>>
>>>> semtimedop()
>>>> -> sem_obtain_object_check()
>>>>              semctl(IPC_RMID)
>>>>              -> freeary()
>>>>              -> ipc_rcu_putref()
>>>>              -> call_rcu()
>>>> -> somehow a grace period
>>>>              -> sem_rcu_free()
>>>>              -> security_sem_free()
>>>>
>>>> Perhaps: modify ipc_free_security() to hexdump perm and a few more bytes if
>>>> the pointer is NULL?
>>> I tried to ask for vmcore and do more analysis, basically, the race condition
>>> still exists and open a hole to be DoS.
>> You said the patch was tested with 3.19-rc5.  But did you reproduce
>> the bug on that kernel version before the patch?  If not, what kernel
>> version were you running when you triggered the bug?
> Also, is this a vanilla kernel? Or from a distro?
  The hard thing, it is hit on customer's environment, the issue kernel 
doesn't
  have many commits far from the last about IPC/SElinux.

> Essentially, did the kernel with the reproducible bug have:
  Not easy to do reproduce it is triggered by a process "opcmon" not 
public to everyone.
  What I have is the panic log. the vmware not get yet.

  Thanks,
  Ethan
> commit 53dad6d3a8e5ac1af8bacc6ac2134ae1a8b085f1
> Author: Davidlohr Bueso <davidlohr@hp.com>
> Date:   Mon Sep 23 17:04:45 2013 -0700
>
>      ipc: fix race with LSMs

  No, the kernel doesn't have this commit, will try it.
>      
>      Currently, IPC mechanisms do security and auditing related checks under
>      RCU.  However, since security modules can free the security structure,
>      for example, through selinux_[sem,msg_queue,shm]_free_security(), we can
>      race if the structure is freed before other tasks are done with it,
>      creating a use-after-free condition.  Manfred illustrates this nicely,
>      for instance with shared mem and selinux:
>      
>       -> do_shmat calls rcu_read_lock()
>       -> do_shmat calls shm_object_check().
>           Checks that the object is still valid - but doesn't acquire any locks.
>           Then it returns.
>       -> do_shmat calls security_shm_shmat (e.g. selinux_shm_shmat)
>       -> selinux_shm_shmat calls ipc_has_perm()
>       -> ipc_has_perm accesses ipc_perms->security
>      
>      shm_close()
>       -> shm_close acquires rw_mutex & shm_lock
>       -> shm_close calls shm_destroy
>       -> shm_destroy calls security_shm_free (e.g. selinux_shm_free_security)
>       -> selinux_shm_free_security calls ipc_free_security(&shp->shm_perm)
>       -> ipc_free_security calls kfree(ipc_perms->security)
>      
>      This patch delays the freeing of the security structures after all RCU
>      readers are done.  Furthermore it aligns the security life cycle with
>      that of the rest of IPC - freeing them based on the reference counter.
>      For situations where we need not free security, the current behavior is
>      kept.  Linus states:
>      
>       "... the old behavior was suspect for another reason too: having the
>        security blob go away from under a user sounds like it could cause
>        various other problems anyway, so I think the old code was at least
>        _prone_ to bugs even if it didn't have catastrophic behavior."
>      
>      I have tested this patch with IPC testcases from LTP on both my
>      quad-core laptop and on a 64 core NUMA server.  In both cases selinux is
>      enabled, and tests pass for both voluntary and forced preemption models.
>      While the mentioned races are theoretical (at least no one as reported
>      them), I wanted to make sure that this new logic doesn't break anything
>      we weren't aware of.
>
>
> Additionally, Manfred's concerns about the grace period are quite valid,
> and it obviously assumes that the ->security nil dereference issue still
> exists to some extent. Changes in RCU are something to consider as well.
> This is all pretty iffy though, lets make sure we are looking at the
> right kernel first.
  Thanks,
  Ethan
>
> Thanks,
> Davidlohr
>

