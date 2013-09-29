Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab3I2JrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 05:47:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:29553 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab3I2JrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 05:47:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1004,1371106800"; 
   d="scan'208";a="411223333"
Date: Sun, 29 Sep 2013 17:47:14 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: vdavydov@parallels.com
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        pjt@google.com, peterz@infradead.org, tglx@linutronix.de, lkp@01.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Huang Ying <ying.huang@intel.com>, linux-tip-commits@vger.kernel.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: Re: [tip:sched/core] sched/balancing: Fix cfs_rq-> task_h_load
 calculation
Message-ID: <20130929094714.GM24743@yliu-dev.sh.intel.com>
References: <1379173186-11944-1-git-send-email-vdavydov@parallels.com>
 <tip-7e3115ef5149fc502e3a2e80719dba54a8e7409d@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-7e3115ef5149fc502e3a2e80719dba54a8e7409d@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 06:46:59AM -0700, tip-bot for Vladimir Davydov wrote:
> Commit-ID:  7e3115ef5149fc502e3a2e80719dba54a8e7409d
> Gitweb:     http://git.kernel.org/tip/7e3115ef5149fc502e3a2e80719dba54a8e7409d
> Author:     Vladimir Davydov <vdavydov@parallels.com>
> AuthorDate: Sat, 14 Sep 2013 19:39:46 +0400
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Fri, 20 Sep 2013 11:59:39 +0200
> 
> sched/balancing: Fix cfs_rq->task_h_load calculation
> 
> Patch a003a2 (sched: Consider runnable load average in move_tasks())
> sets all top-level cfs_rqs' h_load to rq->avg.load_avg_contrib, which is
> always 0. This mistype leads to all tasks having weight 0 when load
> balancing in a cpu-cgroup enabled setup. There obviously should be sum
> of weights of all runnable tasks there instead. Fix it.

Hi Vladimir,

FYI, Here we found a 17% netperf regression by this patch. Here are some
changed stats between this commit 7e3115ef5149fc502e3a2e80719dba54a8e7409d
and it's parent(3029ede39373c368f402a76896600d85a4f7121b)

NOTE: both commit had been tested 10+ times.

stat                                                                 7e3115ef5149fc502e3a2e80719    3029ede39373c368f402a768966
netperf.Throughput_Mbps                                              [ 2515       - 2593       ] -- [ 3010       - 3042       ]

