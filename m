Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab3IMBJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 21:09:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:48721 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab3IMBJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 21:09:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,894,1371106800"; 
   d="scan'208";a="395027286"
Date: Fri, 13 Sep 2013 09:09:36 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Tejun Heo <tj@kernel.org>
Subject: Re: increased vmap_area_lock contentions on "n_tty: Move buffers
 into n_tty_data"
Message-ID: <20130913010936.GA1291@localhost>
References: <20130913005133.GA32479@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130913005133.GA32479@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 08:51:33AM +0800, Fengguang Wu wrote:
> Hi Peter,
> 
> FYI, we noticed much increased vmap_area_lock contentions since this
> commit:
> 
> commit 20bafb3d23d108bc0a896eb8b7c1501f4f649b77
> Author: Peter Hurley <peter@hurleysoftware.com>
> Date:   Sat Jun 15 10:21:19 2013 -0400
> 
>     n_tty: Move buffers into n_tty_data
>     
>     Reduce pointer reloading and improve locality-of-reference;
>     allocate read_buf and echo_buf within struct n_tty_data.

Here are some comparison between this commit [o] with its parent commit [*].

                          slabinfo.kmalloc-128.active_objs

   10400 ++--------O---------------O----------------------------------------+
         |                 O    O       O  O      O    O  O  O O  O O  O O  O
   10200 ++      O    O O     O      O       O  O    O                      |
   10000 ++   O                                                             |
         O  O                                                               |
    9800 ++                                                                 |
         |                                                                  |
    9600 ++                                                                 |
         |                                                                  |
    9400 ++                                                                 |
    9200 ++                                                                 |
         |                                                                  |
    9000 *+.*.                                                              |
         |    *                                                             |
    8800 ++-----------------------------------------------------------------+


                          slabinfo.kmalloc-128.active_objs

   2400 ++------------------------------------------------------------------+
        |                                      O  O        O     O         O|
   2200 ++     O  OO    O    O   O    O O           O    OO         O   O   O
   2000 O+O OOO O   OOO  OOOO  OO OO O O O OOOO  O O O OO   O OOO O  OOO  O |
        |O                                                                  |
   1800 ++                                                                  |
        |                                                                   |
   1600 ++                                                                  |
        |                                                                   |
   1400 ++                                                                  |
   1200 ++                                                                  |
        |*                                                                  |
   1000 ++*.*                                                               |
        *    **                                                             |
    800 ++------------------------------------------------------------------+

    8cb06c983822103da1cf      20bafb3d23d108bc0a89
------------------------  ------------------------
                  976.67      +108.3%      2034.67  lkp-a04/micro/netperf/120s-200%-TCP_STREAM
                 8971.36       +11.4%      9997.05  nhm-white/micro/aim7/exec_test
                 9948.03       +20.9%     12031.72  TOTAL slabinfo.kmalloc-128.active_objs

    8cb06c983822103da1cf      20bafb3d23d108bc0a89  
