Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab3CZRf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:35:59 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38557 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab3CZRf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:35:56 -0400
Message-ID: <5151DBD3.6080201@oracle.com>
Date: Tue, 26 Mar 2013 13:33:07 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130310 Thunderbird/17.0.4
MIME-Version: 1.0
To: Rik van Riel <riel@surriel.com>
CC: torvalds@linux-foundation.org, davidlohr.bueso@hp.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hhuang@redhat.com, jason.low2@hp.com, walken@google.com,
        lwoodman@redhat.com, chegu_vinod@hp.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: ipc,sem: sysv semaphore scalability
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
In-Reply-To: <1363809337-29718-1-git-send-email-riel@surriel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 03:55 PM, Rik van Riel wrote:
> This series makes the sysv semaphore code more scalable,
> by reducing the time the semaphore lock is held, and making
> the locking more scalable for semaphore arrays with multiple
> semaphores.

Hi Rik,

Another issue that came up is:

[   96.347341] ================================================
[   96.348085] [ BUG: lock held when returning to user space! ]
[   96.348834] 3.9.0-rc4-next-20130326-sasha-00011-gbcb2313 #318 Tainted: G        W
[   96.360300] ------------------------------------------------
[   96.361084] trinity-child9/7583 is leaving the kernel with locks still held!
[   96.362019] 1 lock held by trinity-child9/7583:
[   96.362610]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff8192eafb>] SYSC_semtimedop+0x1fb/0xec0

It seems that we can leave semtimedop without releasing the rcu read lock.

I'm a bit confused by what's going on in semtimedop with regards to rcu read lock, it
seems that this behaviour is actually intentional?

        rcu_read_lock();
        sma = sem_obtain_object_check(ns, semid);
        if (IS_ERR(sma)) {
                if (un)
                        rcu_read_unlock();
                error = PTR_ERR(sma);
                goto out_free;
        }

When I've looked at that it seems that not releasing the read lock was (very)
intentional.

After that, the only code path that would release the lock starts with:

        if (un) {
		...

So we won't release the lock at all if un is NULL?


Thanks,
Sasha