lock_stat.&(&base->lock)->rlock.contentions.run_timer_softirq        [ 188        - 261        ] -- [ 1907       - 2018       ]
lock_stat.&rq->lock.contentions                                      [ 16885      - 23944      ] -- [ 2.6544e+05 - 2.8201e+05 ]
lock_stat.slock-AF_INET/1.contentions.release_sock                   [ 28993      - 34079      ] -- [ 2.6537e+05 - 2.7814e+05 ]
lock_stat.slock-AF_INET/1.contentions.tcp_v4_rcv                     [ 54906      - 64453      ] -- [ 4.6572e+05 - 4.8895e+05 ]
lock_stat.slock-AF_INET/1.contentions                                [ 54778      - 64265      ] -- [ 4.6503e+05 - 4.8831e+05 ]
lock_stat.slock-AF_INET/1.contentions.lock_sock_nested               [ 25382      - 29998      ] -- [ 1.9822e+05 - 2.0934e+05 ]
lock_stat.slock-AF_INET.contentions.lock_sock_nested                 [ 1.5861e+05 - 1.8802e+05 ] -- [ 1.2317e+06 - 1.3016e+06 ]
lock_stat.slock-AF_INET.contentions.tcp_v4_rcv                       [ 1.9181e+05 - 2.2617e+05 ] -- [ 1.5482e+06 - 1.6346e+06 ]
lock_stat.slock-AF_INET.contentions                                  [ 1.9259e+05 - 2.269e+05  ] -- [ 1.5536e+06 - 1.6403e+06 ]
lock_stat.&(&base->lock)->rlock.contentions                          [ 5658       - 9045       ] -- [ 1.3812e+05 - 1.478e+05  ]
lock_stat.&(&base->lock)->rlock.contentions.lock_timer_base          [ 11006      - 17636      ] -- [ 2.7183e+05 - 2.9104e+05 ]
lock_stat.slock-AF_INET.contentions.release_sock                     [ 33931      - 39607      ] -- [ 3.2735e+05 - 3.4512e+05 ]
lock_stat.&(&base->lock)->rlock.contentions.mod_timer                [ 93         - 152        ] -- [ 2347       - 2643       ]
lock_stat.&(&zone->lock)->rlock.contentions.__free_pages_ok          [ 6.4647e+07 - 6.6226e+07 ] -- [ 5.3604e+07 - 5.5065e+07 ]
vmstat.system.in                                                     [ 8921       - 9414       ] -- [ 27103      - 28369      ]
vmstat.system.cs                                                     [ 1.4924e+05 - 1.9988e+05 ] -- [ 6.1384e+05 - 6.4036e+05 ]
lock_stat.&(&zone->lock)->rlock.contentions                          [ 6.7612e+07 - 6.9817e+07 ] -- [ 5.7419e+07 - 5.8889e+07 ]
lock_stat.rcu_node_1.contentions.rcu_process_callbacks               [ 81543      - 87346      ] -- [ 97955      - 1.0295e+05 ]
iostat.cpu.user                                                      [ 1.4141     - 1.5051     ] -- [ 2.1044     - 2.1732     ]
lock_stat.&(&zone->lock)->rlock.contentions.get_page_from_freelist   [ 7.0564e+07 - 7.3656e+07 ] -- [ 6.1222e+07 - 6.2746e+07 ]
lock_stat.&rq->lock.contentions.__schedule                           [ 8276       - 11422      ] -- [ 1.1656e+05 - 1.9275e+05 ]
iostat.cpu.system                                                    [ 95.387     - 95.516     ] -- [ 94.736     - 94.81      ]
vmstat.cpu.sy                                                        [ 96         - 96         ] -- [ 95         - 95         ]