------------------------  ------------------------  
                  976.67      +108.3%      2034.67  lkp-a04/micro/netperf/120s-200%-TCP_STREAM
                 9127.64       +11.4%     10164.15  nhm-white/micro/aim7/exec_test
                10104.31       +20.7%     12198.82  TOTAL slabinfo.kmalloc-128.num_objs

                        lock_stat.vmap_area_lock.holdtime-total

   1.8e+07 ++---------------------------------------------------------------+
           O  O   O      O         O                O  O                 O  |
   1.6e+07 ++        O      O   O     O   O  O   O         O  O   O  O      O
   1.4e+07 ++                                                               |
           |                                                                |
   1.2e+07 ++                                                               |
     1e+07 ++                                                               |
           |                                                                |
     8e+06 ++                                                               |
     6e+06 ++                                                               |
           |                                                                |
     4e+06 ++                                                               |
     2e+06 ++                                                               |
           *..*...*..*...*..*...*..*..*...*                                 |
         0 ++---------------------------------------------------------------+



                       lock_stat.vmap_area_lock.holdtime-total

   70000 ++-----------------------------------------------------------------+
         |                O                        O                    O   |
   60000 ++  O   O    O       O   O   O        O           O   O    O       |
         O                                 O           O                    O
   50000 ++                                                                 |
         |                                                                  |
   40000 ++                                                                 |
         |                                                                  |
   30000 ++                                                                 |
         |                                                                  |
   20000 ++                                                                 |
         |                                                                  |
   10000 ++                                                                 |
         *...*...*....*...*                                                 |
       0 ++-----------------------------------------------------------------+


                       lock_stat.vmap_area_lock.holdtime-total

   80000 ++-----------------------------------------------------------------+
         |                                                                  |
   70000 ++                                         O                       |
   60000 ++                                                                 |
         |                       O                                          |
   50000 ++                                               O     O           |
         |                                                                  O
   40000 ++                                   O                             |
         |                                                                  |
   30000 O+                O                                                |
   20000 ++    O     O                 O                              O     |
         |                                                                  |
   10000 ++                                                                 |
         |                                                                  |
       0 *+----*-----*-----*-----*------------------------------------------+


                       lock_stat.vmap_area_lock.holdtime-total

   90000 ++-----------------------------------------------------------------+
         |                                                                  |
   80000 ++                                             O                   |
   70000 ++                                                                 |
         |                                                                  |
   60000 ++                                                                 O
   50000 ++                                                          O      |
         |      O     O                          O                          |
   40000 O+                                                    O            |
   30000 ++                         O                                       |
         |                   O             O                                |
   20000 ++                                                                 |
   10000 ++                                                                 |
         *......                                                            |
       0 ++-----*-----*------*------*------*-----*--------------------------+


                       lock_stat.vmap_area_lock.holdtime-total

   80000 ++-----------------------------------------------------------------+
         |                             O              O                     |
   70000 ++                                                                 |
   60000 ++                                                                 |
         |                                                                  |
   50000 ++                    O                             O       O      |
         |                                                                  |
   40000 ++                                                                 |
         |                                                                  |
   30000 O+     O       O                                                   |
   20000 ++                                   O                             O
         |                                                                  |
   10000 ++                                                                 |
         *......*.......    ...*                                            |
       0 ++-------------*---------------------------------------------------+


                       lock_stat.vmap_area_lock.holdtime-total

   80000 ++-------------------------------------------------------------O---+
         |                                 O           O   O   O            O
   70000 ++                   O                                             |
   60000 ++                                                         O       |
         |                        O            O                            |
   50000 ++                                                                 |
         |                                                                  |
   40000 ++                                                                 |
         |                O                        O                        |
   30000 ++           O               O                                     |
   20000 O+  O   O                                                          |
         |                                                                  |
   10000 ++                                                                 |
         |                                                                  |
       0 *+--*---*----*-----------------------------------------------------+


                       lock_stat.vmap_area_lock.holdtime-total

   80000 ++-----------------------------------------------------------------+
         |                                                     O     O      |
   70000 ++                         O                                       O
   60000 ++                                                                 |
         |                                                                  |
   50000 ++                                                                 |
         |                                                                  |
   40000 ++                                                                 |
         O            O                                                     |
   30000 ++     O                          O     O                          |
   20000 ++                                             O                   |
         |                   O                                              |
   10000 ++                                                                 |
         |                                                                  |
       0 *+-----*-----*------*----------------------------------------------+


                        lock_stat.vmap_area_lock.holdtime-total

   120000 ++----------------------------------------------------------------+
          |                                                                 |
   100000 ++                                                O               O
          |                                O                                |
          |                                        O                        |
    80000 ++                                                                |
          |                                                                 |
    60000 ++                                                        O       |
          |       O                                                         |
    40000 O+               O                                                |
          |                                                                 |
          |                        O                                        |
    20000 ++                                                                |
          |                                                                 |
        0 *+------*--------*-------*----------------------------------------+


                        lock_stat.vmap_area_lock.holdtime-total

   1.6e+07 ++---------------------------------------------------------------+
           |  O                                       O    O    O           O
   1.4e+07 O+   O  O O  O O  O O  O O  O O  O O  O O    O    O    O  O O  O |
   1.2e+07 ++                                                               |
           |                                                                |
     1e+07 ++                                                               |
           |                                                                |
     8e+06 ++                                                               |
           |                                                                |
     6e+06 ++                                                               |
     4e+06 ++                                                               |
           |                                                                |
     2e+06 ++                                                               |
           *..*.*                                                           |
         0 ++---------------------------------------------------------------+


                        lock_stat.vmap_area_lock.holdtime-total

   400000 ++----------------------------------------------------------------+
          |                               O                      O          O
   350000 ++ O  O  O O           O     O    O                               |
          |                O  O     O          O     O  O  O  O    O  O     |
   300000 O+            O                         O                      O  |
   250000 ++                                                                |
          |                                                                 |
   200000 ++                                                                |
          |                                                                 |
   150000 ++                                                                |
   100000 ++                                                                |
          |                                                                 |
    50000 ++                                                                |
          *..*..*                                                           |
        0 ++----------------------------------------------------------------+


                       lock_stat.vmap_area_lock.holdtime-total

   60000 +O-----------O---------O-O--------O-----------------O-----------O--+
         OOOO O OOO OO OOOOOOOOO O OOOOOOOOOOO  O O  OO OOOOO O OOOO OOOOO OO
   50000 ++  O O   O   O O           O      O OO O OO OOO O O OOO  OOO O  O |
         |                                                                  |
         |                                                                  |
   40000 ++                                                                 |
         |                                                                  |
   30000 ++                                                                 |
         |                                                                  |
   20000 ++                                                                 |
         |                                                                  |
         |                                                                  |
   10000 ++                                                                 |
         **                                                                 |
       0 ++-----------------------------------------------------------------+


                        lock_stat.vmap_area_lock.holdtime-total

   350000 ++----------------------------------------------------------------+
          |    O            O                                    O  O  O    O
   300000 O+         O    O         O       O  O  O       O O               |
          |  O    O    O       O  O    O  O         O  O       O         O  |
   250000 ++                                                                |
          |                                                                 |
   200000 ++                                                                |
          |                                                                 |
   150000 ++                                                                |
          |                                                                 |
   100000 ++                                                                |
          |                                                                 |
    50000 ++                                                                |
          *..*.*..*                                                         |
        0 ++----------------------------------------------------------------+


                        lock_stat.vmap_area_lock.holdtime-total

   300000 ++--------------------------O----O--------------O-------O---------+
          O  O O    O              O          O O  O    O    O      O       |
   250000 ++      O           O  O      O            O         O       O    O
          |            O O  O                                            O  |
          |                                                                 |
   200000 ++                                                                |
          |                                                                 |
   150000 ++                                                                |
          |                                                                 |
   100000 ++                                                                |
          |                                                                 |
          |                                                                 |
    50000 ++                                                                |
          *..*.*..*.*                                                       |
        0 ++----------------------------------------------------------------+


                       lock_stat.vmap_area_lock.holdtime-total

   70000 ++-----------------------------------------------------------------+
         |                          O       O                         O     |
   60000 +O  O  OOO   OO   O   O O O O  OOOO O O O OO O OO   O O   O O  O   |
         O O  OO    OO  OO  OOO   O   O         O O    O  O O O OO  O  O  OOO
   50000 ++                                                                 |
         |                                                                  |
   40000 ++                                                                 |
         |                                                                  |
   30000 ++                                                                 |
         |                                                                  |
   20000 ++                                                                 |
         |                                                                  |
   10000 ++                                                                 |
         ***.***                                                            |
       0 ++-----------------------------------------------------------------+


                        lock_stat.vmap_area_lock.holdtime-total

   400000 ++----------------------------------------------------------------+
          |                     O                   O           O    O      |
   350000 O+   O    O    O O                O  O O    O O  O O              O
          | O    O    O       O   O  O O  O                       O    O  O |
   300000 ++                                                                |
   250000 ++                                                                |
          |                                                                 |
   200000 ++                                                                |
          |                                                                 |
   150000 ++                                                                |
   100000 ++                                                                |
          |                                                                 |
    50000 ++                                                                |
          *.*..*.*..*.*                                                     |
        0 ++----------------------------------------------------------------+


                       lock_stat.vmap_area_lock.holdtime-total

   80000 ++--------------------------O--------------------------------------+
         |                      O                        O            O     |
   70000 ++O    O    OO   OOO     OO  OO O OO O O  OOO  O OOO    OO OO OO O |
   60000 ++   OO O OO  O O   O   O      O    O O  O   O       OOO          OO
         OO  O                 O                                            |
   50000 ++                                                                 |
         |                                                                  |
   40000 ++                                                                 |
         |                                                                  |
   30000 ++                                                                 |
   20000 ++                                                                 |
         |                                                                  |
   10000 ++                                                                 |
         ***.***                                                            |
       0 ++-----------------------------------------------------------------+


                       lock_stat.vmap_area_lock.holdtime-total

   50000 ++-------------------------------O---------------------------------O
   45000 OOO OOO O   O OOO  OO O  O   O    OO  OO   O  O O      OO OOOO    O|
         |      O O O O    O  O    OOO   O       OOO  O O O OO O       OO O |
   40000 ++                      O      O    O                O             |
   35000 ++                                                                 |
         |                                                                  |
   30000 ++                                                                 |
   25000 ++                                                                 |
   20000 ++                                                                 |
         |                                                                  |
   15000 ++                                                                 |
   10000 ++                                                                 |
         |                                                                  |
    5000 ***.***                                                            |
       0 ++-----------------------------------------------------------------+


                       lock_stat.vmap_area_lock.holdtime-total

   45000 ++--------------O-----------O---O----------------------------------+
         | O OO  O  OOOO   O O OO             O O  O      OOO               |
   40000 O+    O   O      O O     OO   OO  OO  O  O OO  OO    OO OO OOOOO OOO
   35000 +O     O                O    O      O        O         O           |
         |                                                                  |
   30000 ++                                                                 |
   25000 ++                                                                 |
         |                                                                  |
   20000 ++                                                                 |
   15000 ++                                                                 |
         |                                                                  |
   10000 ++                                                                 |
    5000 ++                                                                 |
         ***.***                                                            |
       0 ++-----------------------------------------------------------------+


                       lock_stat.vmap_area_lock.holdtime-total

   45000 ++------------------------------O------O--O------------------------+
         |  O   O  O   O O   OOOOO  O  O     O   O  O   O  O O OO   O OO O  |
   40000 OO   OO OO  OO    O      O  OO O  OO OO     OOO  O O O   OO O    OOO
   35000 ++O            O O                                                 |
         |                                                                  |
   30000 ++                                                                 |
   25000 ++                                                                 |
         |                                                                  |
   20000 ++                                                                 |
   15000 ++                                                                 |
         |                                                                  |
   10000 ++                                                                 |
    5000 ++                                                                 |
         ****.**                                                            |
       0 ++-----------------------------------------------------------------+


                        lock_stat.vmap_area_lock.holdtime-total

   5.5e+06 O+---------------------------O------O----------------------------+
     5e+06 ++     O      O       O                    O       O      O      |
           |                                                                O
   4.5e+06 ++                                                               |
     4e+06 ++                                                               |
   3.5e+06 ++                                                               |
     3e+06 ++                                                               |
           |                                                                |
   2.5e+06 ++                                                               |
     2e+06 ++                                                               |
   1.5e+06 ++                                                               |
     1e+06 ++                                                               |
           |                                                                |
    500000 *+.....*......*.......*......*                                   |
         0 ++---------------------------------------------------------------+


                       lock_stat.vmap_area_lock.holdtime-total

   7e+06 ++-----------------------------------------------------------------+
         |             O                                                    |
   6e+06 ++O O O O O O   O O O O O   O O O  O O O O O O O O O O O O O O O O O
         O                         O                                        |
   5e+06 ++                                                                 |
         |                                                                  |
   4e+06 ++                                                                 |
         |                                                                  |
   3e+06 ++                                                                 |
         |                                                                  |
   2e+06 ++                                                                 |
         |                                                                  |
   1e+06 ++                                                                 |
         *.*.*.*.*.*.*.*.*.*                                                |
       0 ++-----------------------------------------------------------------+


                       lock_stat.vmap_area_lock.holdtime-total

   45000 ++--O--------------------------------------------------------------+
         |          O   O      O         O    O O O O O      O O O O    O   |
   40000 O+O   O  O       O O    O O O O    O            O O          O   O |
   35000 ++           O                                                     O
         |                                                                  |
   30000 ++                                                                 |
   25000 ++                                                                 |
         |                                                                  |
   20000 ++                                                                 |
   15000 ++                                                                 |
         |                                                                  |
   10000 ++                                                                 |
    5000 ++                                                                 |
         *.*.*                                                              |
       0 ++-----------------------------------------------------------------+


                       lock_stat.vmap_area_lock.holdtime-total

   70000 ++-----------------------------------------------------------------+
         |                                       O                          |
   60000 O+  O    O   O        O    O   O    O        O   O    O   O    O   O
         |                 O                                                |
   50000 ++                                                                 |
         |                                                                  |
   40000 ++                                                                 |
         |                                                                  |
   30000 ++                                                                 |
         |                                                                  |
   20000 ++                                                                 |
         |                                                                  |
   10000 ++                                                                 |
         *...*....*                                                         |
       0 ++-----------------------------------------------------------------+


                       lock_stat.vmap_area_lock.holdtime-total

   45000 ++-----------------------------------------------------------------+
         |         O                                                      O |
   40000 O+    O O   O O O O   O O O O   O  O O     O O     O O O O O   O   O
   35000 ++O O               O         O        O O     O O           O     |
         |                                                                  |
   30000 ++                                                                 |
   25000 ++                                                                 |
         |                                                                  |
   20000 ++                                                                 |
   15000 ++                                                                 |
         |                                                                  |
   10000 ++                                                                 |
    5000 ++                                                                 |
         *.*.*.*                                                            |
       0 ++-----------------------------------------------------------------+


                        lock_stat.vmap_area_lock.holdtime-total

   400000 ++----------------------------------------------------------------+
          |               O        O             O O                 O      |
   350000 ++       O O  O   O O  O   O  O O O O      O  O O O O  O O   O  O O
          O    O O                                                          |
   300000 ++O                                                               |
   250000 ++                                                                |
          |                                                                 |
   200000 ++                                                                |
          |                                                                 |
   150000 ++                                                                |
   100000 ++                                                                |
          |                                                                 |
    50000 ++                                                                |
          |                                                                 |
        0 *+*--*-*----------------------------------------------------------+


                       lock_stat.vmap_area_lock.holdtime-total

   50000 ++-----------------O-------O----------------------------O--------O-+
   45000 O+   O O O   OOO    OO   O   O  O OO  O OOOO   O O   OOO   OO OO  O|
         |OO O   O  OO   O O   O O O O  O O  O  O     OO O         O  O     |
   40000 ++    O                                            OO              O
   35000 ++                                                                 |
         |                                                                  |
   30000 ++                                                                 |
   25000 ++                                                                 |
   20000 ++                                                                 |
         |                                                                  |
   15000 ++                                                                 |
   10000 ++                                                                 |
         |                                                                  |
    5000 ***.***                                                            |
       0 ++-----------------------------------------------------------------+


                        lock_stat.vmap_area_lock.holdtime-total

   120000 ++----------------------------------------------------------------+
          |                   O    O O           O   O                      |
   100000 ++              O      O          O O           O            O  O O
          |                               O        O    O   O    O   O      |
          |          O  O               O                                   |
    80000 ++                O                                 O             |
          |    O   O                                               O        |
    60000 O+O                                                               |
          |      O                                                          |
    40000 ++                                                                |
          |                                                                 |
          |                                                                 |
    20000 ++                                                                |
          |                                                                 |
        0 *+*--*-*-*--------------------------------------------------------+


                       lock_stat.vmap_area_lock.holdtime-total

   10000 ++-----------------------------------------------------------------+
    9000 ++             O    O    O O                 O         O    O      |
         O                O    O       O O  O O  O O    O  O O    O    O  O O
    8000 ++O  O O  O O                                                      |
    7000 ++                                                                 |
         |                                                                  |
    6000 ++                                                                 |
    5000 ++                                                                 |
    4000 ++                                                                 |
         |                                                                  |
    3000 ++                                                                 |
    2000 ++                                                                 |
         |                                                                  |
    1000 ++                                                                 |
       0 *+*--*-*--*-*------------------------------------------------------+


                        lock_stat.vmap_area_lock.holdtime-total

   300000 ++------------------O----------------------------------O-O--------O
          O O  O O O O  O O O    O O O    O O O  O O O  O O O O      O O  O |
   250000 ++                            O                                   |
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
          |                                                                 |
        0 *+*--*-*-*-*------------------------------------------------------+


                       lock_stat.vmap_area_lock.holdtime-total

   70000 ++-----------------------------------------O-----------------------+
         |      O  O  O           O O    O                   O              |
   60000 OO O  O O   O OO     OOO    O O   OOO OOO   O     OO   O OO  O  OOO|
         | O  O   O      OOO O   O    O O     O    O  OOO O   OO    OO O    O
   50000 ++                                                                 |
         |                                                                  |
   40000 ++                                                                 |
         |                                                                  |
   30000 ++                                                                 |
         |                                                                  |
   20000 ++                                                                 |
         |                                                                  |
   10000 ++                                                                 |
         ****.**                                                            |
       0 ++-----------------------------------------------------------------+


                       lock_stat.vmap_area_lock.holdtime-total

   50000 ++-----------------------------------------------------------------+
   45000 ++  O        O   O     O O        O         O O         OO O O   O O
         O O     O OO   O   O       O O O O  O O O O     O O O O        O   |
   40000 ++                   O                                             |
   35000 ++    O                                                            |
         |                                                                  |
   30000 ++                                                                 |
   25000 ++                                                                 |
   20000 ++                                                                 |
         |                                                                  |
   15000 ++                                                                 |
   10000 ++                                                                 |
         |                                                                  |
    5000 *+*.*.*.*.*                                                        |
       0 ++-----------------------------------------------------------------+


                       lock_stat.vmap_area_lock.holdtime-total

   60000 ++---------O----O------------O--------O--------------------------O-+
         O O    O O   O    O O      O   O    O   O O  O O O O  O O O O      O
   50000 ++  O                 O  O        O                            O   |
         |                                                                  |
         |                                                                  |
   40000 ++                                                                 |
         |                                                                  |
   30000 ++                                                                 |
         |                                                                  |
   20000 ++                                                                 |
         |                                                                  |
         |                                                                  |
   10000 ++                                                                 |
         *.*.*..*.*.*                                                       |
       0 ++-----------------------------------------------------------------+

    8cb06c983822103da1cf      20bafb3d23d108bc0a89  
