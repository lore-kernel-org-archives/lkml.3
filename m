Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab3BINL2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 08:11:28 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:56131 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3BINL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 08:11:26 -0500
MIME-Version: 1.0
In-Reply-To: <CANN689F-Gbh56bDFDMSogxsYtUTTqObxyFTzvrz_somvWh-CUw@mail.gmail.com>
References: <1360377937-16297-1-git-send-email-walken@google.com>
	<1360377937-16297-4-git-send-email-walken@google.com>
	<CAJd=RBBd+pGG6=Qjpt-Zkxt5VdP5T3YV5_RVao+kHpz9dCzqXA@mail.gmail.com>
	<CANN689F-Gbh56bDFDMSogxsYtUTTqObxyFTzvrz_somvWh-CUw@mail.gmail.com>
Date: Sat, 9 Feb 2013 21:11:25 +0800
Message-ID: <CAJd=RBB2Hcn7mAdAXF-K7sM=5pxpd8sre6rEJExC79LUO3iEbA@mail.gmail.com>
Subject: Re: [PATCH 3/4] rwsem: implement write lock stealing
From: Hillf Danton <dhillf@gmail.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
        mingo@kernel.org, arjan@linux.intel.com, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, alex.shi@intel.com,
        yuanhan.liu@linux.intel.com, dhowells@redhat.com,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 9, 2013 at 3:42 PM, Michel Lespinasse <walken@google.com> wrote:
> On Fri, Feb 8, 2013 at 11:30 PM, Hillf Danton <dhillf@gmail.com> wrote:
>> On Sat, Feb 9, 2013 at 10:45 AM, Michel Lespinasse <walken@google.com> wrote:
>>> +               if (waiter->type != RWSEM_WAITING_FOR_WRITE) {
>>> +                       list_del(&waiter->list);
>>> +
>>> +                       /* Set RWSEM_WAITING_BIAS before waking the last reader
>>> +                        * so we know there will be a remaining active locker.
>>> +                        */
>>> +                       if (!(--readers) && !list_empty(&sem->wait_list))
>>> +                               rwsem_atomic_add(RWSEM_WAITING_BIAS, sem);
>>> +
>>> +                       tsk = waiter->task;
>>> +                       smp_mb();
>>
>> For what with mb?
>
> This is the same mb that used to be before the readers_only label
> before this change.
> The intention is that the write to waiter->task must be the last
> access to waiter - after that, the reader is granted the lock so it
> could do anything, including deallocating the waiter structure as it
> gets out of rwsem_down_read_failed() and possibly deallocating the
> task structure if it exits
>
Perhaps the waiting process needs to see if no more wait needed,
	/* wait to be given the lock */
	for (;;) {
		if (!waiter.task)
			break;
		schedule();
		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
	}
and another mb do exist at the beginning of try_to_wake_up().

And I want to change
+       /* Block until there are no active lockers. */
+       do {
+               schedule();
+               set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+       } while (sem->count & RWSEM_ACTIVE_MASK);

to
	/* Block until there are no active lockers. */
	while (sem->count & RWSEM_ACTIVE_MASK) {
		schedule();
		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
	}
for sure that we have to wait.
