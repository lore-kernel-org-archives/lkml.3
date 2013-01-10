Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab3AJT6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 14:58:22 -0500
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:39113 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755941Ab3AJT6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 14:58:20 -0500
Date: Thu, 10 Jan 2013 13:58:09 -0600
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org
Subject: Re: kernel BUG at kernel/sched_rt.c:493!
Message-ID: <20130110195809.GA3415@BohrerMBP.rgmadvisors.com>
References: <20130105174632.GB19226@u1004.rgmadvisors.com>
 <20130107175818.GA3411@BohrerMBP.rgmadvisors.com>
 <20130107230218.GB3411@BohrerMBP.rgmadvisors.com>
 <20130108143605.GB5594@home.goodmis.org>
 <20130108150153.GA2219@BohrerMBP.rgmadvisors.com>
 <1357791191.5841.8.camel@marge.simpson.net>
MIME-Version: 1.0
In-Reply-To: <1357791191.5841.8.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: multipart/mixed; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline

On Thu, Jan 10, 2013 at 05:13:11AM +0100, Mike Galbraith wrote:
> On Tue, 2013-01-08 at 09:01 -0600, Shawn Bohrer wrote: 
> > On Tue, Jan 08, 2013 at 09:36:05AM -0500, Steven Rostedt wrote:
> > > > 
> > > > I've also managed to reproduce this on 3.8.0-rc2 so it appears the bug
> > > > is still present in the latest kernel.
> > > 
> > > Shawn,
> > > 
> > > Can you send me your .config file.
> > 
> > I've attached the 3.8.0-rc2 config that I used to reproduce this in an
> > 8 core kvm image.  Let me know if you need anything else.
> 
> I tried beating on my little Q6600 with no success.  I even tried
> setting the entire box rt, GUI and all, nada.
> 
> Hm, maybe re-installing systemd..

I don't know if Steve has had any success.  I can reproduce this easily
now so I'm happy to do some debugging if anyone has some things they
want me to try.

Here is some info on my setup at the moment.  I'm using an 8 core KVM
image now with an xfs file system.  We do use systemd if that is
relevant.  My cpuset controller is mounted on /cgroup/cpuset and we
use libcgroup-tools to move everything on the system that can be moved
into /cgroup/cpuset/sysdefault/  I've also boosted all kworker threads
to run as SCHED_FIFO with a priority of 51.  From there I just drop
the three attached shell scripts (burn.sh, sched_domain_bug.sh and
sched_domain_burn.sh) in /root/ and run /root/sched_domain_bug.sh as
root.  Usually the bug triggers in less than a minute.  You may need
to tweak my shell scripts if your setup is different but they are very
rudimentary.

In order to try digging up some more info I applied the following
patch, and triggered the bug a few times.  The results are always
essentially the same:

---
 kernel/sched/rt.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 418feb0..fba7f01 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -650,6 +650,8 @@ static void __disable_runtime(struct rq *rq)
 		 * we lend and now have to reclaim.
 		 */
 		want = rt_b->rt_runtime - rt_rq->rt_runtime;
+		printk(KERN_INFO "Initial want: %lld rt_b->rt_runtime: %llu rt_rq->rt_runtime: %llu\n",
+		       want, rt_b->rt_runtime, rt_rq->rt_runtime);
 
 		/*
 		 * Greedy reclaim, take back as much as we can.
@@ -684,7 +686,12 @@ static void __disable_runtime(struct rq *rq)
 		 * We cannot be left wanting - that would mean some runtime
 		 * leaked out of the system.
 		 */
