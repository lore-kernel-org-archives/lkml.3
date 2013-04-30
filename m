Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912Ab3D3Jgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 05:36:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61045 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab3D3Jgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 05:36:42 -0400
Message-ID: <1367314539.4616.88.camel@marge.simpson.net>
Subject: Re: [patch v7 0/21] sched: power aware scheduling
From: Mike Galbraith <bitbucket@online.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Len Brown <lenb@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Alex Shi <alex.shi@intel.com>, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        pjt@google.com, namhyung@kernel.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com, Linux PM list <linux-pm@vger.kernel.org>
Date: Tue, 30 Apr 2013 11:35:39 +0200
In-Reply-To: <20130430084135.GA21473@gmail.com>
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
	 <516724F5.20504@kernel.org> <5167C9FA.8050406@intel.com>
	 <20130412162348.GE2368@pd.tnic>
	 <1365785311.5814.36.camel@marge.simpson.net> <516F19EE.5060309@kernel.org>
	 <1366989087.30242.11.camel@marge.simpson.net>
	 <1367298972.4616.41.camel@marge.simpson.net>
	 <1367310625.4616.71.camel@marge.simpson.net>
	 <20130430084135.GA21473@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:Kdmmf4eXU/rDnhT37ymeop9lryQd88O26Z5T9nTJsrY
 qQcLQP0+XsEd1k20hRB3hPo4/1+8PHkaoKj52GkIDJt9VIuZtc
 jVJyHbBFv/ONxDs6t7af/O0Y9BZ5LA1FFp7/8CoF/S44VYAdTh
 s+qLLG1g8Hu0x/VKhC6HQGOfGNN4WRGFiG9kMvf7eA6Xf94UlH
 +mRjg0pi5npdL7rmpfGwhvrFA2qsYJPIuC+o4BY96LxFKizWMa
 SqoKvRdvn57EFfZWw0cef0S4VN2aymflpGrxHpJFb0DdnLdHgm
 C2mC0GdBPnYflbLEm1DjMQ7XlZy117HWr8KiFWCpqsNdSGnwC7
 echRRzlRaaWJ5WJiIvY7UVwSjXnmcvx8de+iilQJNP0RAgSK98
 AroBkF/NQMb8g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-30 at 10:41 +0200, Ingo Molnar wrote: 
> * Mike Galbraith <bitbucket@online.de> wrote:
> 
> > On Tue, 2013-04-30 at 07:16 +0200, Mike Galbraith wrote:
> > 
> > > Well now, that's not exactly what I expected to see for AIM7 compute.
> > > Filesystem is munching cycles otherwise used for compute when load is
> > > spread across the whole box vs consolidated.
> > 
> > So AIM7 compute performance delta boils down to: powersaving stacks
> > tasks, so they pat single bit of spinning rust sequentially/gently.
> 
> So AIM7 with real block IO improved, due to sequentiality. Does it improve 
> if AIM7 works on an SSD, or into ramdisk?

Seriously doubt it, but I suppose I can try tmpfs.

performance 
Tasks    jobs/min  jti  jobs/min/task      real       cpu
   20    11170.51   99       558.5253     10.85     15.19   Tue Apr 30 11:21:46 2013
   20    11078.61   99       553.9305     10.94     15.59   Tue Apr 30 11:21:57 2013
   20    11191.14   99       559.5568     10.83     15.29   Tue Apr 30 11:22:08 2013

powersaving
Tasks    jobs/min  jti  jobs/min/task      real       cpu
   20    10978.26   99       548.9130     11.04     19.25   Tue Apr 30 11:22:38 2013
   20    10988.21   99       549.4107     11.03     18.71   Tue Apr 30 11:22:49 2013
   20    11008.17   99       550.4087     11.01     18.85   Tue Apr 30 11:23:00 2013

Nope.

> Which are the workloads where 'powersaving' mode hurts workload 
> performance measurably?

Well, it'll lose throughput any time there's parallel execution
potential but it's serialized instead.. using average will inevitably
stack tasks sometimes, but that's its goal.  Hackbench shows it.

performance 
monteverdi:/abuild/mike/aim7/:[0]# hackbench -l 1000
Running in process mode with 10 groups using 40 file descriptors each (== 400 tasks)
Each sender will pass 1000 messages of 100 bytes
Time: 0.487
monteverdi:/abuild/mike/aim7/:[0]# hackbench -l 1000
Running in process mode with 10 groups using 40 file descriptors each (== 400 tasks)
Each sender will pass 1000 messages of 100 bytes
Time: 0.487
monteverdi:/abuild/mike/aim7/:[0]# hackbench -l 1000
Running in process mode with 10 groups using 40 file descriptors each (== 400 tasks)
Each sender will pass 1000 messages of 100 bytes
Time: 0.497

powersaving
monteverdi:/abuild/mike/aim7/:[0]# hackbench -l 1000
Running in process mode with 10 groups using 40 file descriptors each (== 400 tasks)
Each sender will pass 1000 messages of 100 bytes
Time: 0.702
monteverdi:/abuild/mike/aim7/:[0]# hackbench -l 1000
Running in process mode with 10 groups using 40 file descriptors each (== 400 tasks)
Each sender will pass 1000 messages of 100 bytes
Time: 0.679
monteverdi:/abuild/mike/aim7/:[0]# hackbench -l 1000
Running in process mode with 10 groups using 40 file descriptors each (== 400 tasks)
Each sender will pass 1000 messages of 100 bytes
Time: 1.137

	-Mike

