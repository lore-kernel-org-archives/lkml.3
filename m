Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab3KAKQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 06:16:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:54707 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459Ab3KAKQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 06:16:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,616,1378882800"; 
   d="scan'208";a="420795441"
Date: Fri, 1 Nov 2013 18:16:43 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michel Lespinasse <walken@google.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: Re: [PATCH 0/4] per anon_vma lock and turn anon_vma rwsem lock to
 rwlock_t
Message-ID: <20131101101643.GC30123@yliu-dev.sh.intel.com>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
 <20131101080135.GB25547@gmail.com>
 <20131101081159.GB12829@yliu-dev.sh.intel.com>
 <20131101082146.GA27021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101082146.GA27021@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 09:21:46AM +0100, Ingo Molnar wrote:
> 
> * Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> 
> > > Btw., another _really_ interesting comparison would be against 
> > > the latest rwsem patches. Mind doing such a comparison?
> > 
> > Sure. Where can I get it? Are they on some git tree?
> 
> I've Cc:-ed Tim Chen who might be able to point you to the latest 
> version.
> 
> The last on-lkml submission was in this thread:
> 
>   Subject: [PATCH v8 0/9] rwsem performance optimizations
> 

Thanks.

I queued bunchs of tests about one hour ago, and already got some
results(If necessary, I can add more data tomorrow when those tests are
finished):


               v3.12-rc7      fe001e3de090e179f95d  
------------------------  ------------------------  
                                -9.3%               brickland1/micro/aim7/shared
                                +4.3%               lkp-ib03/micro/aim7/fork_test
                                +2.2%               lkp-ib03/micro/aim7/shared
                                -2.6%               TOTAL aim7.2000.jobs-per-min

               v3.12-rc7      fe001e3de090e179f95d  
------------------------  ------------------------  
               204056.67       -23.5%    156082.33  brickland1/micro/aim7/shared
                79248.00      +144.3%    193617.25  lkp-ib03/micro/aim7/fork_test
               298355.33       -25.2%    223084.67  lkp-ib03/micro/aim7/shared
               581660.00        -1.5%    572784.25  TOTAL time.involuntary_context_switches

               v3.12-rc7      fe001e3de090e179f95d  
------------------------  ------------------------  
                22487.33        -4.7%     21429.33  brickland1/micro/aim7/dbase
                61412.67       -29.1%     43511.00  brickland1/micro/aim7/shared
               531142.00       -27.7%    383818.75  lkp-ib03/micro/aim7/fork_test
                20158.33       -50.9%      9899.67  lkp-ib03/micro/aim7/shared
               635200.33       -27.8%    458658.75  TOTAL vmstat.system.in

               v3.12-rc7      fe001e3de090e179f95d  
------------------------  ------------------------  
                 6408.67        -4.5%      6117.33  brickland1/micro/aim7/dbase
                87856.00       -39.5%     53170.67  brickland1/micro/aim7/shared
              1043620.00       -28.0%    751214.75  lkp-ib03/micro/aim7/fork_test
                47152.33       -38.0%     29245.33  lkp-ib03/micro/aim7/shared
              1185037.00       -29.1%    839748.08  TOTAL vmstat.system.cs

               v3.12-rc7      fe001e3de090e179f95d  
------------------------  ------------------------  
                13295.00       -10.0%     11960.00  brickland1/micro/aim7/dbase
              1901175.00       -35.5%   1226787.33  brickland1/micro/aim7/shared
                13951.00        -6.5%     13051.00  lkp-ib03/micro/aim7/dbase
            239773251.17       -30.9% 165727820.75  lkp-ib03/micro/aim7/fork_test
              1014933.67       -31.1%    699259.67  lkp-ib03/micro/aim7/shared
            242716605.83       -30.9% 167678878.75  TOTAL time.voluntary_context_switches

               v3.12-rc7      fe001e3de090e179f95d  
------------------------  ------------------------  
                    9.56        -1.0%         9.46  brickland1/micro/aim7/dbase
                   11.01       -10.1%         9.90  brickland1/micro/aim7/shared
                   36.23       +15.3%        41.77  lkp-ib03/micro/aim7/fork_test
                   10.51       -11.9%         9.26  lkp-ib03/micro/aim7/shared
                   67.31        +4.6%        70.39  TOTAL iostat.cpu.system

               v3.12-rc7      fe001e3de090e179f95d  
