Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab3CVHaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 03:30:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64615 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab3CVHai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 03:30:38 -0400
Message-ID: <1363937432.4581.15.camel@marge.simpson.net>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Mike Galbraith <bitbucket@online.de>
To: Rik van Riel <riel@surriel.com>
Cc: torvalds@linux-foundation.org, davidlohr.bueso@hp.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hhuang@redhat.com, jason.low2@hp.com, walken@google.com,
        lwoodman@redhat.com, chegu_vinod@hp.com
Date: Fri, 22 Mar 2013 08:30:32 +0100
In-Reply-To: <1363809337-29718-1-git-send-email-riel@surriel.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:uKMmLGLMC7NV1YXqrCgEuHPJQyNmef6y72E6zYZEDgn
 fYRAwna2aMzDbnZ5D8q+1uThE/eCprrI0plPDJ7t8rlwDBtIdV
 JvFwQJu209I6yLQyZHG2LjeYD9nZscEqgsxQPENh36lGL1AXIF
 CNbks6+0uOH1ThVS2wU32vOQ2QIMQecmyFbTLGrDANDqE8TrRH
 wFzNGk6ghhwpR6eH/+gf6HKYEo5+cn7lOM/wqg7XdfusviTAZM
 SkQhBWIxXMzWmXBjN9vSUULRwR6S5OTQkdG60nKXToFF+xWcZD
 Ersy02/CKA4yKUbrBDZYTbQNrqmSsltsws3FMrULxiY0UYuS/A
 biYM9rQaoxZISTv0vLaUcugrnY2psUTZdOY/cXYO4IaSKf5vLR
 IJUMnYq4OluUA==
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

Hi Rik,

I plugged this set into enterprise -rt kernel, and beat on four boxen.
I ran into no trouble while giving boxen a generic drubbing fwtw.

Some semop-multi -rt numbers for an abby-normal 8 node box, and a
mundane 4 node box below.


32 cores+SMT, 3.0.68-rt92

numactl --hardware
available: 4 nodes (0-3)
node 0 cpus: 0 1 2 3 4 5 6 7 32 33 34 35 36 37 38 39
node 0 size: 32733 MB
node 0 free: 29910 MB
node 1 cpus: 8 9 10 11 12 13 14 15 40 41 42 43 44 45 46 47
node 1 size: 32768 MB
node 1 free: 30396 MB
node 2 cpus: 16 17 18 19 20 21 22 23 48 49 50 51 52 53 54 55
node 2 size: 32768 MB
node 2 free: 30568 MB
node 3 cpus: 24 25 26 27 28 29 30 31 56 57 58 59 60 61 62 63
node 3 size: 32767 MB
node 3 free: 28706 MB
node distances:
node   0   1   2   3 
  0:  10  21  21  21 
  1:  21  10  21  21 
  2:  21  21  10  21 
  3:  21  21  21  10 

SCHED_OTHER
       -v3 set        +v3 set
threads
10      438485        1744599
20      376411        1580813
30      396639        1546841
40      449062        2152861
50      477594        2431344
60      446453        1874476
70      578705        2047884
80      607928        2144898
90      662136        2171074
100     622889        2295879
200     709668        2867273
300     661902        3008695
400     641758        3273250
500     614117        3403775

SCHED_FIFO
       -v3 set        +v3 set
threads
10     158656          914343
20      99784         1133775
30      84245         1099604
40      89725         1756577
50      85697         1607893
60      84033         1467272
70      86833         1979405
80      91451         1922250
90      92484         1990699
100     90691         2067705
200    103692         2308652
300    101161         2376921
400    103722         2417580
500    108838         2443349


64 core box (poor thing, smi free zone though), 3.0.68-rt92

numactl --hardware
available: 1 nodes (0)
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63
node 0 size: 8181 MB
node 0 free: 6309 MB
node distances:
node   0
  0:  10

SCHED_OTHER
       -v3 set        +v3 set
threads
10      677534        2304417
20      451507        1873474
30      356876        1542688
40      329585        1500392
50      415761        1318676
60      403482        1380644
70      394089        1185165
80      407408        1191834
90      445764        1249156
100     430823        1245573
200     425470        1421686
300     427092        1480379
400     497900        1516599
500     421927        1551309

SCHED_FIFO
10      323560        1882543
20      226257        1806862
30      187851        1263163
40      205337         881331
50      196806         766666
60      193218         612709
70      209432        1241797                            
80      240445        1269146
90      219865        1482649
100     227970        1473038
200     201354        1719977
300     183728        1823074
400     175051        1808792
500     243708        1849803


