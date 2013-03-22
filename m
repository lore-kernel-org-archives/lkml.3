Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab3CVBM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 21:12:57 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:21660 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab3CVBMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 21:12:55 -0400
Message-ID: <1363914773.31240.58.camel@buesod1.americas.hpqcorp.net>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Rik van Riel <riel@surriel.com>
Cc: akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        walken@google.com, lwoodman@redhat.com, chegu_vinod@hp.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Thu, 21 Mar 2013 18:12:53 -0700
In-Reply-To: <1363809337-29718-1-git-send-email-riel@surriel.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 15:55 -0400, Rik van Riel wrote:
> Include lkml in the CC: this time... *sigh*
> ---8<---
> 
> This series makes the sysv semaphore code more scalable,
> by reducing the time the semaphore lock is held, and making
> the locking more scalable for semaphore arrays with multiple
> semaphores.
> 
> The first four patches were written by Davidlohr Buesso, and
> reduce the hold time of the semaphore lock.
> 
> The last three patches change the sysv semaphore code locking
> to be more fine grained, providing a performance boost when
> multiple semaphores in a semaphore array are being manipulated
> simultaneously.
> 
> On a 24 CPU system, performance numbers with the semop-multi
> test with N threads and N semaphores, look like this:
> 
> 	vanilla		Davidlohr's	Davidlohr's +	Davidlohr's +
> threads			patches		rwlock patches	v3 patches
> 10	610652		726325		1783589		2142206
> 20	341570		365699		1520453		1977878
> 30	288102		307037		1498167		2037995
> 40	290714		305955		1612665		2256484
> 50	288620		312890		1733453		2650292
> 60	289987		306043		1649360		2388008
> 70	291298		306347		1723167		2717486
> 80	290948		305662		1729545		2763582
> 90	290996		306680		1736021		2757524
> 100	292243		306700		1773700		3059159
> 

After testing these patches with my Oracle Swingbench DSS workload, I
can say that there are significant improvements. The ipc lock contention
was reduced drastically, specially with higher amounts of benchmark
users. As a result, the overall %sys time went down as well.
Furthermore, throughput (in transactions per second) was increased.

TPS:
100 users: 1257.21 (vanilla)    2805.06 (v3 patchset)
400 users: 1437.57 (vanilla)    2664.67 (v3 patchset)
800 users: 1236.89 (vanilla)    2750.73 (v3 patchset)

ipc lock contention:
100 users:  8,74%  (vanilla)    3.17% (v3 patchset)
400 users:  21,86% (vanilla)    5.23% (v3 patchset)
800 users   84,35% (vanilla)    7.39% (v3 patchset)             

As seen with perf, the ipc lock isn't even the main source of contention
anymore. Also, no matter how many benchmark users,  the lock's user is
mostly semctl_main() .

100 users:
    3.17%           oracle  [kernel.kallsyms]   [k] _raw_spin_lock                            
                     |
                     --- _raw_spin_lock
                        |          
                        |--50.53%-- sem_lock
                        |          |          
                        |          |--82.60%-- semctl_main
                        |           --17.40%-- sys_semtimedop

400 users:
    5.23%           oracle  [kernel.kallsyms]   [k] _raw_spin_lock                            
                     |
                     --- _raw_spin_lock
                        |          
                        |--75.81%-- sem_lock
                        |          |          
                        |          |--94.09%-- semctl_main
                        |           --5.91%-- sys_semtimedop


800 users:
     7.39%           oracle  [kernel.kallsyms]   [k] _raw_spin_lock                            
                     |
                     --- _raw_spin_lock
                        |          
                        |--81.71%-- sem_lock
                        |          |          
                        |          |--64.98%-- semctl_main
                        |           --35.02%-- sys_semtimedop


Thanks,
Davidlohr


