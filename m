Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab3C3NhP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 09:37:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:27007 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258Ab3C3NhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 09:37:13 -0400
Message-ID: <5156EA36.8050109@oracle.com>
Date: Sat, 30 Mar 2013 09:35:50 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130310 Thunderbird/17.0.4
MIME-Version: 1.0
To: Rik van Riel <riel@surriel.com>
CC: torvalds@linux-foundation.org, davidlohr.bueso@hp.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hhuang@redhat.com, jason.low2@hp.com, walken@google.com,
        lwoodman@redhat.com, chegu_vinod@hp.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH -mm -next] ipc,sem: untangle RCU locking with find_alloc_undo
References: <1363809337-29718-1-git-send-email-riel@surriel.com> <5151DBD3.6080201@oracle.com> <20130328113222.194bbfe8@cuia.bos.redhat.com>
In-Reply-To: <20130328113222.194bbfe8@cuia.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2013 11:32 AM, Rik van Riel wrote:
> On Tue, 26 Mar 2013 13:33:07 -0400
> Sasha Levin <sasha.levin@oracle.com> wrote:
> 
>> > [   96.347341] ================================================
>> > [   96.348085] [ BUG: lock held when returning to user space! ]
>> > [   96.348834] 3.9.0-rc4-next-20130326-sasha-00011-gbcb2313 #318 Tainted: G        W
>> > [   96.360300] ------------------------------------------------
>> > [   96.361084] trinity-child9/7583 is leaving the kernel with locks still held!
>> > [   96.362019] 1 lock held by trinity-child9/7583:
>> > [   96.362610]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff8192eafb>] SYSC_semtimedop+0x1fb/0xec0
>> > 
>> > It seems that we can leave semtimedop without releasing the rcu read lock.
> Sasha, this patch untangles the RCU locking with find_alloc_undo,
> and should fix the above issue. As a side benefit, this makes the
> code a little cleaner.
> 
> Next up: implement locking in a way that does not trigger any 
> lockdep warnings...

The following is mostly unrelated to this patch but close enough:

semctl_main() has a snippet that looks like this:

        err = -EINVAL;
        if(semnum < 0 || semnum >= nsems)
                goto out_unlock;

        sem_lock(sma, NULL, -1);

Which means we'll try unlocking the sma without trying to lock it first.
It makes lockdep unhappy:

[   95.528492] =====================================
[   95.529251] [ BUG: bad unlock balance detected! ]
[   95.529897] 3.9.0-rc4-next-20130328-sasha-00014-g91a3267 #319 Tainted: G        W
[   95.530190] -------------------------------------
[   95.530190] trinity-child14/9123 is trying to release lock (&(&new->lock)->rlock) at:
[   95.530190] [<ffffffff8192f8e4>] semctl_main+0xe54/0xf00
[   95.530190] but there are no more locks to release!
[   95.530190]
[   95.530190] other info that might help us debug this:
[   95.530190] 1 lock held by trinity-child14/9123:
[   95.530190]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff8192ea90>] semctl_main+0x0/0xf00
[   95.530190]
[   95.530190] stack backtrace:
[   95.530190] Pid: 9123, comm: trinity-child14 Tainted: G        W    3.9.0-rc4-next-20130328-sasha-00014-g91a3267 #319
[   95.530190] Call Trace:
[   95.530190]  [<ffffffff8192f8e4>] ? semctl_main+0xe54/0xf00
[   95.530190]  [<ffffffff8117b7e6>] print_unlock_imbalance_bug+0xf6/0x110
[   95.530190]  [<ffffffff8192f8e4>] ? semctl_main+0xe54/0xf00
[   95.530190]  [<ffffffff81180a35>] lock_release_non_nested+0xd5/0x320
[   95.530190]  [<ffffffff8122e3ab>] ? __do_fault+0x42b/0x530
[   95.530190]  [<ffffffff81179da2>] ? get_lock_stats+0x22/0x70
[   95.530190]  [<ffffffff81179e5e>] ? put_lock_stats.isra.14+0xe/0x40
[   95.530190]  [<ffffffff8192f8e4>] ? semctl_main+0xe54/0xf00
[   95.530190]  [<ffffffff81180f1e>] lock_release+0x29e/0x3b0
[   95.530190]  [<ffffffff819451f4>] ? security_ipc_permission+0x14/0x20
[   95.530190]  [<ffffffff83daf33e>] _raw_spin_unlock+0x1e/0x60
[   95.530190]  [<ffffffff8192f8e4>] semctl_main+0xe54/0xf00
[   95.530190]  [<ffffffff8192ea90>] ? SYSC_semtimedop+0xe30/0xe30
[   95.530190]  [<ffffffff8109d188>] ? kvm_clock_read+0x38/0x70
[   95.530190]  [<ffffffff8114feb5>] ? sched_clock_local+0x25/0xa0
[   95.530190]  [<ffffffff811500e8>] ? sched_clock_cpu+0xf8/0x110
[   95.530190]  [<ffffffff83db3814>] ? __do_page_fault+0x514/0x5e0
[   95.530190]  [<ffffffff81179da2>] ? get_lock_stats+0x22/0x70
[   95.530190]  [<ffffffff81179e5e>] ? put_lock_stats.isra.14+0xe/0x40
[   95.530190]  [<ffffffff83db3814>] ? __do_page_fault+0x514/0x5e0
[   95.530190]  [<ffffffff8113dc0e>] ? up_read+0x1e/0x40
[   95.530190]  [<ffffffff83db3814>] ? __do_page_fault+0x514/0x5e0
[   95.530190]  [<ffffffff811c6500>] ? rcu_eqs_exit_common+0x60/0x260
[   95.530190]  [<ffffffff81202b9d>] ? user_enter+0xfd/0x130
[   95.530190]  [<ffffffff81202c85>] ? user_exit+0xb5/0xe0
[   95.530190]  [<ffffffff8192faf9>] SyS_semctl+0x69/0x430
[   95.530190]  [<ffffffff81076ea0>] ? syscall_trace_enter+0x20/0x2e0
[   95.530190]  [<ffffffff83db7d18>] tracesys+0xe1/0xe6

I'm thinking that the solution is as simple as:

diff --git a/ipc/sem.c b/ipc/sem.c
index 6e109ef..ac36671 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1333,8 +1333,10 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
        /* GETVAL, GETPID, GETNCTN, GETZCNT: fall-through */
        }
        err = -EINVAL;
-       if(semnum < 0 || semnum >= nsems)
-               goto out_unlock;
+       if(semnum < 0 || semnum >= nsems) {
+               rcu_read_unlock();
+               goto out_wakeup;
+       }

        sem_lock(sma, NULL, -1);
        curr = &sma->sem_base[semnum];

But I'm not 100% sure if I don't mess up anything else.


Thanks,
Sasha