------------------------  ------------------------  
                 3470.31     +1631.0%     60070.49  fat/micro/dd-write/1HDD-cfq-ext4-10dd
                 3339.57     +1676.9%     59340.71  fat/micro/dd-write/1HDD-cfq-ext4-1dd
                 2848.79     +1489.1%     45269.54  lkp-a04/micro/netperf/120s-200%-TCP_CRR
                 3563.01     +1515.2%     57548.50  lkp-a04/micro/netperf/120s-200%-TCP_MAERTS
                 2678.64     +1346.0%     38733.80  lkp-a04/micro/netperf/120s-200%-TCP_RR
                 2839.84     +1450.2%     44022.08  lkp-a04/micro/netperf/120s-200%-TCP_SENDFILE
                 3417.37     +1571.4%     57116.34  lkp-a04/micro/netperf/120s-200%-TCP_STREAM
                 2558.59     +1450.8%     39677.58  lkp-a04/micro/netperf/120s-200%-UDP_RR
                 3737.24     +1558.0%     61963.62  lkp-a04/micro/netperf/120s-200%-UDP_STREAM
                20219.50     +1488.7%    321218.02  lkp-a06/crypto/tcrypt/2s-200-204
                21017.17     +1457.1%    327257.41  lkp-a06/crypto/tcrypt/2s-205-210
                22109.84     +1240.3%    296346.33  lkp-a06/crypto/tcrypt/2s-401-417
                17909.60     +1467.3%    280693.71  lkp-a06/micro/dbench/100%
               489739.50      +978.5%   5281916.05  lkp-ne04/micro/aim7/shell_rtns_1
              1601675.63      +906.7%  16123642.52  lkp-snb01/micro/aim7/exec_test
                12105.00     +2453.6%    309110.42  nhm-white/micro/aim7/dbase
               822461.02     +1585.0%  13858430.62  nhm-white/micro/aim7/exec_test
                 9858.11     +2715.9%    277595.41  nhm-white/micro/aim7/fork_test
                 3452.91     +1685.5%     61650.74  nhm-white/micro/aim7/fserver
                  300.14     +2621.5%      8168.53  nhm-white/micro/aim7/misc_rtns_1
               345479.21     +1624.5%   5957828.25  nhm-white/micro/aim7/shell_rtns_1
                 2694.48     +1974.4%     55894.19  nhm-white/sysbench/oltp/100%-600-1000000
                 4415.67     +1202.2%     57501.52  nhm8/micro/dbench/100%
                 2284.65     +1505.2%     36672.75  snb-drag/crypto/tcrypt/2s-200-204
                 2446.02     +1537.1%     40042.87  snb-drag/crypto/tcrypt/2s-205-210
                 2484.11     +1599.6%     42219.71  snb-drag/crypto/tcrypt/2s-500-504
                 2118.55     +1155.8%     26604.99  vpx/crypto/tcrypt/2s-200-204
                 2713.48     +1198.5%     35234.77  vpx/crypto/tcrypt/2s-205-210
                 2711.31      +973.8%     29114.07  vpx/crypto/tcrypt/2s-301-319
                 2369.23      +940.3%     24648.12  vpx/crypto/tcrypt/2s-401-417
                 2620.64     +1428.7%     40060.71  vpx/crypto/tcrypt/2s-500-504
                 1713.98     +1624.3%     29553.72  vpx/crypto/tcrypt/2s-505-509
              3423353.12     +1184.9%  43985148.08  TOTAL lock_stat.vmap_area_lock.holdtime-total

                 lock_stat.vmap_area_lock.contentions.get_vmalloc_info

   200000 ++----------------------------------------------------------------+
          O  O   O  O   O      O  O   O  O                                  |
   180000 ++               O                 O      O  O   O  O   O  O   O  O
   160000 ++                                    O                           |
          |                                                                 |
   140000 ++                                                                |
   120000 ++                                                                |
          |                                                                 |
   100000 ++                                                                |
    80000 ++                                                                |
          |                                                                 |
    60000 ++                                                                |
    40000 ++                                                                |
          *..*...*..*...*..*...*..*...*..*                                  |
    20000 ++----------------------------------------------------------------+



                lock_stat.vmap_area_lock.contentions.get_vmalloc_info

   70000 ++-----------------------------------------------------------------+
         |                                                                  |
   60000 O+ O                                        O    O    O            O
         |    O  O O  O O  O  O O  O O  O  O O  O O    O     O    O O  O O  |
   50000 ++                                                                 |
         |                                                                  |
   40000 ++                                                                 |
         |                                                                  |
   30000 ++                                                                 |
         |                                                                  |
   20000 ++                                                                 |
         |                                                                  |
   10000 *+.*.*                                                             |
         |                                                                  |
       0 ++-----------------------------------------------------------------+



                lock_stat.vmap_area_lock.contentions.get_vmalloc_info

   30000 ++-----------------------------------------------------------------+
         O      O              O       O      O       O              O      |
   25000 ++             O                                    O              O
         |                                                                  |
         |                                                                  |
   20000 ++                                                                 |
         |                                                                  |
   15000 ++                                                                 |
         |                                                                  |
   10000 ++                                                                 |
         |                                                                  |
         |                                                                  |
    5000 *+.....*.......*......*.......*                                    |
         |                                                                  |
       0 ++-----------------------------------------------------------------+



                lock_stat.vmap_area_lock.contentions.get_vmalloc_info

   14000 ++-----------------------------------------------------------------+
         |             O                                                    |
   12000 ++O O O O O O   O O   O            O   O O O O O       O O O O     |
         O                   O   O O O O O    O           O O O         O O O
   10000 ++                                                                 |
         |                                                                  |
    8000 ++                                                                 |
         |                                                                  |
    6000 ++                                                                 |
         |                                                                  |
    4000 ++                                                                 |
         |                                                                  |
    2000 ++                                                                 |
         *.*.*.*.*.*.*.*.*.*                                                |
       0 ++-----------------------------------------------------------------+

    8cb06c983822103da1cf      20bafb3d23d108bc0a89  
