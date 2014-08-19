Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaHSRwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:52:53 -0400
Received: from mga14.intel.com ([192.55.52.115]:1098 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbaHSRww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:52:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,896,1400050800"; 
   d="scan'208";a="578881022"
Date: Wed, 20 Aug 2014 01:52:39 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Mel Gorman <mgorman@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [mm] 3484b2de949: -56.2% vm-scalability.throughput, +9.3%
 turbostat.Pkg_W
Message-ID: <20140819175239.GB8019@localhost>
References: <20140819043252.GA8798@localhost>
 <20140819142925.GB10146@suse.de>
 <20140819155125.GB2697@localhost>
 <20140819171358.GE10146@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140819171358.GE10146@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 06:13:58PM +0100, Mel Gorman wrote:
> On Tue, Aug 19, 2014 at 11:51:25PM +0800, Fengguang Wu wrote:
> > On Tue, Aug 19, 2014 at 03:29:25PM +0100, Mel Gorman wrote:
> > > On Tue, Aug 19, 2014 at 12:32:52PM +0800, Fengguang Wu wrote:
> > > > Hi Mel,
> > > > 
> > > > We noticed the below vm-scalability performance/power regressions on
> > > > commit 3484b2de9499df23c4604a513b36f96326ae81ad ("mm: rearrange zone
> > > > fields into read-only, page alloc, statistics and page reclaim lines").
> > > > 
> > > > 24b7e5819ad5cbe  3484b2de9499df23c4604a513  testbox/testcase/testparams
> > > > ---------------  -------------------------  ---------------------------
> > > >      %stddev        %change               %stddev
> > > >             \          |                 /
> > > >       9.95 ± 2%     +69.1%      16.83 ± 5%  brickland3/vm-scalability/300s-lru-file-mmap-read
> > > >       2.32 ± 6%    +229.4%       7.63 ± 5%  brickland3/vm-scalability/300s-lru-file-readonce
> > > >      12.27 ± 3%     +99.4%      24.46 ± 5%  TOTAL vm-scalability.stddev
> > > > 
> > > > 24b7e5819ad5cbe  3484b2de9499df23c4604a513  
> > > > ---------------  -------------------------  
> > > >   13882598 ± 0%     -35.8%    8915310 ± 1%  brickland3/vm-scalability/300s-lru-file-mmap-read
> > > >   36379953 ± 1%     -64.0%   13093373 ± 0%  brickland3/vm-scalability/300s-lru-file-readonce
> > > >   50262551 ± 0%     -56.2%   22008683 ± 0%  TOTAL vm-scalability.throughput
> > > > 
> > > 
> > > 
> > > What units are these? It's completely unclear what is good and bad from the
> > > figures. 300s-lru-file-mmap-read appears multiple times in this report,
> > > each with different numbers beside them but little clue as to what they
> > > mean or what I'm meant to be looking for :(
> > 
> > Sorry the output format is a bit obscure: the stats names are after
> > the "TOTAL" word, such as TOTAL vm-scalability.stddev, TOTAL
> > vm-scalability.throughput, ...
> > 
> > > This is the same patch that was reported as having a performance gain in
> > > another set of tests from lkp so am a little confused.
> > 
> > That can happen some times -- we've seen some commits to benefit some
> > workloads while hurting some others. I'm now running more complete
> > test set for the commit, hopefully can get some results tomorrow.
> > 
> > > More importantly, as this patch is primary abougt cache misses it should
> > > be very unlikely that it makes a noticable difference to IO as the
> > > relative cost of a cache miss is so low. Similarly any difference it
> > > makes to reclaim activity is likely to be a coincidence or due to test
> > > variance.
> > 
> > The test case creates tmpfs files and read them fast to exercise the LRU.
> > So it's VM test and do not involve disk IO.
> > 
> 
> Ok. How reliable is this? I was reading down through some of the figures and
> some of them are extremely different in areas that this patch should have
> no impact on -- it's just rearranging a struct after all.

Yup. One difficulty with performance testing is that we sometimes
bisect into commit whose change set is obviously not related to the
changed performance.. and the bisect itself looks good.

> I note for example that automatic NUMA balancing was enabled and
> there was activity from it so pages are getting migrated.  There is
> a large amount of reclaim activity on different nodes so where the
> test case gets scheduled and how nodes it runs on during the test
> matters. What I'm wondering is if the performance of the test tends
> to vary quite a lot naturally. Can you check if the performance is
> consistently lower after this patch or if it tends to vary please?

At least for vm-scalability.throughput, it's pretty stable over *all*
the kernels tested during the bisect. Which is a strong indication
that the bisect process itself is fine.

mmap-read:

                               vm-scalability.throughput

  1.5e+07 ++----------------------------------------------------------------+
          |                                                                 |
  1.4e+07 *+*..*.*.*.*..*.*.*.*..*.*.*..*.*. .*..*.*.*..*.*                 |
          |                                 *                               |
  1.3e+07 ++                                                                |
          |                                                                 |
  1.2e+07 ++                                                                |
          |                                                                 |
  1.1e+07 ++                                                                |
          |                                                                 |
    1e+07 ++                                                                |
          |                                                                 |
    9e+06 O+O  O O O O  O O O O  O O O    O   O  O O O  O O O O    O O    O O
          |                             O   O                    O     O    |
    8e+06 ++----------------------------------------------------------------+

        [*] bisect-good sample
        [O] bisect-bad  sample

readonce:

                               vm-scalability.throughput

    4e+07 ++----*-----*----**-----------------------------------------------+
          *****  ***** *.**  *****.* * ** *. *   *                          |
  3.5e+07 ++                        * *  *  * *** *                         |
          |                                                                 |
          |                                                                 |
    3e+07 ++                                                                |
          |                                                                 |
  2.5e+07 ++                                                                |
          |                                                                 |
    2e+07 ++                                                                |
          |                                                                 |
          |                                                                 |
  1.5e+07 OOOOO OOO OOOO OOOOOOOOO OOO OOOO  OOOOOOO OOOOOOOOO OOO          |
          |        O                  O     O                     OOOOO OOOOO
    1e+07 ++----------------------------------------------------------------+

Here are more graphs for other stats in the readonce case, which can
give us a visual impression which stats are stable and have clear
separable values before/after the first bad commit.

                                  time.user_time

  105 ++--------------------------------------------------------------------+
      |                              O O   O O                              |
  100 ++                            O O O O O O O O  O OOOO                 |
      | O OO                                     O OO                     O O
      OO                                                         O O   OO  O|
   95 ++    OOOO OOO   OOO    OO                             O OO   OOO     |
      |       * .* :OO    OO O  OOO                        O  O             |
   90 ++      :*   *      * .***                                            |
      ***.***:      :*.*  :*   :                                            |
   85 ++     *      *   **      :  .*        * .**                          |
      |                         * *  * **. ** *                             |
      |                          ::   *   *                                 |
   80 ++                         *                                          |
      |                                                                     |
   75 ++--------------------------------------------------------------------+


                                  time.system_time

  40000 ++------------------------------------------------------------------+
        |                                                                   |
  35000 OOOO OOOOOO OOOOOOO OOOOOO OOOOOOO OOOOOOO OOOOOO OOOOOOO OOOOOO OOOO
        |                                                                   |
        |                                                                   |
  30000 ++                                                                  |
        |                                                                   |
  25000 ++                                                                  |
        |                                                                   |
  20000 ++                                                                  |
        |                                                                   |
        |                                                                   |
  15000 ****.* ****.* ***  .**** *.*******.*******                          |
        |     *      *   **     *                                           |
  10000 ++------------------------------------------------------------------+


                         time.percent_of_cpu_this_job_got

  9000 +O--OO---------------------------------------------------------------+
       O O   O OO O OO    OOOOO O    O  O  O  O  O     OO O      O OOOOOO OOO
  8500 ++     O    O  OO O       OOOO  O OO O  OO OO OO  O  OOOOO           |
       |                                                                    |
       |                                                                    |
  8000 ++                                                                   |
       |                                                                    |
  7500 ++                                                                   |
       |                                                                    |
  7000 ++                                                                   |
       |                                                                    |
       | *.     *.            *. ****     * *.** *                          |
  6500 **  *****  ******.*****  *    *.*** *    *                           |
       |                                                                    |
  6000 ++-------------------------------------------------------------------+


                                 time.elapsed_time

  450 ++--------------------------------------------------------------------+
      |                                                                     |
      |      O   OO  O OOOO   O OOO O OOO O OOO OO OO    O O OOO       OO   |
  400 OOO OOO OO   OO      O O O     O     O      O  O OO O     OO OOOO   OOO
      |                                                                     |
      |                                                                     |
  350 ++                                                                    |
      |                                                                     |
  300 ++                                                                    |
      |                                                                     |
      |                                                                     |
  250 ++                                                                    |
      |                                                                     |
      *      * *.   * .*        ***.*****.*****.**                          |
  200 +**-***-*--***-*--****-***--------------------------------------------+


                               time.minor_page_faults

  126000 ++-----------------------------------------------------------------+
         |                                                                  O
  125000 ++                                                        OO OO  O |
  124000 ++ O O   O    O               O  O O   O O     O        OO        O|
         |     OOO  OO   O  O    O O O  OO O OO  O O     O OO O O    O      |
  123000 OO        O      OO O OO O           *.*   OOO      O              |
  122000 ++O       *       *    *  *O*   * *  : :         O              O  |
         |       ** * .*O* : *. :: :* : * ::*:   :*                         |
  121000 ++      :   *  * * :: * **   : : *  *   *                          |
  120000 ++      :          *          *                                    |
         |       :                                                          |
  119000 *+* .* :                                                           |
  118000 +* *  ::                                                           |
         |     **                                                           |
  117000 ++-----------------------------------------------------------------+


                          time.voluntary_context_switches

  5000 ++-------------------------------------------------------------------+
       |                                                                    |
       |                                                                    |
  4500 ++                                      *                            |
       |        *.    *      *          * *  .*:                            |
       |        : * ** :  *  :*.* *     :*: *   :*                          |
  4000 +**.*****   *   *.* :*    :::*  :   ::   *                           |
       *                   *     * * *.*   :                                |
  3500 ++                                  *                                |
       |                                                                    O
       |                                                           O  O     |
  3000 ++  O                                                     O  OO O  OO|
       |      O O      O   OOOO   O OO  OOOO  OOOO     O    OO          O   |
       OOO  OO O  OOOOO  OO      O O   O    O     OO OO OOO   O O           |
  2500 ++-----------------------O------------------------------O------------+


                          time.involuntary_context_switches

  300000 ++-----------------------------------------------------------------+
         |OO  OOOOOOOO O  OOOO O   OOO  O OO O  OOOOOOO  OOO OO OOOOOO O OO O
  280000 O+ O           OO      OOO    O O  O O         O   O         O    O|
         |                                                                  |
  260000 ++                                                                 |
         |                                                                  |
  240000 ****.***                                                           |
         |      :                                                           |
  220000 ++     :                                                           |
         |      :                                                           |
  200000 ++      :                                                          |
         |       :                                                          |
  180000 ++      :                                                          |
         |       :*   .* *      * ****.********.***                         |
  160000 ++------*-***--*-****-*-*------------------------------------------+


                                    uptime.boot

  500 ++--------------------------------------------------------------------+
      |                                                                     |
      |     OOOO OO OO OOOOO OOOOOO OOOOO OOOOO OOOOOO OOOOO OOOOO OOO OO OO|
  450 OOO OO       O                                                  O     O
      |                                                                     |
      |                                                                     |
  400 ++                                                                    |
      |                                                                     |
  350 ++                                                                    |
      |                                                                     |
      |                                                                     |
  300 ++                                                                    |
      |                                                                     |
      ***.******.** **.*  **.** ***.*****.*****.**                          |
  250 ++-----------*----**-----*--------------------------------------------+


                               vm-scalability.throughput

    4e+07 ++----*-----*----**-----------------------------------------------+
          *****  ***** *.**  *****.* * ** *. *   *                          |
  3.5e+07 ++                        * *  *  * *** *                         |
          |                                                                 |
          |                                                                 |
    3e+07 ++                                                                |
          |                                                                 |
  2.5e+07 ++                                                                |
          |                                                                 |
    2e+07 ++                                                                |
          |                                                                 |
          |                                                                 |
  1.5e+07 OOOOO OOO OOOO OOOOOOOOO OOO OOOO  OOOOOOO OOOOOOOOO OOO          |
          |        O                  O     O                     OOOOO OOOOO
    1e+07 ++----------------------------------------------------------------+


                              vm-scalability.stddev

  10 ++---------------------------------------------------------------------+
     |     O         O         O  O O     O           O                     |
   9 ++     O  O      O  O O  O                O  OO       OO               |
   8 +OO O         O   O     O   O O   OOO   OO O    O    O   OOO     OO   O|
     O    O  O  OOO     O            O      O       O   OO        O O   O O O
   7 ++                     O                                    O   O      |
   6 ++                                                                     |
     |                                                                      |
   5 ++                                                                     |
   4 ++                                                                     |
     |                                                                      |
   3 +**. *   .*** *.* *                                                    |
   2 *+  * :**    *   * **.*****.*****.****.*****                           |
     |     *                                                                |
   1 ++---------------------------------------------------------------------+




  50 ++-------------------------------------------------------O-------------+
     |          O    O            O                            OO    O      |
  45 OO   OOOO    O            O    O     O    OO   O O O OOO    O          |
  40 ++O       O O O  OOOO    O                    O O            O       OOO
     |                     OO    O O O O O  OO    O                 O   O   |
  35 ++  O                              O     O          O            O     |
     |                       O                                         O    |
  30 ++                                                                     |
     |                                                                      |
  25 ++                                                                     |
  20 ** .*  * .*   *. *      *            *.*****                           |
     | *  ** * : **  * ***.** **.*****. **                                  |
  15 ++         ::                     *                                    |
     |          *                                                           |
  10 ++---------------------------------------------------------------------+




  50 ++---------------------------------------------------------------------+
     |                       O   O   O O    OO                      O O O   |
  45 ++O O       O O    OO    O                   OO              O    O   OO
     OO   OOO  O      OO       O    O   O O   OOO    O  O OO              O |
     |       O    O         O     OO     O          O O  O  O    O   O      |
  40 ++         O          O                                  OOO           |
     |               O                                                      |
  35 ++                                                                     |
     |          *                                                           |
  30 ++      *. :**      *.   **                                            |
     ***.   *  *   *.*  *  ***  : ***     *.**                              |
     |   ***          **        : :  :.***    **                            |
  25 ++                          :   *          *                           |
     |                           *                                          |
  20 ++---------------------------------------------------------------------+




  11 ++---------*-----------------------------------------------------------+
     |          :                                                           |
  10 ++         :                                                           |
   9 ++         :                                                           |
     |         : :                                                          |
   8 ++        : :     **              *                                    |
   7 ++*. ****.* :* .**  *.*****.**** + *  .** *                            |
     **  *       * *                 *   **   * :                           |
   6 ++                                         *                           |
   5 ++                                                                     |
     |                                                                      |
   4 ++                                                                     |
   3 ++                    O                                                |
     |OO  O OO OO OO OOOO   O    OOO    OO    O   OOOOO  O     OOOO O  O  O |
   2 O+--O-O-----O-------O---OOO----OO-O--O-OO-OO-------O-OOO-O------OO-O--OO




    3 ++--------------------------------------------------------------------+
      |          *                                                          |
  2.5 ++         :                                                          |
      |         ::                                                          |
      |         : :                                                         |
    2 ++        : :     **                                                  |
      | *.*****:  :* *.*  **.******.** **.  **                              |
  1.5 **       *  * *                 *   **  *.**                          |
      |                                                                     |
    1 ++                                                                    |
      |                    O                                                |
      |OO     O   O  O OOO   OO     O   O O   O O OOOO   O     O O  O  OO O |
  0.5 O+  OOOO O O OO     O    OOOO  OOO   OOO   O     OO OO OO O  O OO    OO
      |                                                                     |
    0 ++--------------------------------------------------------------------+




  1.8 ++-----------------------------------*--------------------------------+
      |                                    :                                |
  1.6 ++                                   :                                |
  1.4 ++       *.                          ::                               |
      |        : *        *               : :                               |
  1.2 ++       : :       * :       .*     : :                               |
      |     ** :  : * .**  *  *   * :  *  : **  **                          |
    1 *+*.** ::   * :*     O:O:   : O: :O.O   O+                       O    |
      |*      :    :        ::O: :   ** *     *          O                  |
  0.8 ++  O   *    *         * ***                                          |
  0.6 ++                                                                    |
      |                                                                     |
  0.4 ++                                                                    |
      |    OOOOO O O O OOO     OOOO             O OOOO    OO OOOOO  OO  O OOO
  0.2 OOO---------O-O-----O----------OOO---OOO---O-----OO----------O--O-----+




  7 ++--------------------------*-------------------------------------------+
    |      *       *            :            *. *                           |
  6 ++     :+   * : :      *    :    * *.*   : *                            |
    |   ** : *  ::: **   * :*  ::    ::: :   :                              |
  5 +* : ::   *: *    :  ::  + *:  ** *   : :                               |
    * ::  :    *      *  :*   *  : :      * *                               |
  4 ++*   *            +:        ::        ::                               |
    |                   *        ::        *                                |
  3 ++                           :                                    O     |
    |                            *                      O                   |
  2 ++                                                                      |
    |                    O                      O                      O    |
  1 ++        O                                       O                     |
    |                   O       O   O     O                     OO O        |
  0 OOO-OOOO-O-OOO-OOOO---OOO-OO-O-O-OOO-O-OOO-O-OO-OO-O--OOOO-O--O--O--O-OOO




  2.5 ++--------------------------------------------------------------------+
      |                                                                     |
      |                                                                     |
    2 ++    * **  ** *     *.* *   .*                                       |
      ***.**: ::  : ::    *   * * *  ** *.**                                |
      |      :::  : * :   :     : :    ::  :  *.*                           |
  1.5 ++     :  : :   :  :       :     *    : :  *                          |
      |      *  : :    :**       *          **                              |
    1 ++        : :    *                                                    |
      |         ::                                                          |
      |         ::                                                          |
  0.5 ++        ::                                                          |
      |          :                                       O                  |
      OOO OOOOOO OOOOO OOOOO OOOOOO OOOOO OOOOO OOOOOO OO OO OOOOO OOOOOO OOO
    0 ++---------*----------------------------------------------------------+




    5 ++--------------------------------------------------------------------+
  4.5 ++   **         .*                         *                          |
      |    ::       ** :                         :                          |
    4 *+  * :       :   :             *          :                          |
  3.5 ++  : :   .*  :   *             :         :                           |
      |: :   : * : :     : *      *  : :*       :                           |
    3 +* :   : :  ::     * :+ * * :+ * ::+      *                           |
  2.5 ++*    ::   **      *  * * *  *  *  ***  :                            |
    2 ++     **                              : :                            |
      |                                      **                             |
  1.5 ++                                                                    |
    1 ++                                                                    |
      |                                                                     |
  0.5 ++  O                O O          O     O          O           O      |
    0 OOO--OOOOO-OOOOO-OOOO---OOOOO-OOOO--OOOO--OOOOOO-OO-OO-OOOOO-OO-OOO-OOO




  1.8 ++--------------------------------------------------------------------+
      |                                *                                    |
  1.6 ++     *           *       *     ::                                   |
  1.4 ++*. ** **   * *. * **.* * :*.**: *.  **                              |
      **  *    :  * :: *      * *     *   **  :.*                           |
  1.2 ++       :  : *                         *  *                          |
    1 ++        : :                                                         |
      |         : :                                                         |
  0.8 ++        : :                                                         |
  0.6 ++        : :                                                         |
      |         ::                                                          |
  0.4 ++        ::                                                          |
  0.2 ++         :           O                           O                  |
      OOO OOOOOO OOOOO OOOOO  OOOOO OOOOO OOOOO OOOOOO OO OO OOOOO OOOOOO OOO
    0 ++---------*----------------------------------------------------------+




  1.4 ++-------------------------------*------------------------------------+
      |                  *             :                                    |
  1.2 ++     *          *:       *     :    **                              |
      |      :         * :       :     ::   ::                              |
    1 ++     ::        :  :      ::   : :   : :                             |
      |     : :       :   :     : :   : :  :  :                             |
  0.8 ***.*** **  *   :   **. *** *. ** *.*:  *.**                          |
      |        :  :***       *      *      *                                |
  0.6 ++        : :                                                         |
      |         ::                                                          |
  0.4 ++         :                                                          |
      |          *           O                           O                  |
  0.2 ++  O               OO  O     O     O         O              O        |
      OOO  OOOOO OOOOO OOO     OOOO  OOOO  OOOO OOOO O OO OO OOOOO  OOOOO OOO
    0 ++--------------------------------------------------------------------+




  8 ++----------------*-----------------------------------------------------+
    |    **           ::                                                    |
  7 ++ .* :          : :                                                    |
  6 *+*    :     *.***  * *     *    *          *                           |
    |*     :.* * :      : :**.  :*.* :*         :                           |
  5 ++     *  ::*        :    **    *  *.      :                            |
    |         *          *               * *  .*                            |
  4 ++                                    * **                              |
    |                                                                       |
  3 ++                                                                      |
  2 ++                                                                      |
    |                                                                       |
  1 ++                                                                      |
    |                                                                       |
  0 OOO-OOOO-OOOOO-OOOO-OOOOO-OOOO-OOOOO-OOOOO-OOOO-OOOOO-OOOO-OOOOO-OOOO-OOO


                                cpuidle.C6-IVT-4S.time

   1.4e+10 ++---------------------------------------------------------------+
           |                                          O                     |
  1.35e+10 ++                                                               |
           |                             O    O                             |
           |      O   O             OO O    O     O       O   OOO           |
   1.3e+10 ++        O   OO OOO  OOO      OO   OO  OOO O     O   O      OO  |
           |     O OO   O      OO       O    O          OO O                |
  1.25e+10 ++          O                                          OOO       |
           |                                                          O   OOO
   1.2e+10 ++                            *                           O      |
           O O          *                :*                                 |
           *O OO.       ::*.        **  *  * **   **                        |
  1.15e+10 +* :  ** *  * *  ****   *  + :  : : : +                          |
           | *     * **         ***    *    :  **                           |
   1.1e+10 ++-------------------------------*-------------------------------+


                               cpuidle.C6-IVT-4S.usage

  150000 ++-----------------------------------------------------------------+
         |               O                                                  |
  140000 ++                                                                 |
         |          O               O  O    O    O    O O     O             |
         | O   O O                O      O    O    O O           O          |
  130000 ++     O OO    O O OO  O       O O  O  O   O      O O              |
         |           O O         O O              O      OO                 |
  120000 OO O              O         O     O                O   O      O  O O
         |    O                O                                  OO     O O|
  110000 ++                                                          OO     |
         |         *  .** * * .**  **   **   **.* *                 O       |
         |        * **   * * *   **  *.*  ***    *                          |
  100000 ++  .*  *                                                          |
         ****  :*                                                           |
   90000 ++----*------------------------------------------------------------+


                                  turbostat.%c0

  80 ++---------------------------------------------------------------------+
     |                                                                      |
  75 OOO OO                                                          O      |
     |     OOO OOOOO OOOOO OOOOO OOOOO OOOO OOOOO OO OO OOOOO OOOOO O OOO OOO
     |                                              O                       |
  70 ++                                                                     |
     |                                                                      |
  65 ++                                                                     |
     |                                                                      |
  60 ++                                                                     |
     |                                                                      |
     |                             *     *   **                             |
  55 ***.*****.*****.*****.*****.** **.** *.*  **                           |
     |                                                                      |
  50 ++---------------------------------------------------------------------+


                                   turbostat.%c1

  2.8 ++--------------------------------------------------------------------+
  2.6 ++         *     *                                                    |
      |          :     :                                                    |
  2.4 ++        ::    : :                                                   |
  2.2 ++        : :   : :                                                   |
      |        *  : **  *       *   *                                       |
    2 ++       :  * :    ***. * :* + :* *. ** *. *                          |
  1.8 +**.**O**    *         * *  *  O *  *O *  *                           |
  1.6 *+    *                                                               |
      | O              O   O            O     O   O  O                      |
  1.4 ++      O                 O O    O     O  O  O   O     OO O          O|
  1.2 ++     O O OO     O      O      O     O             O                 |
      OO   O       OOO   OO   O  O                  O   OO O   O   O  O     |
    1 ++  O                  O      O     O      O               O   O OO O O
  0.8 ++------------------------------------------------------------O-------+


                                  turbostat.%c6

  50 ++---------------------------------------------------------------------+
     |                                                                      |
  45 ++   **                                                                |
     ***.*  **.*****.*****.*****.** **.** *.** **                           |
     |                             *     *    *                             |
  40 ++                                                                     |
     |                                                                      |
  35 ++                                                                     |
     |                                                                      |
  30 ++                                                                     |
     |                                                                      |
     |      O    O   O OOO   O O OOO O   O  O  OO   O    O OO OO       OO   |
  25 OOO OOO O OO OO  O    OO O     O  OO O  OO   OO OO O O     OOO OOO   OOO
     |                                                                      |
  20 ++---------------------------------------------------------------------+


                                 turbostat.%pc2

  35 ++---------------------------------------------------------------------+
     |                                                                      |
  30 *+    *                                                                |
     |**.** :*   **     **. **    * * .**  .** **                           |
     |      * + *  *.  *   *  * .* * *   **   *                             |
  25 ++        *     * :       *                                            |
     |                :                                                     |
  20 ++               *                                                     |
     |      O    O   O       O    O  O      O       O   OO                  |
  15 +O  OO  O OO OO  OOOO OO OO O O   OOO   OOOO OO OO   OOO OOOOO OO OO O O
     O O                                                              O     |
     |                              O     O                                 |
  10 ++    O                                                               O|
     |                                                                      |
   5 ++---------------------------------------------------------------------+


                                  turbostat.Pkg_W

  420 ++--------------------------------------------------------------------+
      OOO OOO      O                 O     O                               O|
  410 ++     OOO OO OO OOOOO OOOOOO O OOO O OOO OOOO      OO    OO OOOO   O O
  400 ++                                             O OOO   OOO       OO   |
      |                                             O                       |
  390 ++                                                                    |
      |                                                                     |
  380 ++                                                                    |
      |                                                                     |
  370 ++                                                                    |
  360 ++                                                                    |
      |      * *.*   *.*        ***.*    .*   *.                            |
  350 +**. ** *   ***   ****.***     * **  ***  **                          |
      *   *                           *                                     |
  340 ++--------------------------------------------------------------------+


                                  turbostat.Cor_W

  350 ++--------------------------------------------------------------------+
      OOO OOO                        O     O                                |
  340 ++      OO  OOO  OO  O O O       O     O  O O                  OO    OO
  330 ++     O   O   O   OO   O OOO O O O O O O  O O O OOOOO OOOOO OO  OO O |
      |                                             O                       |
  320 ++                                                                    |
      |                                                                     |
  310 ++                                                                    |
      |                                                                     |
  300 ++                                                                    |
  290 ++                                                                    |
      |               .*        *  .*         *                             |
  280 ++     ***.*****  ****. ** **  :   .* ** + *                          |
      ***. **                *       ****  *    *                           |
  270 ++--*-----------------------------------------------------------------+


                                 turbostat.RAM_W

  98 ++---------------------------------------------------------------------+
     | *.    *.        **   **                                              |
  96 **  ****  *****.**  *.*  **. ***   ***.*****                           |
     |                           *   *.*                                    |
  94 ++                                                                     |
     |                                                                      |
  92 ++                                                                     |
     |                                                                      |
  90 ++                                                                     |
     |                                                                      |
  88 ++                                                                     |
     |                                                                      |
  86 OOO OOOOO  OOOO OOOOO OOOOO  O OO OO O OOOOO OO OO OOOOO OOO           |
     |         O                 O O     O          O            OO OOOOO OOO
  84 ++---------------------------------------------------------------------+


                             numa-numastat.node0.numa_hit

  2.6e+08 ++----------------------------------------------------------------+
          |****.*   * * .* ***** *. ** ****.* *****                         |
  2.5e+08 *+     *** * *  *     *  *  *      *                              |
          |                                                                 |
  2.4e+08 ++                                                                |
          |                                                                 |
  2.3e+08 ++                                                                |
          |                                                                 |
  2.2e+08 ++                                                                |
          |                                                                 |
  2.1e+08 O+O    OO OO   O    OOO    O OOO   OOO      OO OOOO  O   OO     O |
          |O OO O  O  OO   OOO   O  O     O     OOOO O  O    O  OOO  OO OO OO
    2e+08 ++              O        O  O     O                               |
          |                                                                 |
  1.9e+08 ++----------------------------------------------------------------+


                             numa-numastat.node0.numa_miss

  4.5e+07 ++-------------------------------------O-----------O--O-----------+
          |O    OOO  OO   OO       OOOOO  O OO  O  O O OO OO     O          |
    4e+07 O+OOO    OO  O O  OOOOOO      OO    OO  O   O  O  O  O            |
          |                                                         OO  O   |
  3.5e+07 ++                                                      O      OOOO
          |                                                        O  O     |
    3e+07 ++                                                                |
          |                                                                 |
  2.5e+07 ++                                                                |
          |                                                                 |
    2e+07 ++                                                                |
          *       *    *.  *      .*  *      *                              |
  1.5e+07 +****. * *** : ** * ****  :* : **. :* ***                         |
          |     *     *      *      *  **   *  *                            |
    1e+07 ++----------------------------------------------------------------+


                           numa-numastat.node0.numa_foreign

    4e+07 ++----O-O--------O--O-----------O-----O---------------------------+
          |OO    O OOOOO OO O  OOO OOOOOOO  OOOO OOO  O   OOOO OOO          |
  3.5e+07 O+ OO              O                       O OOO        OO  O  O O|
          |                                                         OO  O O O
    3e+07 ++                                                                |
          |                                                                 |
  2.5e+07 ++                                                                |
          |                                                                 |
    2e+07 ++                                                                |
          |                                                                 |
  1.5e+07 ++           *. *                                                 |
          *  *    **** : * ** ****.** * ***. * ****                         |
    1e+07 +** *.**    *      *       * *    * *                             |
          |                                                                 |
    5e+06 ++----------------------------------------------------------------+


                            numa-numastat.node0.local_node

  2.6e+08 ++----------------------------------------------------------------+
          |****.*   * * .* ***** *. ** ****.* *****                         |
  2.5e+08 *+     *** * *  *     *  *  *      *                              |
          |                                                                 |
  2.4e+08 ++                                                                |
          |                                                                 |
  2.3e+08 ++                                                                |
          |                                                                 |
  2.2e+08 ++                                                                |
          |                                                                 |
  2.1e+08 O+O    OO OO   O    OOO    O OOO   OOO      OO OOOO  O   OO     O |
          |O OO O  O  OO   OOO   O  O     O     OOOO O  O    O  OOO  OO OO OO
    2e+08 ++              O        O  O     O                               |
          |                                                                 |
  1.9e+08 ++----------------------------------------------------------------+


                            numa-numastat.node0.other_node

  4.5e+07 ++-------------------------------------O-----------O--O-----------+
          |O    OOO  OO   OO       OOOOO  O OO  O  O O OO OO     O          |
    4e+07 O+OOO    OO  O O  OOOOOO      OO    OO  O   O  O  O  O            |
          |                                                         OO  O   |
  3.5e+07 ++                                                      O      OOOO
          |                                                        O  O     |
    3e+07 ++                                                                |
          |                                                                 |
  2.5e+07 ++                                                                |
          |                                                                 |
    2e+07 ++                                                                |
          *       *    *.  *      .*  *      *                              |
  1.5e+07 +****. * *** : ** * ****  :* : **. :* ***                         |
          |     *     *      *      *  **   *  *                            |
    1e+07 ++----------------------------------------------------------------+


                             numa-numastat.node1.numa_hit

  2.6e+08 ++----*-----*---------------------*-------------------------------+
          *****  ***** *.*********.********  ******                         |
  2.5e+08 ++                                                                |
          |                                                                 |
  2.4e+08 ++                                                                |
          |                                                                 |
  2.3e+08 ++                                                                |
          |                                                                 |
  2.2e+08 ++                                                                |
          |                                                                 |
  2.1e+08 ++                                                   O            O
          O O O   O OOO        O        OO    OO O O  OO O O         O      |
    2e+08 +O O  O  O   O  OOOO  OO OOO O  O  O  O    O  O O OO  OOOOO O OOO |
          |      O       O    O       O     O     O                        O|
  1.9e+08 ++----------------------------------------------------------------+


                             numa-numastat.node1.numa_miss

  4.5e+07 ++------------------O---------------------------------------------+
          |OO   OO  O O  OOOO   O    OOOO O OOO O O    O  O  O  OO         O|
    4e+07 O+ O    OO O O     O O O OO    O     O O O OO  O OO     OO    O   |
          |   O                                         O      O    OOO  OO |
  3.5e+07 ++                                                                O
          |                                                                 |
    3e+07 ++                                                                |
          |                                                                 |
  2.5e+07 ++                                                                |
          |                                                                 |
    2e+07 ++                                                                |
          |                                                                 |
  1.5e+07 ++       *   *.**                                                 |
          *  **. ** ** :   *******.********. ******                         |
    1e+07 +**---*-----*---------------------*-------------------------------+


                           numa-numastat.node1.numa_foreign

    4e+07 ++----------------------------------------------------------------+
          |       O            O          O     O     O   O                 |
  3.5e+07 OOOOO O  OOOOO OOOOOO OO O OOOOO  OOOO OOO O O O OOO OOO          |
          |      O                  O                   O         O O   O O |
    3e+07 ++                                                       O OO  O OO
          |                                                                 |
  2.5e+07 ++                                                                |
          |                                                                 |
    2e+07 ++                                                                |
          |                                                                 |
  1.5e+07 ++                    *                                           |
          ****   *******.*** *** :.***** **.*** ***                         |
    1e+07 ++  *.*           *    *      *      *                            |
          |                                                                 |
    5e+06 ++----------------------------------------------------------------+


                            numa-numastat.node1.local_node

  2.6e+08 ++----*-----*---------------------*-------------------------------+
          *****  ***** *.*********.********  ******                         |
  2.5e+08 ++                                                                |
          |                                                                 |
  2.4e+08 ++                                                                |
          |                                                                 |
  2.3e+08 ++                                                                |
          |                                                                 |
  2.2e+08 ++                                                                |
          |                                                                 |
  2.1e+08 ++                                                   O            O
          O O O   O OOO        O        OO    OO O O  OO O O         O      |
    2e+08 +O O  O  O   O  OOOO  OO OOO O  O  O  O    O  O O OO  OOOOO O OOO |
          |      O       O    O       O     O     O                        O|
  1.9e+08 ++----------------------------------------------------------------+


                            numa-numastat.node1.other_node

  4.5e+07 ++------------------O---------------------------------------------+
          |OO   OO  O O  OOOO   O    OOOO O OOO O O    O  O  O  OO         O|
    4e+07 O+ O    OO O O     O O O OO    O     O O O OO  O OO     OO    O   |
          |   O                                         O      O    OOO  OO |
  3.5e+07 ++                                                                O
          |                                                                 |
    3e+07 ++                                                                |
          |                                                                 |
  2.5e+07 ++                                                                |
          |                                                                 |
    2e+07 ++                                                                |
          |                                                                 |
  1.5e+07 ++       *   *.**                                                 |
          *  **. ** ** :   *******.********. ******                         |
    1e+07 +**---*-----*---------------------*-------------------------------+


                             numa-numastat.node2.numa_hit

  2.65e+08 ++---------------------------------------------------------------+
   2.6e+08 +*  *.*                *          *                              |
           * **   ******** .****** ***.****** ***.**                        |
  2.55e+08 ++             *                                                 |
   2.5e+08 ++                                                               |
           |                                                                |
  2.45e+08 ++                                                               |
   2.4e+08 ++                                                               |
  2.35e+08 ++                                                               |
           | O                                         O                    |
   2.3e+08 ++  O O O      O  O O  O     OO   OO   O  O                      |
  2.25e+08 ++     O  OO  O  O O  O OOO    O    O   OO   OO O  OOOO  O       |
           OO       O  O        O      O   OO   O     O   O        O OO O  OO
   2.2e+08 ++ O         O                                    O    O      OO |
  2.15e+08 ++---------------------------------------------------------------+


                             numa-numastat.node2.numa_miss

    4e+07 ++----------------------------------------------------------------+
          |                    O          O     O     O                     |
  3.5e+07 ++  O O O  O O O       O      O     O   OO      O O  OOO          |
          OOOO     OO O   OOOOO O  OOOOO O  OO O O   O O O O O      O     O |
    3e+07 ++     O                                      O         OO OO OO OO
          |                                                                 |
  2.5e+07 ++                                                                |
          |                                                                 |
    2e+07 ++                                                                |
          |                                                                 |
  1.5e+07 ++              *                                                 |
          |           **. :*  * * .** **      * * *                         |
    1e+07 *****.******   *  ** * *   *  ***.** * *                          |
          |                                                                 |
    5e+06 ++----------------------------------------------------------------+


                           numa-numastat.node2.numa_foreign

    5e+07 ++-------------------------O--------------------------------------+
          |     OO  O O  O O OO OO O   O     O         OO O      O          |
  4.5e+07 +O OO   OO O O  O O  O    O O OOO O OOOOOO OO  O OOO  O           |
    4e+07 O+O                                                  O  O     O  O|
          |                                                         OOO   O |
  3.5e+07 ++                                                       O     O  O
          |                                                                 |
    3e+07 ++                                                                |
          |                                                                 |
  2.5e+07 ++                                                                |
    2e+07 ++                                                                |
          |                                                                 |
  1.5e+07 *+      *  * *.*    * *                                           |
          |****.** ** *   **** * *.********.*******                         |
    1e+07 ++----------------------------------------------------------------+


                            numa-numastat.node2.local_node

  2.65e+08 ++---------------------------------------------------------------+
   2.6e+08 +*  *.*                *          *                              |
           * **   ******** .****** ***.****** ***.**                        |
  2.55e+08 ++             *                                                 |
   2.5e+08 ++                                                               |
           |                                                                |
  2.45e+08 ++                                                               |
   2.4e+08 ++                                                               |
  2.35e+08 ++                                                               |
           | O                                         O                    |
   2.3e+08 ++  O O O      O  O O  O     OO   OO   O  O                      |
  2.25e+08 ++     O  OO  O  O O  O OOO    O    O   OO   OO O  OOOO  O       |
           OO       O  O        O      O   OO   O     O   O        O OO O  OO
   2.2e+08 ++ O         O                                    O    O      OO |
  2.15e+08 ++---------------------------------------------------------------+


                            numa-numastat.node2.other_node

    4e+07 ++----------------------------------------------------------------+
          |                    O          O     O     O                     |
  3.5e+07 ++  O O O  O O O       O      O     O   OO      O O  OOO          |
          OOOO     OO O   OOOOO O  OOOOO O  OO O O   O O O O O      O     O |
    3e+07 ++     O                                      O         OO OO OO OO
          |                                                                 |
  2.5e+07 ++                                                                |
          |                                                                 |
    2e+07 ++                                                                |
          |                                                                 |
  1.5e+07 ++              *                                                 |
          |           **. :*  * * .** **      * * *                         |
    1e+07 *****.******   *  ** * *   *  ***.** * *                          |
          |                                                                 |
    5e+06 ++----------------------------------------------------------------+


                             numa-numastat.node3.numa_hit

  2.6e+08 ++----**----------------------------**----------------------------+
          *****   ******.*********.********.**  ***                         |
  2.5e+08 ++                                                                |
          |                                                                 |
          |                                                                 |
  2.4e+08 ++                                                                |
          |                                                                 |
  2.3e+08 ++                                                                |
          |                                                                 |
  2.2e+08 ++                                                                |
          | O             O              O     O   O               O        O
          OO OO OOO  OOO   OO O O   O   O O   O OOO  O O OOO O OOOO OO  OOO |
  2.1e+08 ++       OO        O O   O OOO    OO        O O             O    O|
          |              O       O                          O               |
    2e+08 ++----------------------------------------------------------------+


                             numa-numastat.node3.numa_miss

  4.5e+07 ++-------------O-----------O-O-----O------------------------------+
          |     OO  O O    OOOO OO O      O     O  O  OOOOOOO    O          |
    4e+07 OOOOO   OO O O  O    O      O OO  O OO OO  O       O OO           |
          |                         O                                       |
  3.5e+07 ++                                                      O O O O OOO
          |                                                        O O   O  |
    3e+07 ++                                                                |
          |                                                                 |
  2.5e+07 ++                                                                |
          |                                                                 |
    2e+07 ++                                                                |
          |                                                                 |
  1.5e+07 ++                 *  *                                           |
          *****.  ******.**** ** :.********.*   ***                         |
    1e+07 ++----**---------------*-----------***----------------------------+


                           numa-numastat.node3.numa_foreign

  4.5e+07 ++----------------------------------------------------------------+
          |     OO   O O             O           O           O  OO          |
    4e+07 OOOOO   OOO O  OOOO OOOO OO OOO O OOO O OO OOOO OOO  O            |
          |                  O           O     O         O        O OO  OO  |
  3.5e+07 ++                                                       O  O   OO|
          |                                                                 O
    3e+07 ++                                                                |
          |                                                                 |
  2.5e+07 ++                                                                |
          |                                                                 |
    2e+07 ++                                                                |
          |                                                                 |
  1.5e+07 *+      ** * *. *       .*  *                                     |
          |****. *  * *  * *******  ** ****.*******                         |
    1e+07 ++----*-----------------------------------------------------------+


                            numa-numastat.node3.local_node

  2.6e+08 ++----**----------------------------**----------------------------+
          *****   ******.*********.********.**  ***                         |
  2.5e+08 ++                                                                |
          |                                                                 |
          |                                                                 |
  2.4e+08 ++                                                                |
          |                                                                 |
  2.3e+08 ++                                                                |
          |                                                                 |
  2.2e+08 ++                                                                |
          | O             O              O     O   O               O        O
          OO OO OOO  OOO   OO O O   O   O O   O OOO  O O OOO O OOOO OO  OOO |
  2.1e+08 ++       OO        O O   O OOO    OO        O O             O    O|
          |              O       O                          O               |
    2e+08 ++----------------------------------------------------------------+


                            numa-numastat.node3.other_node

  4.5e+07 ++-------------O-----------O-O-----O------------------------------+
          |     OO  O O    OOOO OO O     OO    OO  O  OOOOOOO    O          |
    4e+07 OOOOO   OO O O  O    O      O O   O O  OO  O       O OO           |
          |                         O                                       |
  3.5e+07 ++                                                      O O O O OOO
          |                                                        O O   O  |
    3e+07 ++                                                                |
          |                                                                 |
  2.5e+07 ++                                                                |
          |                                                                 |
    2e+07 ++                                                                |
          |                                                                 |
  1.5e+07 ++                 *  *                                           |
          *****.  ******.**** ** :.********.*   ***                         |
    1e+07 ++----**---------------*-----------***----------------------------+


                                 vmstat.procs.r

  95 ++---------------------------------------------------------------------+
     |                                                                      |
  90 OOO OOO O OOOOO OOOOO OOOOO O OO  OOOO  OOOO OO OO OOOO  OOOOO OOOOO OOO
     |      O                     O  O      O       O       O               |
  85 ++                                                                     |
     |                                                                      |
  80 ++                                                                     |
     |                                                                      |
  75 ++                                                                     |
     |                                                                      |
  70 ++                                                                     |
     |                                   *   **                             |
  65 ***.*****.*****.*****.*****.*****.** *.*  **                           |
     |                                                                      |
  60 ++---------------------------------------------------------------------+


                                  vmstat.memory.free

  1.4e+08 ++--------------*-------------------------------------------------+
          |   *.*     *   ::            *        *                          |
  1.3e+08 ** *   ***** *.* *******.*** * **.***** *                         |
          | *                         *                                     |
  1.2e+08 ++                                                                |
          |                                                                 |
  1.1e+08 ++                                                                |
          |                                                                 |
    1e+08 ++                                                                |
          |                                                                 |
    9e+07 ++                                                                |
          |                                           O                     |
    8e+07 ++     O          O  OOO  OOO O O O O OOO       O OO  O       OO  |
          OOOOO O OOOOOO OOO OO    O   O O   O O   O O OOO O   O OOOOOO   OOO
    7e+07 ++----------------------------------------------------------------+


                                  vmstat.memory.cache

  4.5e+08 +O-O--------------------------------------------------------------+
          O O O O OOOOOO OOO OOOO  O   O OO  O OO  O O OOO O   O OOOOOO  OOOO
  4.4e+08 ++     O          O    O  OOO O   O O  OO       O OO  O       O   |
          |                                           O                     |
  4.3e+08 ++                                                                |
          |                                                                 |
  4.2e+08 ++                                                                |
          |                                                                 |
  4.1e+08 ++                                                                |
          |                                                                 |
    4e+08 ++                                                                |
          | *                         *                                     |
  3.9e+08 ** *   *******.* *******.*** * **.*******                         |
          |   *.*         *             *                                   |
  3.8e+08 ++----------------------------------------------------------------+


                                  vmstat.system.in

  120000 ++-----------------------------------------------------------------+
         |                                 *  *.                            |
  115000 ****.  *** *    *  **.*******.* ** **  ***                         |
  110000 ++   **  : :*.** **            *                                   |
         |        : :                                                       |
  105000 ++       : :                                                       |
  100000 ++        :                                                        |
         |         :                                                        |
   95000 ++        :                                                        |
   90000 ++   O    *                                                        |
         OOO   OOO OOO OOOOOO    OOOO  OOO  OOO   O O O OO OOOO OO OOO      O
   85000 ++       O                              O O O            O   O  OOO|
   80000 ++ O                  O                                            |
         |                   O  O    O    OO    O         O            O    |
   75000 ++-----------------------------------------------------------------+


                                 vmstat.system.cs

  3600 ++-------------------------------------------------------------------+
       |                                                                    |
  3400 ***.****                                                             |
  3200 ++     :                                                             |
       |      :                                                             |
  3000 ++      :                                                            |
       |       :                                                            |
  2800 ++      **.* *   .******.* *          .**                            |
       |           * ***         * ***.******   **                          |
  2600 ++                                                                   |
  2400 ++                                                                   |
       |                                                                    |
  2200 ++                                                                   |
       OOO OOOOOO OOOOOO OOOOOO OOOOOO OOOOOO OOOOOO OOOOOO  OOOOO OOOOOO OOO
  2000 ++---------------------------------------------------O---------------+


                                    softirqs.TIMER

  1.5e+07 ++-------------------O--------O-----O----------------O------------+
          OOOOO OOOOOOOO OOOOOO OO OOOOO OO OO OOOOO OOOOOOOOO  OOOOOOO OOOOO
  1.4e+07 ++                                                                |
  1.3e+07 ++                                                                |
          |                                                                 |
  1.2e+07 ++                                                                |
  1.1e+07 ++                                                                |
          |                                                                 |
    1e+07 ++                                                                |
    9e+06 ++                                                                |
          |                                                                 |
    8e+06 ++       *              .*****  *.***** *                         |
    7e+06 *****.*** ****.**  *****      **       *                          |
          |                **                                               |
    6e+06 ++----------------------------------------------------------------+


                                   softirqs.SCHED

  350000 ++-----------------------------------------------------------------+
         OOOO OOOOO O   OOO OO OOOOOOO OOO OOOO  OOOOO  OOOOOOO OOOOOOOO OOOO
         |                                                                  |
  300000 ++                                                                 |
         |                                                                  |
         |                                                                  |
  250000 ++                        *         * .*                           |
         ****.*****O*O.O** O   **** **.*  O** * O *   O                     |
  200000 ++              :     :       :  :     : :                         |
         |               :    :        :  :     : :                         |
         |                :   :         ::       ::                         |
  150000 ++               :   :         ::       :                          |
         |                :  :          :*       :                          |
         |                ****          *        *                          |
  100000 ++-----------------------------------------------------------------+


                                    softirqs.RCU

  900000 ++-----------------------------------------------------------------+
         |                          OO     O                              O |
  800000 OO               O                        O        OO             O|
         | O  OOOO  O   OO OOO OOOOO   O    O        OO OOO   O OO O     O  O
  700000 ++ O     OO O O                OOO  OO OOO O      O      O OOOO    |
         |                                                                  |
  600000 ++                                                                 |
         |                                                                  |
  500000 ++                                                                 |
         |                                                                  |
  400000 +**                                                                |
         *  :   * **  .*        *  **                                       |
  300000 ++ *.** *  **  *     .* **  *.* ******.* *                         |
         |               *****          *        *                          |
  200000 ++-----------------------------------------------------------------+


                               proc-vmstat.nr_free_pages

  3.6e+07 ++----------------------------------------------------------------+
          |               *             *                                   |
  3.4e+07 ** **.**  * **.* ** ** *.*** * **. *   **                         |
  3.2e+07 ++*     ** *       *  *     *     * ***                           |
          |                                                                 |
    3e+07 ++                                                                |
  2.8e+07 ++                                                                |
          |                                                                 |
  2.6e+07 ++                                                                |
  2.4e+07 ++                                                                |
          |                                                                 |
  2.2e+07 ++                                          O                     |
    2e+07 ++     O         O     O  O O O   O O   O         O               |
          OOO O O OOOOOO OO OOOOO  O O O OO  O OOO O O OOOOO O OOOOOOOO OOOOO
  1.8e+07 ++-O--------------------------------------------------------------+


                             proc-vmstat.nr_inactive_file

  1.12e+08 ++---------------------------------------------------------------+
           OOOOO O OO  OO O   OO   O    O O  O O    O  OOO O     O O OO   OOO
   1.1e+08 ++     O  OO  O  OO  OOO OO O O OO O O OO O    O  OOOO O O   OO  |
  1.08e+08 ++                                         O                     |
           |                                                                |
  1.06e+08 ++                                                               |
  1.04e+08 ++                                                               |
           |                                                                |
  1.02e+08 ++                                                               |
     1e+08 ++                                                               |
           |                                                                |
   9.8e+07 ++*      * *       *  *    .*      * *.                          |
   9.6e+07 ** **. ** * *** .** ** ****  * **** *  **                        |
           |     *        *              *                                  |
   9.4e+07 ++---------------------------------------------------------------+


                              proc-vmstat.nr_anon_pages

  12800 ++------------------------------------------------------------O-----+
  12600 ++   O       O                             O    O          OO    O  |
        |     O       O  O  O O O  OO  O     O      OO    OO O            O O
  12400 ++OO   O    O   O O  O   O    O  O  O  O O    OO    O OO     O O   O|
  12200 OO      OO     O       O                O               O           |
        |         O                  O  O  O  O                   O         |
  12000 ++                                                                  |
  11800 ++                                                                  |
  11600 ++                                                                  |
        |                                                                   |
  11400 +*                                    *                             |
  11200 ++:*  * *  .*         *  *.*     *.*  ::                            |
        * * + :* :*  :****   * : :  **  *   :* *                            |
  11000 ++   *   *   *    *.*  **     **    *   **                          |
  10800 ++------------------------------------------------------------------+


                               proc-vmstat.nr_mapped

  6000 *+-----------------------*-------------------------------------------+
       |                       ::  *      *      *                          |
  5500 ++*   *        *        : : :   *  :**    :                          |
       |::+  : *      :*.*    *  ** :  : *  :    :                          |
       |*  ** ::*.   *   :  **      * : ::   : * :                          |
  5000 ++     :   ***     :*         :: *    : : :                          |
       |      *           ::         *        :::                           |
  4500 ++                 *                   * :                           |
       |                                        :                           |
  4000 +O            O O         O              *       O   O      O        |
       |    O OOO  OO O  O        OO O OO  OO O    O O       OOO O   O  O OOO
       | O O O    O       OO    O   O     O     OOO   OO        O   O  O    |
  3500 O+                   OOO          O     O         OO           O     |
       |                                                                    |
  3000 ++-------------------------------------------------------------------+


                               proc-vmstat.nr_file_pages

  1.12e+08 +O-O-------------------------------------------------------------+
           O O O O OOOOOOOO OOOOOOOO O OO OOOO OO O OO OOOOO  OOOOOOOOO OOOOO
   1.1e+08 ++     O                 O    O    O    O         O              |
  1.08e+08 ++                                         O                     |
           |                                                                |
  1.06e+08 ++                                                               |
  1.04e+08 ++                                                               |
           |                                                                |
  1.02e+08 ++                                                               |
     1e+08 ++                                                               |
           |                                                                |
   9.8e+07 +**     ** *     * ****    .**   * ***.                          |
   9.6e+07 *+ **.**  * *** + *    ****   :** *    **                        |
           |              *              *                                  |
   9.4e+07 ++---------------------------------------------------------------+


                          proc-vmstat.nr_page_table_pages

  2500 ++-------------------------------------------------------------------+
       |                               O    O                      O      O O
  2400 +O    O               O    O               O  O OO O   OO    O O O   |
       O O OO OO   OOOOO OOOO   O  O    O     O          O  OO       O O   O|
       |        O O           O  O  OO   OOO   OOO O  O         OO          |
  2300 ++                                                                   |
       |                                                                    |
  2200 ++                                                                   |
       |                                                                    |
  2100 ++                                                                   |
       |*   ****   *        *      *        *.**                            |
       |:*.*    *. :** *.   :**   * :*.** * :   *                           |
  2000 *+         *   *  **:   + *  *    * *     *                          |
       |                   *    *                                           |
  1900 ++-------------------------------------------------------------------+


                           proc-vmstat.nr_isolated_file

  2300 ++-------------------------------------------------------------------+
  2200 ++                    *            *                                 |
       |   *   *             :*.          :                                 |
  2100 +* : * * *.**** *  * *   *         : *                               |
  2000 ++::  ::       * + :::    : * *   : ::+ *                            |
       | *   *           * *     * :* +  : :  * *                           |
  1900 *+                         *    * * *     *                          |
  1800 ++   O                           *                           O       |
  1700 ++            O                            O                         |
       O                    O      O                 O             O        |
  1600 ++           O      O      O                    O       O      O   O O
  1500 ++                O   O                     O    O O            O   O|
       | O O  OO      OO        O                     O  O  OO   O      O   |
  1400 +O       O O       O   O  O   O OOO OO OOOO            O O    O      |
  1300 ++----O-----O----------------O-----O---------------------------------+


                                 proc-vmstat.numa_hit

  1.05e+09 ++---------------------------------------------------------------+
           |****.** **** *   ** * * **. *********.**                        |
           *       *    * *.*  * * *   *                                    |
     1e+09 ++                                                               |
           |                                                                |
           |                                                                |
   9.5e+08 ++                                                               |
           |                                                                |
     9e+08 ++                                                               |
           |                                                                |
           |                                                                |
   8.5e+08 ++O O  OO OO   O OO OOO  O   OOO  OOO  O OOOO O O   OOO OOO      O
           OO O  O  O  OOO    O   OO O O   OO   O  O    O O  OO   O   O OOOO|
           |                                                                |
     8e+08 ++---------------------------------------------------------------+


                                 proc-vmstat.numa_miss

  1.8e+08 ++----------------------------------------------------------------+
          |                                                                 |
  1.6e+08 +OO   OOOOOOOO OOOO OOOO O OOOO O OOO OOOO OOO  OOOO  OO          |
          O  OO              O      O    O     O        OO     O            |
  1.4e+08 ++                                                      OOOOO OOOO|
          |                                                                 O
  1.2e+08 ++                                                                |
          |                                                                 |
    1e+08 ++                                                                |
          |                                                                 |
    8e+07 ++                                                                |
          |                                                                 |
    6e+07 ++           *. *                                                 |
          *****. ******  * *******.********.*******                         |
    4e+07 ++----*-----------------------------------------------------------+


                               proc-vmstat.numa_foreign

  1.8e+08 ++----------------------------------------------------------------+
          |                                                                 |
  1.6e+08 +OO   OOOOOOOO OOOO OOOO O OOOO O OOO OOOO OOO  OOOO  OO          |
          O  OO              O      O    O     O        OO     O            |
  1.4e+08 ++                                                      OOOOO OOOO|
          |                                                                 O
  1.2e+08 ++                                                                |
          |                                                                 |
    1e+08 ++                                                                |
          |                                                                 |
    8e+07 ++                                                                |
          |                                                                 |
    6e+07 ++           *. *                                                 |
          *****. ******  * *******.********.*******                         |
    4e+07 ++----*-----------------------------------------------------------+


                                proc-vmstat.numa_local

  1.05e+09 ++---------------------------------------------------------------+
           |****.** ** * *   ** * * **. *********.**                        |
           *       *  * * *.*  * * *   *                                    |
     1e+09 ++                                                               |
           |                                                                |
           |                                                                |
   9.5e+08 ++                                                               |
           |                                                                |
     9e+08 ++                                                               |
           |                                                                |
           |                                                                |
   8.5e+08 ++O O  OO OO   O OO OOO  O   OOO  OOO  O OOOO O O   OOO OOO      O
           OO O  O  O  OOO    O   OO O O   OO   O  O    O O  OO   O   O OOOO|
           |                                                                |
     8e+08 ++---------------------------------------------------------------+


                                proc-vmstat.numa_other

  1.8e+08 ++----------------------------------------------------------------+
          |                                                                 |
  1.6e+08 +OO   OOOOOOOO OOOO OOOO O OOOO O OOO OOOO OOO  OOOO  OO          |
          O  OO              O      O    O     O        OO     O            |
  1.4e+08 ++                                                      OOOOO OOOO|
          |                                                                 O
  1.2e+08 ++                                                                |
          |                                                                 |
    1e+08 ++                                                                |
          |                                                                 |
    8e+07 ++                                                                |
          |                                                                 |
    6e+07 ++           *. *                                                 |
          *****. ******  * *******.********.*******                         |
    4e+07 ++----*-----------------------------------------------------------+


                          proc-vmstat.workingset_nodereclaim

    3e+06 ++----------------------------------------------------------------+
          *  **.*     **.  **           *                                   |
  2.8e+06 +**    *****   **  *****.***** **.*******                         |
  2.6e+06 ++                                                                |
          |                                                                 |
  2.4e+06 ++                                                                |
  2.2e+06 ++                                                                |
          |                                                                 |
    2e+06 ++                                                                |
  1.8e+06 ++                                                                |
          | O     O  O                  O     O    O  OO       OO           |
  1.6e+06 ++  O OO  O OO OOOOOOOOO  OO O OO  O OOOO  O  OOOOOO   O          |
  1.4e+06 OO O     O               O  O     O                     OOOO  OOO O
          |                                                           O    O|
  1.2e+06 ++----------------------------------------------------------------+


                               proc-vmstat.pgalloc_dma32

    3e+06 ++----------------------------------------------------------------+
          **** .***  ***.* ** ** *.********. ******                         |
  2.9e+06 ++  *    **     *  *  *           *                               |
          |                                                                 |
  2.8e+06 ++                                                                |
  2.7e+06 ++                                                                |
          |                                                                 |
  2.6e+06 ++                                                       OO     O |
          |                                                       O  O  OO  O
  2.5e+06 ++                                                          O    O|
  2.4e+06 ++                                                                |
          |                         O                          O            |
  2.3e+06 OOOOO OOO OO   O  OOOO     O OOOO  OOOOOOO OOOOOOOO   OO          |
          |        O  OO  OO    OO O  O     O                O              |
  2.2e+06 ++----------------------------------------------------------------+


                                  proc-vmstat.pgfault

  1.8e+06 ++----------------------------------------------------------------+
          |      O   O     OO       OO  O O   O O O  OO     OO              |
  1.7e+06 OOOO     O  O  O    OOO                O      O OO   O OO O O    OO
  1.6e+06 ++    O O                O                   O                O O |
          |         O  O  O  O   O    OO O  OO O   O     O      O  O O   O  |
  1.5e+06 ++  O                                                             |
  1.4e+06 ++                                                                |
          |                                                                 |
  1.3e+06 ++                                                                |
  1.2e+06 ++                      .**     *.  * * *                         |
          *  *   * **     * *    *   *  * : * :* ::                         |
  1.1e+06 +** *. :* : **.* * :  *     :* *   *   *                          |
    1e+06 ++    *    ::      * *      *                                     |
          |          *        *                                             |
   900000 ++----------------------------------------------------------------+


                          proc-vmstat.pgsteal_kswapd_dma32

  600000 ++-----------------------------------------------------------------+
         |                                                                O |
  500000 ++                                                       O OO O O  |
         |                                                         O       O|
         |                                                            O     |
  400000 ++                                                                 O
         |                                                                  |
  300000 ++                                                                 |
         |     O   O       O            O    O       OO     O O O           |
  200000 OOOO O OOO O  OOOO OO OOOOOOO O OOOO O OOOOO   O OO O   O          |
         |           O                                   O                  |
         |                                                                  |
  100000 ++           .*  *       *     *   *                               |
         ****.********  ** ***.*** ***.* *** **.***                         |
       0 ++-----------------------------------------------------------------+


                           proc-vmstat.pgsteal_kswapd_normal

  2.2e+08 ++----------------------------------------------------------------+
    2e+08 ++O   O O       OO  O OO   O    O     O  O      OO O  OO          |
          |O  O  O  OOOO O  OO O   O   OOO   OOO O   OOO       O            |
  1.8e+08 O+ O     O                O O     O     O     OO  O     O OO  O OO|
  1.6e+08 ++                                                       O  O  O  O
  1.4e+08 ++                                                                |
  1.2e+08 ++                                                                |
          |                                                                 |
    1e+08 ++                                                                |
    8e+07 ++                                                                |
    6e+07 ++                                                                |
    4e+07 ++                                                                |
          |                                                                 |
    2e+07 *****.********.*********.********.*******                         |
        0 ++----------------------------------------------------------------+


                           proc-vmstat.pgsteal_direct_dma32

  2.6e+06 ++----------------------------------------------------------------+
  2.5e+06 *****.********.*********.********.*******                         |
          |                                                                 |
  2.4e+06 ++                                                                |
  2.3e+06 ++                                                                |
          |                                                                 |
  2.2e+06 ++                                                                |
  2.1e+06 ++                                                                |
    2e+06 ++                                                                |
          |                                                                 |
  1.9e+06 ++                                                                |
  1.8e+06 ++                        O    O     O                   O        |
          OOOOO OOOOOOOO OOOOOOOOO O OOOO O OOO OOOO OOOOOOOO  OOO  OOO OOO O
  1.7e+06 ++                                                 O    O        O|
  1.6e+06 ++----------------------------------------------------------------+


                           proc-vmstat.pgsteal_direct_normal

  9.5e+08 ++----------------------------------------------------------------+
          *****.********.*********.********.*******                         |
    9e+08 ++                                                                |
          |                                                                 |
          |                                                                 |
  8.5e+08 ++                                                                |
          |                                                                 |
    8e+08 ++                                                                |
          |                                                                 |
  7.5e+08 ++                                                                |
          |                                                                 |
          |                                                                 |
    7e+08 O+O O      O      O       O   OO    OO OOO OOOOO     O   OO O     O
          |O O  OOOOO OO OOO OOOOO O OOO  O OO  O         OOOO  OOO  O  OOOO|
  6.5e+08 ++----------------------------------------------------------------+


                           proc-vmstat.pgscan_kswapd_dma32

  600000 ++-----------------------------------------------------------------+
         |                                                                O |
  500000 ++                                                       O OO O O  |
         |                                                         O       O|
         |                                                            O     |
  400000 ++                                                                 O
         |                                                                  |
  300000 ++                                                                 |
         |     O   O       O            O    O       OO     O O O           |
  200000 OOOO O OOO O  OOOO OO OOOOOOO O OOOO O OOOOO   O OO O   O          |
         |           O                                   O                  |
         |                                                                  |
  100000 ++           .*  *       *     *   *                               |
         ****.********  ** ***.*** ***.* *** **.***                         |
       0 ++-----------------------------------------------------------------+


                           proc-vmstat.pgscan_kswapd_normal

  2.2e+08 ++----------------------------------------------------------------+
    2e+08 ++O   O O       OO  O OO   O    O     O  O      OO O  OO          |
          |O  O  O  OOOO O  OO O   O   OOO   OOO O   OOO       O            |
  1.8e+08 O+ O     O                O O     O     O     OO  O     O OO  O OO|
  1.6e+08 ++                                                       O  O  O  O
  1.4e+08 ++                                                                |
  1.2e+08 ++                                                                |
          |                                                                 |
    1e+08 ++                                                                |
    8e+07 ++                                                                |
    6e+07 ++                                                                |
    4e+07 ++                                                                |
          |                                                                 |
    2e+07 *****.********.*********.********.*******                         |
        0 ++----------------------------------------------------------------+


                            proc-vmstat.pgscan_direct_dma32

  2.6e+06 ++----------------------------------------------------------------+
  2.5e+06 *****.********.*********.********.*******                         |
          |                                                                 |
  2.4e+06 ++                                                                |
  2.3e+06 ++                                                                |
          |                                                                 |
  2.2e+06 ++                                                                |
  2.1e+06 ++                                                                |
    2e+06 ++                                                                |
          |                                                                 |
  1.9e+06 ++                                                                |
  1.8e+06 ++                        O    O     O                   O        |
          OOOOO OOOOOOOO OOOOOOOOO O OOOO O OOO OOOO OOOOOOOO  OOO  OOO OOO O
  1.7e+06 ++                                                 O    O        O|
  1.6e+06 ++----------------------------------------------------------------+


                           proc-vmstat.pgscan_direct_normal

  9.5e+08 ++----------------------------------------------------------------+
          *****.********.*********.********.*******                         |
    9e+08 ++                                                                |
          |                                                                 |
          |                                                                 |
  8.5e+08 ++                                                                |
          |                                                                 |
    8e+08 ++                                                                |
          |                                                                 |
  7.5e+08 ++                                                                |
          |                                                                 |
          |                                                                 |
    7e+08 O+O O      O      O       O   OO    OO OOO OOOOO     O   OO O     O
          |O O  OOOOO OO OOO OOOOO O OOO  O OO  O         OOOO  OOO  O  OOOO|
  6.5e+08 ++----------------------------------------------------------------+


                        proc-vmstat.pgscan_direct_throttle

  2500 ++-------------------------------------------------------------------+
       |                                       *                            |
       |                                      *:                            |
  2000 +* .** * *.    *      * .*       * *  +  :                           |
       * *   * :: * ** *.**  :* : *     :*: *   :*                          |
       |       *   *       **    :::**.*   ::   *                           |
  1500 ++                        * *       :                                |
       |                                   *                                |
  1000 ++                                                                   O
       |                                                           O        |
       |                                                         O  OOOO  OO|
   500 ++  O    O      O   OOOO   O OO  O OO  O  O          O           O   |
       OOO  OOOO  OOOOO  OO      O     O O  O  OO OO OOOOOO  OO O           |
       |                        O  O                           O            |
     0 ++-------------------------------------------------------------------+


                               proc-vmstat.slabs_scanned

    7e+06 +*--------------------------*------*------------------------------+
          * ***.********.*********.*** ****.* *****                         |
  6.5e+06 ++                                                                |
          |                                                                 |
    6e+06 ++                                                                |
          |                                                                 |
  5.5e+06 ++                                                                |
          |                                                                 |
    5e+06 ++                                                                |
          | O     O  O                                 O                    |
  4.5e+06 +O  O OO  O O   OOO OOOO   O OOOO  OOOOO O OO  OOO O OOO          |
          O  O     O   O O   O     OO O     O     O     O   O      OOO      O
    4e+06 ++                                                      O   O OOOO|
          |                                                                 |
  3.5e+06 ++----------------------------------------------------------------+


                     proc-vmstat.kswapd_high_wmark_hit_quickly

  550 ++--------------------------------------------------------------------+
  500 ++            O  O                                     O          O   |
      |OO  OOOO      O  OOO      O  OOO   OOO    O  OO   O     O O  O  O   O|
  450 O+  O      OOO       O OOOO O    OO    OO O OO   OO OO  O O  O OO   O |
  400 ++       O                                                            O
  350 ++                                                                    |
  300 ++                                                                    |
      |                                                                     |
  250 ++                                                                    |
  200 ++                                                                    |
  150 ++                                                                    |
  100 ++                                                                    |
      |      *      * .*   *.   *                                           |
   50 ***.*** **.*** *  ***  *** **.*****.*****.**                          |
    0 ++--------------------------------------------------------------------+


                              proc-vmstat.pageoutrun

  2200 ++----------------------------------------------------O--------------+
       O O            O                              O           O      O   |
  2100 +O     O   OO O     O O   O     O    O            O     O    O  O   O|
       |   OOO O    O       O     O  O   O O   OO             O O    O    O O
  2000 ++              O O    O    OO     O      O O  O   O O         O     |
       |                  O     O       O     O   O    OO          O        |
  1900 ++       O                                                           |
       |                                                                    |
  1800 ++                                                                   |
       |           *                        *                               |
  1700 *+          : *  .*  *    *  **  *  * +  *                           |
       |**.***    : :::*  ** :*.* **  + :* :  * :*                          |
  1600 ++     ***.* * *      *         *  *    *                            |
       |                                                                    |
  1500 ++-------------------------------------------------------------------+


                               proc-vmstat.allocstall

  29000 ++------------------------------------------------------------------+
        ****.******.*******.******.*******.*******                          |
  28000 ++                                                                  |
  27000 ++                                                                  |
        |                                                                   |
  26000 ++                                                                  |
  25000 ++                                                                  |
        |                                                                   |
  24000 ++                                                                  |
  23000 ++                                                                  |
        |                                                                   |
  22000 ++                                                                  |
  21000 ++                                                         O        O
        O OO O  O O OOOOO O  OO    O  OOO   OOO OO OOOOOO  OO O     OOOO OO |
  20000 +O----OO-O-------O--O--OOO--OO---O-O---O----------O--O-OO-O--------O+


                            proc-vmstat.numa_pte_updates

  16000 ++------------------------------------------------------------------+
  15000 ++      O           O                                             O O
        |  O     O    O        O   O   O     O   O                 OO O     |
  14000 O+                O           O     O      OO       O O   O  O O   O|
  13000 +O   OO   O OO  OO      OO  OO  O  O  O O    O O   O   O         O  |
        |      O       O     O           O     O        O O  O  O           |
  12000 ++O           *       O                       O                     |
  11000 ++            ::                      *  *                          |
  10000 ++        *. : ** *. * * *.*** ** .* * **                           |
        |       **  **   *  * * *     *  *  *                               |
   9000 ++      :                                                           |
   8000 ++      :                                                           |
        |** .* :                                                            |
   7000 *+ *  **                                                            |
   6000 ++------------------------------------------------------------------+


                            proc-vmstat.numa_hint_faults

  18000 ++------------------------------------------------------------------+
        |                          O                                        |
  16000 ++                                                                  |
        |                                                                   |
        |                   O                                               |
  14000 ++       O    O   O                                               O O
        |       O                                                 OOO O     |
  12000 ++ O  O      O  O       O    O OOO O OOOOO OOO      O O      O O O O|
        OOO  O O  O O  O O   OOO O  O O     O         OOO OO O OO           |
  10000 ++                                    ** *                          |
        |        **.*******.******.*******.***  *                           |
        |       *                                                           |
   8000 ++      :                                                           |
        |** .* *                                                            |
   6000 *+-*--*-------------------------------------------------------------+


                         proc-vmstat.numa_hint_faults_local

  15000 ++------------------------------------------------------------------+
  14000 ++                         O                                        |
        |                   O                                               |
  13000 ++       O    O   O                                           O   O O
  12000 ++ O    O                                O            O   OOO  O    |
        O     O     OO  O      OOO   OOOOO OOOOOO  OOOO O O O   O    O   O O|
  11000 +OO  O O  O    O O   OO     O                  O   O O O            |
  10000 ++                                    ** *                          |
   9000 ++       **. **** *. * * *.*** ** .***  *                           |
        |       *   *    *  * * *     *  *                                  |
   8000 ++      :                                                           |
   7000 ++      :                                                           |
        |      :                                                            |
   6000 ****.***                                                            |
   5000 ++------------------------------------------------------------------+


                                    meminfo.MemFree

  1.4e+08 ++--------------*-------------------------------------------------+
          *  **.**    **. ::*  *       ***       **                         |
  1.3e+08 +**     ****   * * ** **.****   *.*****                           |
          |                                                                 |
  1.2e+08 ++                                                                |
          |                                                                 |
  1.1e+08 ++                                                                |
          |                                                                 |
    1e+08 ++                                                                |
          |                                                                 |
    9e+07 ++                                                                |
          |                                           O                     |
    8e+07 ++    OOOOOO O OOOOO OOO OOOOOOOO OOOOOOOO O O OOOOO OOOOOO   OOOO|
          OOOOO       O       O                         O            OO     O
    7e+07 ++----------------------------------------------------------------+


                                    meminfo.Cached

  4.5e+08 ++----------------------------------------------------------------+
          OOOOO       O       O                         O            OO     O
  4.4e+08 ++    OOOOOO O OOOOO OOO OOOOOOOO OOOOOOOO O O OOOOO OOOOOO   OOOO|
          |                                           O                     |
  4.3e+08 ++                                                                |
          |                                                                 |
  4.2e+08 ++                                                                |
          |                                                                 |
  4.1e+08 ++                                                                |
          |                                                                 |
    4e+08 ++                                                                |
          | *                                                               |
  3.9e+08 +* :    ****  .* **** **.*****  *.******                          |
          *  **.**    **  ::   *        **        *                         |
  3.8e+08 ++--------------*-------------------------------------------------+


                                   meminfo.Inactive

  4.5e+08 ++----------------------------------------------------------------+
          OOOOO       O                                 O            OO     |
  4.4e+08 ++    OOOOOO O OOOOOOOOO OOOOOOOO OOOOOOOO O O OOOOO OOOOOO   OOOOO
          |                                           O                     |
  4.3e+08 ++                                                                |
          |                                                                 |
  4.2e+08 ++                                                                |
          |                                                                 |
  4.1e+08 ++                                                                |
          |                                                                 |
    4e+08 ++                                                                |
          |                                                                 |
  3.9e+08 +**     ** *     * ** **.****    .* ***                           |
          *  **. *  * **.* :*  *       ****  *   **                         |
  3.8e+08 ++----*---------*-------------------------------------------------+


                                meminfo.Inactive(file)

  4.5e+08 ++----------------------------------------------------------------+
          OOOOO       O                                 O            O      |
  4.4e+08 ++    OOOOOO O OOOOOOOOO OOOOOOOO OOOOOOOO O O OOOOO OOOOOO O OOOOO
          |                                           O                     |
  4.3e+08 ++                                                                |
          |                                                                 |
  4.2e+08 ++                                                                |
          |                                                                 |
  4.1e+08 ++                                                                |
          |                                                                 |
    4e+08 ++                                                                |
          |                                                                 |
  3.9e+08 ++*     ** *       ** **.** *    .* ***                           |
          ** **. *  * **.* **  *     * ****  *   **                         |
  3.8e+08 ++----*---------*-------------------------------------------------+


                                  meminfo.AnonPages

  52000 ++------------------------------------------------------------------+
        |                                                             O     |
  51000 ++   O       O                             O    O          OO    O  |
  50000 ++    O     O O  O  O O O  OO  O     O      OO    OO O            O O
        OOOO   O        O O  O   O    O  O  O  OOO    OO    O OO     O O   O|
  49000 ++      OOO    O       O        O     O                 O           |
  48000 ++                           O     O                      O         |
        |                                                                   |
  47000 ++                                                                  |
  46000 ++                                                                  |
        |*                                    *                             |
  45000 *+:*.   *  .*         *  *.*    **.*  ::                            |
  44000 ++*  *** :*  :****   * * :  **  :   ** **                           |
        |        *   *    *.*   *     **         *                          |
  43000 ++------------------------------------------------------------------+


                                   meminfo.Mapped

  24000 ++-------------------*----------------------------------------------+
        |                    : *                 *                          |
  22000 ++     **     *    .*: :       *    *    :                          |
        |*     : :  ** *  *  : ::*  * *: *  :: * :                          |
        |:**.* : *  :   : :  : :* + :*  ::+: ** :                           |
  20000 *+    :  : :    *:    ::   *    :  *    *                           |
        |     *   ::     *    :         *                                   |
  18000 ++        *           :                                             |
        |                     :                                             |
  16000 ++O    O    O     O   *         O     O  O          O  O   OO       O
        OO    O O    O O         O OO O     O      OOOOO     OO      OO     |
        |  O     OO   O OO  O        O     O    O         O     O O    O OOO|
  14000 ++   O               OO O      O O   O O        O  O                |
        |                      O                                            |
  12000 ++------------------------------------------------------------------+


                                 meminfo.PageTables

  10000 ++------------------------------------------------------------------+
        |                              O     O       O             O      O O
        |OO   O      O    O   O O  O               O   OO  O  OO    OOO  O  |
   9500 O+ O O OO   O OOOO  OO      O   OO    OOO   O O   O OO         O   O|
        |        OO            O O   OO    OO    O              O O         |
        |                                                                   |
   9000 ++                                                                  |
        |                                                                   |
   8500 ++                                                                  |
        |                    *                *                             |
        |***.****  .*   *    ::*  .**   *    * *                            |
   8000 *+       **  ** :*  : * :*   :** *.* :  *                           |
        |              *  *.*   *    *      *    *                          |
        |                                                                   |
   7500 ++------------------------------------------------------------------+


                              numa-meminfo.node0.MemFree

  3.8e+07 ++----------------------------------------------------------------+
  3.6e+07 *+          *    **           *    *                              |
          |* **.**    :   *  : *  .*** * :*.* : **                          |
  3.4e+07 ++*     ***: :.*   * : *    :: *    * : *                         |
  3.2e+07 ++         * *      * ::    *        *                            |
          |                     *                                           |
    3e+07 ++                                                                |
  2.8e+07 ++                                                                |
  2.6e+07 ++                                                                |
          |                                                                 |
  2.4e+07 ++                                                                |
  2.2e+07 ++             O                            O   O                 |
          |     OOOOOOOO  O OOO OO OO OOO O OOO OO O O OO   OO OOOOOO    OO |
    2e+07 OOOOO            O   O     O   O     O  O      O O         OO O  OO
  1.8e+07 ++----------------------------------------------------------------+


                              numa-meminfo.node0.MemUsed

  1.14e+08 ++---------------------------------------------------------------+
  1.12e+08 +OOOO            O        O             O     O O         OO O  OO
           O     OOOOOOOO O  OOOOOOOO  OOOOOOOOOO O OO OO    OOO OOOO    OO |
   1.1e+08 ++            O                            O   O     O           |
  1.08e+08 ++                                                               |
           |                                                                |
  1.06e+08 ++                                                               |
  1.04e+08 ++                                                               |
  1.02e+08 ++                                                               |
           |                     *                                          |
     1e+08 ++         * *      * ::    *       *                            |
   9.8e+07 ++*     * *: :*    * : *   + : *   * :  *                        |
           |* :*.** *  :  *.  : *  ***  * :** : *.*                         |
   9.6e+07 *+ *        *    **           *   *                              |
   9.4e+07 ++---------------------------------------------------------------+


                              numa-meminfo.node0.Inactive

  1.12e+08 ++---------------------------------------------------------------+
   1.1e+08 +OOOO            O        O                   O O               O|
           O     O OOOOOO O  OOOOOOOO  OO OOOO OO OOOO OO    OOO OOOOOO OOO O
  1.08e+08 ++     O      O               O    O       O   O     O           |
  1.06e+08 ++                                                               |
           |                                                                |
  1.04e+08 ++                                                               |
  1.02e+08 ++                                                               |
     1e+08 ++                                                               |
           |                                                                |
   9.8e+07 ++           *      * *     *                                    |
   9.6e+07 ++*     * ** :*    * ::*   + :     **   *                        |
           |* :*.** *  :  *.  : *  ***  * *** : *.*                         |
   9.4e+07 *+ *        *    **           *   *                              |
   9.2e+07 ++---------------------------------------------------------------+


                           numa-meminfo.node0.Inactive(file)

  1.12e+08 ++---------------------------------------------------------------+
   1.1e+08 +OOOO            O        O                   O O               O|
           O     O OOOOOO O  OO OOOOO  OO OOOO OO OOOO OO    OOO OOOOOO OOO O
  1.08e+08 ++     O      O     O         O    O       O   O     O           |
  1.06e+08 ++                                                               |
           |                                                                |
  1.04e+08 ++                                                               |
  1.02e+08 ++                                                               |
     1e+08 ++                                                               |
           |                                                                |
   9.8e+07 ++           *      * *     *                                    |
   9.6e+07 ++*     * ** :*    * ::*   + :     **   *                        |
           |* :*.** *  :  *.  : *  ***  * *** : *.*                         |
   9.4e+07 *+ *        *    **           *   *                              |
   9.2e+07 ++---------------------------------------------------------------+


                             numa-meminfo.node0.FilePages

  1.12e+08 ++---------------------------------------------------------------+
   1.1e+08 +OOOO            O        O             O     O O         OO O  OO
           O     OOOOOOOO O  OOOOOOOO  OOOOOOOOOO O OO OO    OOO OOOO    OO |
  1.08e+08 ++            O                            O   O     O           |
  1.06e+08 ++                                                               |
           |                                                                |
  1.04e+08 ++                                                               |
  1.02e+08 ++                                                               |
     1e+08 ++                                                               |
           |                                                                |
   9.8e+07 ++         * *      * *     *       *                            |
   9.6e+07 ++*     ***: :*    * ::*   + : *   * :  *                        |
           |* :*.**    :  *.  : *  ***  * :** : *.*                         |
   9.4e+07 *+ *        *    **           *   *                              |
   9.2e+07 ++---------------------------------------------------------------+


                           numa-meminfo.node0.PageTables

  3000 ++-----------------------------------------------------------O-------+
       |                                                           O        |
  2800 ++            O                                    O     O           |
  2600 ++       O   O     O                     O       O     O            O|
       |   OO          O     O   O                   O O                    O
  2400 ++O   OO   O  *O    O  O   OO O    *O    *     O      O   O    O O O |
       O           O :   O              O :*  O :OO      O                  |
  2200 ++   *      : :          O   O  O*OO:O  O:: O           O     O      |
       *O   :*    : : :  *  O*    * *   :   :   :*          O          O    |
  2000 ++  :  *O  * * : + * * *   :::  :    *. :                            |
  1800 +**.*   :  :   **   ::  + * * :.*      *:                            |
       |        ::         *    *    *         *                            |
  1600 ++       ::                                                          |
       |        *                                                           |
  1400 ++-------------------------------------------------------------------+


                              numa-meminfo.node1.MemFree

  3.8e+07 ++----------------------------------------------------------------+
  3.6e+07 ++     *      .*                   *                              |
          |      :*    *  *          *       ::                             |
  3.4e+07 ++*   * : * *   : ***     * :  *   :*  **                         |
  3.2e+07 +* * +   ::*     ::  ***.*  * * *.:  **                           |
          *   *    *       *           *    *                               |
    3e+07 ++                                                                |
  2.8e+07 ++                                                                |
  2.6e+07 ++                                                                |
          |                                                                 |
  2.4e+07 ++                                                                |
  2.2e+07 ++                                          O                     |
          |      O OO      OO  OOO O O  O O   O OOOO O O OO OO OO   O    O  O
    2e+07 OOOOO O O  OOO OO  OO     O OO O  OO O        O        OOO OO O OO|
  1.8e+07 ++-----------------------------------------------O----------------+


                              numa-meminfo.node1.MemUsed

  1.14e+08 O+-O--------------------------------------------O----------------+
  1.12e+08 +OO O O O  OOOOO   OO    O  OOOO OOOO     O  O        OOOOOO O OO|
           |      O OO      OO  OOOO O     O    O OOO  O OO  OOOO        O  O
   1.1e+08 ++                                         O                     |
  1.08e+08 ++                                                               |
           |                                                                |
  1.06e+08 ++                                                               |
  1.04e+08 ++                                                               |
  1.02e+08 ++                                                               |
           *   *    *       *      *    *   *                               |
     1e+08 +* * +   ::*    : : **** :  * * *:  **.                          |
   9.8e+07 ++*   * : * *   : **     * +   *  :*   **                        |
           |      :*    * *          *       *                              |
   9.6e+07 ++     *      *                                                  |
   9.4e+07 ++---------------------------------------------------------------+


                              numa-meminfo.node1.Inactive

  1.12e+08 ++----------------------------------------------O----------------+
   1.1e+08 OOOOO   O  OOOOO   OO       OO   OO          O        OOO OO   O |
           |     OO OO      OO  OOOOOO   OOO  OOO OOOO O OO  OOOO   O   OO OO
  1.08e+08 ++                                         O                     |
  1.06e+08 ++                                                               |
           |                                                                |
  1.04e+08 ++                                                               |
  1.02e+08 ++                                                               |
     1e+08 ++                                                               |
           |        *       *                                               |
   9.8e+07 ** **.   ::*    : :  ****    ** **  *                            |
   9.6e+07 ++::  * : * *   : ***    : .*  * : * *.**                        |
           | *    :*    * *         **       ::                             |
   9.4e+07 ++     *      *                   *                              |
   9.2e+07 ++---------------------------------------------------------------+


                           numa-meminfo.node1.Inactive(file)

  1.12e+08 ++----------------------------------------------O----------------+
   1.1e+08 OOOOO   O  O O O   OO        O    O                   OO   O   O |
           |     OO OO O O  OO  OOOOOO O OOOO OOO OOOO OOOO  OOOO  OOO  OO OO
  1.08e+08 ++                                         O                     |
  1.06e+08 ++                                                               |
           |                                                                |
  1.04e+08 ++                                                               |
  1.02e+08 ++                                                               |
     1e+08 ++                                                               |
           |        *       *                                               |
   9.8e+07 *+  *.   ::*    : :  * **    ** **  *                            |
   9.6e+07 +* *  * : * :   : * * *  : .*  * :  :*.**                        |
           | *    :*   ** *   *     **       :*                             |
   9.4e+07 ++     *      *                   *                              |
   9.2e+07 ++---------------------------------------------------------------+


                             numa-meminfo.node1.FilePages

  1.12e+08 O+----------------------------------------------O----------------+
   1.1e+08 +OOOO O O  OOOOO   OO    O  OO O OO O     O  O        OOOOOO O OO|
           |      O OO      OO  OOOO O   O O  O O OOO  O OO  OOOO        O  O
  1.08e+08 ++                                         O                     |
  1.06e+08 ++                                                               |
           |                                                                |
  1.04e+08 ++                                                               |
  1.02e+08 ++                                                               |
     1e+08 ++                                                               |
           *   *    *       *           *   *                               |
   9.8e+07 +* * +   ::*    : : *****   * * *:  **.                          |
   9.6e+07 ++*   * : * *   : **     * +   *  :*   **                        |
           |      :*    * *          *       *                              |
   9.4e+07 ++     *      *                                                  |
   9.2e+07 ++---------------------------------------------------------------+


                              numa-meminfo.node2.MemFree

  3.6e+07 ++--------------------*-------*-----------------------------------+
          |               *   * ::      :      *                            |
  3.4e+07 *+  *.*   *** .* *  : :*.*   : :     :                            |
  3.2e+07 +*  :  :**   *    ** :    * ** **.  : :**                         |
          | :*   *             *     *      *** *                           |
    3e+07 ++*                                                               |
  2.8e+07 ++                                                                |
          |                                                                 |
  2.6e+07 ++                                                                |
  2.4e+07 ++                                                                |
          |                                                                 |
  2.2e+07 ++                                          O                     |
    2e+07 ++    OOO    O       O    OOO OO  O OO O O       OO    O  O   OO  |
          OOO O    OOOO  O OOO  OO O   O  O  O  O O  O O OO  O OO OO OO   OOO
  1.8e+07 ++-O------------O---O-------------------------O-------------------+


                              numa-meminfo.node2.MemUsed

  1.16e+08 ++---------------------------------------------------------------+
  1.14e+08 ++ O           O    O                                            |
           OOO O     OOO O  O    O O    O    O     O O OO O   OO  O  O      O
  1.12e+08 ++    O OO   O    OO O O OO O OOOO OOO O O    O O O  OO OO O OOOO|
   1.1e+08 ++     O                                   O                     |
           |                                                                |
  1.08e+08 ++                                                               |
  1.06e+08 ++                                                               |
  1.04e+08 ++                                                               |
           | *                                                              |
  1.02e+08 ++::                 *    *      *   *.                          |
     1e+08 +* *   ***   *     * :   * + * ** ** : *                         |
           *   :.*   *** * .** : :**   *: :    :   *                        |
   9.8e+07 ++  *          *    * ::      :     *                            |
   9.6e+07 ++--------------------*-------*----------------------------------+


                              numa-meminfo.node2.Inactive

  1.12e+08 ++-O-----------O----O--------------------------------------------+
           OOO O    OOOO      O  OOO    O  O O  O  O O  OOO   OO  OO OO   O O
   1.1e+08 ++    OOO    OO  OO  O   OO O OO O OO  O O  O   O O  OO  O   OO O|
  1.08e+08 ++                                         O                     |
           |                                                                |
  1.06e+08 ++                                                               |
  1.04e+08 ++                                                               |
           |                                                                |
  1.02e+08 ++                                                               |
     1e+08 ++*                                                              |
           | ::                 *    *.     *** *.                          |
   9.8e+07 +* *   ***    *   ** :   *  ** **  : : **                        |
   9.6e+07 *+  *.*   **** :.*  * :**    : :    :                            |
           |              *      ::      :     *                            |
   9.4e+07 ++--------------------*-------*----------------------------------+


                           numa-meminfo.node2.Inactive(file)

  1.12e+08 ++-O-----------O----O--------------------------------------------+
           OOO O    OOOO      O  O O       O    O  O O  OOO   OO  OO O    O O
   1.1e+08 ++    O O    OO  OO  O O OO OOOO OOOO  O O  O   O O  OO  O O OO O|
  1.08e+08 ++     O                                   O                     |
           |                                                                |
  1.06e+08 ++                                                               |
  1.04e+08 ++                                                               |
           |                                                                |
  1.02e+08 ++                                                               |
     1e+08 ++*                                                              |
           | ::                 *    *      *** *.                          |
   9.8e+07 +* *   ***        ** :   * + * **  : : **                        |
   9.6e+07 *+  *.*   * *** .*  * :**   *: :    :                            |
           |          *   *      ::      :     *                            |
   9.4e+07 ++--------------------*-------*----------------------------------+


                             numa-meminfo.node2.FilePages

  1.14e+08 ++---------------------------------------------------------------+
  1.12e+08 ++ O           O    O                                            |
           OOO O     OOO O  O    O O    O    O     O O OO O   OO  O  OO    OO
   1.1e+08 ++    O OO   O    OO O O OO O OOOO OOO O O    O O O  OO OO   OOO |
  1.08e+08 ++     O                                   O                     |
           |                                                                |
  1.06e+08 ++                                                               |
  1.04e+08 ++                                                               |
  1.02e+08 ++                                                               |
           | *                                                              |
     1e+08 ++::                 *    *      *   *.                          |
   9.8e+07 +* *   ***   *    ** :   * + * ** ** : *                         |
           *   *.*   *** * .*  : :**   *: :    :   *                        |
   9.6e+07 ++             *    * ::      :     *                            |
   9.4e+07 ++--------------------*-------*----------------------------------+


                              numa-meminfo.node3.MemFree

  3.8e+07 ++----------------------------------------------------------------+
  3.6e+07 ++  *.*                        *                                  |
          |  *  :                       *:                                  |
  3.4e+07 *+ :   :     *.** *  * *.    *  :.*  * *                          |
  3.2e+07 +**    ******    * ** :: ** *   *  * :* *                         |
          |                     *    *        *                             |
    3e+07 ++                                                                |
  2.8e+07 ++                                                                |
  2.6e+07 ++                                                                |
          |                                                                 |
  2.4e+07 ++                                                                |
  2.2e+07 ++                                          O                     |
          |          O    OOOO  OO O  O OO  O OO  O  O     OO   O       O O |
    2e+07 OO OO OOOOO OO O    OO    OO O  O  O  OO O   OOOO  O O OOOOOO  O OO
  1.8e+07 ++O---------------------------------------------------------------+


                              numa-meminfo.node3.MemUsed

  1.14e+08 ++O-O------------------------------------------------------------+
  1.12e+08 OO O  OOOOO OOO    OOO   OO  O  O O  O O OO OOOO   OO OOOOOO OOOOO
           |          O   O OO   OOO   O OO O OO   O       O O  O           |
   1.1e+08 ++                                         O                     |
  1.08e+08 ++                                                               |
           |                                                                |
  1.06e+08 ++                                                               |
  1.04e+08 ++                                                               |
  1.02e+08 ++                                                               |
           |                     *   *.       *                             |
     1e+08 +**    ******   .* ** ::**  *   * * **. *                        |
   9.8e+07 *+ :   :     ***  *  * *     *  :*     *                         |
           |  **.:                       *:                                 |
   9.6e+07 ++    *                        *                                 |
   9.4e+07 ++---------------------------------------------------------------+


                              numa-meminfo.node3.Inactive

  1.12e+08 ++O--------------------------------------------------------------+
   1.1e+08 OO OO OOOOO OOO     OO   OO  O  O O  O O O  OO O    O OOOOOO O OOO
           |          O   O OOO  OOO   O OO O OO   O O   O   OO O        O  |
  1.08e+08 ++                                         O    O                |
  1.06e+08 ++                                                               |
           |                                                                |
  1.04e+08 ++                                                               |
  1.02e+08 ++                                                               |
     1e+08 ++                                                               |
           |                     *   *.                                     |
   9.8e+07 +**    ******   .* *  ::**  *     ** *. *                        |
   9.6e+07 *+ :   :     ***  * ** *     *  **  *  *                         |
           |  **.:                       * :                                |
   9.4e+07 ++    *                        *                                 |
   9.2e+07 ++---------------------------------------------------------------+


                           numa-meminfo.node3.Inactive(file)

  1.12e+08 ++O--------------------------------------------------------------+
   1.1e+08 OO OO OOOOO OOO     OO   OO  O  O O  O O O  OO O    O OOOOOO O OOO
           |          O   O OOO  OOO   O OO O OO   O O   O   OO O        O  |
  1.08e+08 ++                                         O    O                |
  1.06e+08 ++                                                               |
           |                                                                |
  1.04e+08 ++                                                               |
  1.02e+08 ++                                                               |
     1e+08 ++                                                               |
           |                     *   *.                                     |
   9.8e+07 +**    ******   .* *  ::**  *     ** *. *                        |
   9.6e+07 *+ :   :     ***  * ** *     *  **  *  *                         |
           |  **.:                       * :                                |
   9.4e+07 ++    *                        *                                 |
   9.2e+07 ++---------------------------------------------------------------+


                             numa-meminfo.node3.FilePages

  1.14e+08 ++---------------------------------------------------------------+
  1.12e+08 ++O                                                              |
           OO OO OOOOO OOO     OO   OO  O  O O  O O O  OOOO   OO OOOOOO  O OO
   1.1e+08 ++         O   O OOO  OOO   O OO O OO   O O     O O  O       O O |
  1.08e+08 ++                                         O                     |
  1.06e+08 ++                                                               |
  1.04e+08 ++                                                               |
           |                                                                |
  1.02e+08 ++                                                               |
     1e+08 ++                    *                                          |
   9.8e+07 ++*    ** ***      *  ::* *.*     ** *. *                        |
   9.6e+07 ** :   : *   ***.** ** * *   *  **  *  *                         |
           |  *  :                       * :                                |
   9.4e+07 ++  *.*                        *                                 |
   9.2e+07 ++---------------------------------------------------------------+


                            numa-vmstat.node0.nr_free_pages

  9.5e+06 ++----------------------------------------------------------------+
    9e+06 *+          *    *         *  *                                   |
          |* **.** *  :   * *  *  .**: * :*.**  ***                         |
  8.5e+06 ++*     * *: :  :  * ::*    :: *    * :                           |
    8e+06 ++         * *.*    * *     *        *                            |
          |                                                                 |
  7.5e+06 ++                                                                |
    7e+06 ++                                                                |
  6.5e+06 ++                                                                |
          |                                                                 |
    6e+06 ++                                                                |
  5.5e+06 ++             O                            O   O                 |
          |     OOOOOOOO  O OOOOOO OO OOO O OOO OO O O OO   OO OOOOOO    O  |
    5e+06 OOOOO            O         O   O     O  O      O O         OO O OOO
  4.5e+06 ++----------------------------------------------------------------+


                          numa-vmstat.node0.nr_inactive_file

   2.8e+07 ++---------------------------------------------------------------+
  2.75e+07 +OOOO            O                            O O                O
           O     OOOOOOOO O  OO OOOOOO OO OOOO OO OOOO OO    OOOOOOOOOO OOOO|
   2.7e+07 ++            O     O         O    O       O   O                 |
  2.65e+07 ++                                                               |
           |                                                                |
   2.6e+07 ++                                                               |
  2.55e+07 ++                                                               |
   2.5e+07 ++                                                               |
           |                                                                |
  2.45e+07 ++           *      * *     *       *                            |
   2.4e+07 ++*     * ** :*    *: :*   : :     * :                           |
           |* **.** *  :  *.  : :  ** : * * **  *.**                        |
  2.35e+07 *+          *    **  *    *   * *                                |
   2.3e+07 ++---------------------------------------------------------------+


                            numa-vmstat.node0.nr_file_pages

   2.8e+07 ++---------------------------------------------------------------+
  2.75e+07 +OOOO            O                      O     O O         OO O  OO
           O     OOOOOOOO O  OOOOOOOOO OOOOOOOOOO O OO OO    OOOOOOOO    OO |
   2.7e+07 ++            O                            O   O                 |
  2.65e+07 ++                                                               |
           |                                                                |
   2.6e+07 ++                                                               |
  2.55e+07 ++                                                               |
   2.5e+07 ++                                                               |
           |                                                                |
  2.45e+07 ++         * *      * *     *       *                            |
   2.4e+07 ++*     * *: :*    * ::*   : : *   * :                           |
           |* **.** *  :  *. *  *  ** : * :***  *.**                        |
  2.35e+07 *+          *    *        *   *                                  |
   2.3e+07 ++---------------------------------------------------------------+


                       numa-vmstat.node0.nr_page_table_pages

  750 ++------------------------------------------------------------O-------+
      |                                                            O        |
  700 ++            O                                     O     O           |
  650 ++       O         O                      O       O     O            O|
      |   OO       O   O        O                   O  O                    O
  600 ++O   OO   O  *O    O  OO  OO  O    *O    *    O       O   O    O O   |
      O           O :   O              O : * O  :O       O                O |
  550 ++   *      : :          O    O O*O:O:O O: :OO           O     O      |
      *O   :*    : : :  *  O     *  *  :*   :  : *         O           O    |
  500 ++  :  :O  * * :  :* *.**  ::+: :     *  :                            |
  450 +**.*  *:  :   *.*  ::   :* *  :*      *:                             |
      |        ::         *    *     *        *                             |
  400 ++       ::                                                           |
      |        *                                                            |
  350 ++--------------------------------------------------------------------+


                              numa-vmstat.node0.numa_hit

    2e+08 ++----------------------------------------------------------------+
          |    .*     *                                                     |
  1.9e+08 *****  ***** *.*********.*** ****.**** **                         |
          |                           *         *                           |
  1.8e+08 ++                                                                |
          |                                                                 |
  1.7e+08 ++                                                                |
          |                                                                 |
  1.6e+08 ++                                                                |
          |                                                                 |
  1.5e+08 ++                                                                |
          |      OO  O   O    O O    O  OO    OO      OO  OOO      OO     O |
  1.4e+08 OOOOO O  OO OO  OOOO O O  O  O  O  O  OOOO O  OO   O OOOO  OO OO OO
          |                        O  O     O                               |
  1.3e+08 ++----------------------------------------------------------------+


                              numa-vmstat.node0.numa_miss

    3e+07 ++----------------------------------------------------------------+
  2.8e+07 ++         O                                       O  O           |
          |O    OOO O O   OO       OOO    O     OO O OOOO OO     O          |
  2.6e+07 ++OOO    O   O O    OOOO    OO O  OO O  O      O  O  O            |
  2.4e+07 O+                OO          O     O                     OO      |
  2.2e+07 ++                                                      O     OOOOO
    2e+07 ++                                                       O  O     |
          |                                                                 |
  1.8e+07 ++                                                                |
  1.6e+07 ++                                                                |
  1.4e+07 ++                                                                |
  1.2e+07 *+      *    *.  *                 *                              |
          |***   * * * : ** *  ***.*  *  *   :*  *                          |
    1e+07 ++  *. :  * *      **     ** ** *.*  ** *                         |
    8e+06 ++----*-----------------------------------------------------------+


                            numa-vmstat.node0.numa_foreign

  2.6e+07 ++----------------------------------------------------------------+
  2.4e+07 ++    O O      O OO O OO   O  O O   O O          O O  O           |
          |OO    O OOOOO  O  O O   OO OO O  OO O OOO OOO  O O  O O          |
  2.2e+07 O+ OO                                         OO        OO  O  OOO|
    2e+07 ++                                                        OO  O   O
          |                                                                 |
  1.8e+07 ++                                                                |
  1.6e+07 ++                                                                |
  1.4e+07 ++                                                                |
          |                                                                 |
  1.2e+07 ++                                                                |
    1e+07 ++              *                                                 |
          |        **  *.* *  *** .*     *                                  |
    8e+06 *****. **  **     **   *  ***** *.*******                         |
    6e+06 ++----*-----------------------------------------------------------+


                             numa-vmstat.node0.numa_local

    2e+08 ++----------------------------------------------------------------+
          |    .*     *                                                     |
  1.9e+08 *****  ***** *.*********.*** ****.**** **                         |
          |                           *         *                           |
  1.8e+08 ++                                                                |
          |                                                                 |
  1.7e+08 ++                                                                |
          |                                                                 |
  1.6e+08 ++                                                                |
          |                                                                 |
  1.5e+08 ++                                                                |
          |      OO  O   O    O O    O  OO    OO      OO  OOO      OO     O |
  1.4e+08 OOOOO O  OO OO  OOOO O O  O  O  O  O  OOOO O  OO   O OOOO  OO OO OO
          |                        O  O     O                               |
  1.3e+08 ++----------------------------------------------------------------+


                             numa-vmstat.node0.numa_other

    3e+07 ++----------------------------------------------------------------+
  2.8e+07 ++         O                                       O  O           |
          |O    OOO O O   OO       OOO    O     OO O OOOO OO     O          |
  2.6e+07 ++OOO    O   O O    OOOO    OO O  OO O  O      O  O  O            |
  2.4e+07 O+                OO          O     O                     OO      |
  2.2e+07 ++                                                      O     OOOOO
    2e+07 ++                                                       O  O     |
          |                                                                 |
  1.8e+07 ++                                                                |
  1.6e+07 ++                                                                |
  1.4e+07 ++                                                                |
  1.2e+07 *+      *    *.  *                 *                              |
          |***   * * * : ** *  ***.*  *  *   :*  *                          |
    1e+07 ++  *. :  * *      **     ** ** *.*  ** *                         |
    8e+06 ++----*-----------------------------------------------------------+


                      numa-vmstat.node0.workingset_nodereclaim

  750000 ++-----------------------------------------------------------------+
         |           *.** **  .*        **                                  |
  700000 *+**.*******    *  **  ******.*  *****. **                         |
  650000 +*                                     *                           |
         |                                                                  |
  600000 ++                                                                 |
  550000 ++                                                                 |
         |                                                                  |
  500000 ++                                                                 |
  450000 ++         O                                OO                     |
         |       O      O    O          OO   OO           OOOO  O           |
  400000 OO    OO  O   O OO O  O    O            O OO   OO       O          |
  350000 ++O  O   O  O     O    OO O   O  O O   O O           O    OO  O OO |
         |  O                     O  O     O                         OO    OO
  300000 ++-------------------------------------------------------O---------+


                            numa-vmstat.node1.nr_free_pages

  9.5e+06 ++----------------------------------------------------------------+
    9e+06 ++     *                                                          |
          |      :*    *.**          *       *                              |
  8.5e+06 ++*   * : * *   :  **     * :  **  :* ***                         |
    8e+06 +* * +   ::*     :*  ***.*  * *  +:  *                            |
          *   *    *       *           *    *                               |
  7.5e+06 ++                                                                |
    7e+06 ++                                                                |
  6.5e+06 ++                                                                |
          |                                                                 |
    6e+06 ++                                                                |
  5.5e+06 ++                                          O                     |
          |      O OO      OO OOOO O O  O O   O OOOO O O OO OO OO   O    O OO
    5e+06 OOOOO O O  OOO OO  O      O OO O  OO O        O        OOO OO O O |
  4.5e+06 ++-----------------------------------------------O----------------+


                          numa-vmstat.node1.nr_inactive_file

   2.8e+07 ++----------------------------------------------O----------------+
  2.75e+07 OOOOO O O  O O O   O         O    O                   OO   O   O |
           |      O OO O O  OO OOOOOOO O OOOO OOO OOOO OOOO  OOOO  OOO  OO OO
   2.7e+07 ++                                         O                     |
  2.65e+07 ++                                                               |
           |                                                                |
   2.6e+07 ++                                                               |
  2.55e+07 ++                                                               |
   2.5e+07 ++                                                               |
           |                *                                               |
  2.45e+07 *+  *.   * *    : *    **    **  *  *                            |
   2.4e+07 +* *  *  ::::   :  ****  : .*  ** : :*.*                         |
           | *    :* * ****         **       **    *                        |
  2.35e+07 ++     *                                                         |
   2.3e+07 ++---------------------------------------------------------------+


                            numa-vmstat.node1.nr_file_pages

   2.8e+07 ++----------------------------------------------O----------------+
  2.75e+07 OOOOO OOO  OOOOO   OO  O O  OO O OO O     O  O       OOOOOOO O O |
           |        OO      OO  OO O O   O O  O O OOO  O OO  OOO         O OO
   2.7e+07 ++                                         O                     |
  2.65e+07 ++                                                               |
           |                                                                |
   2.6e+07 ++                                                               |
  2.55e+07 ++                                                               |
   2.5e+07 ++                                                               |
           *   *    *       *           *   *                               |
  2.45e+07 +* * +   ::*    : *  ****   * *  :  *                            |
   2.4e+07 ++*   * : * *   :  **    * +   ** :* *.**                        |
           |      :*    ***          *       *                              |
  2.35e+07 ++     *                                                         |
   2.3e+07 ++---------------------------------------------------------------+


                              numa-vmstat.node1.numa_hit

    2e+08 ++----------------------------------------------------------------+
          *****.***  ***. ****** *.     * *. *                              |
  1.9e+08 ++       **    *      *  ***** *  * *****                         |
          |                                                                 |
  1.8e+08 ++                                                                |
          |                                                                 |
  1.7e+08 ++                                                                |
          |                                                                 |
  1.6e+08 ++                                                                |
          |                                                                 |
  1.5e+08 ++                                                                |
          |                                           O        O            |
  1.4e+08 ++OOO   O OOO   O O  O O  O  OOOO  OOOOO O O OOOOO      OOOO  OO  O
          OO    OO O   O O O OO O  O OO     O     O         OO  OO    O   OO|
  1.3e+08 ++----------------------------------------------------------------+


                              numa-vmstat.node1.numa_miss

    3e+07 ++----------------------------------------------------------------+
          |                   O      O                       O              |
          |OO   OOOOOOOO OOOO   OO O  OOO O OOO OOOO  OO  OOO   OOO        O|
  2.5e+07 O+ O               O O    O    O     O     O  OO     O   O  O OO  |
          |   O                                                     OO    O |
          |                                                                 O
    2e+07 ++                                                                |
          |                                                                 |
  1.5e+07 ++                                                                |
          |                                                                 |
          |                                                                 |
    1e+07 ++       **  *.**                                                 |
          * ***. **  * :   *******.*** ****. ******                         |
          |*    *     *               *     *                               |
    5e+06 ++----------------------------------------------------------------+


                            numa-vmstat.node1.numa_foreign

  2.6e+07 ++----------------------------------------------------------------+
  2.4e+07 ++                              O     O         O                 |
          |       O    O       O O                 O  O        OO           |
  2.2e+07 OOOOO O   OOO  OOOOOO O  OOOOOOO  OOOO OO  O O O OOO   O          |
    2e+07 ++     O O                                    O         O OO  O O |
          |                                                        O  O  O OO
  1.8e+07 ++                                                                |
  1.6e+07 ++                                                                |
  1.4e+07 ++                                                                |
          |                                                                 |
  1.2e+07 ++                                                                |
    1e+07 ++                                                                |
          |**    *     *. **  * * .** *   *.* * * *                         |
    8e+06 *+ **. :*****  *  ** * *   * ***   * * *                          |
    6e+06 ++----*-----------------------------------------------------------+


                             numa-vmstat.node1.numa_local

    2e+08 ++----------------------------------------------------------------+
          *****.***  ***. ****** *.     * *. *                              |
  1.9e+08 ++       **    *      *  ***** *  * *****                         |
          |                                                                 |
  1.8e+08 ++                                                                |
          |                                                                 |
  1.7e+08 ++                                                                |
          |                                                                 |
  1.6e+08 ++                                                                |
          |                                                                 |
  1.5e+08 ++                                                                |
          |                                           O        O            |
  1.4e+08 ++OOO   O OOO   O O  O O  O  OOOO  OOOOO O O OOOOO      OOOO  O   O
          OO    OO O   O O O OO O  O OO     O     O         OO  OO    O  OOO|
  1.3e+08 ++----------------------------------------------------------------+


                             numa-vmstat.node1.numa_other

    3e+07 ++----------------------------------------------------------------+
          |                   O      O                       O              |
          |OO   OOOOOOOO OOOO   OO O  OOO O OOO OOOO  OO  OOO   OOO        O|
  2.5e+07 O+ OO              O O    O    O     O     O  OO     O   O  O OO  |
          |                                                         OO    O |
          |                                                                 O
    2e+07 ++                                                                |
          |                                                                 |
  1.5e+07 ++                                                                |
          |                                                                 |
          |                                                                 |
    1e+07 ++       **  *.**                                                 |
          * ***. **  * :   *******.*** ****. ******                         |
          |*    *     *               *     *                               |
    5e+06 ++----------------------------------------------------------------+


                      numa-vmstat.node1.workingset_nodereclaim

  750000 ++-----------------------------------------------------------------+
  700000 ** *.** ** **.******    *      *                                   |
         | *    *  *         *.** ****.* ******.***                         |
  650000 ++                                                                 |
  600000 ++                                                                 |
         |                                                                  |
  550000 ++                                                                 |
  500000 ++                                                                 |
  450000 ++                                                                 |
         |                                                                  |
  400000 ++         O      O                         O                      |
  350000 ++OO  OOO O O    O     OOO    OOOO OOO OO O  O  OOO  O O O         |
         OO   O   O      O  OO O   OOO     O      O O   O   OO   O OOO O OOOO
  300000 ++            OO                                             O     |
  250000 ++-----------------------------------------------------------------+


                            numa-vmstat.node2.nr_free_pages

  9.5e+06 ++----------------------------------------------------------------+
    9e+06 ++                    *                                           |
          |               *     ::      *                                   |
  8.5e+06 *+  *.*   ***   :*  * :*.*    ::     *  *                         |
    8e+06 +*  :  :**   *.*  ** :    : ** **.   ::*                          |
          | :*   *             *    **      *** *                           |
  7.5e+06 ++*                                                               |
    7e+06 ++                                                                |
  6.5e+06 ++                                                                |
          |                                                                 |
    6e+06 ++                                                                |
  5.5e+06 ++                                                                |
          |      OO    O       O    OOO O   O O       O    O     O      OO O|
    5e+06 O+O O O  OOOO  O OOO  OO O   O OO  O OOOOO O O OO OO OO OOOOO   O O
  4.5e+06 +O-O------------O---O-------------------------O-------------------+


                          numa-vmstat.node2.nr_inactive_file

   2.8e+07 +O-O-----------O----O--------------------------------------------+
  2.75e+07 O+O O    OO O O  O O  OOO      O    O   OOO OOOO   OOO OO OO   O O
           |     OOO  O O    O  O   OO OOO OOOO O O   O    O O   O  O   OO O|
   2.7e+07 ++                                                               |
  2.65e+07 ++                                                               |
           |                                                                |
   2.6e+07 ++                                                               |
  2.55e+07 ++                                                               |
   2.5e+07 ++*                                                              |
           | ::                 *   *       *** *.                          |
  2.45e+07 +* *   ***    *   ** :   :*. * **   :: **                        |
   2.4e+07 *+  *.*   **** :.*  * :**   * ::    *                            |
           |              *      ::      *                                  |
  2.35e+07 ++                    *                                          |
   2.3e+07 ++---------------------------------------------------------------+


                            numa-vmstat.node2.nr_file_pages

  2.85e+07 ++---------------------------------------------------------------+
   2.8e+07 ++ O           O    O                                            |
           OOO O     O O O  O    OOO    O    O     O O OO     OOO    OO   O O
  2.75e+07 ++    OOOO O O    OO O   OO O OOOO OOO O O    OOO O   OOOO   OO O|
   2.7e+07 ++                                         O                     |
           |                                                                |
  2.65e+07 ++                                                               |
   2.6e+07 ++                                                               |
  2.55e+07 ++                                                               |
           | *                                                              |
   2.5e+07 ++::                 *    *      **  *.                          |
  2.45e+07 +* *   **    **   ** :   * + * **  * : *                         |
           *   :.*  ****  :.*  : :**   *: :    *   *                        |
   2.4e+07 ++  *          *    * ::      :                                  |
  2.35e+07 ++--------------------*-------*----------------------------------+


                        numa-vmstat.node2.nr_isolated_file

  600 ++--------------------------------------------------------------------+
      |    *                                                                |
  550 ++ .* :      *    *    * *            * *.                            |
  500 ***   *  *  * O*  : * :: :*   **  *  *: : **                          |
      |      * :+ : * +: :::: :: : :  ** : : :                        O     |
  450 ++      :  *     * * *  :  * :     : : *                 O   O        |
      |       *         O     *   *       :                                 |
  400 ++                  O       O       *                               O |
      |              O O   O           O     O    O                         |
  350 ++O                        O                 OOO     O O  O      O   O|
  300 +O     OO              OO     O     O             O O   O  O  OO  O   O
      O   OOO  O OO      O     OO    OO O  OO O  O     O                    |
  250 ++           O                            O        O                  |
      |                                                                     |
  200 ++--------------------------------------------------------------------+


                              numa-vmstat.node2.numa_hit

     2e+08 ++---------------------------------------------------------------+
  1.95e+08 *****.**********.*** * *      *   *                              |
           |                   * * ***.** *** ***.**                        |
   1.9e+08 ++                                                               |
  1.85e+08 ++                                                               |
   1.8e+08 ++                                                               |
  1.75e+08 ++                                                               |
           |                                                                |
   1.7e+08 ++                                                               |
  1.65e+08 ++                                                               |
   1.6e+08 ++                                                               |
  1.55e+08 ++O     O  O   O    O  O  O  OO   OO   O  O OO       O           |
           |   O OO  O O O  OOO OO OO  O  OOO  OO  OO O  OOO OOO O OO O    OO
   1.5e+08 OO O     O   O                                         O  O  OOO |
  1.45e+08 ++---------------------------------------------------------------+


                              numa-vmstat.node2.numa_miss

  2.4e+07 ++------------------------------O-----O---------------------------+
  2.2e+07 ++      O            O        O     O       O   O                 |
          OOO O O   OO O O  OOO OO O OO  O  O  O OOO O     OO  OOO          |
    2e+07 ++ O   O O  O   OO        O  O     O         O O   O    O OO   OOO|
  1.8e+07 ++                                            O          O  O O   O
          |                                                                 |
  1.6e+07 ++                                                                |
  1.4e+07 ++                                                                |
  1.2e+07 ++                                                                |
          |                                                                 |
    1e+07 ++                                                                |
    8e+06 ++          **. **  * * .*  *    .* * *                           |
          ***  .******   *  ** * *  ** ****  ::* **                         |
    6e+06 ++ **                              *                              |
    4e+06 ++----------------------------------------------------------------+


                            numa-vmstat.node2.numa_foreign

  3.5e+07 ++----------------------------------------------------------------+
          |                                                                 |
    3e+07 ++     O                   O O     O                              |
          |O  O O OOOOO  O OOOO OO O     OO    OOOOO OOOOOOOOO  OO          |
          O OO         O  O    O    O O O   O O                O  O        O|
  2.5e+07 ++                                                        OOO O O O
          |                                                        O     O  |
    2e+07 ++                                                                |
          |                                                                 |
  1.5e+07 ++                                                                |
          |                                                                 |
          *       *     .*    * *                                           |
    1e+07 +****. * *****  **** * *.********.*** ***                         |
          |     *                              *                            |
    5e+06 ++----------------------------------------------------------------+


                             numa-vmstat.node2.numa_local

     2e+08 ++---------------------------------------------------------------+
  1.95e+08 *****.**********.*** * *      *   *                              |
           |                   * * ***.** *** ***.**                        |
   1.9e+08 ++                                                               |
  1.85e+08 ++                                                               |
   1.8e+08 ++                                                               |
  1.75e+08 ++                                                               |
           |                                                                |
   1.7e+08 ++                                                               |
  1.65e+08 ++                                                               |
   1.6e+08 ++                                                               |
  1.55e+08 ++O     O  O   O    O  O  O  OO   OO   O  O OO                   |
           |   O OO  O O O  OOO OO OO  O  OOO  OO  OO O  OOO OOOOO OO O    OO
   1.5e+08 OO O     O   O                                         O  O  OOO |
  1.45e+08 ++---------------------------------------------------------------+


                             numa-vmstat.node2.numa_other

  2.4e+07 ++------------------------------O-----O---------------------------+
          |       O            O                      O   O                 |
  2.2e+07 +O  O O   OO O O  O O OO O OO O   O O    O O     OO  OOO          |
    2e+07 O+OO     O  O   OO O      O  O O   O O OO    O O   O      OO   OO |
          |      O                                      O         O   O O  OO
  1.8e+07 ++                                                       O        |
  1.6e+07 ++                                                                |
          |                                                                 |
  1.4e+07 ++                                                                |
  1.2e+07 ++                                                                |
          |                                                                 |
    1e+07 ++                                                                |
    8e+06 ++           *. *   * *  *  *       * *                           |
          * *    **** *  * *  :* :+ ** * **.* :* **                         |
    6e+06 +*-**-*----*------**---*------*----*------------------------------+


                      numa-vmstat.node2.workingset_nodereclaim

  750000 ++-----------------------------------------------------------------+
         ** *.**  ****.  **  *.* *      **  *                               |
  700000 ++*    **     **  **   * ****. : ** * .***                         |
         |                             *      *                             |
  650000 ++                                                                 |
  600000 ++                                                                 |
         |                                                                  |
  550000 ++                                                                 |
         |       O                                                          |
  500000 ++                            OO   OO      O         O             |
  450000 ++O  O    OO    O O O OOOO O    OO   O OOOO OO OOO  O  OO          |
         |     OO    O  O   O      O                       OO       OO     OO
  400000 ++ O     O    O             O     O                      OO   O OO |
         |O               O                                           O     |
  350000 O+-----------------------------------------------------------------+


                            numa-vmstat.node3.nr_free_pages

  9.5e+06 ++----------------------------------------------------------------+
    9e+06 ++  *.*                        *                                  |
          |  *  :                       *:                                  |
  8.5e+06 ** :   : *   *.**   ** *.    *  :.*    **                         |
    8e+06 ++*    ** ***    ***  :: ****   *  * **                           |
          |                     *             *                             |
  7.5e+06 ++                                                                |
    7e+06 ++                                                                |
  6.5e+06 ++                                                                |
          |                                                                 |
    6e+06 ++                                                                |
  5.5e+06 ++                                          O                     |
          |          O    OOOO  OO O O  OOO   OOO O  O   O OO  OO O        O|
    5e+06 OO OO OOOOO OO O    OO    O OO    OO   O O   OO O  O   O OOOO OOO O
  4.5e+06 ++O---------------------------------------------------------------+


                          numa-vmstat.node3.nr_inactive_file

   2.8e+07 ++O--------------------------------------------------------------+
  2.75e+07 OO OO OOOOO OOO     OO   O  OO   OO    O O  OO O    O O OOOO O O O
           |          O   O OOO  OOO O   OOO  OOO  O O   O   OO O O      O O|
   2.7e+07 ++                                         O    O                |
  2.65e+07 ++                                                               |
           |                                                                |
   2.6e+07 ++                                                               |
  2.55e+07 ++                                                               |
   2.5e+07 ++                                                               |
           |                     *                                          |
  2.45e+07 ++*    ** ***   .* *  ::***.*     ** *.                          |
   2.4e+07 ** :   : *   ***  * ** *     *  **  *  **                        |
           |  *  :                       * :                                |
  2.35e+07 ++  *.*                        *                                 |
   2.3e+07 ++---------------------------------------------------------------+


                            numa-vmstat.node3.nr_file_pages

  2.85e+07 ++---------------------------------------------------------------+
   2.8e+07 ++O                                                              |
           OO OO OOOOO OOO     OO   O   O    O    O O  OO O   O  O OOOO  OO O
  2.75e+07 ++         O   O OOO  OOO O O OOOO OOO  O O   O O O OO O     O  O|
   2.7e+07 ++                                         O                     |
  2.65e+07 ++                                                               |
   2.6e+07 ++                                                               |
           |                                                                |
  2.55e+07 ++                                                               |
   2.5e+07 ++                    *                                          |
  2.45e+07 ++*    ** ***   .* *  ::***.      **                             |
   2.4e+07 ** :   : *   :**  * ** *    **  **  **.**                        |
           |  *  :      *                * :                                |
  2.35e+07 ++  *.*                        *                                 |
   2.3e+07 ++---------------------------------------------------------------+


                        numa-vmstat.node3.nr_isolated_file

  600 ++--------------------------------------------------------------------+
      |                    *                                                |
  550 ++            *      :   *          *                                 |
      | *           :    *: : *:         : * *                      O       |
  500 +* +  **   *  ::   :* : : :**      :  ::*                             |
      |:  **  * + *O *. *    :  *  + ** *   *  +                            |
  450 O+       *   :   *     *      *  ::       *                         O |
      |            *              O    *         *     O           O        |
  400 ++   O            O                                                   |
      |              O                              O    O                  |
  350 ++    OOO   O    O   O           O     O     O    O       O          O|
      | O O    O O        O   O  O  OO  O OO  O  O   O    OO OOO       OO   O
  300 +O            O    O   O OO     O     O   O O                   O     |
      |                                                          O   O      |
  250 ++--------------------------------------------------------------------+


                              numa-vmstat.node3.numa_hit

    2e+08 ++----------------------------------------------------------------+
          *****.********.**** ** *.     *    *   *                          |
  1.9e+08 ++                 *  *  ***** **.* *** *                         |
          |                                                                 |
  1.8e+08 ++                                                                |
          |                                                                 |
  1.7e+08 ++                                                                |
          |                                                                 |
  1.6e+08 ++                                                                |
          |                                                                 |
  1.5e+08 ++              O                                                 |
          OOO O OOO OOOO   OO OOO   OO  OOO   OOOOOO OOOOOOO O OOOOOOOO OOOOO
  1.4e+08 ++ O     O     O   O   O O  OO    OO              O               |
          |                                                                 |
  1.3e+08 ++----------------------------------------------------------------+


                              numa-vmstat.node3.numa_miss

    3e+07 ++----------------------------------------------------------------+
          |      O       O   O       O O     O                              |
          |     O OOO O    OO OOOO O     OO    OOOOO  OOOOOOO  OOO          |
  2.5e+07 OOOOO      O O  O         O O O   O O      O       O              |
          |                                                       O     O  OO
          |                                                        OOOO  OO |
    2e+07 ++                                                                |
          |                                                                 |
  1.5e+07 ++                                                                |
          |                                                                 |
          |                                                                 |
    1e+07 ++                 *  *                                           |
          *****.  ******.**** ** *.********.*   ***                         |
          |     **                           ***                            |
    5e+06 ++----------------------------------------------------------------+


                            numa-vmstat.node3.numa_foreign

  2.8e+07 ++----------------------------------------------------------------+
  2.6e+07 +O    OOO  O O  OO       O OO   O O   OO O O     O O  OO          |
          | O O    OO O  O  O OOOO  O  OO    OO   O   OOOOO O  O            |
  2.4e+07 O+ O               O           O     O                  O OO  OO O|
  2.2e+07 ++                                                       O  O   O O
    2e+07 ++                                                                |
  1.8e+07 ++                                                                |
          |                                                                 |
  1.6e+07 ++                                                                |
  1.4e+07 ++                                                                |
  1.2e+07 ++                                                                |
    1e+07 *+      **   *. *                                                 |
          |****. *  ***  * *******.* ******. ** ***                         |
    8e+06 ++    *                   *       *  *                            |
    6e+06 ++----------------------------------------------------------------+


                             numa-vmstat.node3.numa_local

    2e+08 ++----------------------------------------------------------------+
          *****.********.**** ** *.     *    *                              |
  1.9e+08 ++                 *  *  ***** **.* *****                         |
          |                                                                 |
  1.8e+08 ++                                                                |
          |                                                                 |
  1.7e+08 ++                                                                |
          |                                                                 |
  1.6e+08 ++                                                                |
          |                                                                 |
  1.5e+08 ++              O                                                 |
          OOO O OOO OOOO   OO OOO   OO  OOO   OOOOOO OOOOOOO O OOOOOOOO OOOOO
  1.4e+08 ++ O     O     O   O   O O  OO    OO              O               |
          |                                                                 |
  1.3e+08 ++----------------------------------------------------------------+


                             numa-vmstat.node3.numa_other

    3e+07 ++----------------------------------------------------------------+
          |      O       O   O       O O     O                              |
          |     O OOO O    OO OOOO O    OOO   OOOOOO  OOOOOOO  OOO          |
  2.5e+07 OOOOO      O O  O         O O     O        O       O              |
          |                                                       O   O O  OO
          |                                                        OOO   OO |
    2e+07 ++                                                                |
          |                                                                 |
  1.5e+07 ++                                                                |
          |                                                                 |
          |                                                                 |
    1e+07 ++                 *  *                                           |
          *****.  ******.**** ** *.********.**  ***                         |
          |     **                            **                            |
    5e+06 ++----------------------------------------------------------------+


                      numa-vmstat.node3.workingset_nodereclaim

  750000 ++----*------------------------------------------------------------+
         ****.* ** * *.  *   *. *   * .*                                    |
  700000 ++       * *  ** ***  * *** *  *******.***                         |
         |                                                                  |
  650000 ++                                                                 |
  600000 ++                                                                 |
         |                                                                  |
  550000 ++                                                                 |
         |                O                                                 |
  500000 ++                                                                 |
  450000 OOO           O O      O  O               O       O                |
         |    OOO  OO      O O   O  O  OOOO OOO O O O         O OO          |
  400000 ++          O  O   O  O  O  O     O     O   OO  OO  O    OOO       O
         |  O    OO                                     O            OOO OOO|
  350000 ++-------------------------------------------------O---------------+

Thanks,
Fengguang
