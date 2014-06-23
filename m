Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368AbaFWRQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 13:16:54 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:41057 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaFWRQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 13:16:52 -0400
Date: Mon, 23 Jun 2014 10:16:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, ak@linux.intel.com, cl@gentwo.org,
        umgwanakikbuti@gmail.com
Subject: Re: [PATCH tip/core/rcu] Reduce overhead of cond_resched() checks
 for RCU
Message-ID: <20140623171644.GH4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140621025958.GA7185@linux.vnet.ibm.com>
 <53A85BF9.7030006@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A85BF9.7030006@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062317-6688-0000-0000-000002C3EF2E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 09:55:21AM -0700, Dave Hansen wrote:
> This still has a regression.  Commit 1ed70de (from Paul's git tree),
> gets a result of 52231880.  If I back up two commits to v3.16-rc1 and
> revert ac1bea85 (the original culprit) the result goes back up to 57308512.
> 
> So something is still going on here.

And commit 1ed70de is in fact the right one, so...

The rcutree.jiffies_till_sched_qs boot/sysfs parameter controls how
long RCU waits before asking for quiescent states.  The default is
currently HZ/20.  Does increasing this parameter help?  Easy for me to
increase the default if it does.

> I'll go back and compare the grace period ages to see if I can tell what
> is going on.

That would be very helpful, thank you!

							Thanx, Paul

> --
> 
> root@bigbox:~/will-it-scale# ./open1_processes -t 160 -s30
> testcase:Separate file open/close
> warmup
> min:319787 max:386071 total:57464989
> min:307235 max:351905 total:53289241
> min:291765 max:342439 total:51364514
> min:297948 max:349214 total:52552745
> min:294950 max:340132 total:51586179
> min:290791 max:339958 total:50793238
> measurement
> min:298851 max:346868 total:51951469
> min:292879 max:340704 total:50817269
> min:305768 max:347381 total:52655149
> min:301046 max:345616 total:52449584
> min:300428 max:345293 total:52021166
> min:293404 max:337973 total:51012206
> min:303569 max:348191 total:52713179
> min:305523 max:357448 total:53707053
> min:307040 max:356937 total:53271883
> min:302134 max:347923 total:52477496
> min:297823 max:340488 total:51884417
> min:286981 max:338246 total:50496850
> min:295920 max:349405 total:51792563
> min:302749 max:343780 total:52305074
> min:298497 max:345208 total:52035318
> min:291393 max:332195 total:50163093
> min:303561 max:353396 total:52983515
> min:301613 max:352988 total:53029200
> min:300693 max:343726 total:52057334
> min:296801 max:352408 total:52028824
> min:304834 max:358236 total:53526191
> min:297933 max:338351 total:51578481
> min:299571 max:341679 total:51817941
> min:308225 max:354075 total:53760098
> min:296262 max:346965 total:51856596
> min:309196 max:356432 total:53455141
> min:295604 max:341814 total:51449366
> min:296931 max:345961 total:52051944
> min:300533 max:350304 total:52652951
> min:299887 max:350764 total:52955064
> average:52231880
> root@bigbox:~/will-it-scale# uname -a
> Linux bigbox 3.16.0-rc1-00002-g1ed70de #176 SMP Mon Jun 23 09:04:02 PDT
> 2014 x86_64 x86_64 x86_64 GNU/Linux
> 
> 
> root@bigbox:~/will-it-scale# ./open1_processes -t 160 -s 30
> testcase:Separate file open/close
> warmup
> min:346853 max:416035 total:62412724
> min:281766 max:344178 total:52207349
> min:311187 max:374918 total:57149451
> min:326309 max:391061 total:60200366
> min:310327 max:375619 total:56744357
> min:323336 max:393415 total:59619164
> measurement
> min:323934 max:393718 total:59665843
> min:307247 max:368313 total:55681436
> min:318210 max:378048 total:57849321
> min:314494 max:383884 total:57741073
> min:316497 max:385223 total:58565045
> min:320490 max:397636 total:59003133
> min:318695 max:391712 total:57789360
> min:304368 max:378540 total:56412216
> min:314609 max:384462 total:58298008
> min:317235 max:384205 total:58812490
> min:323556 max:388014 total:59468492
> min:301011 max:362664 total:55381779
> min:301113 max:364712 total:55375445
> min:311730 max:369336 total:56640530
> min:316951 max:381341 total:58649244
> min:317077 max:383943 total:58132878
> min:316970 max:390127 total:59039489
> min:315895 max:375937 total:57404755
> min:295500 max:346523 total:53086962
> min:310882 max:371923 total:56612144
> min:321837 max:390544 total:59651640
> min:303481 max:368716 total:56135908
> min:306437 max:367658 total:56388659
> min:307343 max:373645 total:56893136
> min:298703 max:358090 total:54152268
> min:319162 max:386583 total:58999429
> min:304881 max:361968 total:55286607
> min:311034 max:381100 total:57846182
> min:312786 max:378270 total:57964383
> min:311740 max:367481 total:56327526
> average:57308512
> root@bigbox:~/will-it-scale# uname -a
> Linux bigbox 3.16.0-rc1-dirty #177 SMP Mon Jun 23 09:13:59 PDT 2014
> x86_64 x86_64 x86_64 GNU/Linux
> 