------------------------  ------------------------  
                 4952.40      +447.0%     27090.40  lkp-ne04/micro/aim7/shell_rtns_1
                28410.80      +556.2%    186423.00  lkp-snb01/micro/aim7/exec_test
                 8142.00      +615.4%     58247.33  nhm-white/micro/aim7/exec_test
                 1386.00      +762.6%     11955.20  nhm-white/micro/aim7/shell_rtns_1
                42891.20      +561.5%    283715.93  TOTAL lock_stat.vmap_area_lock.contentions.get_vmalloc_info

                        lock_stat.vmap_area_lock.waittime-total

   1.2e+06 ++---------------------------------------------------------------+
           |             O                                                  |
     1e+06 O+ O   O                O  O   O                                 |
           |         O      O   O            O      O  O      O          O  O
           |                                     O         O      O  O      |
    800000 ++                                                               |
           |                                                                |
    600000 ++                                                               |
           |                                                                |
    400000 ++                                                               |
           |                                                                |
           |                                                                |
    200000 ++                                                               |
           |                                                                |
         0 *+-*---*--*---*--*---*--*--*---*---------------------------------+



                        lock_stat.vmap_area_lock.waittime-total

   250000 ++----------------------------------------------------------------+
          |      O  O                                                       |
          O             O  O   O  O   O  O   *..*...     ..*..*...  .*...*..|
   200000 ++ O                               :      *..*.         *.        *
          |                                 :                               |
          |                                 :                               |
   150000 ++                                :                               |
          |                                :                                |
   100000 ++                               :                                |
          |                                :                                |
          |                               :                                 |
    50000 ++                              :                                 |
          |                               :                                 |
          |                              :                                  |
        0 *+-*---*--*---*--*---*--*---*--*----------------------------------+



                        lock_stat.vmap_area_lock.waittime-total

   250000 ++----------------------------------------------------------------+
          |  O                                       O    O    O            O
          O    O  O O  O         O    O    O                 O      O    O  |
   200000 ++             O  O O    O    O     O O  O    O         O    O    |
          |                                                                 |
          |                                                                 |
   150000 ++                                                                |
          |                                                                 |
   100000 ++                                                                |
          |                                                                 |
          |                                                                 |
    50000 ++                                                                |
          |                                                                 |
          |                                                                 |
        0 *+-*-*------------------------------------------------------------+



                        lock_stat.vmap_area_lock.waittime-total

   120000 ++----------------------------------------------------------------+
          O      O              O      O       O      O              O      |
   100000 ++             O                                   O              |
          |                                                                 O
          |                                                                 |
    80000 ++                                                                |
          |                                                                 |
    60000 ++                                                                |
          |                                                                 |
    40000 ++                                                                |
          |                                                                 |
          |                                                                 |
    20000 ++                                                                |
          |                                                                 |
        0 *+-----*-------*------*------*------------------------------------+



                       lock_stat.vmap_area_lock.waittime-total

   60000 ++-----------------------------------------------------------------+
         |             O                                                    |
   50000 ++  O O O O O   O                  O   O O   O O       O O O O     |
         O O               O O O O   O O O    O     O     O O O         O O O
         |                         O                                        |
   40000 ++                                                                 |
         |                                                                  |
   30000 ++                                                                 |
         |                                                                  |
   20000 ++                                                                 |
         |                                                                  |
         |                                                                  |
   10000 ++                                                                 |
         |                                                                  |
       0 *+*-*-*-*-*-*-*-*-*------------------------------------------------+



                       lock_stat.vmap_area_lock.waittime-total

   3500 ++------------------------------------------------------------------+
        |             O                                                     |
   3000 ++                            O                                     |
        |                                                                   |
   2500 ++                                                                O |
        |                                                                   |
   2000 ++O                              O                                  |
        |                      O  O             O                  O O      |
   1500 ++   O          O  O                      O                         |
        O                                              O    O   O      O    |
   1000 ++     O    O        O             O                                O
        |        O                            O          O    O             |
    500 ++                          O                O                      |
        |                                                                   |
      0 *+*--*--------------------------------------------------------------+

    8cb06c983822103da1cf      20bafb3d23d108bc0a89  