------------------------  ------------------------  
                   36.39        -3.6%        35.09  brickland1/micro/aim7/dbase
                   34.97        -8.1%        32.13  brickland1/micro/aim7/shared
                   20.34        +6.7%        21.70  lkp-ib03/micro/aim7/shared
                   91.70        -3.0%        88.92  TOTAL boottime.dhcp

               v3.12-rc7      fe001e3de090e179f95d  
------------------------  ------------------------  
                   60.00        +6.7%        64.00  brickland1/micro/aim7/shared
                   60.83        -9.2%        55.25  lkp-ib03/micro/aim7/fork_test
                  120.83        -1.3%       119.25  TOTAL vmstat.cpu.id

               v3.12-rc7      fe001e3de090e179f95d  
------------------------  ------------------------  
                  345.50        -1.1%       341.73  brickland1/micro/aim7/dbase
                 3788.80       +11.5%      4223.15  lkp-ib03/micro/aim7/fork_test
                  108.29        -7.1%       100.62  lkp-ib03/micro/aim7/shared
                 4242.59       +10.0%      4665.50  TOTAL time.system_time

               v3.12-rc7      fe001e3de090e179f95d  
------------------------  ------------------------  
                 7481.33        -0.4%      7454.00  brickland1/micro/aim7/dbase
                 4413.33        -9.4%      3999.67  brickland1/micro/aim7/shared
                  864.83       +15.8%      1001.25  lkp-ib03/micro/aim7/fork_test
                 2747.33        +2.2%      2807.00  lkp-ib03/micro/aim7/shared
                15506.83        -1.6%     15261.92  TOTAL time.percent_of_cpu_this_job_got

               v3.12-rc7      fe001e3de090e179f95d  
------------------------  ------------------------  
                   40.82        -7.0%        37.96  brickland1/micro/aim7/shared
                   29.03        +1.2%        29.39  lkp-ib03/micro/aim7/shared
                   69.85        -3.6%        67.35  TOTAL boottime.boot

               v3.12-rc7      fe001e3de090e179f95d  
------------------------  ------------------------  
                   41.13        +9.8%        45.15  brickland1/micro/aim7/shared
                  451.32        -4.1%       432.71  lkp-ib03/micro/aim7/fork_test
                   31.94        -2.1%        31.27  lkp-ib03/micro/aim7/shared
                  524.39        -2.9%       509.13  TOTAL time.elapsed_time

               v3.12-rc7      fe001e3de090e179f95d  
------------------------  ------------------------  
                   41.92        +0.7%        42.21  brickland1/micro/aim7/dbase
                   60.65        +6.1%        64.33  brickland1/micro/aim7/shared
                   35.64        -1.9%        34.95  lkp-ib03/micro/aim7/dbase
                   61.18        -9.3%        55.48  lkp-ib03/micro/aim7/fork_test
                  199.39        -1.2%       196.97  TOTAL iostat.cpu.idle

               v3.12-rc7      fe001e3de090e179f95d  
------------------------  ------------------------  
                   48.52        -0.4%        48.33  brickland1/micro/aim7/dbase
                   54.52        +1.1%        55.12  lkp-ib03/micro/aim7/dbase
                    2.59        +6.3%         2.76  lkp-ib03/micro/aim7/fork_test
                   50.59        +2.6%        51.90  lkp-ib03/micro/aim7/shared
                  156.23        +1.2%       158.10  TOTAL iostat.cpu.user

               v3.12-rc7      fe001e3de090e179f95d  
------------------------  ------------------------  
                 1804.63        -0.4%      1797.01  brickland1/micro/aim7/dbase
                  117.74        -7.2%       109.21  lkp-ib03/micro/aim7/fork_test
                  769.56        +1.0%       777.37  lkp-ib03/micro/aim7/shared
                 2691.93        -0.3%      2683.58  TOTAL time.user_time

               v3.12-rc7      fe001e3de090e179f95d  
------------------------  ------------------------  
                   50.00        +2.0%        51.00  lkp-ib03/micro/aim7/shared
                   50.00        +2.0%        51.00  TOTAL vmstat.cpu.us


	--yliu