And here are the text plot charts for those changed stats:

    * for 7e3115ef5149fc502e3a2e80719dba54a8e7409d(this commit)
    O for 3029ede39373c368f402a76896600d85a4f7121b(parent)
    
                               netperf.Throughput_Mbps

   3100 ++------------------------------------------------------------------+
        O       O                                                           |
   3000 ++             O       O      O       O      O       O      O       O
        |                                                                   |
        |                                                                   |
   2900 ++                                                                  |
        |                                                                   |
   2800 ++                                                                  |
        |                                                                   |
   2700 ++                                                                  |
        |                                                                   |
        |                                                                   |
   2600 ++                   ..*......*.......*......*.......*......    ....*
        |                ....                                       *...    |
   2500 *+------*------*----------------------------------------------------+


                                  vmstat.system.in

   30000 ++-----------------------------------------------------------------+
   28000 O+     O                      O              O                     |
         |              O      O              O              O       O      O
   26000 ++                                                                 |
   24000 ++                                                                 |
   22000 ++                                                                 |
   20000 ++                                                                 |
         |                                                                  |
   18000 ++                                                                 |
   16000 ++                                                                 |
   14000 ++                                                                 |
   12000 ++                                                                 |
         |                                                                  |
   10000 *+.....*.......*......*.......*......*.......*......*.......*......*
    8000 ++-----------------------------------------------------------------+


                                   vmstat.system.cs

   700000 ++----------------------------------------------------------------+
          O                            O                                    |
   600000 ++     O       O      O              O      O      O       O      O
          |                                                                 |
          |                                                                 |
   500000 ++                                                                |
          |                                                                 |
   400000 ++                                                                |
          |                                                                 |
   300000 ++                                                                |
          |                                                                 |
          |                                                              ...*
   200000 ++                 ...*......    ....*......           ....*...   |
          *......*.......*...          *...           *......*...           |
   100000 ++----------------------------------------------------------------+


                                    vmstat.cpu.sy

     96 *+------*------*--------------*-------*------*-------*------*-------*
        |               :             :                                     |
        |               :            :                                      |
   95.8 ++               :           :                                      |
        |                :          :                                       |
        |                 :         :                                       |
   95.6 ++                :        :                                        |
        |                  :       :                                        |
   95.4 ++                  :     :                                         |
        |                   :     :                                         |
        |                    :   :                                          |
   95.2 ++                   :   :                                          |
        |                     : :                                           |
        |                     : :                                           |
     95 O+------O------O-------*------O-------O------O-------O------O-------O


                      lock_stat.&(&zone->lock)->rlock.contentions

   7.2e+07 ++---------------------------------------------------------------+
           |                                                                |
     7e+07 ++  ...*......*.......*......*......    ...*.......*.....        |
   6.8e+07 *+..                                *...                 .       |
           |                                                         *......*
   6.6e+07 ++                                                               |
           |                                                                |
   6.4e+07 ++                                                               |
           |                                                                |
   6.2e+07 ++                                                               |
     6e+07 ++                                                               |
           |             O                                                  O
   5.8e+07 ++     O              O             O      O                     |
           O                                                  O      O      |
   5.6e+07 ++---------------------------O-----------------------------------+


          lock_stat.&(&zone->lock)->rlock.contentions.get_page_from_freelist

   7.4e+07 ++---------------------------*---------------------*-------------+
           |                 ....*...         .    ...*...        ..        |
   7.2e+07 *+.....*......*...                  *...                 .       |
           |                                                         *......*
     7e+07 ++                                                               |
           |                                                                |
   6.8e+07 ++                                                               |
           |                                                                |
   6.6e+07 ++                                                               |
           |                                                                |
   6.4e+07 ++                                                               |
           |      O      O                                                  O
   6.2e+07 ++                    O             O      O                     |
           O                                                  O      O      |
     6e+07 ++---------------------------O-----------------------------------+


              lock_stat.&(&zone->lock)->rlock.contentions.__free_pages_ok

   6.8e+07 ++---------------------------------------------------------------+
           |                                              ....*.....        |
   6.6e+07 *+.....*......*.......*......*......*......*...          .       |
   6.4e+07 ++                                                        *......*
           |                                                                |
   6.2e+07 ++                                                               |
           |                                                                |
     6e+07 ++                                                               |
           |                                                                |
   5.8e+07 ++                                                               |
   5.6e+07 ++                                                               |
           |      O      O                                                  O
   5.4e+07 O+                    O             O      O              O      |
           |                            O                     O             |
   5.2e+07 ++---------------------------------------------------------------+


                          lock_stat.slock-AF_INET.contentions

   1.8e+06 ++---------------------------------------------------------------+
           O      O                     O             O                     |
   1.6e+06 ++            O       O             O              O      O      O
   1.4e+06 ++                                                               |
           |                                                                |
   1.2e+06 ++                                                               |
     1e+06 ++                                                               |
           |                                                                |
    800000 ++                                                               |
    600000 ++                                                               |
           |                                                                |
    400000 ++                                                               |
    200000 *+.....           ....*......*......*......*.......    ...*......*
           |      *......*...                                 *...          |
         0 ++---------------------------------------------------------------+


                 lock_stat.slock-AF_INET.contentions.lock_sock_nested

   1.4e+06 ++---------------------------------------------------------------+
           O      O                     O             O                     |
   1.2e+06 ++            O       O             O              O      O      O
           |                                                                |
     1e+06 ++                                                               |
           |                                                                |
    800000 ++                                                               |
           |                                                                |
    600000 ++                                                               |
           |                                                                |
    400000 ++                                                               |
           |                                                                |
    200000 *+.....*......*.......*......*......*......*.......*......*......*
           |                                                                |
         0 ++---------------------------------------------------------------+


                   lock_stat.slock-AF_INET.contentions.release_sock

   350000 O+-----O---------------------O--------------O---------------------+
          |              O      O              O             O       O      O
   300000 ++                                                                |
          |                                                                 |
   250000 ++                                                                |
          |                                                                 |
   200000 ++                                                                |
          |                                                                 |
   150000 ++                                                                |
          |                                                                 |
   100000 ++                                                                |
          |                                                                 |
    50000 ++                 ...*......    ....*......*......    ....*......*
          *......*.......*...          *...                  *...           |
        0 ++----------------------------------------------------------------+


                    lock_stat.slock-AF_INET.contentions.tcp_v4_rcv

   1.8e+06 ++---------------------------------------------------------------+
           O      O                     O             O                     |
   1.6e+06 ++            O       O             O              O      O      O
   1.4e+06 ++                                                               |
           |                                                                |
   1.2e+06 ++                                                               |
     1e+06 ++                                                               |
           |                                                                |
    800000 ++                                                               |
    600000 ++                                                               |
           |                                                                |
    400000 ++                                                               |
    200000 *+.....           ....*......*......*......*.......    ...*......*
           |      *......*...                                 *...          |
         0 ++---------------------------------------------------------------+


                lock_stat.rcu_node_1.contentions.rcu_process_callbacks

   110000 ++----------------------------------------------------------------+
          |                                                                 |
   105000 ++                           O                                    |
          |              O                                                  |
          O                                    O                            O
   100000 ++     O              O                                    O      |
          |                                           O      O              |
    95000 ++                                                                |
          |                                                                 |
    90000 ++                                                               .*
          |                                                            .... |
          |     .*.......*......*.....                             ..*.     |
    85000 ++....                      .              .*......  ....         |
          *.                           *.......  ....        *.             |
    80000 ++-----------------------------------*----------------------------+


                         lock_stat.slock-AF_INET/1.contentions

   500000 ++---------------------------O--------------O---------------------+
          O      O       O      O              O             O       O      O
   450000 ++                                                                |
   400000 ++                                                                |
          |                                                                 |
   350000 ++                                                                |
   300000 ++                                                                |
          |                                                                 |
   250000 ++                                                                |
   200000 ++                                                                |
          |                                                                 |
   150000 ++                                                                |
   100000 ++                                                                |
          |                                ....*......                      |
    50000 *+-----*-------*------*------*--------------*------*-------*------*


                   lock_stat.slock-AF_INET/1.contentions.tcp_v4_rcv

   500000 ++---------------------------O--------------O---------------------+
          O      O       O      O              O             O       O      O
   450000 ++                                                                |
   400000 ++                                                                |
          |                                                                 |
   350000 ++                                                                |
   300000 ++                                                                |
          |                                                                 |
   250000 ++                                                                |
   200000 ++                                                                |
          |                                                                 |
   150000 ++                                                                |
   100000 ++                                                                |
          |                                ....*......                      |
    50000 *+-----*-------*------*------*--------------*------*-------*------*


                  lock_stat.slock-AF_INET/1.contentions.release_sock

   300000 ++----------------------------------------------------------------+
          O      O              O      O              O                     |
   250000 ++             O                     O             O       O      O
          |                                                                 |
          |                                                                 |
   200000 ++                                                                |
          |                                                                 |
   150000 ++                                                                |
          |                                                                 |
   100000 ++                                                                |
          |                                                                 |
          |                                                                 |
    50000 ++                 ...*......    ....*......*......    ....*......*
          *......*.......*...          *...                  *...           |
        0 ++----------------------------------------------------------------+


                lock_stat.slock-AF_INET/1.contentions.lock_sock_nested

   220000 ++----------------------------------------------------------------+
   200000 O+     O       O      O      O       O      O      O              |
          |                                                          O      O
   180000 ++                                                                |
   160000 ++                                                                |
          |                                                                 |
   140000 ++                                                                |
   120000 ++                                                                |
   100000 ++                                                                |
          |                                                                 |
    80000 ++                                                                |
    60000 ++                                                                |
          |                                                                 |
    40000 ++                 ...*......    ....*......*......    ....*......*
    20000 *+-----*-------*-------------*---------------------*--------------+


                            lock_stat.&rq->lock.contentions

   300000 O+----------------------------------------------------------------+
          |      O       O             O       O      O                     |
   250000 ++                    O                            O       O      O
          |                                                                 |
          |                                                                 |
   200000 ++                                                                |
          |                                                                 |
   150000 ++                                                                |
          |                                                                 |
   100000 ++                                                                |
          |                                                                 |
          |                                                                 |
    50000 ++                                                                |
          *......*.......*......*......*.......*......*......*.......*......*
        0 ++----------------------------------------------------------------+


                      lock_stat.&rq->lock.contentions.__schedule

   200000 O+----------------------------------------------------------------+
   180000 ++             O      O      O              O      O              O
          |                                                                 |
   160000 ++                                                                |
   140000 ++                                                                |
          |      O                                                          |
   120000 ++                                   O                     O      |
   100000 ++                                                                |
    80000 ++                                                                |
          |                                                                 |
    60000 ++                                                                |
    40000 ++                                                                |
          |                                                                 |
    20000 *+.....*.......*......*......*.......*......*......*.......*......*
        0 ++----------------------------------------------------------------+


                      lock_stat.&(&base->lock)->rlock.contentions

   160000 ++----------------------------------------------------------------+
          O      O                     O       O                            O
   140000 ++             O      O                     O      O       O      |
   120000 ++                                                                |
          |                                                                 |
   100000 ++                                                                |
          |                                                                 |
    80000 ++                                                                |
          |                                                                 |
    60000 ++                                                                |
    40000 ++                                                                |
          |                                                                 |
    20000 ++                                                                |
          *......            ...*......*.......*......*......*.......*......*
        0 ++-----*-------*--------------------------------------------------+


              lock_stat.&(&base->lock)->rlock.contentions.lock_timer_base

   300000 O+-----O---------------------O------------------------------------+
          |              O      O              O      O      O       O      O
   250000 ++                                                                |
          |                                                                 |
          |                                                                 |
   200000 ++                                                                |
          |                                                                 |
   150000 ++                                                                |
          |                                                                 |
   100000 ++                                                                |
          |                                                                 |
          |                                                                 |
    50000 ++                                                                |
          *......*.......*......*......*.......*......*......*.......*......*
        0 ++----------------------------------------------------------------+


            lock_stat.&(&base->lock)->rlock.contentions.run_timer_softirq

   2200 ++------------------------------------------------------------------+
   2000 O+      O                                    O       O              |
        |              O       O      O       O                     O       O
   1800 ++                                                                  |
   1600 ++                                                                  |
   1400 ++                                                                  |
   1200 ++                                                                  |
        |                                                                   |
   1000 ++                                                                  |
    800 ++                                                                  |
    600 ++                                                                  |
    400 ++                                                                  |
        |                  ....*......    ....*......*.......    ...*.......|
    200 *+......*......*...           *...                   *...           *
      0 ++------------------------------------------------------------------+


                lock_stat.&(&base->lock)->rlock.contentions.mod_timer

   3000 ++------------------------------------------------------------------+
        |                                                                   |
   2500 O+      O              O      O              O                      O
        |              O                                     O      O       |
        |                                                                   |
   2000 ++                                                                  |
        |                                                                   |
   1500 ++                                                                  |
        |                                     O                             |
   1000 ++                                                                  |
        |                                                                   |
        |                                                                   |
    500 ++                                                                  |
        *.......           ....*......*.......*......*.......*......*.......*
      0 ++------*------*----------------------------------------------------+


                                  iostat.cpu.user

   2.2 O+--------------------------------------------O----------------------+
       |       O      O       O       O      O               O      O       |
   2.1 ++                                                                   O
     2 ++                                                                   |
       |                                                                    |
   1.9 ++                                                                   |
   1.8 ++                                                                   |
       |                                                                    |
   1.7 ++                                                                   |
   1.6 ++                                                                   |
       |                                                                    |
   1.5 ++                         ....*......*.......            ...*.......*
   1.4 *+......*......    ....*...                   *.......*...           |
       |              *...                                                  |
   1.3 ++-------------------------------------------------------------------+


                                  iostat.cpu.system

   95.6 ++------------------------------------------------------------------+
        *.......    ...*.......*.....                    ....*.....         |
   95.5 ++      *...                 .            ...*...          .        |
   95.4 ++                            *.......*...                  *.......*
        |                                                                   |
   95.3 ++                                                                  |
   95.2 ++                                                                  |
        |                                                                   |
   95.1 ++                                                                  |
     95 ++                                                                  |
        |                                                                   |
   94.9 ++                                                                  |
   94.8 ++             O       O                                            O
        O       O                     O       O      O       O      O       |
   94.7 ++------------------------------------------------------------------+