------------------------  ------------------------  
                 1990.41     +5378.7%    109049.26  lkp-ne04/micro/aim7/shell_rtns_1
                18611.42     +5349.4%   1014205.59  lkp-snb01/micro/aim7/exec_test
                 4171.17     +5040.7%    214427.74  lkp-snb01/micro/aim7/shell_rtns_1
                   10.18    +14277.7%      1463.17  nhm-white/micro/aim7/dbase
                 1715.53    +12791.3%    221153.70  nhm-white/micro/aim7/exec_test
                  325.21    +15376.6%     50331.77  nhm-white/micro/aim7/shell_rtns_1
                26823.92     +5904.5%   1610631.24  TOTAL lock_stat.vmap_area_lock.waittime-total



                         lock_stat.vmap_area_lock.contentions

   100000 ++----------------------------------------------------------------+
          O  O   O  O   O      O  O   O  O                                  |
    90000 ++               O                 O      O  O   O  O   O  O   O  O
    80000 ++                                    O                           |
          |                                                                 |
    70000 ++                                                                |
    60000 ++                                                                |
          |                                                                 |
    50000 ++                                                                |
    40000 ++                                                                |
          |                                                                 |
    30000 ++                                                                |
    20000 ++                                                                |
          *..*...*..*...*..*...*..*...*..*                                  |
    10000 ++----------------------------------------------------------------+



                        lock_stat.vmap_area_lock.contentions

   35000 ++-----------------------------------------------------------------+
         |                                                                  |
   30000 O+ O                                        O    O    O            O
         |    O  O O  O O  O  O O  O O  O  O O  O O    O     O    O O  O O  |
   25000 ++                                                                 |
         |                                                                  |
   20000 ++                                                                 |
         |                                                                  |
   15000 ++                                                                 |
         |                                                                  |
   10000 ++                                                                 |
         |                                                                  |
    5000 *+.*.*                                                             |
         |                                                                  |
       0 ++-----------------------------------------------------------------+



                        lock_stat.vmap_area_lock.contentions

   14000 O+-----O-----------------------------O-------O--------------O------+
         |              O      O       O                     O              O
   12000 ++                                                                 |
         |                                                                  |
         |                                                                  |
   10000 ++                                                                 |
         |                                                                  |
    8000 ++                                                                 |
         |                                                                  |
    6000 ++                                                                 |
         |                                                                  |
         |                                                                  |
    4000 ++                                                                 |
         *......    ....*......*.......*                                    |
    2000 ++-----*-----------------------------------------------------------+

    8cb06c983822103da1cf      20bafb3d23d108bc0a89  
