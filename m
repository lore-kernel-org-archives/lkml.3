Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab3A2Bog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:44:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:57237 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab3A2Boe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:44:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,555,1355126400"; 
   d="scan'208";a="253880959"
Message-ID: <510729B1.8070807@intel.com>
Date: Tue, 29 Jan 2013 09:45:21 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Borislav Petkov <bp@alien8.de>, torvalds@linux-foundation.org,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v4 0/18] sched: simplified fork, release load avg and
 power awareness scheduling
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>  <20130124094439.GB13463@pd.tnic> <51014E34.60309@intel.com>  <510493E4.8060602@intel.com> <1359261385.5803.46.camel@marge.simpson.net>  <20130127103508.GB8894@pd.tnic> <51052ACB.3070703@intel.com>  <1359301903.5805.11.camel@marge.simpson.net>  <1359350266.5783.39.camel@marge.simpson.net> <1359388055.5783.164.camel@marge.simpson.net>
In-Reply-To: <1359388055.5783.164.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2013 11:47 PM, Mike Galbraith wrote:
> On Mon, 2013-01-28 at 06:17 +0100, Mike Galbraith wrote:
> 
> Ok damnit.
> 
>> monteverdi:/abuild/mike/:[0]# echo powersaving > /sys/devices/system/cpu/sched_policy/current_sched_policy
>> monteverdi:/abuild/mike/:[0]# massive_intr 10 60
>> 043321  00058616
>> 043313  00058616
>> 043318  00058968
>> 043317  00058968
>> 043316  00059184
>> 043319  00059192
>> 043320  00059048
>> 043314  00059048
>> 043312  00058176
>> 043315  00058184
> 
> That was boost if you like, and free to roam 4 nodes.
> 
> monteverdi:/abuild/mike/:[0]# echo powersaving > /sys/devices/system/cpu/sched_policy/current_sched_policy
> monteverdi:/abuild/mike/:[0]# echo 0 > /sys/devices/system/cpu/cpufreq/boost
> monteverdi:/abuild/mike/:[0]# massive_intr 10 60
> 014618  00039616
> 014623  00039256
> 014617  00039256
> 014620  00039304
> 014621  00039304  (wait a minute, you said..)
> 014616  00039080
> 014625  00039064
> 014622  00039672
> 014624  00039624
> 014619  00039672
> monteverdi:/abuild/mike/:[0]# echo 1 > /sys/devices/system/cpu/cpufreq/boost
> monteverdi:/abuild/mike/:[0]# massive_intr 10 60
> 014635  00058160
> 014633  00058592
> 014638  00058592
> 014636  00058160
> 014632  00058200
> 014634  00058704
> 014639  00058704
> 014641  00058200
> 014640  00058560
> 014637  00058560
> monteverdi:/abuild/mike/:[0]# massive_intr 10 60
> 014673  00059504
> 014676  00059504
> 014674  00059064
> 014672  00059064
> 014675  00058560
> 014671  00058560
> 014677  00059248
> 014668  00058864
> 014669  00059248
> 014670  00058864
> monteverdi:/abuild/mike/:[0]# massive_intr 10 60
> 014686  00043472
> 014689  00043472
> 014685  00043760
> 014690  00043760
> 014687  00043528
> 014688  00043528  (hmm)
> 014683  00043216
> 014692  00043208
> 014684  00043336
> 014691  00043336

I am sorry Mike. does above 3 times testing has a same sched policy? and
same question for the following testing.

> monteverdi:/abuild/mike/:[0]# echo 0 > /sys/devices/system/cpu/cpufreq/boost
> monteverdi:/abuild/mike/:[0]# massive_intr 10 60
> 014701  00039344
> 014707  00039344
> 014709  00038976
> 014700  00038976
> 014708  00039256  (hmm)
> 014703  00039256
> 014705  00039400
> 014704  00039400
> 014706  00039320
> 014702  00039320
> monteverdi:/abuild/mike/:[0]# massive_intr 10 60
> 014713  00058552
> 014716  00058664
> 014719  00058600
> 014715  00058600
> 014718  00058520
> 014722  00058400
> 014721  00058768
> 014717  00058768
> 014714  00058552
> 014720  00058560
> monteverdi:/abuild/mike/:[0]# massive_intr 10 60
> 014732  00058736
> 014734  00058760
> 014729  00040872
> 014736  00059184
> 014728  00059184
> 014727  00058744
> 014733  00058760
> 014731  00059320
> 014730  00059280
> 014735  00041072
> monteverdi:/abuild/mike/:[0]# numactl --cpunodebind=0 massive_intr 10 60
> 014749  00040608
> 014748  00040616
> 014745  00039360
> 014750  00039360
> 014751  00039416
> 014747  00039416
> 014752  00039336
> 014746  00039336
> 014744  00039480
> 014753  00039480
> monteverdi:/abuild/mike/:[0]# numactl --cpunodebind=0 massive_intr 10 60
> 014757  00039272
> 014761  00039272
> 014765  00039528
> 014756  00039528
> 014759  00039352
> 014760  00039352
> 014764  00039248
> 014762  00039248
> 014758  00039352
> 014763  00039352
> monteverdi:/abuild/mike/:[0]# numactl --cpunodebind=0 massive_intr 10 60
> 014773  00059680
> 014769  00059680
> 014768  00059144
> 014777  00059144
> 014775  00059688
> 014774  00059688
> 014770  00059264
> 014771  00059264
> 014772  00059528
> 014776  00059528
> 
> Ok box, whatever blows your skirt up.  I'm done.
> 
> Non
> Uniform
> Mysterious
> Artifacts
> 


-- 
Thanks Alex