-		BUG_ON(want);
+		if (want) {
+			printk(KERN_ERR "BUG triggered, want: %lld\n", want);
+			for_each_cpu(i, rd->span) {
+				print_rt_stats(NULL, i);
+			}
+		}
 balanced:
 		/*
 		 * Disable all the borrow logic by pretending we have inf
---

Here is the output:

[   81.278842] SysRq : Changing Loglevel
[   81.279027] Loglevel set to 9
[   83.285456] Initial want: 50000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 900000000
[   85.286452] Initial want: 50000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 900000000
[   85.289625] Initial want: 50000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 900000000
[   87.287435] Initial want: 100000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 850000000
[   87.290718] Initial want: 50000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 900000000
[   89.288469] Initial want: -50000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 1000000000
[   89.291550] Initial want: 150000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 800000000
[   89.292940] Initial want: 100000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 850000000
[   89.294082] Initial want: 100000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 850000000
[   89.295194] Initial want: 50000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 900000000
[   89.296274] Initial want: 50000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 900000000
[   90.959004] [sched_delayed] sched: RT throttling activated
[   91.289470] Initial want: 200000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 750000000
[   91.292767] Initial want: 200000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 750000000
[   91.294037] Initial want: 200000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 750000000
[   91.295364] Initial want: 200000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 750000000
[   91.296355] BUG triggered, want: 200000000
[   91.296355] 
[   91.296355] rt_rq[7]:
[   91.296355]   .rt_nr_running                 : 0
[   91.296355]   .rt_throttled                  : 0
[   91.296355]   .rt_time                       : 0.000000
[   91.296355]   .rt_runtime                    : 750.000000
[   91.307332] Initial want: -50000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 1000000000
[   91.308440] Initial want: -100000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 1050000000
[   91.309586] Initial want: -150000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 1100000000
[   91.310716] Initial want: -200000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 1150000000
[   91.311707] BUG triggered, want: -200000000
[   91.311707] 
[   91.311707] rt_rq[6]:
[   91.311707]   .rt_nr_running                 : 1
[   91.311707]   .rt_throttled                  : 0
[   91.311707]   .rt_time                       : 307.209987
[   91.311707]   .rt_runtime                    : 1150.000000
[   93.293733] Initial want: -43802666 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 993802666
[   93.296601] Initial want: 150000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 800000000
[   93.299600] Initial want: 100000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 850000000
[   93.301068] Initial want: 100000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 850000000
[   93.302075] Initial want: 50000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 900000000
[   93.303063] Initial want: 50000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 900000000
[   95.294857] Initial want: 200000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 750000000
[   95.298568] Initial want: 200000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 750000000
[   95.300016] Initial want: 200000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 750000000
[   95.301204] Initial want: 200000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 750000000
[   95.302161] BUG triggered, want: 200000000
[   95.302180] 
[   95.302180] rt_rq[7]:
[   95.302180]   .rt_nr_running                 : 0
[   95.302180]   .rt_throttled                  : 0
[   95.302180]   .rt_time                       : 0.000000
[   95.302180]   .rt_runtime                    : 750.000000
[   95.309281] Initial want: -50000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 1000000000
[   95.311185] Initial want: -100000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 1050000000
[   95.312115] Initial want: -150000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 1100000000
[   95.312980] Initial want: -200000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 1150000000
[   95.313107] BUG triggered, want: -200000000
[   95.313107] 
[   95.313107] rt_rq[6]:
[   95.313107]   .rt_nr_running                 : 1
[   95.313107]   .rt_throttled                  : 0
[   95.313107]   .rt_time                       : 309.317451
[   95.313107]   .rt_runtime                    : 1150.000000
[   97.300908] Initial want: -43805084 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 993805084
[   97.303466] Initial want: 150000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 800000000
[   97.304429] Initial want: 100000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 850000000
[   97.305333] Initial want: 100000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 850000000
[   97.307685] Initial want: 50000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 900000000
[   97.308977] Initial want: 50000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 900000000
[   99.301776] Initial want: 50000000 rt_b->rt_runtime: 950000000 rt_rq->rt_runtime: 900000000

Every time I've triggered this 'want' has always been 200000000, and it
is always rt_rq[7] and rt_rq[6].  Perhaps this will point folks in the
right direction.  If not I'll keep poking at this.

Thanks,
Shawn

-- 

---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

--BOKacYhQ+x31HxR3
Content-Type: application/x-sh
Content-Disposition: attachment; filename="burn.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A=0Awhile true; do : ; done=0A
--BOKacYhQ+x31HxR3
Content-Type: application/x-sh
Content-Disposition: attachment; filename="sched_domain_burn.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A=0Acpuset_mnt=3D"/cgroup/cpuset"=0A=0Amkdir ${cpuset_mnt}/pac=
kage0=0Acat ${cpuset_mnt}/cpuset.mems > ${cpuset_mnt}/package0/cpuset.mems=
=0Aecho 0,2,4,6 > ${cpuset_mnt}/package0/cpuset.cpus=0Aecho 1,3,5,7 > ${cpu=
set_mnt}/sysdefault/cpuset.cpus=0Aecho $$ >> ${cpuset_mnt}/package0/tasks=
=0Achrt -p -f 20 $$=0A=0Awhile true; do =0A    echo "starting burners"=0A  =
  chrt -f 1 /root/burn.sh &=0A    sleep 2=0A    chrt -f 1 /root/burn.sh &=
=0A    sleep 2=0A    chrt -f 1 /root/burn.sh &=0A    sleep 2=0A    chrt -f =
1 /root/burn.sh &=0A    sleep 10=0A    CPIDS=3D$(pgrep -P $$)=0A    kill -9=
 $CPIDS=0A    echo "burners killed"=0Adone=0A
--BOKacYhQ+x31HxR3
Content-Type: application/x-sh
Content-Disposition: attachment; filename="sched_domain_bug.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A=0Acpuset_mnt=3D"/cgroup/cpuset"=0A=0Aecho 9 > /proc/sysrq-tr=
igger=0Aecho $$ >> ${cpuset_mnt}/sysdefault/tasks=0Achrt -p -f 20 $$=0A=0A/=
root/sched_domain_burn.sh &=0A=0Awhile true; do=0A    echo 0 > ${cpuset_mnt=
}/cpuset.sched_load_balance=0A    echo "toplevel domain off"=0A    sleep 2=
=0A    echo 1 > ${cpuset_mnt}/cpuset.sched_load_balance=0A    echo "topleve=
l domain on"=0A    sleep 2=0Adone=0A
--BOKacYhQ+x31HxR3--