------------------------  ------------------------  
                 2476.20      +447.0%     13545.20  lkp-ne04/micro/aim7/shell_rtns_1
                14205.40      +556.2%     93211.50  lkp-snb01/micro/aim7/exec_test
                 4071.00      +615.4%     29123.67  nhm-white/micro/aim7/exec_test
                20752.60      +554.8%    135880.37  TOTAL lock_stat.vmap_area_lock.contentions



                         lock_stat.vmap_area_lock.con-bounces

   100000 ++----------------------------------------------------------------+
          O  O   O  O   O      O  O   O  O                                  |
    90000 ++               O                 O      O  O   O  O   O  O   O  O
    80000 ++                                    O                           |
          |                                                                 |
    70000 ++                                                                |
    60000 ++                                                                |
          |                                                                 |
    50000 ++                                                                |
    40000 ++                                                                |
          |                                                                 |
    30000 ++                                                                |
    20000 ++                                                                |
          *..*...*..*...*..*...*..*...*..*                                  |
    10000 ++----------------------------------------------------------------+



                        lock_stat.vmap_area_lock.con-bounces

   35000 ++-----------------------------------------------------------------+
         |                                                                  |
   30000 O+ O                                        O    O    O            O
         |    O  O O  O O  O  O O  O O  O  O O  O O    O     O    O O  O O  |
   25000 ++                                                                 |
         |                                                                  |
   20000 ++                                                                 |
         |                                                                  |
   15000 ++                                                                 |
         |                                                                  |
   10000 ++                                                                 |
         |                                                                  |
    5000 *+.*.*                                                             |
         |                                                                  |
       0 ++-----------------------------------------------------------------+



                        lock_stat.vmap_area_lock.con-bounces

   14000 O+-----O-----------------------------O-------O--------------O------+
         |              O      O       O                     O              O
   12000 ++                                                                 |
         |                                                                  |
         |                                                                  |
   10000 ++                                                                 |
         |                                                                  |
    8000 ++                                                                 |
         |                                                                  |
    6000 ++                                                                 |
         |                                                                  |
         |                                                                  |
    4000 ++                                                                 |
         *......    ....*......*.......*                                    |
    2000 ++-----*-----------------------------------------------------------+

    8cb06c983822103da1cf      20bafb3d23d108bc0a89  
------------------------  ------------------------  
                 2476.20      +447.0%     13545.20  lkp-ne04/micro/aim7/shell_rtns_1
                14205.40      +556.2%     93211.50  lkp-snb01/micro/aim7/exec_test
                 4071.00      +615.4%     29123.67  nhm-white/micro/aim7/exec_test
                20752.60      +554.8%    135880.37  TOTAL lock_stat.vmap_area_lock.con-bounces

                                 time.system_time

   550 ++--------------------------------------O------O----------O----------+
   540 ++                                          O      O  O       O  O   O
       |                                   O                                |
   530 ++                                                                   |
   520 ++                                                                   |
       |                                                                    |
   510 ++                                                                   |
   500 ++                                                                   |
   490 ++                                                                   |
       |                                                                    |
   480 O+                       O                                           |
   470 *+..           O  O   O      O   O                                   |
       |   *..*.. O  .*..         ..*...                                    |
   460 ++        . ..    *...*..*.      *                                   |
   450 ++---------*---------------------------------------------------------+



                                 time.system_time

   30 ++--------------------------------------------------------------------+
      |                           O                                         |
      |                                                                     |
   25 ++                                                                    |
      |                                                                     |
      |                                                                     |
   20 ++                                                                    |
      |                                                                     |
   15 O+                   O                           O      O             O
      |                                                                     |
      |      O      O                           O                           |
   10 ++                                                                    |
      *......    ...*......*             O                           O      |
      |      *...                                                           |
    5 ++--------------------------------------------------------------------+



                                 time.system_time

   740 ++-------------------------------------------------------------------+
       |              O               O                                     |
   730 ++                     O                                             |
   720 O+                                                                   |
       |       O                                                            |
   710 ++                                                                   |
       |                                                                    |
   700 ++                                                                   |
       |                                                     O      O       |
   690 ++                                                                   |
   680 ++  ....*......    ....*.....         O       O                      |
       *...           *...          ..                                      |
   670 ++                             *                                     O
       |                                                                    |
   660 ++-------------------------------------------------------------------+

    8cb06c983822103da1cf      20bafb3d23d108bc0a89  
------------------------  ------------------------  
                  677.85        +7.4%       728.28  lkp-ne04/micro/aim7/shell_rtns_1
                  459.71        +2.4%       470.66  lkp-snb01/micro/aim7/exec_test
                    8.05       +80.1%        14.49  vpx/crypto/tcrypt/2s-505-509
                 1145.61        +5.9%      1213.42  TOTAL time.system_time



                                  time.user_time

   48 ++---------------------------------------------------------O----------+
      |                                        O      O                     |
   47 ++                                          O                         |
   46 ++                                                  O  O       O  O   O
      |                                    O                                |
   45 ++                                                                    |
      O                                                                     |
   44 ++                    O      O   O                                    |
      |              O  O       O                                           |
   43 *+..*..O   O                                                          |
   42 ++     *..                *..*..                                      |
      |         .  ..*..*..   ..      .                                     |
   41 ++         *.        . .         *                                    |
      |                     *                                               |
   40 ++--------------------------------------------------------------------+



                                  time.user_time

   162 ++-----------------------------O-------------------------------------+
       O                                                                    |
   160 ++             O       O                                             |
   158 ++                                                                   |
       |                                                                    |
   156 ++      O                                                            |
       |                                                                    |
   154 ++                                                    O              |
       |                                                                    |
   152 ++                                    O                              |
   150 ++                    .*...                   O              O       |
       |     ..*...        ..     ...                                       |
   148 ++....      ..    ..          .                                      O
       *.            . ..             *                                     |
   146 ++-------------*-----------------------------------------------------+

    8cb06c983822103da1cf      20bafb3d23d108bc0a89  
