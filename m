Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab3BIHaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 02:30:09 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:64734 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab3BIHaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 02:30:08 -0500
MIME-Version: 1.0
In-Reply-To: <1360377937-16297-4-git-send-email-walken@google.com>
References: <1360377937-16297-1-git-send-email-walken@google.com>
	<1360377937-16297-4-git-send-email-walken@google.com>
Date: Sat, 9 Feb 2013 15:30:06 +0800
Message-ID: <CAJd=RBBd+pGG6=Qjpt-Zkxt5VdP5T3YV5_RVao+kHpz9dCzqXA@mail.gmail.com>
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

On Sat, Feb 9, 2013 at 10:45 AM, Michel Lespinasse <walken@google.com> wrote:
> +               if (waiter->type != RWSEM_WAITING_FOR_WRITE) {
> +                       list_del(&waiter->list);
> +
> +                       /* Set RWSEM_WAITING_BIAS before waking the last reader
> +                        * so we know there will be a remaining active locker.
> +                        */
> +                       if (!(--readers) && !list_empty(&sem->wait_list))
> +                               rwsem_atomic_add(RWSEM_WAITING_BIAS, sem);
> +
> +                       tsk = waiter->task;
> +                       smp_mb();

For what with mb?

> +                       waiter->task = NULL;
> +                       wake_up_process(tsk);
> +                       put_task_struct(tsk);
> +               }
> +       } while (readers);
> +       sem->wait_readers = 0;


> +       /* If there are no active locks, wake the front queued process(es). */

s/locks/lockers/

> +       if (!(count & RWSEM_ACTIVE_MASK))
> +               sem = __rwsem_do_wake(sem, RWSEM_WAKE_ANY);