And here is the bisect log:
# bad: [e9a5cecac4145ba4a64827ac55728d33f5c8bb79] Merge 'drm/drm-fixes' into devel-hourly-2013092910                                                                                                                                                           
# good: [272b98c6455f00884f0350f775c5342358ebb73f] Linux 3.12-rc1                                                                                                                                                                                              
git bisect start 'e9a5cecac4145ba4a64827ac55728d33f5c8bb79' '272b98c6455f00884f0350f775c5342358ebb73f' '--'                                                                                                                                                    
# bad: [654fdd041227d7de1594baa61c58f2c87bd0640f] Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip                                                                                                                 
git bisect bad 654fdd041227d7de1594baa61c58f2c87bd0640f                                                                                                                                                                                                        
# good: [b75ff5e84bb6c2d43a8ec39b240c80f0543821f0] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net                                                                                                                                               
git bisect good b75ff5e84bb6c2d43a8ec39b240c80f0543821f0                                                                                                                                                                                                       
# good: [d8524ae9d6f492a9c6db9f4d89c5f9b8782fa2d5] Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux                                                                                                                                     
git bisect good d8524ae9d6f492a9c6db9f4d89c5f9b8782fa2d5                                                                                                                                                                                                       
# good: [4a10c2ac2f368583138b774ca41fac4207911983] Linux 3.12-rc2                                                                                                                                                                                              
git bisect good 4a10c2ac2f368583138b774ca41fac4207911983                                                                                                                                                                                                       
# good: [a153e67bda3639a46edac6205610ae63c0fdea4c] Merge branch 'akpm' (patches from Andrew Morton)                                                                                                                                                            
git bisect good a153e67bda3639a46edac6205610ae63c0fdea4c                                                                                                                                                                                                       
# good: [fa7315871046b9a4c48627905691dbde57e51033] perf: Fix capabilities bitfield compatibility in 'struct perf_event_mmap_page'                                                                                                                              
git bisect good fa7315871046b9a4c48627905691dbde57e51033                                                                                                                                                                                                       
# bad: [82dfaa58a79c121be3611ce549dec806f2e6004f] Merge branch 'sched-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip                                                                                                               
git bisect bad 82dfaa58a79c121be3611ce549dec806f2e6004f                                                                                                                                                                                                        
# good: [bdc5663fa14de657f24080ee959670d49c8dd094] Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip                                                                                                               
git bisect good bdc5663fa14de657f24080ee959670d49c8dd094                                                                                                                                                                                                       
# good: [3029ede39373c368f402a76896600d85a4f7121b] sched/balancing: Fix 'local->avg_load > busiest->avg_load' case in fix_small_imbalance()                                                                                                                    
git bisect good 3029ede39373c368f402a76896600d85a4f7121b                                                                                                                                                                                                       
# bad: [7e3115ef5149fc502e3a2e80719dba54a8e7409d] sched/balancing: Fix cfs_rq->task_h_load calculation                                                                                                                                                         
git bisect bad 7e3115ef5149fc502e3a2e80719dba54a8e7409d                                                                                                                                                                                                        
# first bad commit: [7e3115ef5149fc502e3a2e80719dba54a8e7409d] sched/balancing: Fix cfs_rq->task_h_load calculation                    

Please feel free to ask more data.

Thanks.

	--yliu
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> Reviewed-by: Paul Turner <pjt@google.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/r/1379173186-11944-1-git-send-email-vdavydov@parallels.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  kernel/sched/fair.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 2aedacc..7c70201 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4242,7 +4242,7 @@ static void update_cfs_rq_h_load(struct cfs_rq *cfs_rq)
>  	}
>  
>  	if (!se) {
> -		cfs_rq->h_load = rq->avg.load_avg_contrib;
> +		cfs_rq->h_load = cfs_rq->runnable_load_avg;
>  		cfs_rq->last_h_load_update = now;
>  	}
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