------------------------  ------------------------  
                  148.19        +7.8%       159.75  lkp-ne04/micro/aim7/shell_rtns_1
                   41.96        +3.6%        43.49  lkp-snb01/micro/aim7/exec_test
                  190.15        +6.9%       203.23  TOTAL time.user_time



                                   iostat.cpu.idle

     34 ++---------------------*--------------------------------------------+
        |                ....        .                                      |
        *.......*......*.             *                                     |
   33.5 O+             O                                                    |
        |                      O      O                                     |
        |       O                                                           |
     33 ++                                                                  |
        |                                                                   |
   32.5 ++                                                                  |
        |                                                                   |
        |                                            O                      |
     32 ++                                                                  O
        |                                                                   |
        |                                     O              O      O       |
   31.5 ++------------------------------------------------------------------+

    8cb06c983822103da1cf      20bafb3d23d108bc0a89  
------------------------  ------------------------  
                   33.75        -1.3%        33.31  lkp-ne04/micro/aim7/shell_rtns_1
                   33.75        -1.3%        33.31  TOTAL iostat.cpu.idle



                         time.percent_of_cpu_this_job_got

   270 ++--------------------------------------O------O----------O------O---+
       |                                           O      O  O       O      O
   265 ++                                  O                                |
       |                                                                    |
       |                                                                    |
   260 ++                                                                   |
       |                                                                    |
   255 ++                                                                   |
       O                     O  O       O                                   |
   250 ++             O                                                     |
       *...   O          O          O                                       |
       |   *..    O   *..         ..*..                                     |
   245 ++     *..   ..         .*.     .                                    |
       |         . .     *...*.         *                                   |
   240 ++---------*---------------------------------------------------------+



                         time.percent_of_cpu_this_job_got

   555 ++-------------------------------------------------------------------+
   550 ++                             O                                     |
       |              O       O                                             |
   545 O+                                                                   |
   540 ++      O                                                            |
       |                                                     O              |
   535 ++                                                           O       |
   530 ++                                    O                              |
   525 ++                                                                   |
       |                                             O                      |
   520 ++                                                                   |
   515 ++                   ..*.....                                        O
       *.......*......  ....        ..                                      |
   510 ++             *.              *                                     |
   505 ++-------------------------------------------------------------------+

    8cb06c983822103da1cf      20bafb3d23d108bc0a89  
------------------------  ------------------------  
                  510.40        +7.1%       546.60  lkp-ne04/micro/aim7/shell_rtns_1
                  244.60        +2.1%       249.80  lkp-snb01/micro/aim7/exec_test
                  755.00        +5.5%       796.40  TOTAL time.percent_of_cpu_this_job_got



                                  iostat.cpu.system

   34.2 ++------------------------------------------O-----------------------O
        |                             O                                  O  |
     34 ++       O                 O                            O           |
        |              O                               O  O  O     O  O     |
   33.8 ++          O        O  O          O  O                             |
        |                 O                      O                          |
   33.6 ++                               O                                  |
        |                                                                   |
   33.4 ++                                                                  |
        |                                                                   |
   33.2 ++                                                                  |
        |  O  O                                                             |
     33 *+.                                                                 |
        |  *..*                                                             |
   32.8 ++------------------------------------------------------------------+



                                  iostat.cpu.system

   34.4 ++------------------------------------------------------------------+
        |                           O                                       O
   34.2 ++                            O  O      O    O    O    O    O       |
        |              O  O    O O         O       O              O    O O  |
     34 ++                                              O    O              |
        |                   O                 O                             |
   33.8 ++                                                                  |
        |                                                                   |
   33.6 ++                                                                  |
        *..O      O  O                                                      |
   33.4 O+   O    *..                                                       |
        |  *.*..O:   *                                                      |
   33.2 ++       :                                                          |
        |       *                                                           |
     33 ++------------------------------------------------------------------+



                                  iostat.cpu.system

   56.6 ++----------------------------------------------------------O-------+
   56.4 ++                                    O              O              |
        |                                                                   O
   56.2 ++                                           O                      |
     56 ++                                                                  |
        |                                                                   |
   55.8 ++                                                                  |
   55.6 ++                                                                  |
   55.4 ++      O                                                           |
        |              O       O      O                                     |
   55.2 O+                                                                  |
     55 *+......*......                                                     |
        |              *.......    ...*                                     |
   54.8 ++                     *...                                         |
   54.6 ++------------------------------------------------------------------+

    8cb06c983822103da1cf      20bafb3d23d108bc0a89  
------------------------  ------------------------  
                   32.94        +0.4%        33.07  lkp-a06/crypto/tcrypt/2s-200-204
                   33.31        +0.4%        33.44  lkp-a06/crypto/tcrypt/2s-205-210
                   54.91        +0.8%        55.33  lkp-ne04/micro/aim7/shell_rtns_1
                  121.17        +0.6%       121.83  TOTAL iostat.cpu.system



                                  vmstat.system.in

   65500 ++-----------------------------------------------------------------+
         |     .*...         .*...  .*..                                    |
         *...*.     *..*...*.     *.    .                                   |
   65000 ++                              *                                  |
         |   O  O   O                                                       |
         |                                                                  |
   64500 O+            O   O  O      O   O                                  |
         |                        O                                         |
   64000 ++                                                                 |
         |                                                                  |
         |                                                                  |
   63500 ++                                 O                               |
         |                                         O   O  O   O      O      |
         |                                      O                       O   O
   63000 ++------------------------------------------------------O----------+



                                  vmstat.system.in

   20600 ++-----*-------*---------------------------------------------------+
         | .... O              *.......*                                    |
   20500 *+                                                                 |
   20400 ++                                                                 |
         O              O      O                                            |
   20300 ++                            O                                    |
         |                                                                  |
   20200 ++                                                                 |
         |                                                                  |
   20100 ++                                                                 |
   20000 ++                                                                 |
         |                                                                  |
   19900 ++                                                                 |
         |                                                           O      |
   19800 ++-----------------------------------O-------O------O--------------O



                                  vmstat.system.in

   1090 ++------------------------------------------------------------------+
        |  .*.*                                                             |
   1088 *+*                                                             O   |
   1086 ++                                     O                            |
        |         O        O                                                |
   1084 ++    O                O     O     O                      O         |
   1082 ++      O       O                    O   O            O             |
        |                              O           O        O               |
   1080 ++O                        O                     O      O   O       |
   1078 ++                                                                  |
        |   O                            O           O                      O
   1076 ++          O            O                     O                  O |
   1074 O+            O                                                     |
        |                    O                                        O     |
   1072 ++------------------------------------------------------------------+

    8cb06c983822103da1cf      20bafb3d23d108bc0a89  
