Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906Ab3CYUWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 16:22:30 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42398 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab3CYUW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 16:22:28 -0400
Message-ID: <5150B1C2.8090607@oracle.com>
Date: Mon, 25 Mar 2013 16:21:22 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130310 Thunderbird/17.0.4
MIME-Version: 1.0
To: Rik van Riel <riel@surriel.com>
CC: torvalds@linux-foundation.org, davidlohr.bueso@hp.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hhuang@redhat.com, jason.low2@hp.com, walken@google.com,
        lwoodman@redhat.com, chegu_vinod@hp.com, Dave Jones <davej@redhat.com>
Subject: Re: ipc,sem: sysv semaphore scalability
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
In-Reply-To: <1363809337-29718-1-git-send-email-riel@surriel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 03:55 PM, Rik van Riel wrote:
> Include lkml in the CC: this time... *sigh*
> ---8<---
> 
> This series makes the sysv semaphore code more scalable,
> by reducing the time the semaphore lock is held, and making
> the locking more scalable for semaphore arrays with multiple
> semaphores.

Hi Rik,

I'm getting the following false positives from lockdep:

[   80.492995] =============================================
[   80.494052] [ INFO: possible recursive locking detected ]
[   80.494878] 3.9.0-rc4-next-20130325-sasha-00044-gcb6ef58 #315 Tainted: G        W
[   80.496228] ---------------------------------------------
[   80.497171] trinity-child9/7210 is trying to acquire lock:
[   80.497934]  (&(&sma->sem_base[i].lock)->rlock){+.+...}, at: [<ffffffff8192da37>] newary+0x1c7/0x2a0
[   80.499202]
[   80.499202] but task is already holding lock:
[   80.500031]  (&(&sma->sem_base[i].lock)->rlock){+.+...}, at: [<ffffffff8192da37>] newary+0x1c7/0x2a0
[   80.500031]
[   80.500031] other info that might help us debug this:
[   80.500031]  Possible unsafe locking scenario:
[   80.500031]
[   80.500031]        CPU0
[   80.500031]        ----
[   80.500031]   lock(&(&sma->sem_base[i].lock)->rlock);
[   80.500031]   lock(&(&sma->sem_base[i].lock)->rlock);
[   80.500031]
[   80.500031]  *** DEADLOCK ***
[   80.500031]
[   80.500031]  May be due to missing lock nesting notation
[   80.500031]
[   80.500031] 4 locks held by trinity-child9/7210:
[   80.500031]  #0:  (&ids->rw_mutex){+++++.}, at: [<ffffffff8192a422>] ipcget+0x72/0x340
[   80.500031]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff81929b65>] ipc_addid+0x35/0x230
[   80.500031]  #2:  (&(&new->lock)->rlock){+.+...}, at: [<ffffffff81929c00>] ipc_addid+0xd0/0x230
[   80.500031]  #3:  (&(&sma->sem_base[i].lock)->rlock){+.+...}, at: [<ffffffff8192da37>] newary+0x1c7/0x2a0
[   80.500031]
[   80.500031] stack backtrace:
[   80.500031] Pid: 7210, comm: trinity-child9 Tainted: G        W    3.9.0-rc4-next-20130325-sasha-00044-gcb6ef58 #315
[   80.500031] Call Trace:
[   80.500031]  [<ffffffff8117f65e>] __lock_acquire+0xc6e/0x1e50
[   80.500031]  [<ffffffff819ff225>] ? idr_get_empty_slot+0x255/0x3c0
[   80.500031]  [<ffffffff8117ca1e>] ? mark_held_locks+0x12e/0x150
[   80.500031]  [<ffffffff811810ba>] lock_acquire+0x1aa/0x240
[   80.500031]  [<ffffffff8192da37>] ? newary+0x1c7/0x2a0
[   80.500031]  [<ffffffff83d8768b>] _raw_spin_lock+0x3b/0x70
[   80.500031]  [<ffffffff8192da37>] ? newary+0x1c7/0x2a0
[   80.500031]  [<ffffffff8192da37>] newary+0x1c7/0x2a0
[   80.500031]  [<ffffffff8192a422>] ? ipcget+0x72/0x340
[   80.500031]  [<ffffffff8192a5d6>] ipcget+0x226/0x340
[   80.500031]  [<ffffffff81930215>] SyS_semget+0x65/0x80
[   80.500031]  [<ffffffff8192d870>] ? semctl_down.constprop.8+0x320/0x320
[   80.500031]  [<ffffffff8192c770>] ? wake_up_sem_queue_do+0xa0/0xa0
[   80.500031]  [<ffffffff8192c690>] ? SyS_msgrcv+0x20/0x20
[   80.500031]  [<ffffffff83d90898>] tracesys+0xe1/0xe6

The code is:

        for (i = 0; i < nsems; i++) {
                INIT_LIST_HEAD(&sma->sem_base[i].sem_pending);
                spin_lock_init(&sma->sem_base[i].lock);
                spin_lock(&sma->sem_base[i].lock);  <---- here
        }


Thanks,
Sasha
