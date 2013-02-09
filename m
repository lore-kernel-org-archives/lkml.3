Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab3BIHmR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 02:42:17 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:41669 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab3BIHmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 02:42:16 -0500
MIME-Version: 1.0
In-Reply-To: <CAJd=RBBd+pGG6=Qjpt-Zkxt5VdP5T3YV5_RVao+kHpz9dCzqXA@mail.gmail.com>
References: <1360377937-16297-1-git-send-email-walken@google.com>
	<1360377937-16297-4-git-send-email-walken@google.com>
	<CAJd=RBBd+pGG6=Qjpt-Zkxt5VdP5T3YV5_RVao+kHpz9dCzqXA@mail.gmail.com>
Date: Fri, 8 Feb 2013 23:42:15 -0800
Message-ID: <CANN689F-Gbh56bDFDMSogxsYtUTTqObxyFTzvrz_somvWh-CUw@mail.gmail.com>
Subject: Re: [PATCH 3/4] rwsem: implement write lock stealing
From: Michel Lespinasse <walken@google.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
        mingo@kernel.org, arjan@linux.intel.com, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, alex.shi@intel.com,
        yuanhan.liu@linux.intel.com, dhowells@redhat.com,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 8, 2013 at 11:30 PM, Hillf Danton <dhillf@gmail.com> wrote:
> On Sat, Feb 9, 2013 at 10:45 AM, Michel Lespinasse <walken@google.com> wrote:
>> +               if (waiter->type != RWSEM_WAITING_FOR_WRITE) {
>> +                       list_del(&waiter->list);
>> +
>> +                       /* Set RWSEM_WAITING_BIAS before waking the last reader
>> +                        * so we know there will be a remaining active locker.
>> +                        */
>> +                       if (!(--readers) && !list_empty(&sem->wait_list))
>> +                               rwsem_atomic_add(RWSEM_WAITING_BIAS, sem);
>> +
>> +                       tsk = waiter->task;
>> +                       smp_mb();
>
> For what with mb?

This is the same mb that used to be before the readers_only label
before this change.
The intention is that the write to waiter->task must be the last
access to waiter - after that, the reader is granted the lock so it
could do anything, including deallocating the waiter structure as it
gets out of rwsem_down_read_failed() and possibly deallocating the
task structure if it exits

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