------------------------  ------------------------  
                20557.20        -0.8%     20384.60  lkp-ne04/micro/aim7/shell_rtns_1
                65159.10        -1.0%     64507.71  lkp-snb01/micro/aim7/exec_test
                 1088.00        -0.9%      1078.50  snb-drag/crypto/tcrypt/2s-200-204
                86804.30        -1.0%     85970.81  TOTAL vmstat.system.in



                                 time.elapsed_time

   222 ++-------------------------------------------------------------------+
       |                                   O       O  O          O          |
   220 ++                                      O          O  O       O  O   O
   218 ++                                                                   |
       |                                                                    |
   216 ++                                                                   |
   214 ++                                                                   |
       |                                                                    |
   212 ++                                                                   |
   210 ++                                                                   |
       |                                                                    |
   208 ++                                                                   |
   206 ++                                                                   |
       *...*..*...O ..*..*...O .*...*...*                                   |
   204 ++---------*----------*----------------------------------------------+



                                  time.elapsed_time

   160.5 ++-----------------------------------------------------------------+
     160 ++                   O   O                                         |
         O ..*..O   O               .*...O                                  |
   159.5 *+     *...*..*...*..*...*. O   *                                  |
     159 ++                              :                                  |
         |                                :                                 |
   158.5 ++                               :                                 |
     158 ++                                :                                |
   157.5 ++                                :                                |
         |                                 :                                |
     157 ++                                 :                    *...       |
   156.5 ++                                 *...          *... ..    *..    |
         |                                      *..*... ..    *         *...|
     156 ++                                            *                    *
   155.5 ++-----------------------------------------------------------------+



                                 time.elapsed_time

   280 ++-------------------------------------------------------------------+
       |       O  O    O          O         O    O  O    O     O            |
   279 ++           O     O O       O  O  O    O            O    O  O  O O  O
   278 ++                      O                       O                    |
       |                                                                    |
   277 ++                                                                   |
   276 ++                                                                   |
       |                                                                    |
   275 ++                                                                   |
   274 ++                                                                   |
       |                                                                    |
   273 ++ O                                                                 |
   272 O+                                                                   |
       *..*.*                                                               |
   271 ++-------------------------------------------------------------------+



                                  time.elapsed_time

     602 ++--O--------------------------------------------------------------+
         |                                                                  |
   601.8 ++                                                                 |
   601.6 ++                                                                 O
         |                                                                  |
   601.4 ++                                  O                              |
   601.2 ++           O                                   O                 |
         |                     O                                            |
     601 ++       O                 O   O                      O            |
   600.8 O+                                           O            O        |
         *..               O                                                |
   600.6 ++ .                                    O                          |
   600.4 ++  *....                                                      O   |
         |        *                                                         |
   600.2 ++-----------------------------------------------------------------+

    8cb06c983822103da1cf      20bafb3d23d108bc0a89  
------------------------  ------------------------  
                  600.51        +0.1%       601.28  fat/micro/dd-write/1HDD-cfq-ext4-10dd
                  204.81        +0.3%       205.38  lkp-snb01/micro/aim7/exec_test
                  159.50        +0.2%       159.77  lkp-snb01/micro/aim7/shell_rtns_1
                  271.47        +0.4%       272.49  nhm-white/micro/aim7/exec_test
                 1236.29        +0.2%      1238.92  TOTAL time.elapsed_time



                                  vmstat.system.cs

   61600 ++-----------------------------------------------------------------+
         |                                                                  |
   61400 ++                                                                 *
   61200 ++                   *..                                          +|
         |                  ..   ..        ..*....                        + |
   61000 ++                .          ..*..       *....         ..*...   +  |
         |               ..        *..                 *.....*..      . +   |
   60800 ++       .*....*                                              *    |
         *....  ..                                                          |
   60600 ++   *.                             O         O                    |
   60400 ++   O                                                             |
         O                    O         O         O                         |
   60200 ++        O    O          O                                        |
         |                                                                  |
   60000 ++-----------------------------------------------------------------+



                                  vmstat.system.cs

   19200 ++--------------------O--------------------------------------------+
         |                                                                  |
   19100 ++                                                                 |
         |                                                                  |
         |                                                                  |
   19000 ++                                                                 |
         |                                                                  |
   18900 ++            O                              O                     |
         |          OO   O                                                  |
   18800 ++     O                       O   O      O     O  O        O      O
         | O     O        O     OOOO OOO       OO O  O     O  O   O   OOO  O|
         |O  O     O       OO              O OO     O   O                 O |
   18700 *+   OO      O                  O                O    OOO  O       |
         O**.***             O                                              |
   18600 ++-----------------------------------------------------------------+



                                  vmstat.system.cs

   49100 ++-----------------------------------------------------------------+
         |          ....*..                                                 |
   49000 ++    .*...       ..                                               |
         | ....              ..                                             |
   48900 *+                        ....*                             O      |
         |      O              *...                                         |
   48800 ++                                                  O              |
         |                                    O                             O
   48700 ++                                                                 |
         |                                            O                     |
   48600 ++                                                                 |
         |              O                                                   |
   48500 O+                                                                 |
         |                                                                  |
   48400 ++--------------------O-------O------------------------------------+



                                 vmstat.system.cs

   732 ++--*----------------------------------------------------------------+
       *.*  +                                                  O            |
   730 ++    *   O                    O        O                    O       |
       | O O O            O         O              O              O       O |
   728 ++                     O                                         O   |
       |            O   O                        O       O   O        O     O
   726 O+      O      O           O     O    O       O     O                |
       |                                                                    |
   724 ++                                  O                                |
       |                                               O                    |
   722 ++                                                                   |
       |                        O                                           |
   720 ++                   O                                               |
       |                                                                    |
   718 ++-------------------------------------------------------------------+

    8cb06c983822103da1cf      20bafb3d23d108bc0a89  
------------------------  ------------------------  
                18644.50        +0.3%     18702.67  lkp-a04/micro/netperf/120s-200%-UDP_RR
                48938.00        -0.8%     48539.80  lkp-ne04/micro/aim7/shell_rtns_1
                60751.18        -0.6%     60359.04  lkp-nex05/micro/aim7/exec_test
                  731.00        -0.4%       728.25  snb-drag/crypto/tcrypt/2s-200-204
               129064.68        -0.6%    128329.76  TOTAL vmstat.system.cs
